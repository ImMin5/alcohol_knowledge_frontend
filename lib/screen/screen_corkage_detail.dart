import 'dart:convert';

import 'package:alcohol_knowledge_frontend/model/model_corkage_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StoreDetailScreen extends StatefulWidget {
  int storeId;
  StoreDetailScreen(this.storeId);

  @override
  State<StatefulWidget> createState() {
    return _StoreDetailScreen(storeId);
  }
}

class _StoreDetailScreen extends State<StoreDetailScreen> {
  int storeId;
  CorkageStore corkageStore = CorkageStore.empty();
  _StoreDetailScreen(this.storeId);

  void fetchStoreInfo(int id) async {
    CorkageStore parsedResponse;
    final response = await http.get("http://localhost:8080/api/corkage-store?id="+'$id',
        headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin" :  "*"}
    );
    if (response.statusCode == 200) {
      var text = utf8.decode(response.bodyBytes);
      Map<String, dynamic> dataObjJson =  jsonDecode(text);
      parsedResponse = CorkageStore.fromJson(dataObjJson);
      print(text);
    }
    else {
      throw Exception('Failed to load Corkage store');
    }
    setState(() {
      corkageStore = parsedResponse;
    });
  }
  @override
  void initState() {
    super.initState();
    fetchStoreInfo(storeId);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Alcohol-Knowledge'),
      ),
      body: Column(
        children: [
          titleSection(),
          buttonSection(),
          textSection()
        ],
      ),
    ));
  }

  Widget titleSection() {
    CorkageStore corkageStore = this.corkageStore;
    return Container(
        padding: const EdgeInsets.all(32),
        child: Row(children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        corkageStore.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Text(
                    corkageStore.addr,
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              )
          ),
          Column(
            children: [
              Text('(지도 들어갈 예정)'),
            ],
          ),
        ]));
  }
  Widget buttonSection() {
    CorkageStore corkageStore = this.corkageStore;
    Color color = Theme.of(context).primaryColor;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCallButton(color, '01095113170'),
          _buildButtonColumn(color, Icons.map_outlined, '지도'),
          if (corkageStore.website==null)
            _buildLinkButton(color, 'https://www.naver.com'),
          if (corkageStore.website!=null)
            _buildLinkButton(color, corkageStore.website),

        ],
      )
    );
  }
  Widget textSection() {
    CorkageStore corkageStore = this.corkageStore;
    return Container(
      padding: const EdgeInsets.all(32),
      child: Text(corkageStore.desc),
    );
  }
  InkWell _buildLinkButton (Color color, String url) {
    return InkWell(
      onTap: () {
        _launchURL(url);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Icon(Icons.link, color: color,),
          Text(
              "사이트",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              )
          )
        ],
      )
    );
  }
  InkWell _buildCallButton (Color color, String number) {
    return InkWell (
      onTap: () {
        Clipboard.setData(ClipboardData(text: number));
        _showDialog();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.call, color: color,),
          Text(number,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          ))
        ]
      )
    );
  }
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        )
      ],
    );
  }
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
          ),
          content: Text("복사되었습니다."),
        );
      }
    );
  }
  void _launchURL(String url) async {
    if (!await launch(url)) throw 'could not launch $url';
  }
}
