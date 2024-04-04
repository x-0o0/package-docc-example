# Distributing Documentation via BitBucket (BitBucket Server)

## 1. Overview

To share your documentation, you create a documentation archive, a self-contained bundle that has everything you need, including:
- Compiled documentation from in-source comments, articles, tutorials, and resources
- A single-page web app that renders the documentation

Distributing your documentation involves the following steps:
1. Export your documentation using the docc command-line tool.
2. Share your documentation by hosting it on a website.

## 2. Methodology

### 2.1. Repository Settings

> Reference: https://support.atlassian.com/bitbucket-cloud/docs/publishing-a-website-on-bitbucket-cloud/

> **Important**: Your repository should belong to some project.

1. Go to **Repository settings** > **Web Pages**
2. Enable pages for branches (or tags)

### 2.2. Generate Documentation
Run command below to configure the web hosting
  a. Go to BitBucket repository settings > Web Pages and refer to URL examples for the file path
  b. **pages/{PROJECT}/{REPOSITORY}/{BRANCH}/browse/docs**
  ```bash
  swift package --allow-writing-to-directory ./docs \
    generate-documentation --target {SCHEME NAME} \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path pages/{PROJECT}/{REPOSITORY}/{BRANCH}/browse/docs \
    --output-path ./docs
  ```

### 2.3. Distributing Documentation
After pushing the commit, it's distributed automatically.
You can check the documentation from the URL:

https://{COMPANY_HOST_URL}/pages/{PROJECT}/{REPOSITORY}/{BRANCH}/browse/docs **/documentation/{FIREST_DOCUMENTATION_NAME}**

e.g., https://repo.jaesung.dev/pages/DDOC/code-style-guide/main/browse/docs/documentation/codestyleguide
