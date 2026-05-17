import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingScreen extends StatelessWidget {
  final String slotId;

  const BookingScreen({
    super.key,
    required this.slotId,
  });

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref("slots/$slotId");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Slot Details"),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: ref.get(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              Map<String, dynamic>.from(
                snapshot.data!.value as Map,
              );

          final bool isAvailable =
              data['isAvailable'] == true;

          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  data['name'],

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "📍 ${data['description'] ?? "Parking Area"}",

                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Latitude: ${data['lat']}",
                ),

                Text(
                  "Longitude: ${data['lng']}",
                ),

                const SizedBox(height: 25),

                Text(
                  isAvailable
                      ? "Available"
                      : "Occupied",

                  style: TextStyle(
                    color: isAvailable
                        ? Colors.green
                        : Colors.red,

                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    icon: Icon(
                      isAvailable
                          ? Icons.local_parking
                          : Icons.cancel,
                    ),

                    label: Text(
                      isAvailable
                          ? "Book Slot"
                          : "Unbook Slot",
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),

                    onPressed: () async {
                      //toggle status
                      await ref.update({
                        "isAvailable":
                            !isAvailable,
                      });

                      //booking logic
                      if (isAvailable) {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => QRScreen(
                              slotId: slotId,
                              slotName:
                                  data['name'],
                            ),
                          ),
                        );
                      }

                      //unbooking logic
                      else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QRScreen extends StatelessWidget {
  final String slotId;
  final String slotName;

  const QRScreen({
    super.key,
    required this.slotId,
    required this.slotName,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = """
Parking Booking

Slot Name: $slotName
Slot ID: $slotId
Status: Booked
""";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parking QR"),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              const Text(
                "Show this QR at parking entry",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.1),

                      blurRadius: 10,
                    ),
                  ],
                ),

                child: QrImageView(
                  data: qrData,
                  size: 250,
                  backgroundColor:
                      Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                slotName,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Booking ID: $slotId",
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text(
                    "Done",
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