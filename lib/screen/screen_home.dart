import 'package:alcohol_knowledge_frontend/model/api_adapter.dart';
import 'package:alcohol_knowledge_frontend/model/model_wineinfo.dart';
import 'package:alcohol_knowledge_frontend/screen/screen_wineinfo_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  // 검색창의 텍스트를 위한 변수
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  // wineinfo의 데이터를 저장하기 위한 리스트
  List<WineInfo> wineInfos =[];
  bool isLoading = false, allLoaded = false;
  //

  @override
  void initState(){
    super.initState();
    fetchWineInfos();
  }

  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    //SafeArea 기기의 상탄 노티바 부분, 하단영역을 침범하지 않는 영역을 잡아주는 위젯
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home : Scaffold(
          body : body(),
        )
    );
  }

  // 검색창
  Widget searchInput(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
        },
        controller: _filter,
        decoration: InputDecoration(
            labelText: "Search",
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  //메인페이지 body부분
  Widget body(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          searchInput(),
          Container(
            child: ElevatedButton(
              child: Text('와인 구매정보 입력'),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WineInfoFormScreen())
                ).then((context) => fetchWineInfos());
              },

            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: getDataTable(),
              )
        ],
      ),
    );
  }


  //wineinfo의 정보를 가져옴
  fetchWineInfos() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get('http://localhost:8080/api/wineinfo',
        headers: {
          "Accept" : "application/json",
          "Access-Control-Allow-Origin" :  "*"
        });
    if(response.statusCode == 200){
      setState(() {
        wineInfos = parseWineInfos(utf8.decode(response.bodyBytes));
        isLoading = false;
        print("winewinfos is loading");
      });
    }
    else{
      print('failed json');
      throw Exception('failed to load data');
    }
  }

  //메인화면 데이터테이
  Widget getDataTable() {
    return DataTable(
      horizontalMargin: 1.0, columnSpacing: 28.0,
      columns: getColumns(),showCheckboxColumn: true,
      rows: getRows(), );

  }
  //테이블 row 생성
  List<DataRow> getRows(){
    List<DataRow> dataRow = [];
    for (var i=0; i<wineInfos.length; i++) {
      List<DataCell> cells = [];
      cells.add(DataCell(Text(wineInfos[i].nameEng+'\n'+wineInfos[i].nameKor)));
      cells.add(DataCell(Text('${wineInfos[i].vintage}')));
      cells.add(DataCell(Text('${wineInfos[i].price}')));
      cells.add(DataCell(Text(wineInfos[i].sizeBottle+' ml')));
      cells.add(DataCell(Text(wineInfos[i].region + ' '+ wineInfos[i].store)));
      cells.add(DataCell(Text('${wineInfos[i].datePurchase}')));
      cells.add(DataCell(Text(wineInfos[i].description)));
      dataRow.add(DataRow(cells: cells));
    }
    return dataRow;
  }

  //태아불의 헤더
  List<DataColumn> getColumns(){
    List<DataColumn> dataColumn = [];
    dataColumn.add(DataColumn(label: Text('이름')));
    dataColumn.add(DataColumn(label: Text('빈티지'), numeric: true, ));
    dataColumn.add(DataColumn(label: Text('가격'), numeric: true, ));
    dataColumn.add(DataColumn(label: Text('용량'), numeric: true, ));
    dataColumn.add(DataColumn(label: Text('구매장소')));
    dataColumn.add(DataColumn(label: Text('구매일')));
    dataColumn.add(DataColumn(label: Text('설명')));

    return dataColumn;
  }

  //메인페이지 하단바
  Widget _BottomAppBar(){
    return BottomAppBar(
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.home), Icon(Icons.wine_bar), Icon(Icons.settings_rounded),
          ],
        ),
      ),
    );
  }


}

//Scaffold 상중하로 나누어줌
//AppBar 상단