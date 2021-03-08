#!/bin/bash
flutter clean
flutter pub get
flutter build apk   --build-name=0.0.6 --build-number=1 --flavor staging  -t lib/config/Main_staging.dart
cd android
fastlane distribute_staging

