import 'dart:convert';

import 'package:alcohol_knowledge_frontend/model/model_corkage_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class CorkageStoreForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CorkageStoreForm();
  }
}

class _CorkageStoreForm extends State<CorkageStoreForm> {
  // 폼에 부여할 수 있는 유니크한 글로벌 키
  final _formKey = GlobalKey<FormState>();
  String addr="";
  String desc="";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home:Scaffold(
        appBar: AppBar(leading: Icon(Icons.list),title : Text('Alchol-Knowlege')),
        body: _Form()
        ),
    );
  }

  Widget _Form() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _GetFormItems(),
      ),
    );
  }

  void _register() async {
    Map<String, dynamic> requestData = {
      'desc' : desc,
      'addr' : addr,
    };
    http.Response response = await http.post(
        Uri.parse('http://localhost:8080/api/corkage-info/new'),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(requestData));

    int statusCode = response.statusCode;
    if (statusCode != 200) {
      throw Exception('Failed to post Corkage Info');
    }
  }

  Widget _GetFormItems() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(60.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  child: Text('* 주소'),
                ),
                Flexible(child: TextFormField(
                  onSaved: (String? value) {
                    addr = value!;
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return '주소는 필수 입력사항입니다.';
                    }
                    else
                      return null;
                  },
                ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 50,
                  child: Text('설명'),
                ),
                Flexible(
                  child: TextFormField(
                    onSaved: (String? value) {
                      desc = value!;
                    },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      value = '';
                    }
                  },
                ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState == null) {
                    print('formKey NULL');
                  }
                  else if (_formKey.currentState!.validate()) {
                    // call onSaved()
                    _formKey.currentState!.save();
                    print('pressed');
                    _register();
                    Navigator.pop(context);
                  }
                },
                child: Text('등록하기'),),
            )
          ],
        ),
      ),
    );
  }
}