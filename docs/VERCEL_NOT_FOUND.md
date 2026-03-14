# Vercel NOT_FOUND (404) — 원인과 해결

## 1. 제안한 수정 사항

- **`vercel.json`**
  - **루트 경로 명시**: `"source": "/"` → `"/index.html"` 추가 (최상위 `/`가 항상 `index.html`로 가도록).
  - **SPA 폴백 정규식 정리**: `^/((?!.*\\.).*)$` 사용. 확장자 없는 경로만 `index.html`로 보내고, `main.dart.js` 등 정적 파일은 그대로 반환.
  - **스키마 추가**: `"$schema": "https://openapi.vercel.sh/vercel.json"`로 설정 검증 가능.
- **빌드 출력 확인**
  - 배포 로그에서 `Build completed. Output in build/web` 이후에 `build/web`에 `index.html`, `main.dart.js` 등이 생성되었는지 확인.
  - 출력이 비어 있으면 Flutter 빌드 실패 → NOT_FOUND 원인 1.

---

## 2. 근본 원인

### 2.1 코드/설정이 한 일 vs 해야 할 일

- **한 일**
  - Vercel은 요청 URL 경로(예: `/`, `/home`, `/splash`)에 해당하는 **파일**을 `outputDirectory`(`build/web`) 안에서 찾음.
  - Flutter 웹은 **단일 페이지 앱(SPA)**이라 실제 파일은 `index.html` 하나와 JS/CSS 등 자산뿐임. `/home` 같은 경로에 대응하는 물리 파일은 없음.
- **해야 할 일**
  - “이 경로에 파일이 없으면 **항상 `index.html`을 내려주라**”는 **rewrite** 규칙이 필요함. 그래야 클라이언트(GoRouter)가 URL을 해석해 화면을 그림.

### 2.2 NOT_FOUND가 나는 조건

1. **빌드 결과가 비어 있음**  
   - `buildCommand`가 실패했거나, Flutter가 설치되지 않아 `build/web`에 아무것도 없음.  
   - 그러면 `/` 요청에도 줄 파일이 없어 **404 NOT_FOUND**.

2. **rewrite가 적용되지 않음**  
   - `build/web`에는 `index.html`이 있는데, `/home` 같은 경로로 직접 접근하면, 해당 경로에 파일이 없으므로 404.  
   - “경로에 파일이 없을 때는 `index.html`로 보내라”는 규칙이 없거나, 정규식이 해당 경로를 매칭하지 못함.

### 2.3 왜 이런 실수가 나왔는지

- Vercel은 “정적 파일 서버 + rewrite/redirect” 모델이라, **프레임워크가 SPA인지 자동으로 추론하지 않음**.
- Flutter 웹은 Next/React처럼 Vercel이 기본 지원하는 프레임워크가 아니라, **SPA 폴백을 직접 설정해야 함**을 놓치기 쉬움.
- “빌드만 올리면 된다”고 생각하면, “빌드가 실제로 성공했는지”, “출력 디렉터리가 맞는지”, “SPA용 rewrite가 있는지”를 안 보게 됨.

---

## 3. 개념 이해

### 3.1 NOT_FOUND가 있는 이유 / 무엇을 막아 주는가

- “요청한 URL에 해당하는 리소스가 이 배포에 없다”고 서버가 명시적으로 알려주는 것.
- 잘못된 URL, 삭제된 페이지, 잘못된 배포를 사용자가 구분하는 데 도움이 됨.

### 3.2 올바른 멘탈 모델

- **정적 배포 = “URL 경로 → 파일 하나” 매핑**  
  - 기본 동작: `GET /foo` → `outputDir/foo` 또는 `outputDir/foo/index.html` 존재 시 그 파일 반환, 없으면 404.
- **SPA**  
  - “경로는 많지만, 실제로 줄 파일은 `index.html` 하나”이므로,  
  - “**파일이 없을 때** → `index.html`로 **rewrite**” 규칙으로 404를 막아야 함.
- **Flutter 웹**  
  - 빌드 결과는 `build/web` 한 곳에만 있고, 라우팅은 전부 클라이언트(GoRouter)가 담당한다고 보면 됨.

### 3.3 프레임워크/언어 설계와의 관계

- Vercel/정적 호스팅은 “빌드 결과물 디렉터리”만 배포하고, **라우팅 규칙(rewrite/redirect)**은 `vercel.json` 등으로 따로 정의함.
- Next.js 등은 플러그인/어댑터가 이 규칙을 자동 생성해 주지만, Flutter는 그렇지 않으므로 **수동 설정**이 필요함.

---

## 4. 앞으로 주의할 점

### 4.1 이 오류를 다시 만들 수 있는 것

- `vercel.json`에서 `rewrites` 제거하거나, 정규식을 잘못 고쳐서 “경로 → index.html”이 안 걸리는 경우.
- `outputDirectory`를 `build/web`이 아닌 다른 값으로 두어, Flutter 빌드 결과가 배포에 포함되지 않는 경우.
- `buildCommand` 실패(Flutter 미설치, 스크립트 오류)로 `build/web`이 비어 있는데도 배포가 “성공”한 것처럼 보이는 경우.

### 4.2 비슷한 실수

- 다른 정적 호스팅(Netlify, Firebase Hosting, GitHub Pages)에서도 SPA는 **fallback to index** 같은 설정을 해 주어야 함. 설정 이름만 다름(예: `redirects`, `rewrites`).
- `flutter build web --base-href "/subpath/"` 처럼 서브 경로로 배포할 때, rewrite 규칙과 `base href`를 같이 맞춰야 함.

### 4.3 의심해 볼 코드/패턴

- 배포 로그에 “Build Completed in 101ms”처럼 **비정상적으로 짧은 빌드** → Flutter가 안 돌았을 가능성.
- “Skipping cache upload because no files were prepared” → 출력 파일이 없음.
- `/`는 되는데 `/home`만 404 → rewrite가 루트만 처리하거나, 정규식이 `/home`을 포함하지 않음.

---

## 5. 다른 접근과 트레이드오프

| 접근 | 장점 | 단점 |
|------|------|------|
| **Vercel에서 Flutter 빌드** (현재: `scripts/vercel-build.sh`) | 푸시만 하면 자동 배포, 브랜치별 프리뷰 가능 | 빌드 시간 길고, Flutter 미설치/의존성 이슈 가능 |
| **로컬/CI에서 빌드 후 `build/web`만 배포** | Vercel 빌드 환경 의존성 없음, 재현 가능 | 배포 파이프라인을 따로 구성해야 함 |
| **Firebase Hosting 등 Flutter 가이드 있는 호스팅** | 공식 예제/가이드 있음 | Vercel이 아닌 플랫폼으로 이전 필요 |

현재는 1번(Vercel에서 Flutter 빌드 + `vercel.json` rewrites)으로 수정했고, 빌드가 실패하면 2번(로컬/CI 빌드 후 `build/web` 배포)을 검토하면 됨.
