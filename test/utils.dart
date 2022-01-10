import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:mock_data/mock_data.dart';

import 'models/basic_data_object.dart';

MaterialApp wrapWithMaterialApp(Widget home,
    {Map<String, Widget Function(BuildContext)>? routes,
    GlobalKey<NavigatorState>? navigatorKey}) {
  return MaterialApp(
    home: home,
    navigatorKey: navigatorKey,
    routes: routes ?? {},
  );
}

Future<List<BasicDataObject>> populateWithRandomPersons(JsonCollectionRef ref,
    [int count = 100]) async {
  final list = List.generate(
    count,
    (_) => BasicDataObject(
      ref: ref.doc(),
      name: mockName() + '-' + mockString(),
    ),
  );
  await Future.wait(
    list.map(
      (p) => p.set(),
    ),
  );
  return list;
}
