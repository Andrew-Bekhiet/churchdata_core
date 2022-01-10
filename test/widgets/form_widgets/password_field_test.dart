import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  group(
    'Password field widget tests ->',
    () {
      group(
        'Widget structure ->',
        () {
          testWidgets(
            'Basic',
            (tester) async {
              await tester.pumpWidget(
                wrapWithMaterialApp(
                  const Scaffold(
                    body: PasswordFormField(),
                  ),
                ),
              );

              expect(find.text('كلمة السر'), findsOneWidget);
              expect(find.byType(TextField), findsOneWidget);
              expect(find.widgetWithIcon(IconButton, Icons.visibility),
                  findsOneWidget);
            },
          );

          testWidgets(
            'Label',
            (tester) async {
              await tester.pumpWidget(
                wrapWithMaterialApp(
                  const Scaffold(
                    body: PasswordFormField(
                      labelText: 'label',
                    ),
                  ),
                ),
              );

              expect(find.text('label'), findsOneWidget);
              expect(find.byType(TextField), findsOneWidget);
              expect(find.widgetWithIcon(IconButton, Icons.visibility),
                  findsOneWidget);
            },
          );
        },
      );

      testWidgets(
        'Functionallity',
        (tester) async {
          await tester.pumpWidget(
            wrapWithMaterialApp(
              const Scaffold(
                body: PasswordFormField(
                  key: Key('PasswordField'),
                ),
              ),
            ),
          );

          bool isObsecuringText() => tester
              .firstWidget<TextField>(
                find.descendant(
                  of: find.byKey(const Key('PasswordField')),
                  matching: find.byType(TextField),
                  matchRoot: true,
                ),
              )
              .obscureText;

          expect(isObsecuringText(), isTrue);
          await tester.tap(find.widgetWithIcon(IconButton, Icons.visibility));
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.visibility), findsNothing);
          expect(find.byIcon(Icons.visibility_off), findsOneWidget);
          expect(isObsecuringText(), isFalse);

          await tester
              .tap(find.widgetWithIcon(IconButton, Icons.visibility_off));
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.visibility), findsOneWidget);
          expect(find.byIcon(Icons.visibility_off), findsNothing);
          expect(isObsecuringText(), isTrue);
        },
      );
    },
  );
}
