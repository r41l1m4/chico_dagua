import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/initial_flow/pos_loc_pre_cult.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';

/// Responsável por colher a localização do usuário via GPS.
class LocPermPage extends StatelessWidget {

  final DataStuff ds = DataStuff();

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
                            "Precisamos da sua permissão para acessar a "
                                "localização e saber onde você está, "
                                "para isso, é só clicar no botão abaixo. \n"
                                "Certifique-se que o GPS do aparelho está ativo.",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300),
                            //textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
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

                                      model.setLat(locData.latitude);
                                      print("Lat: ${locData.latitude}");
                                      coods = Coordinates(locData.latitude, locData.longitude);
                                    }).whenComplete(() {

                                      Future.delayed(Duration(milliseconds: 500));
                                      Geocoder.local.findAddressesFromCoordinates(coods)
                                          .then((geolocData) {
                                        print("COODS: ${coods.latitude}, ${coods.longitude}");
                                        Future.delayed(Duration(milliseconds: 500));
                                        model.setCity(geolocData.first.subAdminArea);

                                        //verifica se a cidade relatada pelo GPS já existe como
                                        //cidade com o coeficiente calibrado
                                        if(ds.getCityKeys().contains(geolocData.first.subAdminArea)) {
                                          //Se já existe, pega o Id da cidade e seta no Model
                                          model.setCityId(ds.getCityId(geolocData.first.subAdminArea));
                                        }else {
                                          //Caso não, seta o valor para 15, assim ele vai pegar os coeficientes padrão
                                          model.setCityId(15);
                                        }

                                        model.setState(geolocData.first.adminArea);
                                        model.setCityState(true);
                                        print("Local: ${geolocData.first.subAdminArea}, ${geolocData.first.adminArea}");
                                      });
                                    });

                                    Future.delayed(Duration(milliseconds: 500));
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => PosLocPreCult()
                                        ));
                                    //Se não está
                                  }else {
                                    //Pede para que o serviço seja ativado
                                    Location().requestService().then((hasServ) {
                                      //Se o serviço não foi ativado
                                      if(!hasServ) {
                                        Future.delayed(Duration(milliseconds: 500));
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => LocPermPage()));
                                      }
                                    });
                                  }
                                });
                              } else {
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text("O acesso a localização é"
                                          " realmente necessário para que "
                                          "possamos prosseguir."),
                                      title: Text("ERRO!"),
                                      backgroundColor: Theme.of(context).primaryColor,
                                    );
                                  },
                                );
                              }
                            });
                          },
                          child: Text("Ceder Permissão"),
                          shape: StadiumBorder(),
                          splashColor: Colors.white,
                          highlightColor: Theme.of(context).primaryColor,
                          borderSide: BorderSide(
                              width: 0.2,
                              color: Theme.of(context).accentColor
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  );
                }
              });
        },
      ),
    );
  }
}
