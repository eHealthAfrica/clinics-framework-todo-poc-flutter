import 'package:what_next/data/database/data_repository.dart';

class DataSource {
  DataSource._();
  static Repository getRepo({String userId}) {
    throw 'Platform Not Supported';
  }
}