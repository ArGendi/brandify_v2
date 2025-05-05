class ProductSize{
  int? id;
  String? name;
  int? quantity;

  ProductSize({this.id, this.name, this.quantity});
  ProductSize.fromJson(Map<dynamic, dynamic> json){
    id = json["id"];
    name = json["name"];
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "name": name,
      "quantity": quantity,
    };
  }
}