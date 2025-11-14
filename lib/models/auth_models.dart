// Login Request Model
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

// Login Response Model
class LoginResponse {
  final String access;
  final String refresh;
  final int userId;
  final String username;

  LoginResponse({
    required this.access,
    required this.refresh,
    required this.userId,
    required this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        access: json['access'],
        refresh: json['refresh'],
        userId: json['user_id'],
        username: json['username'],
      );
}

// User Model (for /me/ endpoint)
class User {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String primaryRole;
  final String primaryRoleDisplay;
  final List<String> roles;
  final bool isMultiRole;
  final bool isStaff;
  final bool isActive;
  final bool isSuperuser;
  final DateTime? lastLogin;
  final DateTime dateJoined;
  final Map<String, dynamic>? profiles;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    required this.primaryRole,
    required this.primaryRoleDisplay,
    required this.roles,
    required this.isMultiRole,
    required this.isStaff,
    required this.isActive,
    required this.isSuperuser,
    this.lastLogin,
    required this.dateJoined,
    this.profiles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        phone: json['phone'],
        primaryRole: json['primary_role'] ?? '',
        primaryRoleDisplay: json['primary_role_display'] ?? '',
        roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
        isMultiRole: json['is_multi_role'] ?? false,
        isStaff: json['is_staff'] ?? false,
        isActive: json['is_active'] ?? true,
        isSuperuser: json['is_superuser'] ?? false,
        lastLogin:
            json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
        dateJoined: json['date_joined'] != null
            ? DateTime.parse(json['date_joined'])
            : DateTime.now(),
        profiles: json['profiles'],
      );

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}

// Token Refresh Response
class TokenRefreshResponse {
  final String access;

  TokenRefreshResponse({required this.access});

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) =>
      TokenRefreshResponse(
        access: json['access'],
      );
}

// API Error Model
class ApiError {
  final String message;
  final int? statusCode;
  final String? code;

  ApiError({
    required this.message,
    this.statusCode,
    this.code,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        message: json['detail'] ?? json['message'] ?? 'Unknown error',
        code: json['code'],
        statusCode: null,
      );
}

