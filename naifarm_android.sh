#!/bin/bash
flutter clean
flutter pub get
flutter build apk --no-sound-null-safety  --build-name=0.0.5 --build-number=1 --flavor production  -t lib/config/Main_production.dart
cd android
fastlane distribute_prod

