import 'dart:convert';
import 'package:partice_project/models/property_model.dart';
import 'package:partice_project/models/auth_models.dart';
import 'package:partice_project/services/http_client.dart';

class PropertyService {
  /// Get all properties (authenticated endpoint)
  static Future<List<Property>> getProperties({
    String? search,
    String? category,
    String? location,
  }) async {
    try {
      String endpoint = '/properties/';
      List<String> queryParams = [];

      if (search != null && search.isNotEmpty) {
        queryParams.add('search=$search');
      }
      if (category != null && category.isNotEmpty) {
        queryParams.add('category=$category');
      }
      if (location != null && location.isNotEmpty) {
        queryParams.add('location=$location');
      }

      if (queryParams.isNotEmpty) {
        endpoint += '?${queryParams.join('&')}';
      }

      final response = await HttpClient.get(endpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Backend array döndürüyorsa
        if (data is List) {
          return data
              .map((json) => Property.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        }

        // Backend object içinde results döndürüyorsa (pagination)
        if (data is Map && data['results'] != null) {
          return (data['results'] as List)
              .map((json) => Property.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        }

        // Tek property döndürüyorsa
        if (data is Map) {
          return [Property.fromJson(Map<String, dynamic>.from(data))];
        }

        return [];
      } else {
        String errorMessage = 'Failed to fetch properties';
        try {
          final errorBody = jsonDecode(response.body);
          errorMessage = errorBody['detail'] ?? errorMessage;
        } catch (_) {
          errorMessage =
              response.body.isNotEmpty ? response.body : errorMessage;
        }
        throw ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Network error: ${e.toString()}');
    }
  }

  /// Get single property by ID
  static Future<Property> getPropertyById(int id) async {
    try {
      final response = await HttpClient.get('/api/properties/$id/');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Property.fromJson(Map<String, dynamic>.from(data));
      } else {
        String errorMessage = 'Failed to fetch property';
        try {
          final errorBody = jsonDecode(response.body);
          errorMessage = errorBody['detail'] ?? errorMessage;
        } catch (_) {
          errorMessage =
              response.body.isNotEmpty ? response.body : errorMessage;
        }
        throw ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Network error: ${e.toString()}');
    }
  }
}
