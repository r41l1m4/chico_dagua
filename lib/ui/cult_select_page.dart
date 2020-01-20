import 'dart:convert';

import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/initial_flow/loc_perm_page.dart';
import 'package:flutter/material.dart';

class CultSelectPage extends StatefulWidget {
  @override
  _CultSelectPageState createState() => _CultSelectPageState();
}

class _CultSelectPageState extends State<CultSelectPage> {
  static DataStuff ds = DataStuff();

  List allCults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Culturas",
          style: TextStyle(fontFamily: "Comfortaa"),
        ),
        backgroundColor: Colors.lightBlueAccent[400],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => LocPermPage()
                    )
                );
              });
            },
          )
        ],
      ),
      body: FutureBuilder<String>(
        future: ds.readData(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.data == null || snapshot.data.length <= 2) {
            return hasNone();
          }else {
            List cults = json.decode(snapshot.data);
            allCults = cults;
            return hasSome(cults);
          }
        },
      ),
    );
  }

  ///Retorna um Widget com um texto dizendo que não tem nada, cas não haja registros
  ///no histórico.
  Widget hasNone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 110.0),
          child:  Text("Nada aqui ainda. :(",
            style: TextStyle(fontFamily: "Comfortaa",
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  ///Retorna um Widget com a lista de Cards de entradas de culturas.
  Widget hasSome(List cults) {
    return ListView.builder(
      itemCount: cults.length,
      itemBuilder: (context, index) {
        return cultCard(index, cults.reversed.elementAt(index));
      },
    );
  }

  ///Retorna um Widget, um Card especificamente, dados determinados parâmetros
  Widget cultCard(int index, Map cultEntry) {

    return InkWell(
      //Quando o card com a cultura é selecionado, usa-se os dados da cultura selecionada
      //para redefinir os dados do SessionModel do contexto.
      onTap: () {
        SessionModel.of(context).setCityState(cultEntry.values.elementAt(0));
        SessionModel.of(context).setCityId(cultEntry.values.elementAt(1)["\"cityId\""]);
        SessionModel.of(context).setCity(cultEntry.values.elementAt(1)["\"cityName\""]);
        SessionModel.of(context).setState(cultEntry.values.elementAt(1)["\"stateName\""]);
        SessionModel.of(context).setLat(cultEntry.values.elementAt(1)["\"latitude\""]);
        SessionModel.of(context).setCultId(cultEntry.values.elementAt(2)["\"cultId\""]);
        SessionModel.of(context).setCultName(cultEntry.values.elementAt(2)["\"cultName\""]);
        SessionModel.of(context).setEp(double.parse(cultEntry.values.elementAt(2)["\"Ep\""].toString()));
        SessionModel.of(context).setq(double.parse(cultEntry.values.elementAt(3)["\"q\""].toString()));
        SessionModel.of(context).setEem(double.parse(cultEntry.values.elementAt(3)["\"Eem\""].toString()));
        SessionModel.of(context).setEl(double.parse(cultEntry.values.elementAt(3)["\"El\""].toString()));

        Navigator.pop(context);
      },
      child: Card(
        elevation: 13.0,
        color: Colors.lightBlueAccent[400],
        child: ExpansionTile(
          title: Text("${cultEntry.values.elementAt(2)["\"cultName\""]}",
            style: TextStyle(fontSize: 32.0,
                fontFamily: "Comfortaa",
                color: Colors.white
            ),
          ),
          backgroundColor: Colors.lightBlueAccent[100],
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    infoCel("Vazão", cultEntry.values.elementAt(3)["\"q\""], "l/h"),
                    infoCel("Esp. plantas", cultEntry.values.elementAt(2)["\"Ep\""], "cm"),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    infoCel("Esp. gotejadores", cultEntry.values.elementAt(3)["\"Eem\""], "cm"),
                    infoCel("Esp. linhas", cultEntry.values.elementAt(3)["\"El\""], "cm"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///Retorna um Widget (Text) com as informações da cultura, estas sendo passadas
  ///por parâmetro
  Widget infoCel(String info, double value, String measure) {
    return Text(
      "$info: $value $measure",
      style: TextStyle(
          fontSize: 15.0,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
    );
  }

}
