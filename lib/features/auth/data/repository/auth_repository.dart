import 'package:fcjanja/features/auth/data/models/set_password_request.dart';

import '../../../../core/network/api_service.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<LoginResponse> login(LoginRequest request) {
    return apiService.login(request);
  }

  Future<void> setPassword(String token, SetPasswordRequest request) {
    return apiService.setPassword(token, request);
  }
}
