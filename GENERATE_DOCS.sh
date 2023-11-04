set -e

# 사전 정의 (Definition)
OUTPUT_PATH="./docs"
TARGET_NAME="PackageDocCExample"
HOSTING_BASE_PATH="package-docc-example"
# for `xcodebuild docbuild`
# BUILD_DESTINATION="generic/platform=iOS" 
# BUILD_PATH="/tmp/docbuild"
# DOCCARCHIVE_PATH="${BUILD_PATH}/Build/Products/Debug-iphoneos/${TARGET_NAME}.doccarchive"

# ---------------------
# docc-plugin
# ----------------------
swift package --allow-writing-to-directory ${OUTPUT_PATH} \
    generate-documentation --target ${TARGET_NAME} --disable-indexing \
    --output-path ${OUTPUT_PATH} \
    --transform-for-static-hosting \
    --hosting-base-path ${HOSTING_BASE_PATH}

# ---------------------
# xcodebuild
# ----------------------
# xcodebuild docbuild \
#     -scheme ${TARGET_NAME} \
#     -destination ${BUILD_DESTINATION} \
#     -derivedDataPath ${BUILD_PATH}
#    
# $(xcrun --find docc) process-archive \
#     transform-for-static-hosting ${DOCCARCHIVE_PATH} \
#     --hosting-base-path ${HOSTING_BASE_PATH} \
#     --output-path ${OUTPUT_PATH}
