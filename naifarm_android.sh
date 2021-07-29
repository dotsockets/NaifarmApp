#!/bin/bash appbundle
flutter clean
flutter pub get
flutter build appbundle --target-platform android-arm,android-arm64  --build-name=2.1.3 --build-number=49 --flavor production  -t lib/config/Main_production.dart
cd android
fastlane distribute_prod


