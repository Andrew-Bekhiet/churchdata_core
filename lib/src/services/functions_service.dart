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
    String deletedPath, {
    bool keepBackup = true,
    bool nested = true,
  }) async {
    return httpsCallable('recoverDoc')({
      'deletedPath': deletedPath,
      'keepBackup': keepBackup,
      'nested': nested,
    });
  }
}
