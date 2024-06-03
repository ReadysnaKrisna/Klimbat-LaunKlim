class Detail {
  final String name;
  final int price;
  final String duration;

  Detail({required this.name, required this.price, required this.duration});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Detail && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
