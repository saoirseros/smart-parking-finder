import 'package:flutter/material.dart';
import '../models/parking_slot.dart';
import '../services/firebase_service.dart';
import 'qr_screen.dart';

class BookingScreen extends StatelessWidget {
  final ParkingSlot slot;
  final FirebaseService service = FirebaseService();

  BookingScreen({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book ${slot.name}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Slot: ${slot.name}", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await service.bookSlot(slot.id);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QRScreen(slotId: slot.id),
                  ),
                );
              },
              child: const Text("Confirm Booking"),
            ),
          ],
        ),
      ),
    );
  }
}