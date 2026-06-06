import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String kLaravelBaseUrl = String.fromEnvironment(
  'LARAVEL_BASE_URL',
  defaultValue: 'https://tattling-reoccupy-surfacing.ngrok-free.dev',
);

class LaravelApiException implements Exception {
  LaravelApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class LaravelApi {
  LaravelApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? kLaravelBaseUrl).replaceAll(RegExp(r'/+$'), '');

  final http.Client _client;
  final String _baseUrl;
  String? _token;

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  String publicAsset(String path) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$_baseUrl$cleanPath';
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('mobile_token');
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile_token', token);
  }

  Future<void> clearSession() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mobile_token');
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final body = await _post(
      '/login',
      {'email': email, 'password': password},
      authenticated: false,
    );
    await _saveToken(body['token'] as String);
    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
    final body = await _post(
      '/register',
      {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'mobile_number': mobileNumber,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      authenticated: false,
    );
    await _saveToken(body['token'] as String);
    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<Map<String, dynamic>> me() async {
    final body = await _get('/me');
    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    String? emergencyContactName,
    String? emergencyContactNumber,
  }) async {
    final body = await _put('/profile', {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile_number': mobileNumber,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_number': emergencyContactNumber,
    });
    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<void> logout() async {
    if (isAuthenticated) {
      try {
        await _post('/logout', {});
      } catch (_) {
        // Keep local logout available when the tunnel is offline.
      }
    }
    await clearSession();
  }

  Future<Map<String, dynamic>> dashboard() async {
    final body = await _get('/dashboard');
    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<Map<String, dynamic>> catalog() async {
    final body = await _get('/catalog');
    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<List<Map<String, dynamic>>> bookings() => _list('/bookings');

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    final body = await _post('/bookings', data);
    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<Map<String, dynamic>> updateBooking(
    int reservationId,
    Map<String, dynamic> data,
  ) async {
    final body = await _put('/bookings/$reservationId', data);
    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<void> cancelBooking(int reservationId) async {
    await _delete('/bookings/$reservationId');
  }

  Future<Map<String, dynamic>> payGcash({
    required int reservationId,
    required String referenceNumber,
    String? senderNumber,
  }) async {
    final body = await _post('/payments/gcash', {
      'reservation_id': reservationId,
      'gcash_reference_number': referenceNumber,
      'gcash_sender_number': senderNumber,
    });
    return Map<String, dynamic>.from(body['data'] as Map);
  }

  Future<List<Map<String, dynamic>>> receipts() => _list('/receipts');

  Future<List<Map<String, dynamic>>> _list(String path) async {
    final body = await _get(path);
    final data = body['data'];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final response = await _client.get(_uri(path), headers: _headers());
    return _decode(response);
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data, {
    bool authenticated = true,
  }) async {
    final response = await _client.post(
      _uri(path),
      headers: _headers(authenticated: authenticated, json: true),
      body: jsonEncode(_withoutNulls(data)),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> _put(
    String path,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.put(
      _uri(path),
      headers: _headers(json: true),
      body: jsonEncode(_withoutNulls(data)),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> _delete(String path) async {
    final response = await _client.delete(_uri(path), headers: _headers());
    return _decode(response);
  }

  Uri _uri(String path) => Uri.parse('$_baseUrl/api/mobile$path');

  Map<String, String> _headers({bool authenticated = true, bool json = false}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
    if (json) {
      headers['Content-Type'] = 'application/json';
    }
    if (authenticated && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Map<String, dynamic> _decode(http.Response response) {
    final decoded =
        response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    final body = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'data': decoded};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final errors = body['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) {
        throw LaravelApiException(
          first.first.toString(),
          statusCode: response.statusCode,
        );
      }
    }

    throw LaravelApiException(
      (body['message'] ?? 'Request failed with status ${response.statusCode}')
          .toString(),
      statusCode: response.statusCode,
    );
  }

  Map<String, dynamic> _withoutNulls(Map<String, dynamic> data) {
    final cleaned = <String, dynamic>{};
    for (final entry in data.entries) {
      final value = entry.value;
      if (value == null) {
        continue;
      }
      if (value is String && value.trim().isEmpty) {
        continue;
      }
      cleaned[entry.key] = value;
    }
    return cleaned;
  }
}
