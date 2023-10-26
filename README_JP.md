# Swift パッケージの DocC の例

Swift パッケージの DocC の作成からデプロイまでの例です。

> **重要**
>
> この内容は*ChatGPT*で作成されたため、翻訳に誤りが含まれる可能性があります。

[👉ENGLISH Ver.](/README_ENG.md): This repository provides examples of DocC for Swift package, covering the process from creation to deployment.

[👉한국어 버전](/README.md): 스위프트 패키지를 위한 DocC 생성부터 배포까지의 예시를 제공하는 레포지토리입니다.

## 概要

### ドキュメント カタログの作成方法
[公式ドキュメントリンク](https://developer.apple.com/documentation/Xcode/documenting-apps-frameworks-and-packages)

> **Apple ドキュメントから**:
>
> Swift パッケージの場合、DocC がカタログをライブラリと関連付けるために、カタログをライブラリのソースファイルと同じフォルダに配置します。
>
> (翻訳) Swift パッケージの場合、ライブラリのソースファイルがあるフォルダにドキュメント カタログを配置してください。

以下の手順に従って、ドキュメント カタログを追加します:
1. Xcode でプロジェクトナビゲータでパッケージの `Source/{パッケージ名}` フォルダを選択します。
2. 右クリックして '新しいファイル...' を選択し、ファイルテンプレートの選択ウィンドウを開きます。
3. Documentation セクションで 'Documentation Catalog' テンプレートを選択して '次へ' をクリックします。
4. ファイル名が必要な場合は変更します。

## GitHub Pages でのデプロイに GitHub Actions を使用する

### デプロイ条件を GitHub Actions で設定する

Settings > Pages > Build and deployment で 'Source' を 'GitHub Actions' に変更します。

### GitHub Pages デプロイのための GitHub トークンの権限設定

```yml
# GitHub Pages へのデプロイのための GITHUB_TOKEN の権限設定
permissions:
  contents: read
  pages: write
  id-token: write
```

### 必須設定

```yml
environment:
  # GitHub Pages へのデプロイのための必須設定
  name: github-pages
  url: ${{ steps.deployment.outputs.page_url }}
```

### ドキュメントのビルド

```yml
xcodebuild docbuild -scheme {ターゲット_名} \
  -derivedDataPath /tmp/docbuild \
  -destination 'generic/platform=iOS';
$(xcrun --find docc) process-archive \
  transform-for-static-hosting /tmp/docbuild/Build/Products/Debug-iphoneos/{ターゲット_名}.doccarchive \
  --hosting-base-path {リポジトリ_名} \
  --output-path docs; # 'docs' パスに抽出
echo "<script>window.location.href += \"/documentation/{ターゲット名_小文字}\"</script>" > docs/index.html
```

もし `docc-plugin` への依存関係がある場合、

```yml
swift package --allow-writing-to-directory {保存場所} \
    generate-documentation --target {ターゲット名} \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path {リポジトリ_名} \ 
    --output-path {保存場所}
```

### アーティファクトのアップロード

```yml
- name: アーティファクトのアップロード
  uses: actions/upload-pages-artifact@v1
  with:
    # 'docs' パスにあるものだけアップロード
    path: 'docs'
```

### GitHub Pages へのデプロイ

```
- name: GitHub Pages へのデプロイ
  id: deployment
  uses: actions/deploy-pages@v1
```

### 遭遇するかもしれない問題

#### Swift パッケージのビルドバージョンの問題

現在のパッケージは最小ビルドバージョンが 5.9 なので、Xcode 15 にバージョンを固定しないとコンパイルエラーが発生することがあります。

**解決策**

macOS バージョンを 13 に、Xcode バージョンを 15 に設定します。

```yml
jobs:
  deploy:
  runs-on: macos-13  #最新バージョン
  steps:
  - name: Xcode バージョンのセットアップ
    uses: maxim-lobanov/setup-xcode@v1 # Xcode バージョンの設定のため
    with:
      xcode-version: '15.0'
```

#### デプロイされない main をベースにした PR の問題

Settings > Environment > GitHub Protection rule を確

---

## docc-pluginを使用してGitHub Pagesにデプロイする

> **参考**
>
> [Apple Swift DocC Plugin 公式ドキュメント](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/)

### ブランチでのデプロイ設定

1. Settings > Pages > Build and deployment
2. Sourceを「Deploy from a branch」に変更
3. Branchにmain、/docsを選択
4. Saveをクリック

### docc-plugin
1. Package.swiftに依存関係を追加
```swift
dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main"),
],
```

2. ターミナルでdocc-pluginコマンドを使用

```bash
$ swift package --allow-writing-to-directory {保存場所} \
    generate-documentation --target {ターゲット名} \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path {リポジトリ名} \ 
    --output-path {保存場所}
```

| 値 | 例 |
| --- | --- |
| {保存場所} | `./docs` |
| {ターゲット名} | `PackageDocCExample` |
| {リポジトリ名} | `package-docc-example` |

| コマンド | 意味 |
| --- | --- |
| `--allow-writing-to-directory {保存場所}` | 保存したい場所への書き込み許可 |
| `generate-documentation --target {ターゲット名}` | 特定のターゲットに対するドキュメントの生成 |
| `--disable-indexing` | インデックスの無効化 |
| `--transform-for-static-hosting` | 静的ホスティングのための形式に変換。 `doccarchive` ではなく、css、htmlファイルが生成されます |
| `--hosting-base-path {リポジトリ名}` | ホスティングのベースパスを指定 |
| `--output-path {保存場所}` | ドキュメントファイルの保存場所 |

3. コミット後、プッシュ

### スクリプトで作成する

[GENERATE_DOCS.sh](/GENERATE_DOCS.sh) を参照

```bash
chmod +x ./GENERATE_DOCS.sh
./GENERATE_DOCS.sh
```
