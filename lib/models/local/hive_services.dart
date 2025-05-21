import 'package:hive/hive.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/models/local/cache.dart';

class HiveServices {

  static Future<void> openUserBoxes() async {
    final phone = Cache.getPhone();
    if (phone != null) {
      if(!Hive.isBoxOpen(getTableName(productsTable))) {
        await Hive.openBox(getTableName(productsTable));
      }
      if(!Hive.isBoxOpen(getTableName(sellsTable))) {
        await Hive.openBox(getTableName(sellsTable));
      }
      if(!Hive.isBoxOpen(getTableName(extraExpensesTable))) {
        await Hive.openBox(getTableName(extraExpensesTable));
      }
      if(!Hive.isBoxOpen(getTableName(sidesTable))) {
        await Hive.openBox(getTableName(sidesTable));
      }
      if(!Hive.isBoxOpen(getTableName(adsTable))) {
        await Hive.openBox(getTableName(adsTable));
      }
    }
  }

  static String getTableName(String table) {
    final phone = Cache.getPhone();
    return "${phone}_$table";
  }
}