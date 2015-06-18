xcrun xcodebuild \
    -SYMROOT=build \
    -derivedDataPath build \
    ARCHS="i386 x86_64" \
    VALID_ARCHS="i386 x86_64" \
    ONLY_ACTIVE_ARCH=NO \
    -workspace EnTurma.xcworkspace \
    -scheme EnTurma-cal \
    -sdk iphonesimulator \
    -configuration DEBUG \
    clean build

export APP_BUNDLE_PATH = "build/Build/Products/Release-iphonesimulator/EnTurma-cal.app"

cucumber
