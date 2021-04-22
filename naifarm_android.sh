#!/bin/bash appbundle
flutter clean
flutter pub get
flutter build appbundle --no-sound-null-safety  --build-name=0.0.5 --build-number=5 --flavor production  -t lib/config/Main_production.dart
cd android
fastlane distribute_prod

