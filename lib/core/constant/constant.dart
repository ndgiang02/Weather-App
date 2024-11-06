const String kApiHost = 'api.openweathermap.org';
const String kIconHost = 'www.openweathermap.org';
const String kUnit = 'metric';
const String kLimit = '1';

const String kApiMap = 'api.openrouteservice.org';


class Urls {
  static String weatherIcon(String iconCode) =>
      'http://openweathermap.org/img/wn/$iconCode@2x.png';
}