enum MaintenanceType {
  oilChange,
  tireMaintenance,
  chainLubrication,
  brakeService,
  generalService,
  other,
}

enum MaintenanceStatus {
  pending,
  overdue,
  completed,
}

class Maintenance {
  final String? id;
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
}

