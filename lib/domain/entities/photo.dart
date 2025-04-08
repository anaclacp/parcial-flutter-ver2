
class GeoLocation {
  final double latitude;
  final double longitude;

  GeoLocation({
    required this.latitude,
    required this.longitude,
  });
}

class Photo {
  final String? id;
  final String? url;
  final String? caption;
  final DateTime? timestamp;
  final GeoLocation? location;
  final String? tripId;

  Photo({
    this.id,
    this.url,
    this.caption,
    this.timestamp,
    this.location,
    this.tripId,
  });

  Photo copyWith({
    String? id,
    String? url,
    String? caption,
    DateTime? timestamp,
    GeoLocation? location,
    String? tripId,
  }) {
    return Photo(
      id: id ?? this.id,
      url: url ?? this.url,
      caption: caption ?? this.caption,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      tripId: tripId ?? this.tripId,
    );
  }
}

