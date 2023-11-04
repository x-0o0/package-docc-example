# `xcodebuild docbuild` 명령어로 문서 빌드 배포하기

`xcodebuild docbuild` 로 doccarchive 파일 추출 및 정적 웹 호스팅을 위한 형태로 변형하는 과정을 담았습니다.

## 서론

`docc-plugin` 의 경우 mac 으로 빌드하고 build destination 을 변경할 수 없습니다. 
build destination 을 변경하고자 하는 경우 `xcodebuild` 커맨드라인툴의 `docbuild` 명령어를 사용해야합니다.

## 방법

### 1. 문서 아카이브 파일 생성 (`.doccarchive`)

```bash
xcodebuild docbuild -scheme BoxOffice \
  -derivedDataPath /tmp/docbuild \
  -destination 'generic/platform=iOS'
```
`docbuild` 는 문서 아카이브 (`.doccarchive`) 파일을 생성하는 명령어<sup>[1](#footnote_1)</sup> 입니다. `docbuild`의 옵션은 다음과 같습니다.

| 옵션 | 설명 | 예시 코드 |
| --- | --- | --- |
| `-scheme {스킴이름}` |  문서 빌드를 하고자하는 스킴 | `-scheme MyPackage` |
| `-derivedDataPath {아카이브저장위치}` | 저장 위치. 필수는 아니지만 이 옵션을 포함하면 `.doccarchive` 번들을 찾을 때 용이. | `-derivedDataPath /tmp/docbuild` |
| `-destination {플랫폼}` | 빌드 destination | `-destination 'generic/platform=iOS' |


### 2. 정적 호스팅을 위한 형태로 변형 (`/docs`)

```bash
$(xcrun --find docc) process-archive \
  transform-for-static-hosting /tmp/docbuild/Build/Products/Debug-iphoneos/{타겟이름}.doccarchive \
  --hosting-base-path {레포지토리_이름} \
  --output-path {저장위치}
```

`xcrun --find docc` 는 `docc` 도구를 실행시키는 명령어 입니다. `process-archive` 는 아카이브를 처리하는 `docc` 명령어 입니다.

| 옵션 | 설명 | 예시코드 |
| --- | --- | --- |
| `transform-for-static-hosting`<sup>[2](#footnote_2)</sup> | 호스팅 형태로 바꿀 `.doccarchive` 파일 위치 | `transform-for-static-hosting /tmp/docbuild/Build/Products/Debug-iphoneos/BoxOffice.doccarchive` |
| `--hosting-base-path {호스팅경로}` | 호스팅할 주소의 base 경로 값. 깃헙페이지의 경우 레포지토리 이름. | --hosting-base-path my-repository-name \ |
| `--output-path {결과물저장위치} | 결과물 저장 위치. (`/docs` 로 하는 것을 권장) | `--output-path ./docs` |

### 결과

`/docs` 경로에 웹 호스팅이 가능한 파일들이 위치한 것을 알 수 있습니다. [방법1](#1-문서-아카이브-파일-생성-doccarchive) 과 [방법2](#2-정적-호스팅을-위한-형태로-변형-docs) 의 명령어들을 `.sh` 스크립트 파일로 저장해두면 GitHub Actions 로 배포<sup>[3](#footnote_3)</sup>할 때 용이하다.

## 고찰

`-destination` 옵션 설정 시 `generic/platform=iOS` 에서 `generic` 을 제외시키면 모든 iOS 시뮬레이터로 빌드하기 때문에 긴 빌드 시간이 소요되었다. 
따라서 특정 시뮬레이터들을 돌려야 하는 경우가 아니면 `generic` 을 포함시키는 것이 좋다.

## 참고문헌

<a name="footnote_1">1</a>: [https://developer.apple.com/documentation/xcode/distributing-documentation-to-external-developers](https://developer.apple.com/documentation/xcode/distributing-documentation-to-external-developers#:~:text=xcodebuild%20docbuild%20%2Dscheme%20SlothCreator%20%2DderivedDataPath%20~/Desktop/SlothCreatorBuild), Apple, Inc.

<a name="footnote_2">2</a>: [https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/generating-documentation-for-hosting-online/), Apple, Inc.

<a name="footnote_3">3</a>: [https://github.com/jaesung-0o0/package-docc-example](https://github.com/jaesung-0o0/package-docc-example#깃헙-액션으로-github-pages-배포하기)
