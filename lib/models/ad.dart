import 'package:intl/intl.dart';
import 'package:brandify/enum.dart';

class Ad{
  int? id;
  String? backendId;
  int? cost;
  SocialMediaPlatform? platform;
  DateTime? date;

  Ad({this.id, this.backendId, this.cost, this.date, this.platform});
  Ad.fromJson(Map<dynamic, dynamic> json){
    id = json["id"];
    cost = json["cost"];
    platform = toPlatform(json["platform"]);
    date = DateTime.parse(json["date"]);
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "cost": cost,
      "platform": platform?.name ?? "other",
      "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(date!),
    };
  }

  SocialMediaPlatform toPlatform(String value){
    switch(value){
      case "facebook": return SocialMediaPlatform.facebook;
      case "instagram": return SocialMediaPlatform.instagram;
      case "tiktok": return SocialMediaPlatform.tiktok;
      default: return SocialMediaPlatform.other;
    }
  }
}