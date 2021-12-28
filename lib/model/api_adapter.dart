import 'dart:convert';
import 'model_wineinfo.dart';


List<WineInfo> parseWineInfos(String responseBody){
  print("parse WineInfos");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<WineInfo>((json) => WineInfo.fromJson(json)).toList();
}