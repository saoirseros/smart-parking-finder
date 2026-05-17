import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/firebase_service.dart';

class QRScreen extends StatelessWidget {
  final String slotId;
  final FirebaseService service = FirebaseService();

  QRScreen({super.key, required this.slotId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Parking QR")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImageView(
            data: slotId,
            size: 250,
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () async {
              await service.releaseSlot(slotId);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("Exit Parking"),
          )
        ],
      ),
    );
  }
}