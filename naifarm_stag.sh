#!/bin/bash
flutter clean
flutter pub get
flutter build apk --no-sound-null-safety  --build-name=0.0.1 --build-number=1 --flavor staging  -t lib/config/Main_staging.dart
cd android
fastlane distribute_staging

