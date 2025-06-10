import 'package:cloud_firestore/cloud_firestore.dart';

enum MaintenanceType {
  oilChange, tireMaintenance, chainLubrication, brakeService, generalService, other
}
enum MaintenanceStatus {
  pending, overdue, completed
}

class Maintenance {
  final String? id;
  final String userId; 
  final String title;
  final String description;
  final MaintenanceType type;
  final DateTime dueDate;
  final double odometerThreshold;
  final MaintenanceStatus status;
  final String? notes;
  final DateTime? completedDate;
  final double? completedOdometer;
  final String? completionNotes;

  Maintenance({
    this.id,
    required this.userId, 
    required this.title,
    required this.description,
    required this.type,
    required this.dueDate,
    required this.odometerThreshold,
    required this.status,
    this.notes,
    this.completedDate,
    this.completedOdometer,
    this.completionNotes,
  });

  Maintenance copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    MaintenanceType? type,
    DateTime? dueDate,
    double? odometerThreshold,
    MaintenanceStatus? status,
    String? notes,
    DateTime? completedDate,
    double? completedOdometer,
    String? completionNotes,
  }) {
    return Maintenance(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      dueDate: dueDate ?? this.dueDate,
      odometerThreshold: odometerThreshold ?? this.odometerThreshold,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      completedDate: completedDate ?? this.completedDate,
      completedOdometer: completedOdometer ?? this.completedOdometer,
      completionNotes: completionNotes ?? this.completionNotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last, 
      'dueDate': Timestamp.fromDate(dueDate),
      'odometerThreshold': odometerThreshold,
      'status': status.toString().split('.').last,
      'notes': notes,
      'completedDate': completedDate != null ? Timestamp.fromDate(completedDate!) : null,
      'completedOdometer': completedOdometer,
      'completionNotes': completionNotes,
    };
  }

  factory Maintenance.fromMap(Map<String, dynamic> map, String documentId) {
    return Maintenance(
      id: documentId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: MaintenanceType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => MaintenanceType.other,
      ),
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      odometerThreshold: map['odometerThreshold']?.toDouble() ?? 0.0,
      status: MaintenanceStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => MaintenanceStatus.pending,
      ),
      notes: map['notes'],
      completedDate: (map['completedDate'] as Timestamp?)?.toDate(),
      completedOdometer: map['completedOdometer']?.toDouble(),
      completionNotes: map['completionNotes'],
    );
  }
}