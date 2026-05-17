import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/firebase_service.dart';
import '../models/parking_slot.dart';
import 'booking_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final FirebaseService _service = FirebaseService();

  static const CameraPosition _initial = CameraPosition(
    target: LatLng(12.9716, 77.5946), // Bangalore
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Parking Finder")),
      body: StreamBuilder<List<ParkingSlot>>(
        stream: _service.getSlots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final slots = snapshot.data!;

          return GoogleMap(
            initialCameraPosition: _initial,
            markers: slots.map((slot) {
              return Marker(
                markerId: MarkerId(slot.id),
                position: LatLng(slot.lat, slot.lng),
                infoWindow: InfoWindow(
                  title: slot.name,
                  snippet: slot.isAvailable ? "Available" : "Booked",
                  onTap: () {
                    if (slot.isAvailable) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingScreen(slot: slot),
                        ),
                      );
                    }
                  },
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  slot.isAvailable
                      ? BitmapDescriptor.hueGreen
                      : BitmapDescriptor.hueRed,
                ),
              );
            }).toSet(),
          );
        },
      ),
    );
  }
}