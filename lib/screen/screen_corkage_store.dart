import 'dart:convert';

import 'package:alcohol_knowledge_frontend/model/model_corkage_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CorkageStoreScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CorkageStoreScreen();
  }
}

class _CorkageStoreScreen extends State<CorkageStoreScreen> {

  /*
  ckStoreList: CorkageStore 데이터들을 List 형태로 저장
   */
  List<CorkageStore> ckStoreList = [];

  void _fetchStores() async {
    final response = await http.get("http://localhost:8080/api/corkage-store/list");
    List<CorkageStore> parsedResponse = [];
    if (response.statusCode == 200) {
      var _text = utf8.decode(response.bodyBytes);
      var dataObjJson =  jsonDecode(_text)['data'].cast<Map<String, dynamic>>();
      parsedResponse = dataObjJson.map((e) => CorkageStore.fromJson(e)).toList();
    }
    else {
      throw Exception('Failed to load Corkage Stores');
    }

    setState(() {
      ckStoreList.clear();
      ckStoreList.addAll(parsedResponse);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list(),
    );
  }

  Widget list() {
    return Container(
      child:Column(
        children: [
          //ElevatedButton(onPressed: onPressed, child: Text('매장 등록하기')),
          SingleChildScrollView(
              child: _getDataTable(),
          )
        ],
      )
    );
  }

  Widget _getDataTable() {
    return DataTable(
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('매장명')),
          DataColumn(label: Text('주소')),
          DataColumn(label: Text('설명')),
        ],
        rows: _getRows());
  }

  List<DataRow> _getRows() {
    List<DataRow> dataRow = [];
    for (var i=0; i < ckStoreList.length; i++) {
      List<DataCell> cells = [];
      cells.add(DataCell(Text('${ckStoreList[i].id}')));
      cells.add(DataCell(Text(ckStoreList[i].name)));
      cells.add(DataCell(Text(ckStoreList[i].addr)));
      cells.add(DataCell(Text(ckStoreList[i].desc)));
      dataRow.add(DataRow(cells: cells));
    }
    return dataRow;
  }
}

