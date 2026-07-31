# Hmiru.github.io

개인 홈페이지 + 학술 CV. GitHub Pages로 서빙됩니다.

## 구조

| 파일 | 역할 |
|------|------|
| `index.html` | 홈 (About / Problems / Interests / Photos) |
| `cv.html` | **전체 학술 CV — 단일 소스** |
| `resume.html` | **1페이지 industry 이력서 — 단일 소스** |
| `build.sh` | 위 두 HTML을 PDF로 렌더 |
| `MiruHong_CV.pdf` | 생성물. 직접 수정 금지 |
| `MiruHong_Resume.pdf` | 생성물. 직접 수정 금지 |

**HTML이 유일한 소스입니다.** PDF는 빌드 산출물이라 손으로 고치면 다음 빌드에
덮어써집니다. 내용은 항상 `.html`에서 고치고 `./build.sh`를 다시 돌리세요.

## 빌드

```bash
./build.sh
```

headless Chrome이 각 페이지의 `@media print` 스타일시트를 A4로 렌더합니다.
`google-chrome` / `chromium` 중 아무거나 있으면 되고, 없으면 `CHROME=/path/to/chrome`으로 지정합니다.
`poppler-utils`(`pdfinfo`, `pdftotext`)가 있으면 아래 검증까지 함께 돕니다.

빌드가 검사하는 것:

- **résumé가 1페이지를 넘으면 실패합니다.** 넘치면 글자를 줄이지 말고 내용을 쳐내세요.
- **PDF에 본문 텍스트가 실제로 들어갔는지** 확인합니다. `.reveal`이 `opacity:0`에서
  시작하기 때문에, print 오버라이드가 깨지면 섹션이 통째로 빈 채로 렌더됩니다.
  이 검사가 그걸 잡습니다.

`.github/workflows/build-pdf.yml`이 `main`에 HTML이 푸시될 때마다 같은 빌드를 돌리고
바뀐 PDF를 커밋해 되돌립니다. 웹과 PDF가 어긋나지 않게 하는 안전장치입니다.

## 두 버전을 나눠 쓰는 이유

- `cv.html` → **학술 CV.** 학교·연구실 지원용. 논문 전체 목록, 학위논문, 티칭,
  service, references 포함. 2페이지 이상 OK.
- `resume.html` → **학회에서 recruiter에게 뿌리는 버전.** 1페이지 고정.
  Skills / Experience / Selected work 중심. thesis·service·references 없음.
  상세 주소와 전화번호도 일부러 뺐습니다 — 불특정 다수에게 배포되는 문서라서요.

전체 기록은 `cv.html` 한 곳에만 두고, résumé에서는 링크만 겁니다. 복붙해서 두 벌
관리하지 마세요.

## 현재 상태

- `cv.html` — **채워짐.** placeholder 없음. 3페이지.
- `resume.html` — **아직 템플릿.** 기업 부스용으로 쓸 거면 `cv.html`에서 뽑아 채워야 합니다.

빈칸이 남았는지는 이걸로 확인합니다:

```bash
grep -o '&lt;[^&]*&gt;' cv.html resume.html | sort -u
```

## 어학 표기에 대해

Skills의 Languages 줄은 **점수를 일부러 안 적었습니다** (`English (working proficiency)`).

- 보유: OPIc IM2, DELE A2.
- OPIc은 한국 취업시장용 시험이라 유럽 입학사정관이 읽지 못하고, 찾아보면 IM2는
  "중급"으로 읽힙니다. DELE A2는 초급입니다. 적으면 오히려 감점 요인입니다.
- **표기와 별개로 실제 요건이 남아 있습니다.** 유럽 PhD는 대부분 IELTS 6.5~7.0
  또는 TOEFL 90+를 정식 입학 요건으로 겁니다. 점수를 받으면 그때 이 줄을
  `English (IELTS 7.0, 2026)` 형태로 바꾸세요.

## 작성법

1. 두 파일의 `<...>` placeholder를 전부 채웁니다.
2. `<title>`도 채웁니다 — Chrome이 이걸 **PDF 메타데이터 제목**으로 씁니다.
   안 채우면 recruiter가 PDF를 열었을 때 탭에 `CV — <Full Name>`이 뜹니다.
3. `./build.sh`를 돌리고 **PDF를 직접 열어서 확인하세요.** 화면에서 멀쩡해도
   종이에서 깨질 수 있습니다.
4. `cv.html`과 `resume.html`의 `<style>` 블록은 의도적으로 같습니다.
   색을 바꾸면 양쪽 다 바꾸세요.

### 편집할 때 주의

- **`.reveal`**: 스크롤 애니메이션용으로 `opacity:0`에서 시작합니다. print 블록의
  `.reveal { opacity:1 !important }`를 지우면 PDF가 백지로 나옵니다.
- **다크 모드**: print 블록이 CSS 변수를 밝은 값으로 되돌립니다. 이게 없으면
  다크 모드 브라우저에서 `Ctrl+P`했을 때 새까만 PDF가 나옵니다.
- **링크**: 종이에는 URL이 안 보이므로 `cv.html`은 GitHub/ORCID/Scholar 같은
  라벨 링크 뒤에 주소를 찍습니다. `resume.html`은 링크 텍스트 자체가 주소라서
  안 찍습니다 — placeholder를 채울 때도 그 규칙을 유지하세요.

## 파일명

`cv.pdf`는 recruiter 폴더에서 사라집니다. 그래서 `MiruHong_CV.pdf` 형태로 나갑니다.
접두사는 `CV_NAME` 환경변수로 바꿀 수 있고, 바꾸면 HTML 안의 다운로드 링크도
같이 고쳐야 합니다.

> 이전 버전은 `cv.tex`(LaTeX)로 PDF를 만들었습니다. 웹과 PDF가 각자 놀아서
> 소스를 HTML 하나로 합쳤습니다. 필요하면 `git log -- cv.tex`로 찾을 수 있습니다.
