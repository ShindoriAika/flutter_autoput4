import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  static int? _selected = 0;
  late String _lon = '141.3467972';
  late String _lat = '43.06428056';

  String icon = '04d';
  String tempMax = '';
  String tempMin = '';

  static final List<Japan> japanList = [
    Japan('141.3467972', '43.06428056'), //北海道
    Japan('140.7399662', '40.82435392'), //青森県
    Japan('141.152709', '39.70358439'), //岩手県
    Japan('140.8720061', '38.26892558'), //宮城県
    Japan('140.1031778', '39.71803056'), //秋田県
    Japan('140.3634278', '38.24048889'), //山形県
    Japan('140.4675816', '37.74997969'), //福島県
    Japan('140.4466188', '36.34159972'), //茨城県
    Japan('139.8830857', '36.56548547'), //栃木県
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アウトプット4'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 50.0, top: 30.0, right: 50.0, bottom: 20.0),
                child: DropdownButton<int>(
                  value: _selected,
                  onChanged: (value) => {
                    setState(() {
                      _lon = japanList[value!]._lon;
                      _lat = japanList[value!]._lat;

                      _selected = value;
                    }),
                  },
                  style: const TextStyle(
                      fontSize:28.0,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"
                  ),
                  items: const <DropdownMenuItem<int>> [
                    DropdownMenuItem<int>(value: 0, child: Text('北海道')),
                    DropdownMenuItem<int>(value: 1, child: Text('青森県')),
                    DropdownMenuItem<int>(value: 2, child: Text('岩手県')),
                    DropdownMenuItem<int>(value: 3, child: Text('宮城県')),
                    DropdownMenuItem<int>(value: 4, child: Text('秋田県')),
                    DropdownMenuItem<int>(value: 5, child: Text('山形県')),
                    DropdownMenuItem<int>(value: 6, child: Text('福島県')),
                    DropdownMenuItem<int>(value: 7, child: Text('茨城県')),
                    DropdownMenuItem<int>(value: 8, child: Text('栃木県')),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, top: 10.0, right: 50.0, bottom: 10.0),
                width: double.infinity,
                child: Image.network('https://openweathermap.org/img/wn/$icon@2x.png'),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, top: 30.0, right: 50.0, bottom: 20.0),
                width: double.infinity,
                child: Row(
                  children: [
                    Text('最高気温：$tempMax', style:TextStyle(color:Colors.red)),
                    Text('／'),
                    Text('最低気温：$tempMin', style:TextStyle(color:Colors.blue)),
                    Text('℃'),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50.0, top: 30.0, right: 50.0, bottom: 20.0),
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('天気予報取得'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,  //背景色
                    foregroundColor: Colors.white, //文字色
                  ),
                  onPressed: () {
                    weather(_lat,_lon);
                  },
                )
              ),
            ]
        ),
      ),
    );
  }

  void weather(String lat, String lon) async { //lat=緯度、lon=経度
    const String key = '152e3c2e816919be93a551407f13d237';
    var response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&APPID=$key&units=metric&lang=ja'));

    // レスポンスが正常な場合
    var data = json.decode(response.body);
    var mainData = data['main'];
    var weatherData = data['weather'];

    setState(() {
      tempMin ='${mainData['temp_min']}';
      tempMax ='${mainData['temp_max']}';
      icon ='${weatherData[0]['icon']}';

    });
  }
}
class Japan {
  final String _lon; // 経度
  final String _lat; // 緯度

  Japan(this._lon,this._lat);
}
