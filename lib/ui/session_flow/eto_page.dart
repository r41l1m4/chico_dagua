import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/flow_model.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/session_flow/kc_page.dart';
import 'package:chico_dagua/ui/session_flow/kc_page_alt.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'dart:math';

import 'package:scoped_model/scoped_model.dart';

/// Responsável pela tela de entrada de temperaturas e também pelo calculo de ETo.
class EToPage extends StatefulWidget {
  @override
  _EToPageState createState() => _EToPageState();
}

/// Responsável pela tela de entrada de temperaturas e também pelo calculo de ETo.
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
                    SessionModel.of(context).city,
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
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                      child: _tempInputBox(tMaxController, "Máxima"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                      child: _tempInputBox(tMinController, "Mínima"),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ScopedModelDescendant<FlowModel>(
                      builder: (context, child, model) {
                        return OutlineButton(
                          // ignore: missing_return
                          onPressed: () {
                            if(_formKey.currentState.validate()) {
                              double et0 = resETo(
                                  SessionModel.of(context).city,
                                  double.parse(tMaxController.text),
                                  double.parse(tMinController.text)
                              );
                              model.setTempMax(double.parse(tMaxController.text));
                              model.setTempMin(double.parse(tMinController.text));
                              model.setEt0(et0);
                              return Navigator.pushReplacement(
                                  this.context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondAnimation)
                                    => SessionModel.of(context).cultId == 25 ? KcPageAlt() : KcPage(),
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

  ///Retorna um campo de entrada de texto, recebendo um título e um controlador
  ///de campo de entrada.
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
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: Colors.black),
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 15.0,
      ),
    );
  }

  /// Retorna o numero sequencial do dia do ano, vulgo dia juliano, baseados no
  /// ano, mês e dia.
  int ordinalDay(int year, int month, int day) { //retorna o dia juliano
    if (month == DateTime.january) {
      return day;
    } else if (month == DateTime.february) {
      return day + 31;
    } else {
      if (isLeapYear(year)) {
        return ordinalDayFromMarchFirst(month, day) + 60;
      } else {
        return ordinalDayFromMarchFirst(month, day) + 59;
      }
    }
  }

  ///Recebe o dia juliano e retorna distância Terra-Sol para aquele dia do ano. (dr)
  double calcDistanceEarthSun(int julianDay) {
    return 1 + 0.033 * cos(2 * pi * (julianDay / 365));
  }

  ///Recebe o dia juliano e calcula a constante psicrométrica para aquele dia do ano. (d)
  double calcPsychometricConstD(int julianDay) {
    return 0.409 * sin((2 * pi * (julianDay / 365)) - 1.39);
  }

  ///Recebe o dia juliano e calcula a constante psicrométrica para aquele dia do ano,
  ///naquela exata localização (latitude). (j)
  double calcPsychometricConstJ(int julianDay) {
    return (pi / 180) * SessionModel.of(context).lat;
  }

  ///Retorna o ângulo do pôr do sol para determinado dia, baseado nas constantes
  ///psicrométricas "d" e "j". (ws)
  double calcSunsetAngle(double d, double j) {
    return acos((-tan(j)) * tan(d));
  }

  ///Retorna a radiação solar extraterrestre, baseado na distância terra-sol,
  ///ângulo do pôr do sol e constantes psicrométricas "d" e "j".
  double calcSolarRadExt(double dr, double d, double j, double ws) {
    return (24 * 60 * 0.082 * (dr / pi)) * (ws * sin(j) * sin(d) + cos(j) * cos(d) * sin(ws));
  }

  ///Dado um nome de cidade, e temperaturas máxima e mínima, retorna o ETo.
  double resETo(String cityName, double tMax, double tMin) {

    List cfts = List();
    double a;
    double b;
    double c;

    int julianDay = ordinalDay(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    double d = calcPsychometricConstD(julianDay);
    double j = calcPsychometricConstJ(julianDay);
    double dr = calcDistanceEarthSun(julianDay);
    double ws = calcSunsetAngle(d, j);

    //Se há coeficientes calibrados para a cidade
    if(ds.hasBetterCfts(cityName)) {
      cfts.add(ds.getAllCftsCity(ds.getCityId(cityName)));
      a = cfts.elementAt(0)[0];
      b = cfts.elementAt(0)[1];
      c = cfts.elementAt(0)[2];
     //Caso não haja.
    }else {
      cfts.add(ds.getDefaultCfts());
      a = cfts.elementAt(0)[0];
      b = cfts.elementAt(0)[1];
      c = cfts.elementAt(0)[2];
    }
    double tMed = (tMax + tMin) / 2;
    double eto = a * (calcSolarRadExt(dr, d, j, ws) / 2.45) * pow((tMax - tMin), b) * (tMed + c);
    double eto2 = double.parse(eto.toStringAsPrecision(3));
    print(eto2);
    return eto2;
  }

}