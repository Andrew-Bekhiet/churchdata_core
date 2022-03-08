import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group(
    'Tappable form field widget tests ->',
    () {
      testWidgets(
        'Normal',
        (tester) async {
          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: TappableFormField<String?>(
                  initialValue: null,
                  labelText: 'label',
                  onTap: (state) => state.didChange('newValue'),
                  builder: (context, state) => Text(state.value ?? 'null'),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.text('label'), findsOneWidget);
          expect(find.text('null'), findsOneWidget);
          expect(find.text('newValue'), findsNothing);

          await tester.tap(find.text('null'));
          await tester.pumpAndSettle();

          expect(find.text('label'), findsOneWidget);
          expect(find.text('null'), findsNothing);
          expect(find.text('newValue'), findsOneWidget);
        },
      );
      testWidgets(
        'With Error',
        (tester) async {
          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: TappableFormField<String?>(
                  initialValue: null,
                  labelText: 'label',
                  validator: (value) => value == null ? null : 'error',
                  onTap: (state) => state
                    ..didChange('newValue')
                    ..validate(),
                  builder: (context, state) => Text(state.value ?? 'null'),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.text('label'), findsOneWidget);
          expect(find.text('null'), findsOneWidget);
          expect(find.text('newValue'), findsNothing);
          expect(find.text('error'), findsNothing);

          await tester.tap(find.text('null'));
          await tester.pumpAndSettle();

          expect(find.text('label'), findsOneWidget);
          expect(find.text('null'), findsNothing);
          expect(find.text('newValue'), findsOneWidget);
          expect(find.text('error'), findsOneWidget);
        },
      );
    },
  );
}
