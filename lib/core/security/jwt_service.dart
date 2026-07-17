import 'package:jwt_decoder/jwt_decoder.dart';

class JwtService {
  bool isAdmin(String token) {
    final decoded = JwtDecoder.decode(token);

    return decoded["role"] == "ADMIN";
  }

  String getFullName(String token) {
    final decoded = JwtDecoder.decode(token);

    return decoded["fullName"];
  }

  String getPhoneNumber(String token) {
    final decoded = JwtDecoder.decode(token);

    return decoded["phoneNumber"];
  }

  int getUserId(String token) {
    final decoded = JwtDecoder.decode(token);

    return decoded["userId"];
  }
}
