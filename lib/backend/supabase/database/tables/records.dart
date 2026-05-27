import '../database.dart';

class RecordsTable extends SupabaseTable<RecordsRow> {
  @override
  String get tableName => 'records';

  @override
  RecordsRow createRow(Map<String, dynamic> data) => RecordsRow(data);
}

class RecordsRow extends SupabaseDataRow {
  RecordsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RecordsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get firstname => getField<String>('firstname')!;
  set firstname(String value) => setField<String>('firstname', value);

  String? get middlename => getField<String>('middlename');
  set middlename(String? value) => setField<String>('middlename', value);

  String get lastname => getField<String>('lastname')!;
  set lastname(String value) => setField<String>('lastname', value);

  double get year => getField<double>('year')!;
  set year(double value) => setField<double>('year', value);

  String get course => getField<String>('course')!;
  set course(String value) => setField<String>('course', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
