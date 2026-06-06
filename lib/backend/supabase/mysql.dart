import 'package:supabase_flutter/supabase_flutter.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'database/database.dart';

/// Backend base URL (Laravel via ngrok).
///
/// This replaces the generated Supabase config; all CRUD now goes through
/// your Laravel API.
const String kLaravelBaseUrl =
<<<<<<< HEAD:lib/backend/supabase/mysql.dart
    'https://https://tattling-reoccupy-surfacing.ngrok-free.dev/';
=======
    'https://immaculate-maryetta-inventively.ngrok-free.dev';
>>>>>>> 3effe74ef90c5d1b81edc4c237f91a534c4b9751:lib/backend/supabase/supabase.dart

/// Required to bypass ngrok's browser warning page for programmatic requests.
const String kNgrokSkipBrowserWarningHeader = 'ngrok-skip-browser-warning';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  /// Kept for backwards-compatibility with generated FlutterFlow code.
  /// The app no longer uses Supabase for CRUD, so this client is unused.
  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Map<String, String> defaultHeaders(
      {bool includeJsonContentType = false}) {
    final headers = <String, String>{
      kNgrokSkipBrowserWarningHeader: 'true',
      'Accept': 'application/json',
    };
    if (includeJsonContentType) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }

  /// No-op initialize: Supabase is no longer used as the backend.
  static Future initialize() async {
    return;
  }
}
