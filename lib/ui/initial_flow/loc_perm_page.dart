import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/initial_flow/cult_query.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';

class LocPermPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<SessionModel>(
        builder: (context, child, model) {
          return FutureBuilder(
              future: Location().hasPermission(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data) {
                    Future.delayed(Duration(milliseconds: 500)).then((val) {
//                  return Navigator.of(context)
//                      .pushReplacement(MaterialPageRoute(builder: (context) => PageTwo()));
                    });
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              "Bem...",
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              "Precisamos da sua permissão para acessar a localização e saber onde você está, para isso, é só clicar no botão abaixo.",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300),
                              //textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          OutlineButton(
                            onPressed: () {
                              // ignore: missing_return
                              Location().requestPermission().then((hasPerm) {
                                if (hasPerm) {
                                  //verifica se o serviço de localização está ativado
                                  Location().serviceEnabled().then((isEnabled) {
                                    //Se está ativado
                                    if(isEnabled) {
                                      Coordinates coods;

                                      Location().getLocation().then((locData) {

                                        model.setLong(locData.longitude);
                                        print("Long: ${locData.longitude}");
                                        coods = Coordinates(locData.latitude, locData.longitude);
                                      }).whenComplete(() {

                                        Future.delayed(Duration(milliseconds: 500));
                                        Geocoder.local.findAddressesFromCoordinates(coods)
                                            .then((geolocData) {
                                          print("COODS: ${coods.latitude}, ${coods.longitude}");
                                          Future.delayed(Duration(milliseconds: 500));
                                          model.setCity(geolocData.first.subAdminArea);
                                          model.setState(geolocData.first.adminArea);
                                          print("Local: ${geolocData.first.subAdminArea}, ${geolocData.first.adminArea}");
                                        });
                                      });

                                      Future.delayed(Duration(milliseconds: 500));
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => CultQuery()
                                          ));
                                      //Se não está
                                    }else {
                                      //Pede para que o serviço seja ativado
                                      Location().requestService().then((hasServ) {
                                        //Se o serviço foi ativado
                                        if(hasServ) {
                                          Future.delayed(Duration(milliseconds: 500));
//                                      Navigator.of(context).pushReplacement(
//                                          MaterialPageRoute(
//                                              builder: (context) => PageTwo()));
                                        }
                                      });
                                    }
                                  });
                                } else {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text("Bora liberar essa porra?"),
                                        title: Text("ERRO!"),
                                        backgroundColor: Colors.lightBlueAccent[400],
                                      );
                                    },
                                  );
                                }
                              });
                            },
                            child: Text("Ceder Permissão"),
                            shape: StadiumBorder(),
                            splashColor: Colors.white,
                            highlightColor: Colors.lightBlueAccent[400],
                            borderSide: BorderSide(
                                width: 0.2
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Container();
              });
        },
      ),
    );
  }
}
