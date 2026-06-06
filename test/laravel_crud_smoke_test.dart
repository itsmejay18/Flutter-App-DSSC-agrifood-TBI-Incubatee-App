import 'dart:convert';

import 'package:exam/services/laravel_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Laravel mobile API client sends booking CRUD through /api/mobile',
      () async {
    SharedPreferences.setMockInitialValues({});
    final seen = <String>[];

    final client = MockClient((request) async {
      seen.add('${request.method} ${request.url.path}');

      if (request.url.host != 'example.test') {
        return http.Response('{"message":"wrong host"}', 500);
      }

      switch ('${request.method} ${request.url.path}') {
        case 'POST /api/mobile/login':
          return _json({
            'token': 'token-123',
            'data': {
              'id': 1,
              'email': 'user@example.com',
              'display_name': 'Ana Santos',
            },
          });
        case 'POST /api/mobile/bookings':
        case 'PUT /api/mobile/bookings/7':
        case 'POST /api/mobile/payments/gcash':
          expect(request.headers['Authorization'], 'Bearer token-123');
          return _json({
            'data': {
              'id': 7,
              'reservation_code': 'PBJ-TEST',
              'payment_status': 'pending_verification',
            },
          });
        case 'DELETE /api/mobile/bookings/7':
          expect(request.headers['Authorization'], 'Bearer token-123');
          return _json({'message': 'Booking cancelled.'});
      }

      return http.Response('{"message":"not found"}', 404);
    });

    final api = LaravelApi(client: client, baseUrl: 'https://example.test');
    await api.login(email: 'user@example.com', password: 'password');
    await api.createBooking({
      'location_id': 1,
      'court_id': 1,
      'reservation_date': '2026-06-05',
      'start_time': '08:00',
      'end_time': '09:00',
      'equipment': <Map<String, dynamic>>[],
    });
    await api.updateBooking(7, {
      'location_id': 1,
      'court_id': 1,
      'reservation_date': '2026-06-05',
      'start_time': '09:00',
      'end_time': '10:00',
    });
    await api.payGcash(
      reservationId: 7,
      referenceNumber: 'GCASH-REF-123',
      senderNumber: '09170000000',
    );
    await api.cancelBooking(7);

    expect(seen, [
      'POST /api/mobile/login',
      'POST /api/mobile/bookings',
      'PUT /api/mobile/bookings/7',
      'POST /api/mobile/payments/gcash',
      'DELETE /api/mobile/bookings/7',
    ]);
  });
}

http.Response _json(Map<String, dynamic> body) {
  return http.Response(
    jsonEncode(body),
    200,
    headers: {'Content-Type': 'application/json'},
  );
}
