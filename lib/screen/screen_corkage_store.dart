import 'dart:convert';
import 'dart:io';

import 'package:alcohol_knowledge_frontend/model/model_corkage_store.dart';
import 'package:alcohol_knowledge_frontend/screen/screen_corkage_detail.dart';
import 'package:alcohol_knowledge_frontend/screen/screen_corkage_store_form.dart';
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
  final scrollController = ScrollController();
  int pageIdx = 0;
  int pageSize = 10;
  bool isSearchMode = false;
  String keyword = "";

  void _fetchStores() async {
    final response = await http.get("http://localhost:8080/api/corkage-store/list",
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin" :  "*"
    });
    List<CorkageStore> parsedResponse = [];
    if (response.statusCode == 200) {
      var _text = utf8.decode(response.bodyBytes);
      var dataObjJson =  json.decode(_text).cast<Map<String, dynamic>>();

      //jsonDecode(_text)['data'].cast<Map<String, dynamic>>();
      print(dataObjJson);
      parsedResponse = dataObjJson.map<CorkageStore>((e) => CorkageStore.fromJson(e)).toList();
    }
    else {
      throw Exception('Failed to load Corkage Stores');
    }

    setState(() {
      ckStoreList.clear();
      ckStoreList.addAll(parsedResponse);
    });
  }

  void _fetchStoresPagination() async {
    final response = await http.get("http://localhost:8080/api/corkage-store/list?idx=$pageIdx&size=$pageSize");

    if (response.statusCode == 200) {
      var _text = utf8.decode(response.bodyBytes);
      var dataObjJson =  json.decode(_text).cast<Map<String, dynamic>>();
      print(dataObjJson);

      var parsedResponse = dataObjJson.map<CorkageStore>((e) => CorkageStore.fromJson(e)).toList();

      // no more data to fetch
      if (parsedResponse.toString().length == 2) {
        return;
      }
      setState(() {
        ckStoreList.addAll(parsedResponse);
        pageIdx = ckStoreList.length;
      });
    }
    else {
      throw Exception('Failed to load Corkage Stores pageIndex');
    }
  }
  /*
  Scroll Listener
   */
  void _addScrollController() {
    if (scrollController.offset == scrollController.position.maxScrollExtent
        && !scrollController.position.outOfRange) {
      if ( isSearchMode ) {
          _findMatchingStore();
        }
        else {
          _fetchStoresPagination();
        }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchStoresPagination();
    scrollController.addListener(() {
      _addScrollController();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list(),
      floatingActionButton: _AddButton(),
    );
  }

  Widget list() {
    return SingleChildScrollView(
      controller: scrollController,
      child:Column(
        children: [
          _SearchInput(),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _getDataTable(),
          )
        ],
      )
    );
  }

  Widget _AddButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) =>
                CorkageStoreForm()));
      },
      label: Text('매장 등록하기'),
      icon: Icon(Icons.store),
    );
  }
  Widget _getDataTable() {
    return DataTable(
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('매장명')),
          DataColumn(label: Text('주소')),
          DataColumn(label: Text('설명')),
        ],
        rows: _getRows()
    );
  }

  Widget _SearchInput() {
    return Container(
      child:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          textInputAction: TextInputAction.go,
          decoration: const InputDecoration(
            labelText: '검색',
            hintText: '매장명 또는 지역명을 입력하세요',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))
            ),
          ),
          onSubmitted: (keyword) {
            pageIdx = 0;
            isSearchMode = true;
            this.keyword = keyword;
            _findMatchingStore();
          },
        ),
        ),
    );
  }

  void findMatchingStore(String keyword) async {
    final response = await http.get("http://localhost:8080/api/corkage-store/search?keyword="+keyword);
    List<CorkageStore> stores = [];
    if (response.statusCode == 200) {
      String _text = utf8.decode(response.bodyBytes);
      if (_text != "") {
        var dataObjJson = json.decode(_text).cast<Map<String, dynamic>>();
        print(dataObjJson);
        stores = dataObjJson.map<CorkageStore>((e) => CorkageStore.fromJson(e)).toList();
      }
    }
    else {
      throw Exception('Failed to load search result');
    }
    setState(() {
      ckStoreList.clear();
      ckStoreList.addAll(stores);
    });
  }

  void _findMatchingStore() async {
    final response = await http.get("http://localhost:8080/api/corkage-store/search?keyword=$keyword&idx=$pageIdx&size=$pageSize");
    List<CorkageStore> stores = [];
    if (response.statusCode == 200) {
      String _text = utf8.decode(response.bodyBytes);
      if (_text != "") {
        var dataObjJson = json.decode(_text).cast<Map<String, dynamic>>();
        print(dataObjJson);
        stores = dataObjJson.map<CorkageStore>((e) => CorkageStore.fromJson(e)).toList();
      }
    }
    else {
      throw Exception('Failed to load search result');
    }
    setState(() {
      if (pageIdx == 0) ckStoreList.clear();
      ckStoreList.addAll(stores);
      pageIdx = ckStoreList.length;
    });
  }

  List<DataRow> _getRows() {
    List<DataRow> dataRow = [];
    for (var i=0; i < ckStoreList.length; i++) {
      List<DataCell> cells = [];
      cells.add(DataCell(Text('${ckStoreList[i].id}'),));
      cells.add(DataCell(Text(ckStoreList[i].name)));
      cells.add(DataCell(Text(ckStoreList[i].addr)));
      cells.add(DataCell(Text(ckStoreList[i].desc)));
      dataRow.add(DataRow(cells: cells,
      onSelectChanged: (selected) {
        Navigator.push(context, MaterialPageRoute(builder: (context)
        => StoreDetailScreen(ckStoreList[i].id))
        );
      }),);
    }
    return dataRow;
  }
}

