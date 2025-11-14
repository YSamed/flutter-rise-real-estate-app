import 'package:flutter/material.dart';
import 'package:partice_project/models/auth_models.dart';
import 'package:partice_project/services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Check initial auth status
  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        _status = AuthStatus.authenticated;
        await loadUser();
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Login
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final response = await AuthService.login(
        username: username,
        password: password,
      );

      // Load user data
      await loadUser();

      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiError catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _status = AuthStatus.error;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Load User Data
  Future<void> loadUser() async {
    try {
      _user = await AuthService.getMe();
      notifyListeners();
    } on ApiError catch (e) {
      print('Load user error: ${e.message}');

      // 500 hatası ise user bilgisi yüklenemedi ama login geçerli
      if (e.statusCode != null && e.statusCode! >= 500) {
        // User bilgisi yüklenemedi ama devam et
        _errorMessage = null; // Hata gösterme
      } else {
        _errorMessage = e.message;
        if (e.statusCode == 401) {
          // Token invalid, logout
          await logout();
        }
      }
    } catch (e) {
      print('Load user error: ${e.toString()}');
      // Hata olsa da devam et
      _errorMessage = null;
    }
  }

  // Logout
  Future<void> logout() async {
    await AuthService.logout();
    _status = AuthStatus.unauthenticated;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

