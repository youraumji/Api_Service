import 'package:flutter/material.dart';
import 'package:mytestapp/AirService.dart';

class AirQuality extends StatefulWidget {
  const AirQuality({super.key});

  @override
  _AirQualityState createState() => _AirQualityState();
}

class _AirQualityState extends State<AirQuality> {
  final AirService airQualityService = AirService();
  int? aqi;
  String city = "";
  double? temperature;
  String airQualityStatus = "";
  Color aqiColor = const Color.fromARGB(255, 37, 35, 35);

  Future<void> fetchData() async {
    final data = await airQualityService.fetchAirQuality();
    if (data != null) {
      setState(() {
        aqi = data['aqi'];
        city = data['city'];
        temperature = data['temperature'];
        if (aqi != null) {
          setAirQualityStatus(aqi!);
        }
      });
    }
  }

  void setAirQualityStatus(int aqi) {
    if (aqi <= 50) {
      airQualityStatus = "Good";
      aqiColor = Colors.green;
    } else if (aqi <= 100) {
      airQualityStatus = "Moderate";
      aqiColor = Colors.yellow;
    } else if (aqi <= 150) {
      airQualityStatus = "Unhealthy for\nSensitive Groups";
      aqiColor = Colors.orange;
    } else if (aqi <= 200) {
      airQualityStatus = "Unhealthy";
      aqiColor = Colors.red;
    } else if (aqi <= 300) {
      airQualityStatus = "Very Unhealthy";
      aqiColor = Colors.purple;
    } else {
      airQualityStatus = "Hazardous";
      aqiColor = Colors.brown;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Air Quality Index (AQI)",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFDDE6ED),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFFDF6EC),
        child: Center(
          child: aqi == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ชื่อจังหวัด
                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // AQI และสถานะ
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: aqiColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "$aqi",
                            style: const TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            airQualityStatus,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // อุณหภูมิ
                    Text(
                      "Temperature: ${temperature?.toStringAsFixed(1)}°C",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 55),
                    // ปุ่ม Refresh
                    ElevatedButton(
                      onPressed: fetchData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 100, 156, 251),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text(
                        "Refresh",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
