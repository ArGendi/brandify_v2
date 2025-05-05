class Side{
  int? id;
  String? backendId;
  String? name;
  int? price;
  int? quantity;

  Side({this.id, this.backendId, this.name, this.price, this.quantity});
  Side.fromJson(Map<dynamic, dynamic> json){
    id = json["id"];
    name = json["name"];
    price = json["price"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "name": name,
      "price": price,
      "quantity": quantity,
    };
  }
}