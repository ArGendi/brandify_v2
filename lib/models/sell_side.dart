import 'package:brandify/models/side.dart';

class SellSide{
  Side? side;
  int? usedQuantity;

  SellSide(this.side, {this.usedQuantity = 0});

  SellSide.fromJson(Map<dynamic, dynamic> json){
    side = json["side"] != null ? Side.fromJson(json["side"]) : null;
    usedQuantity = json["usedQuantity"] ?? 0;
  }

   Map<String, dynamic> toJson(){
    return {
      "side": side?.toJson(),
      "usedQuantity": usedQuantity,
    };
  }
}