set -e

# 사전 정의
OUTPUT_DIRECTORY_PATH="./docs"
TARGET_NAME="PackageDocCExample"
HOSTING_BASE_PATH="package-docc-example"

# 문서 빌드
swift package --allow-writing-to-directory ${OUTPUT_DIRECTORY_PATH} \
    generate-documentation --target ${TARGET_NAME} --disable-indexing \
    --output-path ${OUTPUT_DIRECTORY_PATH} \
    --transform-for-static-hosting \
    --hosting-base-path ${HOSTING_BASE_PATH}
