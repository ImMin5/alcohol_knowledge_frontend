import 'dart:io';

import 'package:alcohol_knowledge_frontend/model/api_adapter.dart';
import 'package:alcohol_knowledge_frontend/model/model_wineinfo.dart';
import 'package:alcohol_knowledge_frontend/screen/screen_wineinfo_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class HomeScreen extends StatefulWidget {
  @override
  createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // 검색창의 텍스트를 위한 변수
  final TextEditingController searchWord = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isLoading = false, allLoaded = false;

  // wineinfo의 데이터를 저장하기 위한 리스트
  late Future<List<WineInfo>> wineInfos;

  //데이터 테이블 칼럼 인덳스
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    print('hompage init');
    wineInfos = fetchWineInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('home page build');
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    //SafeArea 기기의 상탄 노티바 부분, 하단영역을 침범하지 않는 영역을 잡아주는 위젯
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: body(),
        ));
  }

  //wineinfo의 정보를 가져옴
  Future<List<WineInfo>> fetchWineInfos() async {
    final response = await http.get('http://localhost:8080/api/wineinfo',
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });
    if (response.statusCode == 200) {
      print("winewinfos is loading");
      return parseWineInfos(utf8.decode(response.bodyBytes));
    } else {
      print('failed fetchWineInfos');
      throw Exception('failed to load data');
    }
  }

  Future<List<WineInfo>> searchWineInfos() async {
    String word = searchWord.text;

    final response = await http.get(
      'http://localhost:8080/api/wineinfo/search?word=' + '$word',
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    if (response.statusCode == 200) {
      //wineInfos = parseWineInfos(utf8.decode(response.bodyBytes));
      return parseWineInfos(utf8.decode(response.bodyBytes));
      isLoading = false;
    } else {
      print('failed searchWineInfos');
      throw Exception('failed to load data');
    }
  }

  // 검색창
  Widget searchInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchWord,
        decoration: InputDecoration(
          labelText: "검색",
          hintText: "검색",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.cancel,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                searchWord.text = "";
              });
            },
          ),
        ),
        onSubmitted: (value) {
          print(searchWord.text);
          setState(() {
            wineInfos = searchWineInfos();
          });
        },
      ),
    );
  }

  //메인페이지 body부분
  Widget body() {
    print('home page body build');
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          searchInput(),
          Container(
            child: ElevatedButton(
              child: Text('와인 구매정보 입력'),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(
                    builder: (context) => WineInfoFormScreen()))
                    .then((value) {
                      setState(() {
                        print(value);
                        print('after wineinfoform');
                        wineInfos = fetchWineInfos();
                        Duration(milliseconds: 10);
                  });
                });
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: getDataTable(),
          ),
        ],
      ),
    );
  }

  //메인화면 데이터테이
  Widget getDataTable() {
    print('home page table build');
    final columns = ['이름', '빈티지', '가격', '용량' '구매장소', '구매일', '설명'];
    return FutureBuilder(
        future: wineInfos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return DataTable(
                columnSpacing: 60,
                horizontalMargin: 1.0,
                sortAscending: isAscending,
                sortColumnIndex: sortColumnIndex,
                columns: getColumns((snapshot.data), columns),
                rows: getRows(snapshot.data),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }
          return const CircularProgressIndicator();
        });
  }

  //테이블 row 생성
  List<DataRow> getRows(data) {
    List<DataRow> dataRow = [];

    for (var i = 0; i < data.length; i++) {
      List<DataCell> cells = [];
      cells.add(DataCell(Text(data[i].nameEng + '\n' + data[i].nameKor)));
      cells.add(DataCell(Text('${data[i].vintage}')));
      cells.add(DataCell(Text('${data[i].price}')));
      cells.add(DataCell(Text(data[i].sizeBottle + ' ml')));
      cells.add(DataCell(Text(data[i].region + ' ' + data[i].store)));
      cells.add(DataCell(Text('${data[i].datePurchase}')));
      cells.add(DataCell(Text(data[i].description)));
      dataRow.add(DataRow(cells: cells));
    }
    return dataRow;
  }

  //태아불의 헤더
  List<DataColumn> getColumns(data, List<String> columns) {
    List<DataColumn> dataColumn = [];

    dataColumn.add(DataColumn(
        label: Text('이름'),
        onSort: (columnIndex, ascending) {
          if (columnIndex == 0) {
            setState(() {
              this.sortColumnIndex = columnIndex;
              this.isAscending = ascending;
              data.sort(
                  (a, b) => compareString(ascending, a.nameEng, b.nameEng));
              print(ascending);
            });
          }
        }));
    dataColumn.add(DataColumn(
        label: Text('빈티지'),
        numeric: true,
        onSort: (columnIndex, ascending) {
          if (columnIndex == 1) {
            setState(() {
              data.sort(
                  (a, b) => compareInteger(ascending, a.vintage, b.vintage));
              this.sortColumnIndex = columnIndex;
              this.isAscending = ascending;
            });

            for (int i = 0; i < data.length; i++) {
              print(data[i].vintage);
            }
          }
        }));
    dataColumn.add(DataColumn(
        label: Text('가격'),
        numeric: true,
        onSort: (columnIndex, ascending) {
          if (columnIndex == 2) {
            setState(() {
              data.sort((a, b) => compareInteger(ascending, a.price, b.price));
              this.sortColumnIndex = columnIndex;
              this.isAscending = ascending;
            });
          }
        }));
    dataColumn.add(DataColumn(
      label: Text('용량'),
      numeric: true,
    ));
    dataColumn.add(DataColumn(label: Text('구매장소')));
    dataColumn.add(DataColumn(
        label: Text('구매일'),
        onSort: (columnIndex, ascending) {
          if (columnIndex == 5) {
            setState(() {
              data.sort((a, b) => compareString(ascending, a.datePurchase, b.datePurchase));
              this.sortColumnIndex = columnIndex;
              this.isAscending = ascending;
              print(ascending);
            });
          }
        }));
    dataColumn.add(DataColumn(
      label: Text('설명'),
    ));
    return dataColumn;
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareInteger(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  //메인페이지 하단바
  Widget _BottomAppBar() {
    return BottomAppBar(
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.home),
            Icon(Icons.wine_bar),
            Icon(Icons.settings_rounded),
          ],
        ),
      ),
    );
  }
}

//Scaffold 상중하로 나누어줌
//AppBar 상단
