# Vercel 배포 설정 (Build and Deployment)

Flutter 웹 빌드를 위해 **Install** 단계에서 `flutter precache --web`까지 해야 합니다.  
`vercel.json`에 이미 넣어 두었고, 대시보드에서 덮어쓴 경우만 아래처럼 맞추면 됩니다.

---

## 1. vercel.json에 있는 값 (권장)

저장소의 `vercel.json`이 이렇게 되어 있으면 **대시보드 Override는 비우고** 그대로 두세요.

- **installCommand**: Flutter 클론 + 웹 엔진 받기  
  `git clone https://github.com/flutter/flutter.git -b stable --depth 1 && ./flutter/bin/flutter precache --web`
- **buildCommand**: 의존성 받고 웹 빌드  
  `./flutter/bin/flutter pub get && ./flutter/bin/flutter build web`
- **outputDirectory**: `build/web`

대시보드에서 **Install Command / Build Command**를 비우면(Override 해제) 이 값들이 사용됩니다.

---

## 2. 대시보드에서 직접 넣을 때

**Settings → Build and Deployment**에서 Override를 쓴다면 아래를 그대로 복사해서 넣으세요.

| 항목 | 넣을 값 |
|------|--------|
| **Install Command** | `git clone https://github.com/flutter/flutter.git -b stable --depth 1 && ./flutter/bin/flutter precache --web` |
| **Build Command** | `./flutter/bin/flutter pub get && ./flutter/bin/flutter build web` |
| **Output Directory** | `build/web` |

**중요**: Install에 `precache --web`이 없으면 `flutter build web` 단계에서 실패하거나 불안정할 수 있습니다.

---

## 3. 여전히 실패할 때

- 빌드 로그 끝부분에서 **어느 명령이 exit 1**인지 확인 (pub get vs build web).
- **Build Command**를 한 줄씩 나눠서 로그 보기:
  - `./flutter/bin/flutter pub get`
  - `./flutter/bin/flutter build web`
- 로그에 나온 에러 메시지(예: 패키지 이름, 파일 경로)를 그대로 복사해 두면 원인 파악에 도움이 됩니다.
