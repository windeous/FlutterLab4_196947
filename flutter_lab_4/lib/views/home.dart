import 'package:flutter/material.dart';
import 'package:flutter_lab_4/models/exam.dart';
import 'package:flutter_lab_4/views/exam_schedule.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  final List<Exam> exams;

  const HomeScreen({super.key, required this.exams});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final LatLng _defaultPosition = const LatLng(42.0040144, 21.4086502);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_currentPosition!),
      );
    } catch (e) {
      setState(() {
        _isLoading =
            false; 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Tracker Home'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamScheduleScreen(),
                          ),
                        );
                      },
                      child: const Text('Go to Schedule'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _defaultPosition,
                      zoom: 12,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    markers: _buildMarkers(),
                  ),
                ),
              ],
            ),
    );
  }

  Set<Marker> _buildMarkers() {
    return widget.exams
        .where((exam) => exam.location != null)
        .map(
          (exam) => Marker(
            markerId: MarkerId(exam.subject),
            position: exam.location!,
            infoWindow: InfoWindow(
              title: exam.subject,
              snippet: 'Date: ${exam.date}',
            ),
          ),
        )
        .toSet();
  }
}
