# The Examples of DocC for Swift Package

This repository provides the examples of DocC for Swift package from creatiing to deploying

## Overview

### How to create DocC Catalog
[Apple Developer Link](https://developer.apple.com/documentation/Xcode/documenting-apps-frameworks-and-packages)

> **Apple says...**:
>
> For Swift packages, place the documentation catalog in the same folder as your library’s source files for DocC to associate the catalog with the library.

Add DocC Catalogue by following the instructions:
1. Go to Project Navigator in Xcode and Select Source/{TARGET_NAME} folder
2. Right click > New File... > Open File Template Selector
3. Go to Documentation Section, Select Documentation Catolog Template. Then, click Next
4. Change file name if need

## Deploy to GitHub Pages via GitHub Actions

### Set Deployment Condition to GitHub Actions

1. Go to Settings > Pages > Build and deployment
2. Set Source to "GitHub Actions"

### Set up GitHub Token permission for deployment
```yml
# Set up GITHUB_TOKEN permission to deploy to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write
```

### 필수 설정
```yml
environment:
  # Mandatory settings for GitHub Pages
  name: github-pages
  url: ${{ steps.deployment.outputs.page_url }}
```

### 문서 빌드

```yml
xcodebuild docbuild -scheme {TARGET_NAME} \
  -derivedDataPath /tmp/docbuild \
  -destination 'generic/platform=iOS';
$(xcrun --find docc) process-archive \
  transform-for-static-hosting /tmp/docbuild/Build/Products/Debug-iphoneos/{TARGET_NAME}.doccarchive \
  --hosting-base-path {REPOSITORY_NAME} \
  --output-path docs; # export to the path: docs
echo "<script>window.location.href += \"/documentation/{TARGET_NAME}\"</script>" > docs/index.html
```

If you use docc-plugin,

```yml
swift package --allow-writing-to-directory {OUTPUT_PATH} \
    generate-documentation --target {TARGET_NAME} \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path {REPOSITORY_NAME} \ 
    --output-path {OUTPUT_PATH}
```

### Upload Artifact

```yml
- name: Upload artifact
  uses: actions/upload-pages-artifact@v1
  with:
    # Upload files in `/docs` path
    path: 'docs'
```

### Deploy to GitHub Pages
```
- name: GitHub Pages 에 배포
  id: deployment
  uses: actions/deploy-pages@v1
```

### FAQ

#### Issue #1: Swift Package Compiler Version

macos-latest doesn't have Xcode15 (the latest version of Xcode is 14.1).

**Resolve**

Set up the version of...
- macOS to **13**
- xcode to **15**

```yml
jobs:
  deploy:
  runs-on: macos-13  # latest macOS version
  steps:
  - name: Setup Xcode version
    uses: maxim-lobanov/setup-xcode@v1 # to specify xcode version
    with:
      xcode-version: '15.0'
```

#### Issue #2: The PR doesn't deploy even its base branch is "main"

**Reason**
When you go to Settings > Environment > GitHub Protection rule, it should be set to "main".
Therefore, the production rule doesn't allow to the PR branch


## Deploy to GitHub Pages via docc-plugin

> **Reference**
>
> [Apple Swift DocC Plugin Documentation](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/)

### Set Deployment Condition to Branch

1. Settings > Pages > Build and deployment
2. Set Source to "Deploy from a branch"
3. Select "main", "/docs" as Branch
4. Click Save

### docc-plugin
1. Add dependency to Package.swift
```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main"),
],
```

2. Use docc-plugin command in Terminal

```bash
$ swift package --allow-writing-to-directory {OUTPUT_PATH} \
    generate-documentation --target {TARGET_NAME} \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path {REPOSITORY_NAME} \ 
    --output-path {OUTPUT_PATH}
```

| Placeholder | Example |
| --- | --- |
| **OUTPUT_PATH** | `./docs` |
| **TARGET_NAME** | `PackageDocCExample` |
| **REPOSITORY_NAME** | `package-docc-example` |

| Command | Description |
| --- | --- |
| `--allow-writing-to-directory {OUTPUT_PATH}` | Allow writing to the path where the output should be located |
| `generate-documentation --target {TARGET_NAME}` | Generate documentation for the target |
| `--disable-indexing` | Disable indexing |
| `--transform-for-static-hosting` | Transform for static hosting. It generates css, html files, not `doccarchive` file |
| `--hosting-base-path {REPOSITORY_NAME}` | Set up the base path for hosting |
| `--output-path {OUTPUT_PATH}` | The path where the output will be located |

3. Commit & Push

### Create Script

[GENERATE_DOCS.sh](/GENERATE_DOCS.sh) 참고

```bash
chmod +x ./GENERATE_DOCS.sh
./GENERATE_DOCS.sh
``` 
