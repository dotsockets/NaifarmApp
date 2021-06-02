#!/bin/bash appbundle
flutter clean
flutter pub get
flutter build appbundle --target-platform android-arm,android-arm64  --build-name=1.0.2 --build-number=36 --flavor production  -t lib/config/Main_production.dart
cd android
fastlane distribute_prod


