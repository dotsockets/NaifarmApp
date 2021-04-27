#!/bin/bash appbundle
flutter clean
flutter pub get
flutter build appbundle --release  --build-name=0.0.13 --build-number=13 --flavor production  -t lib/config/Main_production.dart
cd android
fastlane distribute_prod

