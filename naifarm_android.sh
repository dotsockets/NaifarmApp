#!/bin/bash appbundle
flutter clean
flutter pub get
flutter build appbundle --target-platform android-arm,android-arm64  --build-name=2.1.7 --build-number=53 --flavor production  -t lib/config/Main_production.dart
cd android
fastlane distribute_prod


