import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';

class DefaultViewableObjectService {
  final GlobalKey<NavigatorState> navigatorKey;
  NavigatorState get navigator => navigatorKey.currentState!;

  DefaultViewableObjectService(this.navigatorKey);

  void onTap(Viewable object) {
    if (object is PersonBase)
      navigator.pushNamed('PersonInfo', arguments: object);
    else if (object is QueryInfo)
      navigator.pushNamed('SearchQuery', arguments: object);
  }

  FutureOr<String?> getSecondLine(Viewable object) => object.getSecondLine();
}
