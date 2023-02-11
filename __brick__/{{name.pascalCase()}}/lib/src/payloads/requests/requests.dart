import 'package:apex_api/apex_api.dart';

/// A class to manage all requests in a single file
/// You can also create a separated file for each request if you need this
/// to be cleaner.
class Requests extends SimpleRequest {
  static Map<Type, ResType> responseModels = {};

  // TODO : implement other requests like this.
  // Requests.fetchSomething() : super(1, responseMockData: {'success': 1});
}
