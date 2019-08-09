import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/city_query.dart';
import 'package:chico_dagua/ui/eto_page.dart';
import 'package:chico_dagua/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(NewOne());
}

class NewOne extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SessionModel>(
      model: SessionModel(),
      child: MaterialApp(
        home: HomePage(),
        title: "Chico d'Água",
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: <String, WidgetBuilder> {
          "chooseCity": (BuildContext context) => CityQuery(),
          "calcETo" : (BuildContext context) => EToPage(),
        },
      ),
    );
  }
}
