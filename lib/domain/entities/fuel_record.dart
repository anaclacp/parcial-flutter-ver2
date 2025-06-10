import 'package:cloud_firestore/cloud_firestore.dart';

class FuelRecord {
  final String? id;
  final String? userId;
  final DateTime date;
  final double odometer;
  final double amount;
  final double cost;
  final double? fuelEconomy; // km/l
  final String? notes;

  const FuelRecord({
    this.id,
    this.userId,
    required this.date,
    required this.odometer,
    required this.amount,
    required this.cost,
    this.fuelEconomy,
    this.notes,
  });

  FuelRecord copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? odometer,
    double? amount,
    double? cost,
    double? fuelEconomy,
    String? notes,
  }) {
    return FuelRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      amount: amount ?? this.amount,
      cost: cost ?? this.cost,
      fuelEconomy: fuelEconomy ?? this.fuelEconomy,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date), 
      'odometer': odometer,
      'amount': amount,
      'cost': cost,
      'fuelEconomy': fuelEconomy,
      'notes': notes,
    };
  }

  factory FuelRecord.fromMap(Map<String, dynamic> map, String documentId) {
    return FuelRecord(
      id: documentId,
      userId: map['userId'],
      date: (map['date'] as Timestamp).toDate(), 
      odometer: map['odometer']?.toDouble() ?? 0.0,
      amount: map['amount']?.toDouble() ?? 0.0,
      cost: map['cost']?.toDouble() ?? 0.0,
      fuelEconomy: map['fuelEconomy']?.toDouble(),
      notes: map['notes'],
    );
  }

}