import 'dart:convert';

import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/ui/kc_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class EToPage extends StatefulWidget {
  @override
  _EToPageState createState() => _EToPageState();
}

class _EToPageState extends State<EToPage> {

  static DataStuff ds = DataStuff();

  static List city = [];
  static int actCityId = 0;

  TextEditingController tMaxController = TextEditingController();
  TextEditingController tMinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    Map<String, dynamic> mn = Map();
    ds.readData().then((data) {
      setState(() {
        city = json.decode(data);
        mn.addAll(city[0]);
        actCityId = mn["\"city\""]["\"cityId\""];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String actCityName = ds.getCityName(actCityId);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.only(top: 40.0, left: 15.0),
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  alignment: Alignment.topLeft,
                ),
                Container(
                  padding: EdgeInsets.only(top: 40.0, right: 10.0),
                  alignment: Alignment.topRight,
                  child: Text(
                    actCityName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: 550.0,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
                      child: Text(
                        "Inicialmente, precisamos das temperaturas.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      child: TextFormField(
                        controller: tMaxController,
                        validator: (value) {
                          if(value.isEmpty) {
                            return "Campo obrigatório!";
                          }else if(value.contains(",")) {
                            return "Decimais devem ser separados por \"ponto\". Ex: 29.8";
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffix: Text("Cº"),
                          labelText: "Máxima",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      child: TextFormField(
                        controller: tMinController,
                        validator: (value) {
                          if(value.isEmpty) {
                            return "Campo obrigatório!";
                          }else if(value.contains(",")) {
                            return "Decimais devem ser separados por \"ponto\"";
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffix: Text("Cº"),
                          labelText: "Mínima",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    OutlineButton(
                      onPressed: () {
                        if(_formKey.currentState.validate()) {
                          double et0 = resETo(
                              actCityId,
                              double.parse(tMaxController.text),
                              double.parse(tMinController.text)
                          );
                          return Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  new KcPage(eto: et0)
                              )
                          );
                        }
                        return null;
                      },
                      child: Text("Próximo"),
                      splashColor: Colors.white,
                      highlightColor: Colors.lightBlueAccent[400],
                      shape: StadiumBorder(),
                      borderSide: BorderSide(
                          width: 0.2
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  double resETo(int cityId, double tMax, double tMin) {

    List cfts = List();
    cfts.add(ds.getAllCftsCity(cityId));
    double a = cfts.elementAt(0)[0];
    double b = cfts.elementAt(0)[1];
    double c = cfts.elementAt(0)[2];
    double tMed = (tMax + tMin) / 2;
    int mes = DateTime.now().month;
    double irrSol = ds.getIrrSolarMes(cityId, mes);

    double eto = a * irrSol * pow((tMax - tMin), b) * (tMed + c);
    double eto2 = double.parse(eto.toStringAsPrecision(3));
    print(eto2);
    return eto2;
  }

}