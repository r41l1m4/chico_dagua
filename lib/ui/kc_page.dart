import 'dart:convert';
import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/flow_model.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/result_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class KcPage extends StatefulWidget {

  KcPage();

  @override
  _KcPageState createState() => _KcPageState();
}

class _KcPageState extends State<KcPage> {
  static DataStuff ds = DataStuff();
  static String dropdownValue;

  //double evtrs;

  _KcPageState();

//  static List city = [];
//  static int actCityId = 0;

  TextEditingController kcController = TextEditingController();

  bool manualKc = false;

//  @override
//  void initState() {
//    super.initState();
//    Map<String, dynamic> mn = Map();
//    ds.readData().then((data) {
//      setState(() {
//        city = json.decode(data);
//        mn.addAll(city[0]);
//        actCityId = mn["\"city\""]["\"cityId\""];
//      });
//    });
//  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
                    child: Text(
                      "Agora, selecione a fase em que se encontra a sua cultura.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: DropdownButton<String>(
                      iconEnabledColor: Colors.grey,
                      hint: Text("Selecione"),
                      iconSize: 30.0,
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: ds
                          .getStageKeys()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: manualKc,
                        checkColor: Colors.lightBlueAccent[400],
                        activeColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            manualKc = value;
                          });
                        },
                      ),
                      Text("Quero digitar o Kc da cultura.")
                    ],
                  ),
                  AnimatedOpacity(
                    opacity: manualKc ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.0, vertical: 20.0),
                      child: TextFormField(
                        controller: kcController,
                        enabled: manualKc,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Campo obrigatório!";
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Kc",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  ScopedModelDescendant<FlowModel>(
                    builder: (context, child, model) {
                      return OutlineButton(
                        onPressed: () {
                          if ((dropdownValue == null && !manualKc) ||
                              (manualKc && kcController.text.isEmpty)) {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.lightBlueAccent[400],
                                    title: Text("Erro!"),
                                    content: Text(
                                      "Todos os campos são obrigatórios.",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                });
                          } else if ((manualKc &&
                              kcController.text.contains(","))) {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.lightBlueAccent[400],
                                    title: Text("Erro!"),
                                    content: Text(
                                      "Decimais devem ser separados por \"ponto\".",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                });
                          } else {
                            int cultId = ScopedModel.of<SessionModel>(context).cultId;
                            //ds.city.elementAt(0)["\"cult\""]["\"cultId\""];
                            //String cult = ds.getCultName(cultId);
                            double kc = manualKc
                                ? double.parse(kcController.text)
                                : ds.getCultKc(
                                cultId, ds.getStageId(dropdownValue));
                            double etc = getETc(model.et0, kc);
                            model.setEtc(etc);
                            model.setStage(dropdownValue ?? "Kc Manual");
                            return Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondAnimation) =>
                                      ResultPage(
                                        etc: etc,
                                        stage: dropdownValue == null
                                            ? "Kc Manual"
                                            : dropdownValue,
                                      ),
                                  transitionDuration: Duration(milliseconds: 400),
                                  transitionsBuilder:
                                      (context, animation, secondAnimation, child) {
                                    var begin = Offset(1.0, 0.0);
                                    var end = Offset.zero;
                                    var tween = Tween(begin: begin, end: end);
                                    var offsetAnimation = animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ));
                          }
                        },
                        child: Text("Calcular"),
                        splashColor: Colors.white,
                        highlightColor: Colors.lightBlueAccent[400],
                        shape: StadiumBorder(),
                        borderSide: BorderSide(width: 0.2),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getETc(double eto, double kc) {
    double etc = eto * kc;
    double etc2 = double.parse(etc.toStringAsPrecision(3));
    return etc2;
  }
}
