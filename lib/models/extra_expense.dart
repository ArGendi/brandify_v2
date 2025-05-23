import 'package:intl/intl.dart';

class ExtraExpense {
  int? id;
  String? backendId;
  String? name;
  int? price;
  DateTime? date;
  DateTime? createdAt;

  ExtraExpense({
    this.id,
    this.backendId,
    this.name,
    this.price,
    this.date,
  }){
    createdAt = DateTime.now();
  }
  ExtraExpense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    backendId = json['backendId'];
    name = json['name'];
    price = json['price'];
    date = DateTime.parse(json['date']);
    createdAt = json["createdAt"] != null? DateTime.parse(json["created_at"]) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'backendId': backendId,
      'name': name,
      'price': price,
      'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(date!),
      "created_at": createdAt != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt!) : null,
    }; 
  }
}