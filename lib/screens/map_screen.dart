import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'booking_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final dbRef = FirebaseDatabase.instance.ref("slots");
  final Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = {};
  bool loading = true;
  Map<String, dynamic> allSlots = {};

@override
void initState() {
  super.initState();

  dbRef.onValue.listen((event) {
    final data = event.snapshot.value;

    print("FIREBASE DATA: $data"); 

    if (data == null) {
      print("NO DATA FROM FIREBASE");
      setState(() => loading = false);
      return;
    }

    final map = Map<String, dynamic>.from(data as Map);
    allSlots = map;

    Set<Marker> temp = {};

    map.forEach((key, value) {
      final slot = Map<String, dynamic>.from(value);

      temp.add(
        Marker(
          markerId: MarkerId(key),
          position: LatLng(
            (slot['lat'] as num).toDouble(),
            (slot['lng'] as num).toDouble(),
          ),
          infoWindow: InfoWindow(
  title: slot['name'],
  snippet:
      "Status: ${slot['isAvailable'] ? "Available" : "Occupied"}\nTap to manage",
),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            slot['isAvailable']
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingScreen(slotId: key),
              ),
            );
          },
        ),
      );
    });

    setState(() {
      markers = temp;
      loading = false;
    });
  });
}

  // nearest slot function
  double distance(lat1, lon1, lat2, lon2) {
    const R = 6371;
    var dLat = (lat2 - lat1) * pi / 180;
    var dLon = (lon2 - lon1) * pi / 180;

    var a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);

    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

void findNearestSlot() async {
  double userLat = 12.9716;
  double userLng = 77.5946;

  double minDist = double.infinity;
  LatLng? nearest;

  allSlots.forEach((key, value) {
    final slot = Map<String, dynamic>.from(value);

    if (slot['isAvailable'] == true) {
      final lat = (slot['lat'] as num).toDouble();
      final lng = (slot['lng'] as num).toDouble();

      double d = distance(userLat, userLng, lat, lng);

      if (d < minDist) {
        minDist = d;
        nearest = LatLng(lat, lng);
      }
    }
  });

  if (nearest != null) {
    final controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(nearest!, 16),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No available slots")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Parking Finder")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(12.9716, 77.5946),
                zoom: 14,
              ),
              markers: markers,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
            ),

      // find nearest button
      floatingActionButton: FloatingActionButton(
        onPressed: findNearestSlot,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}