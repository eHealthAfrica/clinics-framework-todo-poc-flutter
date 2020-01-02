import 'package:what_next/data/database/data_repository.dart';
import 'package:what_next/data/database/web_data_service.dart';

class DataSource {
  DataSource._();
  static Repository getRepo({String userId}) {
    return WebDataService(userId: userId);
  }
}