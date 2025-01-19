import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiniMap extends StatelessWidget {
  final LatLng location;

  const MiniMap({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('event_location'),
            position: location,
          ),
        },
        liteModeEnabled: true,
      ),
    );
  }
}
