# Agri Guide

A Smart Innovative Platform for Crop Prediction

# Execution

* For normal execution: 
  - `flutter run --target=lib\main.dart`

* For execution on GCP:
  - Start Compute instance
  - Fetch the latest API branch and start the server
  - Get the External IP Address as `host_ip`
  - Port 4999 as `port`
  - `flutter run --target=lib\main.dart --dart-define=base_url="http://host_ip:port"`
