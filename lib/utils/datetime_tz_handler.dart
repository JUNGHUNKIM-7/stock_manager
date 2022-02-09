import 'package:timezone/standalone.dart' as tz;

class DateTimeHandler {
  static List<String> getTzList() {
    return tz.timeZoneDatabase.locations.keys.toList();
  }

  static tz.TZDateTime getNow(String loc) {
    final location = tz.getLocation(loc);
    final now = tz.TZDateTime.now(location);
    return now;
  }

  static String userAt(String tz) {
    return getNow(tz).toIso8601String();
  }
}
