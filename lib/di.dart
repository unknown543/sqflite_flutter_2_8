import 'package:get_it/get_it.dart';

import '../controller/sqflite_db_controller.dart';
import '../utils/validation.dart';

final locator = GetIt.instance;
void init() {
  locator.registerSingleton(SqfLiteDbController());
  locator.registerSingleton(Validator());
}
