# ``PackageDocCExample``

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

## 시작하기

```swift
struct ContentView: View {
    @StateObject private var sevenSegment = SevenSegment()

    var body: some View {
        VStack {
            BinarySwitchView(modelData: sevenSegment)

            SevenSegmentView(modelData: sevenSegment)
        }
    }
}
```

``SevenSegment`` 에 대한 자세한 내용은 <doc:SevenSegment> 를 참고하세요.
