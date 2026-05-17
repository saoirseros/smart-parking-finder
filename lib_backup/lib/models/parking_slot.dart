class ParkingSlot {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final bool isAvailable;

  ParkingSlot({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.isAvailable,
  });

  factory ParkingSlot.fromMap(Map data, String id) {
    return ParkingSlot(
      id: id,
      name: data['name'],
      lat: data['lat'],
      lng: data['lng'],
      isAvailable: data['isAvailable'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
      'isAvailable': isAvailable,
    };
  }
}