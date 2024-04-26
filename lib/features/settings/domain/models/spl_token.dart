class SplToken {
  final int id, decimals, priority;
  final String name, address, symbol, icon;

  SplToken({
    required this.id,
    required this.decimals,
    required this.priority,
    required this.name,
    required this.address,
    required this.symbol,
    required this.icon,
  });

  factory SplToken.fromJson(dynamic json) {
    return SplToken(
      id: json['id'],
      decimals: json['decimals'],
      priority: json['priority'],
      name: json['name'],
      address: json['address'],
      symbol: json['symbol'],
      icon: json['icon'],
    );
  }

  @override
  String toString() {
    return 'id: $id, decimals: $decimals, priorty: $priority, name: $name, address: $address, symbol: $symbol, icon: $icon';
  }
}
