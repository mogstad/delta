#!/bin/sh
set -o pipefail && xcodebuild test -project Delta.xcodeproj -scheme iOS -sdk iphonesimulator -destination platform='iOS Simulator',OS=9.1,name='iPhone 5s' | xcpretty
