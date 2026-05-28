import 'package:flutter_test/flutter_test.dart';

import 'package:exam/backend/supabase/supabase.dart';

void main() {
  test('Laravel (ngrok) CRUD smoke test', () async {
    final table = RecordsTable();

    RecordsRow? created;
    try {
      created = await table.insert({
        'firstname': 'FlutterSmoke',
        'middlename': 'T',
        'lastname': 'Test',
        'year': 1,
        'course': 'BSCS',
        'photo_url': null,
      });

      expect(created.id, isNotNull);
      expect(created.firstname, 'FlutterSmoke');

      await table.update(
        data: {
          'firstname': 'FlutterSmokeUpdated',
          'middlename': created.middlename,
          'lastname': created.lastname,
          'year': 2,
          'course': created.course,
          'photo_url': created.photoUrl,
        },
        matchingRows: (rows) => rows.eqOrNull('id', created!.id),
      );

      final fetched = await table.querySingleRow(
        queryFn: (q) => q.eqOrNull('id', created!.id),
      );
      expect(fetched, isNotEmpty);
      expect(fetched.first.firstname, 'FlutterSmokeUpdated');
    } finally {
      final id = created?.id;
      if (id != null) {
        await table.delete(
          matchingRows: (rows) => rows.eqOrNull('id', id),
        );
      }
    }
  });
}

