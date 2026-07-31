#!/usr/bin/env bash
#
# Render the HTML CV and résumé to PDF with headless Chrome.
#
#   ./build.sh
#
# The HTML files are the single source of truth. The PDFs are build output —
# never hand-edit them, and re-run this after any content change so the file
# recruiters download matches the page they can see.
#
# Env:
#   CV_NAME     filename prefix for the PDFs   (default: MiruHong)
#   CHROME      path to a Chrome/Chromium binary
#
set -euo pipefail

cd "$(dirname "$0")"

NAME="${CV_NAME:-MiruHong}"

# ---- locate Chrome -----------------------------------------------------
if [ -z "${CHROME:-}" ]; then
  for c in google-chrome google-chrome-stable chromium chromium-browser chrome; do
    if command -v "$c" >/dev/null 2>&1; then CHROME="$c"; break; fi
  done
fi
if [ -z "${CHROME:-}" ]; then
  echo "build: no Chrome/Chromium found. Install one, or set CHROME=/path/to/chrome." >&2
  exit 1
fi

have_poppler=1
command -v pdfinfo >/dev/null 2>&1 && command -v pdftotext >/dev/null 2>&1 || have_poppler=0
[ "$have_poppler" = 1 ] || echo "build: poppler-utils not found — skipping page-count and content checks." >&2

fail=0

# render <src.html> <out.pdf> <max-pages|0 for no limit> <required text>...
render() {
  local src="$1" out="$2" maxpages="$3"; shift 3

  "$CHROME" \
    --headless=new \
    --disable-gpu \
    --no-sandbox \
    --no-pdf-header-footer \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=4000 \
    --print-to-pdf="$out" \
    "file://$PWD/$src" >/dev/null 2>&1

  if [ ! -s "$out" ]; then
    echo "  ✗ $src → $out : Chrome produced nothing" >&2
    fail=1; return
  fi

  local pages="?"
  if [ "$have_poppler" = 1 ]; then
    pages=$(pdfinfo "$out" | awk '/^Pages:/{print $2}')
    local text; text=$(pdftotext -q "$out" - 2>/dev/null || true)
    # section labels are text-transform:uppercase, and that is how they come
    # back out of the PDF — compare case-insensitively
    text=${text^^}

    # Guards against the failure mode that matters: a PDF that renders but is
    # blank, because .reveal starts at opacity:0 and the print override or the
    # JS that clears it went missing.
    for needle in "$@"; do
      case "$text" in
        *"${needle^^}"*) ;;
        *) echo "  ✗ $out : expected text \"$needle\" is missing — is the print CSS still overriding .reveal?" >&2
           fail=1 ;;
      esac
    done

    if [ "$maxpages" != 0 ] && [ "${pages:-0}" -gt "$maxpages" ]; then
      echo "  ✗ $out : $pages pages, limit is $maxpages — cut content, don't shrink the type" >&2
      fail=1
    fi
  fi

  printf '  %s → %-24s %s pages, %s\n' "$src" "$out" "$pages" "$(du -h "$out" | cut -f1)"
}

echo "building PDFs with $CHROME"
render cv.html     "${NAME}_CV.pdf"     0 "Research Interests" "Education" "Publications"
render resume.html "${NAME}_Resume.pdf" 1 "Skills" "Experience" "Education"

if [ "$fail" != 0 ]; then
  echo "build: FAILED" >&2
  exit 1
fi
echo "build: ok"
