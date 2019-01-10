import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/city/CityData.dart';
import 'package:flutter_weather/weather/WeatherWidget.dart';
import 'package:http/http.dart' as http;

class CityWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CityState();
  }
}

class CityState extends State<CityWidget> {
  List<CityData> cityList = new List<CityData>();

  CityState() {
    _getCityList();
  }

  void _getCityList() async {
    List<CityData> citys = await _fetchCityList();
    setState(() {
      cityList = citys;
    });
  }

  //拉取城市列表
  Future<List<CityData>> _fetchCityList() async {
    final response = await http.get(
        'https://search.heweather.net/top?group=cn&key=9ef9c434b0184081aad7b40d7f86ee27');

    List<CityData> cityList = new List<CityData>();

    if (response.statusCode == 200) {
      //解析数据
      Map<String, dynamic> result = json.decode(response.body);
      for (dynamic data in result['HeWeather6'][0]['basic']) {
        CityData cityData = CityData(data['location']);
        cityList.add(cityData);
      }
      return cityList;
    } else {
      return cityList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cityList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: GestureDetector(
            child: Text(cityList[index].cityName),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WeatherWidget(cityList[index].cityName)));
            },
          ),
        );
      },
    );
  }
}
