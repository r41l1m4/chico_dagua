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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Olá",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Preciso da sua permissão para catar a localização",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
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
                              Location().serviceEnabled().then((isEnabled) {
                                if(isEnabled) {
                                  Future.delayed(Duration(milliseconds: 500));
//                                  Navigator.of(context).pushReplacement(
//                                      MaterialPageRoute(
//                                          builder: (context) => PageTwo()));
                                }else {
                                  Location().requestService().then((hasServ) {
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
                      RaisedButton(
                        child: Text("Ceder Permissão"),
                        color: Colors.lightBlueAccent[400],
                        onPressed: () {
                          // ignore: missing_return
                          Location().requestPermission().then((hasPerm) {
                            print(hasPerm);
                            if (hasPerm) {
                              Location().serviceEnabled().then((isEnabled) {
                                if(isEnabled) {
                                  Future.delayed(Duration(milliseconds: 500));
//                                  Navigator.of(context).pushReplacement(
//                                      MaterialPageRoute(
//                                          builder: (context) => PageTwo()));
                                }else {
                                  Location().requestService().then((hasServ) {
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
