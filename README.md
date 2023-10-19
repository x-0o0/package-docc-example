# 스위프트 패키지 DocC 예시

스위프트 패키지 DocC 생성부터 배포까지의 예시

## Overview

### 문서 카탈로그 생성 방법
[공식 문서 링크](https://developer.apple.com/documentation/Xcode/documenting-apps-frameworks-and-packages)

> **애플 문서 중**:
>
> For Swift packages, place the documentation catalog in the same folder as your library’s source files for DocC to associate the catalog with the library.
>
> (번역) 스위프트 패키지의 경우, 문서 카탈로그를 라이브러리 소스파일들이 있는 폴더에 위치 시켜야 합니다.

다음 절차에 따라서 문서 카탈로그를 추가합니다
1. Xcode 에서 프로젝트 네비게이터에 패키지의 Source/{패키지이름} 폴더를 선택
2. 우클릭 해서 New File... 선택해서 파일 템플릿 선택창을 엽니다
3. Documentation 섹션에서 Documentation Catolog 템플릿을 선택하고 Next 클릭
4. 파일 이름 필요시 변경

## 깃헙 액션으로 GitHub Pages 배포하기

### 배포 조건을 깃헙 액션으로 설정하기

Settings > Pages > Build and deployment 에서 Source 를 GitHub Actions 로 변경

### 배포를 위한 깃헙토큰 권한 설정
```yml
# GitHub Pages 에 배포하기 위한 GITHUB_TOKEN 권한 설정
permissions:
  contents: read
  pages: write
  id-token: write
```

### 필수 설정
```yml
environment:
  # GitHub Pages 로 배포하기 위한 필수 설정
  name: github-pages
  url: ${{ steps.deployment.outputs.page_url }}
```

### 문서 빌드

```yml
xcodebuild docbuild -scheme {타겟_이름} \
  -derivedDataPath /tmp/docbuild \
  -destination 'generic/platform=iOS';
$(xcrun --find docc) process-archive \
  transform-for-static-hosting /tmp/docbuild/Build/Products/Debug-iphoneos/{타겟_이름}.doccarchive \
  --hosting-base-path {레포지토리_이름} \
  --output-path docs; # docs 라는 경로로 추출
echo "<script>window.location.href += \"/documentation/{타겟이름_소문자}\"</script>" > docs/index.html
```

만약 docc-plugin 의존성이 추가되어 있는 경우,

```yml
swift package --allow-writing-to-directory {저장위치} \
    generate-documentation --target {타겟이름} \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path {레포지토리_이름} \ 
    --output-path {저장위치}
```

### Artifact 업로드

```yml
- name: artifact 업로드
  uses: actions/upload-pages-artifact@v1
  with:
    # docs 경로에 있는 것만 업로드
    path: 'docs'
```

### GitHub Pages에 배포
```
- name: GitHub Pages 에 배포
  id: deployment
  uses: actions/deploy-pages@v1
```

### 마주할 수 있는 문제

#### 스위프트 패키지 빌드 버전 문제

현재 패키지는 5.9 가 최소 빌드 버전이기 때문에 Xcode15 로 버전을 고정시켜주지 않으면 컴파일 에러가 발생

**해결 방법**

macOS 버전 13으로, xcode 버전 15로 설정

```yml
jobs:
  deploy:
  runs-on: macos-13  #최신버전
  steps:
  - name: Setup Xcode version
    uses: maxim-lobanov/setup-xcode@v1 # xcode 버전 설정을 위함
    with:
      xcode-version: '15.0'
```

#### main 을 베이스 브랜치로 하는 PR 에서 배포 안되는 문제

Settings > Environment > GitHub Protection rule 가보면 main 으로 설정되어 있기 때문에 
해당 규칙이 적용되지 않은 PR 브랜치에서는 배포가 불가능


## docc-plugin 으로 GitHub Pages 배포하기

> **참고**
>
> [애플 Swift DocC Plugin 공식 문서](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/)

### 배포 조건을 브랜치로 설정하기

1. Settings > Pages > Build and deployment
2. Source 를 Deploy from a branch 로 변경
3. Branch 에 main, /docs 로 선택
4. Save 클릭

### docc-plugin
1. Package.swift 에 디펜던시 추가
```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main"),
],
```

2. 터미널에 docc-plugin 커멘드 사용

```bash
$ swift package --allow-writing-to-directory {저장위치} \
    generate-documentation --target {타겟이름} \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path {레포지토리-이름} \ 
    --output-path {저장위치}
```

| 값 | 예시 |
| --- | --- |
| 저장위치 | `./docs` |
| 타겟이름 | `PackageDocCExample` |
| 레포지토리-이름 | `package-docc-example` |

| 명령어 | 의미 |
| --- | --- |
| `--allow-writing-to-directory {저장위치}` | 저장하고자 하는 경로에 대한 쓰기 권한 허용 |
| `generate-documentation --target {타겟이름}` | 해당 타겟에 대한 문서 생성 |
| `--disable-indexing` | 인덱싱 비활성화 |
| `--transform-for-static-hosting` | 정적 호스팅을 위한 형태로 변형. `doccarchive` 가 아닌 css, html 파일이 생성됨 |
| `--hosting-base-path {레포지토리-이름}` | 호스팅 경로 지정 |
| `--output-path {저장위치}` | 문서 파일 저장 위치 |

3. 커밋 후 푸시

### 스크립트로 만들기

[GENERATE_DOCS.sh](/GENERATE_DOCS.sh) 참고

```bash
chmod +x ./GENERATE_DOCS.sh
./GENERATE_DOCS.sh
``` 
