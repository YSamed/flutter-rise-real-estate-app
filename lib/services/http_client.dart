import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:partice_project/models/auth_models.dart';
import 'package:partice_project/services/storage_service.dart';
import 'package:partice_project/services/auth_service.dart';

/// HTTP Client with automatic token refresh
class HttpClient {
  static const String baseUrl = 'http://193.111.78.74';

  /// Authenticated GET request with auto token refresh
  static Future<http.Response> get(String endpoint) async {
    return await _makeAuthenticatedRequest(
      () async {
        final accessToken = await StorageService.getAccessToken();
        return await http.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );
      },
    );
  }

  /// Authenticated POST request with auto token refresh
  static Future<http.Response> post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    return await _makeAuthenticatedRequest(
      () async {
        final accessToken = await StorageService.getAccessToken();
        return await http.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(body),
        );
      },
    );
  }

  /// Authenticated PUT request with auto token refresh
  static Future<http.Response> put(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    return await _makeAuthenticatedRequest(
      () async {
        final accessToken = await StorageService.getAccessToken();
        return await http.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(body),
        );
      },
    );
  }

  /// Authenticated DELETE request with auto token refresh
  static Future<http.Response> delete(String endpoint) async {
    return await _makeAuthenticatedRequest(
      () async {
        final accessToken = await StorageService.getAccessToken();
        return await http.delete(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );
      },
    );
  }

  /// Generic request handler with automatic token refresh on 401
  static Future<http.Response> _makeAuthenticatedRequest(
    Future<http.Response> Function() requestFunction,
  ) async {
    try {
      // İlk istek
      var response = await requestFunction();

      // 401 hatası alındıysa token refresh dene
      if (response.statusCode == 401) {
        // Token'ı refresh et
        await AuthService.refreshToken();

        // İsteği tekrar dene
        response = await requestFunction();
      }

      return response;
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Public POST (authentication gerekmeden)
  static Future<http.Response> publicPost(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    try {
      return await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } catch (e) {
      throw ApiError(
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Public GET (authentication gerekmeden)
  static Future<http.Response> publicGet(String endpoint) async {
    try {
      return await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      throw ApiError(
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}


