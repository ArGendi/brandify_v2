import 'package:intl/intl.dart';
import 'package:brandify/enum.dart';

class Ad{
  int? id;
  String? backendId;
  int? cost;
  SocialMediaPlatform? platform;
  DateTime? date;
  DateTime? createdAt;

  Ad({this.id, this.backendId, this.cost, this.date, this.platform,}){
    this.createdAt = DateTime.now();
  }
  Ad.fromJson(Map<dynamic, dynamic> json){
    id = json["id"];
    cost = json["cost"];
    platform = toPlatform(json["platform"]);
    date = DateTime.parse(json["date"]);
    createdAt = json["createdAt"] != null? DateTime.parse(json["created_at"]) : null;
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "cost": cost,
      "platform": platform?.name ?? "other",
      "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(date!),
      "created_at": createdAt != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt!) : null,
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