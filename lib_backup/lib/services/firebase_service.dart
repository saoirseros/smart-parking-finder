import 'package:firebase_database/firebase_database.dart';
import '../models/parking_slot.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref("slots");

  Stream<List<ParkingSlot>> getSlots() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.entries.map((e) {
        return ParkingSlot.fromMap(
          Map<String, dynamic>.from(e.value),
          e.key,
        );
      }).toList();
    });
  }

  Future<void> bookSlot(String id) async {
    await _db.child(id).update({'isAvailable': false});
  }

  Future<void> releaseSlot(String id) async {
    await _db.child(id).update({'isAvailable': true});
  }
}