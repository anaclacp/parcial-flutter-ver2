class FuelRecord {
  final String? id;
  final DateTime date;
  final double odometer;
  final double amount;
  final double cost;
  final double? fuelEconomy; // km/l
  final String? notes;

  FuelRecord({
    this.id,
    required this.date,
    required this.odometer,
    required this.amount,
    required this.cost,
    this.fuelEconomy,
    this.notes,
  });

  FuelRecord copyWith({
    String? id,
    DateTime? date,
    double? odometer,
    double? amount,
    double? cost,
    double? fuelEconomy,
    String? notes,
  }) {
    return FuelRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      amount: amount ?? this.amount,
      cost: cost ?? this.cost,
      fuelEconomy: fuelEconomy ?? this.fuelEconomy,
      notes: notes ?? this.notes,
    );
  }
}

