
import 'dart:io';

import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:flutter_test/flutter_test.dart';

final dataStuff = DataStuff();

void gettersTest(){
  final cityId = 0;

  test("Deve retornar o id da cidade", (){
    int cityIdByName = dataStuff.getCityId("Arapiraca");

    expect(cityIdByName, 0);
  });

  test("Deve retornar o nome da cidade", (){
    String cityName = dataStuff.getCityName(cityId);

    expect(cityName, "Arapiraca");
  });

  test("Deve retornar os coeficientes da cidade", (){
    double cftA = dataStuff.getCfts(cityId, "a");
    double cftB = dataStuff.getCfts(cityId, "b");
    double cftC = dataStuff.getCfts(cityId, "c");

    expect(cftA, 0.003992);
    expect(cftB, 0.588707);
    expect(cftC, -7.339);
  });

  test("Deve retornar em lista os coeficientes da cidade", (){
    List cftsCity = dataStuff.getAllCftsCity(cityId);

    expect(cftsCity.isEmpty, false);
  });

  test("Deve retornar em lista das cidades com coeficientes calibrados", (){
    Iterable cftsCityKeys = dataStuff.getCityKeys();

    expect(cftsCityKeys.isEmpty, false);
  });

  test("Deve retornar o Kc da cultura", (){
    double cultKc = dataStuff.getCultKc(0, 0);

    expect(cultKc, 0.40);
  });

  test("Deve retornar em lista todas as culturas pré-cadastradas", (){
    Iterable cultKeys = dataStuff.getCultKeys();

    expect(cultKeys.isEmpty, false);
  });

  test("Deve retornar em lista todas as fases das culturas", (){
    Iterable stageKeys = dataStuff.getStageKeys();

    expect(stageKeys.isEmpty, false);
  });

  test("Deve retornar o Id da cultura", (){
    int cultId = dataStuff.getCultId("Tomate");

    expect(cultId, 22);
  });

  test("Deve retornar o nome da cultura", (){
    String cultName = dataStuff.getCultName(22);

    expect(cultName, "Tomate");
  });

  test("Deve retornar o Id do estágio", (){
    int stageId = dataStuff.getStageId("Colheita");

    expect(stageId, 4);
  });

  test("Deve retornar o nome do estágio", (){
    String stageName = dataStuff.getStageName(4);

    expect(stageName, "Colheita");
  });

  test("Deve retornar se a cidade tem coeficientes calibrados", (){
    bool betterCfts = dataStuff.hasBetterCfts("Arapiraca");
    bool betterCfts2 = dataStuff.hasBetterCfts("Craíbas");

    expect(betterCfts, true);
    expect(betterCfts2, false);
  });

  test("Deve retornar em lista os coeficientes padrão", (){
    List cftsDefault = dataStuff.getDefaultCfts();

    expect(cftsDefault.isEmpty, false);
  });

}

void fileIOTest() {

  test("Deve retornar o caminho do diretório", () async{
    String directory = await dataStuff.getDirectory();

    expect(directory.isNotEmpty, true);
  });

  test("getFile - Deve retornar um File", () async {
    String directory = "test/tmp_data";
    var fileData = await dataStuff.getFile(directory);
    var fileHistory = await dataStuff.getFile(directory, isHistory: true);

    expectLater(await fileData.exists(), true);
    expectLater(fileData, isA<File>());

    expectLater(await fileHistory.exists(), true);
    expectLater(fileHistory, isA<File>());
  });

  test("saveData - Deve retornar um File", () async {
    List data = List.filled(4, "lalalala");

    var fileData = await dataStuff.saveData(data);
    var fileHistory = await dataStuff.saveData(data, isHistory: true);

    expectLater(fileData, isA<File>());
    expectLater(fileHistory, isA<File>());
  });

  test("readData - Deve retornar uma String", () async {

    var readData = await dataStuff.readData();
    var readHistory = await dataStuff.readData(isHistory: true);

    expectLater(readData, isA<String>());
    expectLater(readHistory, isA<String>());
  });
}


void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  gettersTest();
  fileIOTest();
}