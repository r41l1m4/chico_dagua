import 'dart:convert';

import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/flow_model.dart';
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

  static DataStuff ds = DataStuff();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: ds.readData(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ),
          );
        }else if(snapshot.data.length > 2 && (snapshot.data.isNotEmpty || snapshot.data != null)) {
          List city = json.decode(snapshot.data);

          return ScopedModel<SessionModel>(
            model: SessionModel.init(
                        city.elementAt(0)["\"hasCity\""],
                        city.elementAt(0)["\"city\""]["\"cityId\""],
                        city.elementAt(0)["\"city\""]["\"cityName\""],
                        city.elementAt(0)["\"city\""]["\"stateName\""],
                        double.parse(city.elementAt(0)["\"city\""]["\"longitude\""].toString()),
                        city.elementAt(0)["\"cult\""]["\"cultId\""],
                        double.parse(city.elementAt(0)["\"cult\""]["\"Ep\""].toString()),
                        double.parse(city.elementAt(0)["\"irrig\""]["\"q\""].toString()),
                        double.parse(city.elementAt(0)["\"irrig\""]["\"Eem\""].toString()),
                        double.parse(city.elementAt(0)["\"irrig\""]["\"El\""].toString())
                    ),
            child: ScopedModelDescendant<SessionModel>(
              builder: (context, child, model) {
                return ScopedModel<FlowModel>(
                  model: FlowModel(),
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
              },
            ),
          );
        }else {
          return ScopedModel<SessionModel>(
            model: SessionModel(),
            child: ScopedModelDescendant<SessionModel>(
              builder: (context, child, model) {
                return ScopedModel<FlowModel>(
                  model: FlowModel(),
                  child: MaterialApp(
                    home: HomePage(),
                    title: "Chico d'Água",
                    debugShowCheckedModeBanner: false,
                    initialRoute: "chooseCity",
                    routes: <String, WidgetBuilder> {
                      "chooseCity": (BuildContext context) => CityQuery(),
                      "calcETo" : (BuildContext context) => EToPage(),
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
