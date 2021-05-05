#!/bin/bash appbundle
flutter clean
flutter pub get
flutter build appbundle --target-platform android-arm,android-arm64  --build-name=0.0.23 --build-number=23 --flavor production  -t lib/config/Main_production.dart
cd android
fastlane distribute_prod


