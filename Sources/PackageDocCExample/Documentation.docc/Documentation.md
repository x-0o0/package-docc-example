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
