import 'package:churchdata_core/churchdata_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get_it/get_it.dart';

class FunctionsService {
  FunctionsService();

  HttpsCallable httpsCallable(
    String functionName, {
    HttpsCallableOptions? options,
  }) {
    return GetIt.I<FirebaseFunctions>()
        .httpsCallable(functionName, options: options);
  }

  Future<HttpsCallableResult> recoverDocument(
    JsonRef deletedDoc, {
    bool keepBackup = true,
    bool nested = true,
  }) async {
    return httpsCallable('recoverDoc')({
      'deletedPath': deletedDoc.path,
      'keepBackup': keepBackup,
      'nested': nested,
    });
  }

  Future<HttpsCallableResult> registerFCMToken(String token) async {
    return httpsCallable('registerFCMToken')({'token': token});
  }
}
