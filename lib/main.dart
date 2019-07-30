import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/Car/Car.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'همراه مکانیک',
      debugShowCheckedModeBanner: false,
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
  int id = 1;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('همراه مکانیک'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch(cars: cars));
              },
            )
          ],
        ),
        body: Center(
          child:cars.length>0?  CarList(cars: cars):CircularProgressIndicator(),
        ));
  }

  void _loadData() async {
    Car c = new Car();
    var items = await c.getCars();
    setState(() {
      cars = items;
    });
  }
}

class CarList extends StatelessWidget {
  const CarList({
    Key key,
    @required this.cars,
  }) : super(key: key);

  final List<Car> cars;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (c, i) {
        return SizedBox(
          height: 189,
          child: Stack(
            children: <Widget>[
              Ink.image(
                image: NetworkImage(cars[i].url),
                child: InkWell(
                  onTap: () {},
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      cars[i].carName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          backgroundColor: Colors.black.withOpacity(0.5)),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      cars[i].price,
                      style: TextStyle(color: Colors.white, fontSize: 23),
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
    );
  }
}

class DataSearch extends SearchDelegate<Car> {
  DataSearch({this.cars});
  List<Car> cars;

  List<Car> recentCars = List<Car>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print(query);
    final suggestionList = query.isEmpty
        ? recentCars
        : cars.where((c) => c.carName.contains(query)).toList();

    return CarList(
      cars: suggestionList,
    );
  }
}

class CarTile extends StatelessWidget {
  const CarTile({
    Key key,
    @required this.suggestionList,
  }) : super(key: key);

  final List<Car> suggestionList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (c, i) {
        return ListTile(
          leading: Icon(Icons.location_city),
          title: Text(suggestionList[i].carName),
          subtitle: Text(suggestionList[i].price),
        );
      },
      itemCount: suggestionList.length,
    );
  }
}
