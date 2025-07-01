## 🔧 프로젝트 실행 방법

본 프로젝트는 Windows 환경의 Android Studio와 Flutter SDK를 활용하여 개발되었습니다.
에뮬레이터 설치 없이 웹 브라우저에서 바로 실행할 수 있도록 구성되어 있습니다.

### 1. Flutter SDK 설치
 👉  https://flutter.dev/docs/get-started/install

### 2. Android Studio 설치 및 설
 👉 https://developer.android.com/studio?hl=ko
 

보다 쉬운 설치와 설정을 원하신다면 아래 블로그의 챕터 5까지만 따라 하시면 됩니다.

 👉 https://blockdmask.tistory.com/420

 
 File -> Project Structure -> Project 메뉴에서 Flutter SDK 경로가 정확히 설정되어 있는지 확인해주세요.

### 3. 패키지 의존성 설치
루트 디렉토리에서 아래 명령어를 실행해주세요

`flutter pub get`


### 4.Flutter는 기본적으로 main.dart가 실행 파일로 설정되어야 합니다.
Android Studio의 Run 창 상단에서 main.dart가 선택되어 있는지 확인하세요.

![image](https://github.com/user-attachments/assets/d83fa3a3-47c6-4c23-8846-ab0c1b454986)

✅ 만약 선택되어 있지 않다면 수동으로 클릭해 지정해주세요.

### 5. 웹 실행 (CORS 우회 포함)
   웹사이트의 cros 정책 때문에 아래와 같이 실행합니다.

   `flutter run -d chrome --web-browser-flag "--disable-web-security"`

