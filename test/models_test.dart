import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'churchdata_core_test.dart';
import 'models/basic_data_object.dart';

void main() {
  group(
    "Models' tests ->",
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'ModelsTestsScope');
          registerFirebaseMocks();

          GetIt.I.registerSingleton(DatabaseRepository());
          GetIt.I.registerSingleton<FunctionsService>(FunctionsService());
        },
      );

      tearDown(() async => GetIt.I.reset());

      test(
        'DataObject tests ->',
        () async {
          final unit = BasicDataObject(
            ref: GetIt.I<DatabaseRepository>().collection('col').doc('doc'),
            name: 'name',
            color: Colors.green.shade500,
          );

          await unit.set();

          expect(
            unit.ref,
            GetIt.I<DatabaseRepository>().collection('col').doc('doc'),
          );
          expect(unit.name, 'name');
          expect(unit.color, Colors.green.shade500);

          expect(unit.id, 'doc');
          expect(unit.toJson(), {
            'Name': unit.name,
            'Color': unit.color?.value,
          });

          final doc = await unit.ref.get();
          expect(BasicDataObject.fromJsonDoc(doc), unit);

          await unit.update(old: {'Name': 'name'});
          expect((await unit.ref.get()).data(), unit.toJson());

          await unit.set(merge: {'name': 'newName'});
          expect((await unit.ref.get()).data(), {
            ...unit.toJson(),
            'name': 'newName',
          });

          await unit.set(merge: {'Name': 'f', 'name': 'newName'});
          expect((await unit.ref.get()).data(), {
            ...unit.toJson(),
            'Name': 'f',
            'name': 'newName',
          });
        },
      );

      group(
        'QueryInfo tests',
        () {
          test(
            'Test case 1',
            () async {
              const queryJson = {
                'collection': 'collection',
                'fieldPath': 'fieldPath',
                'operator': '=',
                'queryValue': null,
                'order': 'true',
                'orderBy': 'fieldOrder',
                'descending': 'true',
              };

              final unit = QueryInfo.fromJson(queryJson);

              expect(
                unit.collection.id,
                'collection',
              );
              expect(unit.fieldPath, 'fieldPath');
              expect(unit.operator, '=');
              expect(unit.queryValue, isNull);
              expect(unit.order, isTrue);
              expect(unit.orderBy, 'fieldOrder');
              expect(unit.descending, isTrue);

              expect(unit.toJson(), queryJson);
            },
          );

          test(
            'Test case 2',
            () async {
              const queryJson = {
                'collection': 'collection',
                'fieldPath': 'fieldPath',
                'operator': '>',
                'queryValue': 'Btrue',
                'order': 'false',
                'orderBy': 'fieldOrder',
                'descending': 'false',
              };

              final unit = QueryInfo.fromJson(queryJson);

              expect(
                unit.collection.id,
                'collection',
              );
              expect(unit.fieldPath, 'fieldPath');
              expect(unit.operator, '>');
              expect(unit.queryValue, isTrue);
              expect(unit.order, isFalse);
              expect(unit.orderBy, 'fieldOrder');
              expect(unit.descending, isFalse);

              expect(unit.toJson(), queryJson);
            },
          );

          test(
            'Test case 3',
            () async {
              const queryJson = {
                'collection': 'collection',
                'fieldPath': 'fieldPath',
                'operator': '<',
                'queryValue': 'Bfalse',
                'order': 'false',
                'orderBy': 'fieldOrder',
                'descending': 'false',
              };

              final unit = QueryInfo.fromJson(queryJson);

              expect(
                unit.collection.id,
                'collection',
              );
              expect(unit.fieldPath, 'fieldPath');
              expect(unit.operator, '<');
              expect(unit.queryValue, isFalse);
              expect(unit.order, isFalse);
              expect(unit.orderBy, 'fieldOrder');
              expect(unit.descending, isFalse);

              expect(unit.toJson(), queryJson);
            },
          );

          test(
            'Test case 4',
            () async {
              const queryJson = {
                'collection': 'collection',
                'fieldPath': 'fieldPath',
                'operator': '<',
                'queryValue': 'Dcollection/path',
                'order': 'false',
                'orderBy': 'fieldOrder',
                'descending': 'true',
              };

              final unit = QueryInfo.fromJson(queryJson);

              expect(
                unit.collection.id,
                'collection',
              );
              expect(unit.fieldPath, 'fieldPath');
              expect(unit.operator, '<');
              expect(unit.queryValue, const TypeMatcher<JsonRef>());
              expect((unit.queryValue as JsonRef).path, 'collection/path');
              expect(unit.order, isFalse);
              expect(unit.orderBy, 'fieldOrder');
              expect(unit.descending, isTrue);

              expect(unit.toJson(), queryJson);
            },
          );

          test(
            'Test case 5',
            () async {
              const queryJson = {
                'collection': 'collection',
                'fieldPath': 'fieldPath',
                'operator': '>',
                'queryValue': 'T1641052756360',
                'order': 'true',
                'orderBy': 'fieldOrder',
                'descending': 'true',
              };

              final unit = QueryInfo.fromJson(queryJson);

              expect(
                unit.collection.id,
                'collection',
              );
              expect(unit.fieldPath, 'fieldPath');
              expect(unit.operator, '>');
              expect(unit.queryValue, const TypeMatcher<DateTime>());
              expect((unit.queryValue as DateTime).millisecondsSinceEpoch,
                  1641052756360);
              expect(unit.order, isTrue);
              expect(unit.orderBy, 'fieldOrder');
              expect(unit.descending, isTrue);

              expect(unit.toJson(), queryJson);
            },
          );

          test(
            'Test case 6',
            () async {
              const queryJson = {
                'collection': 'collection',
                'fieldPath': 'fieldPath',
                'operator': '<',
                'queryValue': 'I1641052756360',
                'order': 'false',
                'orderBy': 'fieldOrder',
                'descending': 'true',
              };

              final unit = QueryInfo.fromJson(queryJson);

              expect(
                unit.collection.id,
                'collection',
              );
              expect(unit.fieldPath, 'fieldPath');
              expect(unit.operator, '<');
              expect(unit.queryValue, const TypeMatcher<int>());
              expect(unit.queryValue, 1641052756360);
              expect(unit.order, isFalse);
              expect(unit.orderBy, 'fieldOrder');
              expect(unit.descending, isTrue);

              expect(unit.toJson(), queryJson);
            },
          );

          test(
            'Test case 7',
            () async {
              const queryJson = {
                'collection': 'collection',
                'fieldPath': 'fieldPath',
                'operator': '=',
                'queryValue': 'Sabc',
                'order': 'false',
                'orderBy': 'fieldOrder',
                'descending': 'true',
              };

              final unit = QueryInfo.fromJson(queryJson);

              expect(
                unit.collection.id,
                'collection',
              );
              expect(unit.fieldPath, 'fieldPath');
              expect(unit.operator, '=');
              expect(unit.queryValue, const TypeMatcher<String>());
              expect(unit.queryValue, 'abc');
              expect(unit.order, isFalse);
              expect(unit.orderBy, 'fieldOrder');
              expect(unit.descending, isTrue);

              expect(unit.toJson(), queryJson);
            },
          );
        },
      );

      test(
        'User test',
        () async {
          const unit = UserBase(
            uid: 'uid',
            name: 'name',
            email: 'email',
            phone: 'phone',
          );

          expect(unit.props, [
            'uid',
            'name',
            'email',
            'phone',
            PermissionsSet.empty,
          ]);

          expect(unit.toJson(), {
            'Name': 'name',
            'Email': 'email',
            'Phone': 'phone',
            'Permissions': unit.permissions.permissions
          });
        },
      );
    },
  );
}
