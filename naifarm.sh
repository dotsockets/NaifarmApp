#!/bin/bash
flutter build apk   --build-name=0.0.5 --build-number=1 --flavor staging  -t lib/config/Main_staging.dart
cd android
fastlane distribute_staging

