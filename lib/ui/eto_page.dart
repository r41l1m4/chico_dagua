import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/flow_model.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/kc_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:scoped_model/scoped_model.dart';

class EToPage extends StatefulWidget {
  @override
  _EToPageState createState() => _EToPageState();
}

class _EToPageState extends State<EToPage> {

  static DataStuff ds = DataStuff();

  TextEditingController tMaxController = TextEditingController();
  TextEditingController tMinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                    ds.getCityName(ScopedModel.of<SessionModel>(context).cityId),
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
                        "Inicialmente, precisamos das temperaturas do dia anterior.",
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
                      child: _tempInputBox(tMaxController, "Máxima"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      child: _tempInputBox(tMinController, "Mínima"),
                    ),
                    ScopedModelDescendant<FlowModel>(
                      builder: (context, child, model) {
                        return OutlineButton(
                          // ignore: missing_return
                          onPressed: () {
                            if(_formKey.currentState.validate()) {
                              double et0 = resETo(
                                  ScopedModel.of<SessionModel>(context).cityId,
                                  double.parse(tMaxController.text),
                                  double.parse(tMinController.text)
                              );
                              model.setEt0(et0);
                              return Navigator.pushReplacement(
                                  this.context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondAnimation) => KcPage(),
                                    transitionDuration: Duration(milliseconds: 400),
                                    transitionsBuilder: (context, animation, secondAnimation, child) {
                                      var begin = Offset(1.0, 0.0);
                                      var end = Offset.zero;
                                      var tween = Tween(begin: begin, end: end);
                                      var offsetAnimation = animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  )
                              );
                            }
                          },
                          child: Text("Próximo"),
                          splashColor: Colors.white,
                          highlightColor: Colors.lightBlueAccent[400],
                          shape: StadiumBorder(),
                          borderSide: BorderSide(
                              width: 0.2
                          ),
                        );
                      },
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

  Widget _tempInputBox(controller, label) {
    return TextFormField(
      controller: controller,
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
        labelText: "$label",
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 15.0,
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