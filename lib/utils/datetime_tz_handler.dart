import 'package:timezone/standalone.dart' as tz;

class DateTimeHandler {
  static Map<String, tz.Location> getTzList() {
    return tz.timeZoneDatabase.locations;
  }

  static tz.TZDateTime getNow(String loc) {
    var location = tz.getLocation(loc);
    var now = tz.TZDateTime.now(location);
    return now;
  }

  static String userAt(String tz) {
    return getNow(tz).toIso8601String();
  }
}

class TzHandler {
  static List<String> data = DateTimeHandler.getTzList().keys.toList();

  static List<dynamic> returnLoc(List<String> locations) {
    final countryLi = [];
    for (var i = 0; i < locations.length; i++) {
      countryLi.add(data
              .toList()
              .map((e) => e.toLowerCase().split('/')[1])
              .contains(locations[i].toLowerCase())
          ? data
              .toList()
              .firstWhere((e) => e.toLowerCase().split('/')[1] == locations[i])
          : 'No TimeZone');
    }
    return countryLi;
  }

  static final countries = [
    ...(TzHandler.returnLoc(['tokyo', 'london'])),
  ];
}
