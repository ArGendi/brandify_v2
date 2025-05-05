class Brand {
  int? id;
  String? backendId;
  String? name;
  String? phone;

  Brand({this.name, this.phone});

  Brand.fromJson(Map<dynamic, dynamic> json){
    id = json["id"];
    name = json["name"];
    phone = json["phone"];

  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "brandName": name,
      "brandPhone": phone,
    };
  }
}