import 'package:hive/hive.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/models/local/cache.dart';

class HiveServices {

  static Future<void> openUserBoxes() async {
    final phone = Cache.getPhone();
    if (phone != null) {
      await Future.wait([
        Hive.openBox(getTableName(productsTable)),
        Hive.openBox(getTableName(sellsTable)),
        Hive.openBox(getTableName(extraExpensesTable)),
        Hive.openBox(getTableName(sidesTable)),
        Hive.openBox(getTableName(adsTable)),
      ]);
    }
  }

  static String getTableName(String table) {
    final phone = Cache.getPhone();
    return "${phone}_$table";
  }
}