import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/services.dart';

class WineInfoFormScreen extends StatefulWidget{

  _WineInfoFormScreenState createState() => _WineInfoFormScreenState();

}

class _WineInfoFormScreenState extends State<WineInfoFormScreen>{
  CurrencyTextInputFormatter currencyTextInputFormatter = new CurrencyTextInputFormatter(
    locale: 'ko',
    decimalDigits: 0,
    symbol: '(₩)',
  );


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home : Scaffold(
          appBar: AppBar(leading: Icon(Icons.list),title : Text('Alchol-Knowlege')),
          body:Container(
            padding:  EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (val){},
                      validator: (val){
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText:'와인 이름(영문)',
                        border: OutlineInputBorder(),
                        hintText: '와인이름(영문)',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (val){},
                      validator: (val){
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText:'와인 이름(한글)',
                        border: OutlineInputBorder(),
                        hintText: '와인이름(한글)',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      onSaved: (val){},
                      validator: (val){
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
                      inputFormatters: <CurrencyTextInputFormatter>[currencyTextInputFormatter],
                      keyboardType: TextInputType.number,
                      onSaved: (val){},
                      validator: (val){
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText:'가격',
                        border: OutlineInputBorder(),
                        hintText: '가격',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      keyboardType: TextInputType.number,
                      onSaved: (val){},
                      validator: (val){
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
                      name: 'date_range',
                      inputType: InputType.date,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1970),
                      lastDate: DateTime(2030),
                      format: DateFormat('yyyy-MM-dd'),
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
                      onSaved: (val){},
                      validator: (val){
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
                    child: TextFormField(
                      onSaved: (val){},
                      validator: (val){
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText:'구매 매장',
                        border: OutlineInputBorder(),
                        hintText: 'ex) 와인앤모, 이마트',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      maxLines: 8,
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
                        onPressed: null,
                        child: Text('제출')),
                  )
                ],
              ),
            ),

          ),
          bottomNavigationBar: BottomAppBar(
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
          ),
        )
    );
  }

}