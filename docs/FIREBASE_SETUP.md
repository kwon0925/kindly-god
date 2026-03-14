# Firebase 설정 가이드 (Kindly)

아래 순서대로 Firebase Console에서 설정해 주시면, 앱에서 **로그인·게시판** 등을 연동할 수 있습니다.

---

## ✅ 현재 프로젝트 설정 (kindly-god)

콘솔에서 발급한 **웹 앱 설정이 맞습니다.**  
동일한 값이 `lib/config/firebase_config.dart`에 들어 있어, 나중에 `firebase_core`·Authentication·Firestore 연동 시 그대로 사용하면 됩니다.

---

## 1. 프로젝트 생성

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. **프로젝트 추가** → 프로젝트 이름 입력 (예: kindly-god)
3. Google Analytics 사용 여부 선택 (선택 사항)
4. 프로젝트 생성 완료

---

## 2. 웹 앱 등록

1. 프로젝트 개요 → **웹(</>)** 아이콘 클릭
2. 앱 닉네임 입력 (예: kindly-web)
3. **Firebase Hosting은 사용 안 함** 체크 해도 됨 (Vercel 사용 시)
4. **앱 등록** 후 나오는 `firebaseConfig` 객체를 복사해 두기  
   - 나중에 `lib/config/firebase_options.dart` 또는 환경 변수로 사용

예시:
```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "xxx.firebaseapp.com",
  projectId: "xxx",
  storageBucket: "xxx.appspot.com",
  messagingSenderId: "123...",
  appId: "1:123:web:abc..."
};
```

---

## 3. Authentication (로그인)

1. 왼쪽 메뉴 **Build → Authentication** 이동
2. **시작하기** 클릭
3. **Sign-in method** 탭에서 다음 제공업체 **사용 설정**:

   | 제공업체 | 설정 내용 |
   |----------|-----------|
   | **Google** | 사용 설정 → 프로젝트 지원 이메일 선택 → 저장 |
   | **Apple** | 사용 설정 → Services ID 등 Apple 개발자 계정 설정 필요 (iOS/웹에서 Apple 로그인 시) |

4. **승인된 도메인**에 로컬/배포 도메인 추가  
   - 로컬: `localhost`  
   - 배포: Vercel 도메인 (예: `xxx.vercel.app`)

이렇게 설정해 두시면, 제가 **Flutter 앱에서 Google/Apple 로그인** 코드를 연동할 수 있습니다.

---

## 3-1. Google 로그인(웹) — OAuth 클라이언트 ID 필수

**"로그인에 실패했습니다"** 가 나오면, 웹용 **OAuth 2.0 클라이언트 ID**가 없어서입니다. 아래를 반드시 설정하세요.

1. [Google Cloud Console](https://console.cloud.google.com/) 접속 → 프로젝트 **kindly-god** 선택  
2. **APIs & Services** → **Credentials** 이동  
3. **OAuth 2.0 Client IDs** 목록에서 **Web client** (유형: 웹 애플리케이션) 찾기  
   - 없으면 **+ CREATE CREDENTIALS** → **OAuth client ID** → 애플리케이션 유형 **웹 애플리케이션** → 이름 입력 후 만들기  
4. 만들어진 클라이언트의 **클라이언트 ID** 복사 (형식: `377587650257-xxxxxxxxxx.apps.googleusercontent.com`)  
5. **승인된 JavaScript 원본**에 다음 추가:
   - `http://localhost`
   - `http://localhost:포트번호` (Flutter 웹 실행 포트, 예: 7357)
   - 배포 시: `https://your-app.vercel.app` 등

### 앱에 넣을 곳 (같은 값 2곳)

| 위치 | 할 일 |
|------|--------|
| **`lib/config/firebase_config.dart`** | `googleWebClientId = null` → `googleWebClientId = '복사한_클라이언트_ID'` 로 변경 |
| **`web/index.html`** | `<meta name="google-signin-client_id" content="복사한_클라이언트_ID">` 로 `content` 값을 위와 동일하게 설정 |

저장 후 다시 **Google로 로그인** 버튼을 눌러 보세요.

---

## 4. Firestore Database (게시판·데이터)

1. **Build → Firestore Database** 이동
2. **데이터베이스 만들기** 클릭
3. **보안 규칙**은 먼저 **테스트 모드**로 시작 후, 아래처럼 규칙 수정 권장
4. 위치 선택 (예: `asia-northeast3` 서울)

### 컬렉션 구조 (제가 코드에서 사용할 예정)

| 컬렉션 | 용도 | 주요 필드 예시 |
|--------|------|----------------|
| `users` | 회원 프로필 (로그인 후 생성) | `uid`, `email`, `displayName`, `religionId`, `countryId`, `createdAt` |
| `posts` | 활동 소식 게시판 | `title`, `summary`, `body`, `imageUrl`, `createdAt`, `authorId` |
| `religions` | 종교 목록/포인트 | `id`, `name`, `nameEn`, `points` |
| `point_logs` | 포인트 적립 내역 (응원/광고) | `userId`, `religionId`, `countryId`, `points`, `source`, `createdAt` |

### Firestore 보안 규칙 예시 (나중에 조정)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 로그인 사용자만 읽기/쓰기 (게시판은 나중에 공개 읽기로 변경 가능)
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /posts/{postId} {
      allow read: if true;
      allow create, update, delete: if request.auth != null;
    }
    match /religions/{id} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /point_logs/{id} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

이 구조로 설정해 두시면, 제가 **게시판 CRUD·회원 프로필·포인트 기록**을 Firestore로 연동할 수 있습니다.

---

## 5. Storage (이미지 업로드, 선택)

- 활동 소식에 **이미지**를 올릴 경우: **Build → Storage** 에서 Storage 만들기
- 제가 게시판에서 이미지 URL 저장 시 **Firebase Storage** 연동 가능

---

## 6. Flutter 프로젝트에 필요한 것

설정 후, 제가 코드에서 사용할 수 있도록 다음 중 하나를 해 주시면 됩니다.

1. **FlutterFire CLI 사용 (권장)**  
   - 터미널에서 프로젝트 폴더에서:  
     `dart run flutterfire_configure`  
   - Firebase 로그인 후 자동으로 `lib/firebase_options.dart` 생성됨  
   - 이 파일이 있으면 제가 `firebase_core` / `firebase_auth` / `cloud_firestore` 초기화 및 연동 코드 작성 가능

2. **수동 설정**  
   - 웹 앱 등록 시 나온 `firebaseConfig` 값을 알려주시거나  
   - `lib/config/firebase_options.dart` 에 같은 형태로 만들어 두시면  
   - 제가 그걸 기준으로 `main.dart` 초기화 및 로그인/게시판 코드 작성 가능

---

## 요약: 당신이 설정해 주면 제가 할 수 있는 것

| Firebase 설정 | 제가 앱에서 연동할 수 있는 기능 |
|---------------|----------------------------------|
| Authentication (Google, Apple) | 로그인 / 로그아웃 / 회원 확인 |
| Firestore (컬렉션: users, posts, religions, point_logs) | 게시판 목록·상세·작성·수정·삭제, 회원 프로필, 포인트 기록 |
| Storage (선택) | 게시판 이미지 업로드·표시 |
| 웹 앱 등록 후 `firebaseConfig` 또는 `firebase_options.dart` | 앱 초기화 및 위 서비스 모두 연동 |

위처럼 설정해 두시면, 게시판·로그인 등을 코드에서 관리할 수 있습니다.
