#!/bin/bash appbundle
flutter clean
flutter pub get
flutter build appbundle --release  --build-name=0.0.8 --build-number=8 --flavor production  -t lib/config/Main_production.dart
cd android
fastlane distribute_prod

