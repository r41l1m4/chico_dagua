import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/ui/city_query.dart';
import 'package:chico_dagua/ui/eto_page.dart';
import 'package:chico_dagua/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(NewOne());
}

class NewOne extends StatefulWidget {
  @override
  _NewOneState createState() => _NewOneState();
}

class _NewOneState extends State<NewOne> {

  DataStuff ds = DataStuff();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: "Chico d'Água",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: <String, WidgetBuilder> {
        "chooseCity": (BuildContext context) => CityQuery(),
        "calcETo" : (BuildContext context) => EToPage(),
      },
    );
  }
}
