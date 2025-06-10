import 'package:cloud_firestore/cloud_firestore.dart';
class Trip {
  final String? id;
  final String? userId; 
  final String? title;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? distance;
  final int? duration; 
  final double? maxSpeed;
  final String? notes;
  final List<String>? photoIds;
  final String? coverPhotoUrl;

  Trip({
    this.id,
    required this.userId,
    this.title,
    this.startTime,
    this.endTime,
    this.distance,
    this.duration,
    this.maxSpeed,
    this.notes,
    this.photoIds,
    this.coverPhotoUrl,
  });

  Trip copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    double? distance,
    int? duration,
    double? maxSpeed,
    String? notes,
    String? coverPhotoUrl,
    List<String>? photoIds,
  }) {
    return Trip(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      notes: notes ?? this.notes,
      photoIds: photoIds ?? this.photoIds,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'startTime': startTime != null ? Timestamp.fromDate(startTime!) : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'distance': distance,
      'duration': duration,
      'maxSpeed': maxSpeed,
      'notes': notes,
      'coverPhotoUrl': coverPhotoUrl,
    };
  }
    factory Trip.fromMap(Map<String, dynamic> map, String documentId) {
    return Trip(
      id: documentId,
      userId: map['userId'] ?? '',
      title: map['title'],
      startTime: (map['startTime'] as Timestamp?)?.toDate(),
      endTime: (map['endTime'] as Timestamp?)?.toDate(),
      distance: map['distance']?.toDouble(),
      duration: map['duration']?.toInt(),
      maxSpeed: map['maxSpeed']?.toDouble(),
      notes: map['notes'],
      coverPhotoUrl: map['coverPhotoUrl'],
    );
  }
}

