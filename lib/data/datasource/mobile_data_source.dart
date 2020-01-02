import 'package:what_next/data/database/data_repository.dart';
import 'package:what_next/data/database/mobile_data_service.dart';

class DataSource {
  DataSource._();

  static Repository getRepo({String userId}) {
    return MobileDataService(userId: userId);
  }
}
