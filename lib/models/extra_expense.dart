class ExtraExpense {
  int? id;
  String? backendId;
  String? name;
  int? price;
  DateTime? date;

  ExtraExpense({
    this.id,
    this.backendId,
    this.name,
    this.price,
    this.date,
  });
  ExtraExpense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    backendId = json['backendId'];
    name = json['name'];
    price = json['price'];
    date = DateTime.fromMillisecondsSinceEpoch(json['date']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'backendId': backendId,
      'name': name,
      'price': price,
      'date': date?.millisecondsSinceEpoch,
    }; 
  }
}