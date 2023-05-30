class Medicine {
  final String id;
  final String name;
  final List<Batch> batches;

  Medicine({
    required this.id,
    required this.name,
    required this.batches,
  });
}

class Batch {
  final int batchNumber;
  final DateTime expirationDate;
  final DateTime manufacturingDate;
  // final int quantity;

  Batch({
    required this.batchNumber,
    required this.expirationDate,
    required this.manufacturingDate,
    // required this.quantity,
  });
}
