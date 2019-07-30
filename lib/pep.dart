import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/Car/Car.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'همراه مکانیک',debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'iransans'),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Car> cars = new List<Car>();
  ScrollController _controller = ScrollController();
  int id = 1;
  @override
  void initState() {
    _loadData(id);
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        id++;
        _loadData(id);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView.builder(
        controller: _controller,
        itemBuilder: (c, i) {
          return SizedBox(
            height: 189,
            child: Stack(
              children: <Widget>[
               Ink.image(
                 image: NetworkImage(cars[i].url),child: InkWell(onTap: (){},),
               ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        cars[i].carName,
                        style: TextStyle(color: Colors.white,fontSize: 18,backgroundColor: Colors.black.withOpacity(0.5)),
                        textAlign: TextAlign.center,
                      ),                      Text(
                        cars[i].price,
                        style: TextStyle(color: Colors.white,fontSize: 23),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: cars.length,
      ),
    ));
  }

  void _loadData(int id) async {
    Car c = new Car();
    var items = await c.getCar(id);
    setState(() {
      cars.addAll(items);
    });
    print(id);
  }
}
