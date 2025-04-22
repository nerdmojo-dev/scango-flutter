import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scango/services/api_client.dart';

class SOSButton extends StatelessWidget {
  final ApiClient _apiClient = ApiClient();

  SOSButton({Key? key}) : super(key: key);

  Future<void> _sendSOS(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          throw Exception('Location permission denied.');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await _apiClient.post('/mobile/student/emergency/sos', {
        'lat': position.latitude,
        'lang': position.longitude,
      });

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🚨 SOS Alert Sent Successfully')),
        );
      } else {
        throw Exception('Failed to send SOS');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _sendSOS(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink.shade200,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(50),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shield, size: 50, color: Colors.white),
            SizedBox(height: 8),
            Text(
              "SOS",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
