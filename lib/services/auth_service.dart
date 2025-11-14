import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:partice_project/models/auth_models.dart';
import 'package:partice_project/services/storage_service.dart';

class AuthService {
  static const String baseUrl = 'http://193.111.78.74';

  // Login
  static Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(data);

        // Token'ları kaydet
        await StorageService.saveLoginData(
          accessToken: loginResponse.access,
          refreshToken: loginResponse.refresh,
          userId: loginResponse.userId,
          username: loginResponse.username,
        );

        return loginResponse;
      } else {
        final error = jsonDecode(response.body);
        throw ApiError(
          message: error['detail'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Get User Info (Me)
  static Future<User> getMe() async {
    try {
      final accessToken = await StorageService.getAccessToken();
      if (accessToken == null) {
        throw ApiError(message: 'No access token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/me/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Backend hatası varsa basic user bilgisi döndür
        try {
          return User.fromJson(data);
        } catch (parseError) {
          print('Parse error: $parseError');
          // Minimal user object oluştur
          return User(
            id: data['id'] ?? 0,
            username: data['username'] ?? '',
            email: data['email'] ?? '',
            primaryRole: '',
            primaryRoleDisplay: '',
            roles: [],
            isMultiRole: false,
            isStaff: false,
            isActive: true,
            isSuperuser: false,
            dateJoined: DateTime.now(),
          );
        }
      } else if (response.statusCode == 401) {
        // Token expired, try refresh
        await refreshToken();
        return await getMe(); // Retry
      } else {
        // 500 hatası için de login başarılı sayalım
        if (response.statusCode >= 500) {
          throw ApiError(
            message: 'Server error. Login successful but profile unavailable.',
            statusCode: response.statusCode,
          );
        }

        final error = jsonDecode(response.body);
        throw ApiError(
          message: error['detail'] ?? 'Failed to get user info',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Refresh Token
  static Future<String> refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) {
        throw ApiError(message: 'No refresh token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access'];

        // Yeni access token'ı kaydet
        await StorageService.saveAccessToken(newAccessToken);

        return newAccessToken;
      } else {
        // Refresh token da geçersiz, logout gerekli
        await logout();
        throw ApiError(
          message: 'Session expired, please login again',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(
        message: 'Token refresh failed: ${e.toString()}',
      );
    }
  }

  // Logout
  static Future<void> logout() async {
    await StorageService.clearAuthData();
  }

  // Check if logged in
  static Future<bool> isLoggedIn() async {
    return await StorageService.isLoggedIn();
  }
}

