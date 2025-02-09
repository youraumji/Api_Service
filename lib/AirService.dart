import 'package:http/http.dart' as http;
import 'dart:convert';

class AirService {
  final String apiUrl =
      'https://api.waqi.info/feed/here/?token=6615c4aacf7291f9e800aeeafd67a713d2494250';

  Future<Map<String, dynamic>?> fetchAirQuality() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'aqi': data['data']['aqi'],
          'city': data['data']['city']['name'],
          'temperature': data['data']['iaqi']['t']['v'].toDouble(),
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
