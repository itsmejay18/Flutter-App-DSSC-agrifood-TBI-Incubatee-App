import 'database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class SupabaseTable<T extends SupabaseDataRow> {
  String get tableName;
  T createRow(Map<String, dynamic> data);

  /// Laravel API collection endpoint for this table.
  ///
  /// The FlutterFlow project uses a Supabase-style `tableName` ("records"),
  /// but the Laravel API for this project exposes `students`.
  String get _laravelCollectionPath {
    if (tableName == 'records') return '/api/students';
    return '/api/$tableName';
  }

  Future<List<T>> queryRows({
    required dynamic Function(dynamic) queryFn,
    int? limit,
  }) {
    final q = LaravelQuery();
    queryFn(q);
    if (limit != null) q.limit(limit);

    return _laravelGetList(limit: q._limit);
  }

  Future<List<T>> querySingleRow({
    required dynamic Function(dynamic) queryFn,
  }) =>
      _laravelGetSingle(queryFn);

  Future<T> insert(Map<String, dynamic> data) => _laravelCreate(data);

  Future<List<T>> update({
    required Map<String, dynamic> data,
    required dynamic Function(dynamic) matchingRows,
    bool returnRows = false,
  }) async {
    final filter = LaravelFilter();
    matchingRows(filter);

    final id = filter.eqFilters['id']?.toString();
    if (id == null || id.isEmpty) {
      throw Exception('Update requires an id filter.');
    }

    final updated = await _laravelUpdate(id, data);
    return returnRows ? [updated] : [];
  }

  Future<List<T>> delete({
    required dynamic Function(dynamic) matchingRows,
    bool returnRows = false,
  }) async {
    final filter = LaravelFilter();
    matchingRows(filter);

    final id = filter.eqFilters['id']?.toString();
    if (id == null || id.isEmpty) {
      throw Exception('Delete requires an id filter.');
    }

    await _laravelDelete(id);
    return [];
  }

  Uri _uri(String path) => Uri.parse('${kLaravelBaseUrl}${path.startsWith('/') ? '' : '/'}$path');

  Future<List<T>> _laravelGetList({int? limit}) async {
    final res = await http.get(
      _uri(_laravelCollectionPath),
      headers: SupaFlow.defaultHeaders(),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('GET $_laravelCollectionPath failed: ${res.statusCode} ${res.body}');
    }

    final decoded = json.decode(res.body);
    final data = (decoded is Map<String, dynamic> ? decoded['data'] : decoded) as dynamic;
    final list = (data is List ? data : <dynamic>[]);
    final rows = list
        .whereType<Map>()
        .map((m) => Map<String, dynamic>.from(m as Map))
        .map(createRow)
        .toList();

    if (limit != null && limit >= 0 && rows.length > limit) {
      return rows.take(limit).toList();
    }
    return rows;
  }

  Future<List<T>> _laravelGetSingle(dynamic Function(dynamic) queryFn) async {
    final filter = LaravelFilter();
    queryFn(filter);
    final id = filter.eqFilters['id']?.toString();
    if (id == null || id.isEmpty) {
      return [];
    }

    final res = await http.get(
      _uri('$_laravelCollectionPath/$id'),
      headers: SupaFlow.defaultHeaders(),
    );
    if (res.statusCode == 404) return [];
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('GET $_laravelCollectionPath/$id failed: ${res.statusCode} ${res.body}');
    }

    final decoded = json.decode(res.body);
    final data = (decoded is Map<String, dynamic> ? decoded['data'] : decoded) as dynamic;
    if (data is Map) {
      return [createRow(Map<String, dynamic>.from(data as Map))];
    }
    return [];
  }

  Future<T> _laravelCreate(Map<String, dynamic> data) async {
    final res = await http.post(
      _uri(_laravelCollectionPath),
      headers: SupaFlow.defaultHeaders(includeJsonContentType: true),
      body: json.encode(data),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('POST $_laravelCollectionPath failed: ${res.statusCode} ${res.body}');
    }

    final decoded = json.decode(res.body);
    final row = (decoded is Map<String, dynamic> ? decoded['data'] : decoded) as dynamic;
    return createRow(Map<String, dynamic>.from(row as Map));
  }

  Future<T> _laravelUpdate(String id, Map<String, dynamic> data) async {
    final res = await http.put(
      _uri('$_laravelCollectionPath/$id'),
      headers: SupaFlow.defaultHeaders(includeJsonContentType: true),
      body: json.encode(data),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('PUT $_laravelCollectionPath/$id failed: ${res.statusCode} ${res.body}');
    }

    final decoded = json.decode(res.body);
    final row = (decoded is Map<String, dynamic> ? decoded['data'] : decoded) as dynamic;
    return createRow(Map<String, dynamic>.from(row as Map));
  }

  Future<void> _laravelDelete(String id) async {
    final res = await http.delete(
      _uri('$_laravelCollectionPath/$id'),
      headers: SupaFlow.defaultHeaders(),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('DELETE $_laravelCollectionPath/$id failed: ${res.statusCode} ${res.body}');
    }
  }
}

class LaravelQuery {
  int? _limit;

  LaravelQuery limit(int value) {
    _limit = value;
    return this;
  }
}

class LaravelFilter {
  final Map<String, dynamic> eqFilters = <String, dynamic>{};

  LaravelFilter eq(String column, dynamic value) {
    eqFilters[column] = value;
    return this;
  }

  LaravelFilter eqOrNull(String column, dynamic value) {
    if (value != null) {
      eqFilters[column] = value;
    }
    return this;
  }
}

class PostgresTime {
  PostgresTime(this.time);
  DateTime? time;

  static PostgresTime? tryParse(String formattedString) {
    final datePrefix = DateTime.now().toIso8601String().split('T').first;
    return PostgresTime(
        DateTime.tryParse('${datePrefix}T$formattedString')?.toLocal());
  }

  String? toIso8601String() {
    return time?.toIso8601String().split('T').last;
  }

  @override
  String toString() {
    return toIso8601String() ?? '';
  }
}
