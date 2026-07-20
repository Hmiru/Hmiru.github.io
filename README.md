# PhD Application CV

해외 박사 지원용 학술 CV 템플릿 (영문).

## 파일
- `cv.tex` — CV 템플릿 (LaTeX)
- `cv.pdf` — 컴파일 결과물

## 컴파일
```bash
pdflatex cv.tex   # 링크·페이지 정확히 잡히도록 2번 실행
pdflatex cv.tex
```
> Overleaf에 `cv.tex`만 올려도 바로 컴파일됩니다.

## 작성법
1. `<...>` 형태의 placeholder를 전부 본인 내용으로 교체하세요.
2. 해당 없는 항목(예: Teaching, Service)은 섹션째 지워도 됩니다.
3. 순서는 **강점 우선**으로 조정하세요. 보통 논문 실적이 강하면
   Publications를 Education 바로 다음에 올립니다.

## 섹션 구성
| 섹션 | 설명 |
|------|------|
| Research Interests | 지원 분야와 맞는 키워드 3~5개 |
| Education | 최신순. GPA는 만점 표기(예: 3.9/4.0) |
| Publications | `*` 공동1저자, `†` 교신저자 각주 포함 |
| Research Experience | 동사로 시작, 성과는 숫자로 |
| Teaching / Awards / Skills / Talks / Service | 있으면 채우고 없으면 삭제 |
| References | 추천인 2~3명 (지도교수 우선) |

## 팁
- 1~2쪽 권장. 논문·경력이 많으면 2쪽까지 OK.
- 아이콘(이메일/깃허브 등)을 넣고 싶으면 `cv.tex` 상단
  `\usepackage{fontawesome5}` 주석을 해제하세요 (texlive-fonts-extra 필요).
- 지원 학교/랩마다 Research Interests 문구를 조금씩 맞춤 조정하면 좋습니다.
