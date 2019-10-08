import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocPermPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
                            print(hasPerm);
                            if (hasPerm) {
                              //verifica se o serviço de localização está ativado
                              Location().serviceEnabled().then((isEnabled) {
                                //Se está ativado
                                if(isEnabled) {
                                  Future.delayed(Duration(milliseconds: 500));
//                                  Navigator.of(context).pushReplacement(
//                                      MaterialPageRoute(
//                                          builder: (context) => PageTwo()));
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
          }),
    );
  }
}
