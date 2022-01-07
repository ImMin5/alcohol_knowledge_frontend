// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:alcohol_knowledge_frontend/screen/screen_corkage_store.dart';
import 'package:alcohol_knowledge_frontend/screen/screen_home.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp>{
  static const String _title = 'Alchol-Knowlege';

  int _selectedIndex=0;
  List<BottomNavigationBarItem> bottomItems=[
    BottomNavigationBarItem(
      label: '홈',
      icon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
        label: '콜키지',
        icon: Icon(Icons.wine_bar)
    ),
    BottomNavigationBarItem(
        label: '설정',
        icon: Icon(Icons.settings)
    ),
  ];
  List pages=[
    HomeScreen(),
    CorkageStoreScreen(),
    Center(child: Text('설정페이지'),),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false -> 앱 상단에 debug 사라
        home:Scaffold(
          appBar: _AppBar(),
          body:pages[_selectedIndex],
          bottomNavigationBar: _BottomNavigationBar(),
        )
    );
  }


  //상단 앱바
  AppBar _AppBar(){
    return AppBar(leading: Icon(Icons.list),title : Text('Alchol-Knowlege'));
  }

  Widget _BottomNavigationBar(){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black, // Bar 배경색
      selectedItemColor: Colors.white, // 선택된 아이템의 색상
      unselectedItemColor: Colors.grey.withOpacity(0.60),
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items:bottomItems,
    );
  }
}

