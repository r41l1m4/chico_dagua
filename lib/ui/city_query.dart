import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/ui/cult_query.dart';
import 'package:flutter/material.dart';

class CityQuery extends StatefulWidget {
  @override
  _CityQueryState createState() => _CityQueryState();
}

class _CityQueryState extends State<CityQuery> {
  static String dropdownValue;
  static final DataStuff ds = DataStuff();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 270.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                child: Text(
                  "Selecione sua cidade.",
                  style: TextStyle(
                    fontSize: 23.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  "Ou a mais próxima.",
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
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
                      .getCityKeys()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              IconButton(
                highlightColor: Colors.lightBlueAccent[400],
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  if(dropdownValue == null ) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            backgroundColor: Colors.lightBlueAccent[400],
                            title: Text("Erro!"),
                            content: Text("É necessário selecionar uma cidade.",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          );
                        }
                    );
                  }else if(dropdownValue != null) {
                    ds.setCity(dropdownValue);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new CultQuery()
                        )
                    );
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
