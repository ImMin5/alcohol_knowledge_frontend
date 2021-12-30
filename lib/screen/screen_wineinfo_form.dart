import 'dart:convert';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class WineInfoFormScreen extends StatelessWidget{
  CurrencyTextInputFormatter currencyTextInputFormatter = new CurrencyTextInputFormatter(
    locale: 'ko',
    decimalDigits: 0,
    symbol: '(₩)',
  );

  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();
    bool validForm = false;

    //TextFormField의 Text Controller 및 초기화
    List<TextEditingController> textEditingController = [];
    for(int i=0; i<9; i++) textEditingController.add(new TextEditingController());

    //와인정보 제출
    sendWineInfo(textEditingController) async {
      Map <String,dynamic> data = {
        'nameEng' : textEditingController[0].text,
        'nameKor' : textEditingController[1].text,
        'vintage' : int.parse(textEditingController[2].text),
        'price': int.parse(textEditingController[3].text),
        'sizeBottle' : textEditingController[4].text,
        'datePurchase': textEditingController[5].text,
        'region' : textEditingController[6].text,
        'store' : textEditingController[7].text,
        'description' : textEditingController[8].text,
      };
      String body = json.encode(data);

      final response = await http.post('http://localhost:8080/api/wineinfo',
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin" :  "*"
          },
          body: body
      );
    }

    // TODO: implement build
    return MaterialApp(
        home : Scaffold(
          appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              title : Text('Alchol-Knowlege'),
          ),
          body:Container(
            padding:  EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: textFormField('와인이름(영문)', '와인이름(영문)',textEditingController[0])
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: textFormField('와인이름(한글)', '와인이름(한글)', textEditingController[1])
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: textEditingController[2],
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        onSaved: (val){},
                        validator: (val){
                          if(val == null || val.isEmpty){
                            return '빈칸을 채워주세요.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText:'빈티지',
                          border: OutlineInputBorder(),
                          hintText: '빈티지',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: textEditingController[3],
                        //inputFormatters: <CurrencyTextInputFormatter>[currencyTextInputFormatter],
                        inputFormatters:  <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
                        keyboardType: TextInputType.number,
                        onSaved: (val){},
                        validator: (val){
                          if(val == null || val.isEmpty){
                            return '빈칸을 채워주세요.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText:'가격',
                          border: OutlineInputBorder(),
                          hintText: '가격',
                          suffixText:"(₩)원",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: textEditingController[4],
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        keyboardType: TextInputType.number,
                        onSaved: (val){},
                        validator: (val){
                          if(val == null || val.isEmpty){
                            return '빈칸을 채워주세요.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText:'사이즈',
                          border: OutlineInputBorder(),
                          hintText: '사이즈',
                          suffixText:"ml",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FormBuilderDateTimePicker(
                        controller: textEditingController[5],
                        name: 'date_range',
                        inputType: InputType.date,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2030),
                        format: DateFormat('yyyy-MM-dd'),
                        onSaved: (val){},
                        validator: (val){
                          if(val == null ){
                            return '빈칸을 채워주세요.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '구매 날짜',
                          hintText: '정확하지 않아도 됨',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: textEditingController[6],
                        onSaved: (val){},
                        validator: (val){
                          if(val == null || val.isEmpty){
                            return '빈칸을 채워주세요.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText:'구매지역',
                          border: OutlineInputBorder(),
                          hintText: 'ex)서울',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: textFormField('구매매장', '구매매장', textEditingController[7])
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: textEditingController[8],
                        autocorrect: true,
                        onSaved: (val){},
                        validator: (val){
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText:'참고사항',
                          border: OutlineInputBorder(),
                          hintText: '설명',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async{
                            if(formKey.currentState!.validate()){
                              sendWineInfo(textEditingController);
                              Navigator.pop(context);
                            }
                          },
                          child: Text('제출')),
                    )
                  ],
                ),
              ),
            ),

          ),
        )
    );

  }

  bool checkTextFormFieldIsEmpty(List<TextEditingController> textEditingController){
    for(int i = 0; i< textEditingController.length-1; i++) {
      if(textEditingController == null || textEditingController == "") return false;
    }
    return true;
  }

  Widget textFormField(String label, String hint, TextEditingController textEditingController){
    return TextFormField(
      controller: textEditingController,
      autocorrect: true,
      onSaved: (val){},
      validator: (val){
        if(val == null || val.isEmpty){
          return '빈칸을 채워주세요.';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText:label,
        border: OutlineInputBorder(),
        hintText: hint,
      ),
    );
  }
}