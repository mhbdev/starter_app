import 'package:apex_api/apex_api.dart';

/// This is a sample of a DataModel/Response class
/// Be sure that you add [FetchSomething.fromJson]
/// into ../requests.dart [responseModels]
class FetchSomething extends DataModel {
  final int id;

  FetchSomething._(this.id);

  factory FetchSomething.fromJson(Json json) {
    return FetchSomething._(
      json.optInt('id', defaultValue: 0)!,
    );
  }
}
