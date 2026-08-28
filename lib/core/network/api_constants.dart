import 'package:flutter/foundation.dart';

class ApiConstants {
  // Automatically uses localhost for development and Render for production
  static const String baseUrl = kReleaseMode
      ? "https://onrender.com"
      : "http://localhost:8080";
}
