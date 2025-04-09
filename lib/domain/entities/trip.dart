class Trip {
  final String? id;
  final String? title;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? distance;
  final int? duration; // in minutes
  final double? averageSpeed;
  final double? maxSpeed;
  final String? notes;
  final List<String>? photoIds;
  final String? coverPhotoUrl;

  Trip({
    this.id,
    this.title,
    this.startTime,
    this.endTime,
    this.distance,
    this.duration,
    this.averageSpeed,
    this.maxSpeed,
    this.notes,
    this.photoIds,
    this.coverPhotoUrl,
  });

  Trip copyWith({
    String? id,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    double? distance,
    int? duration,
    double? averageSpeed,
    double? maxSpeed,
    String? notes,
    String? coverPhotoUrl,
    List<String>? photoIds,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      notes: notes ?? this.notes,
      photoIds: photoIds ?? this.photoIds,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
    );
  }
}

