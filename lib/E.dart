import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:jsonsample/data1.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class E extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chart',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //*** */
  String dropdownvalue = 'JSON Ex10 Random';
  var items = [
    'JSON Ex2 Float 0-1',
    'JSON Ex3 Float 0-1 & 1-1000',
    'JSON Ex4 12 bit random',
    'JSON Ex5 16 bit random',
    'JSON Ex6 Long',
    'JSON Ex7 Byte',
    'JSON Ex8 Rad',
    'JSON Ex9 Deg',
    'JSON Ex10 Random'
  ];

  ///** */
  List<JDatas> chartData = [];

  Future loadSalesData() async {
    final String jsonString = await getJsonFromAssets();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse) {
      chartData.add(JDatas.fromJson(i));
    }
  }

  Future<String> getJsonFromAssets() async {
    return await rootBundle.loadString('assets/12bit.json');
  }

  @override
  void initState() {
    loadSalesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Here is the chart'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getJsonFromAssets(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        // Chart title
                        title: ChartTitle(text: 'Datas from JSON'),
                        series: <ChartSeries<JDatas, String>>[
                          LineSeries<JDatas, String>(
                            dataSource: chartData,
                            xValueMapper: (JDatas value, _) => value.x,
                            yValueMapper: (JDatas value, _) => value.y,
                          )
                        ]);
                  } else {
                    return Card(
                      elevation: 5.0,
                      child: Container(
                        height: 100,
                        width: 400,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Retriving JSON data...',
                                  style: TextStyle(fontSize: 20.0)),
                              Container(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  semanticsLabel: 'Retriving JSON data',
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.pink),
                                  backgroundColor: Colors.amber[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: DropdownButton(
                value: dropdownvalue,
                icon: Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => data1()));
                  
                    if (newValue != null) {
                      dropdownvalue = newValue;
                    }
                    
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JDatas {
  JDatas(this.x, this.y);

  final String x;
  final double y;

  factory JDatas.fromJson(Map<String, dynamic> parsedJson) {
    return JDatas(
      parsedJson['x'].toString(),
      parsedJson['y'],
    );
  }
}