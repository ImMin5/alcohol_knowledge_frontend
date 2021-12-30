import 'dart:convert';
import 'package:alcohol_knowledge_frontend/model/model_wineinfoform.dart';

import 'model_wineinfo.dart';


List<WineInfo> parseWineInfos(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<WineInfo>((json) => WineInfo.fromJson(json)).toList();
}

WineInfoForm parseWineInfoForm(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<WineInfo>((json) => WineInfoForm.fromJson(json)).toList();
}
