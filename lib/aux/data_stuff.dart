import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataStuff {

  static final DataStuff dt = DataStuff.internal();
  factory DataStuff() => dt;
  DataStuff.internal();

  var _ids = {
    "Arapiraca": 0,
    "Belo Monte": 1,
    "Canapi": 2,
    "Coruripe": 3,
    "Girau do Ponciano": 4,
    "Igaci": 5,
    "Igreja Nova": 6,
    "Inajá": 7,
    "Major Isidoro": 8,
    "Mata Grande": 9,
    "Olho d’Água das Flores": 10,
    "Olho d’Água do Casado": 11,
    "Pariconha": 12,
    "São Braz": 13,
    "São José da Tapera": 14
  };

  var _cfts = [
    [0.003992, 0.588707, -7.339],
    [0.003202, 0.609479, -4.382],
    [0.002742, 0.614307, -0.812],
    [0.013552, 0.287915, -13.81],
    [0.003408, 0.593598, -4.608],
    [0.003507, 0.547011, -2.288],
    [0.007516, 0.430677, -10.81],
    [0.003350, 0.599207, -4.463],
    [0.003033, 0.578141, -0.732],
    [0.002780, 0.642025, -2.966],
    [0.002864, 0.605679, -1.220],
    [0.002981, 0.617031, -3.168],
    [0.002659, 0.638314, -1.356],
    [0.003992, 0.588707, -7.339],
    [0.003263, 0.585528, -0.435],
    [0.0023, 0.5, 17.8] //valores padrão
  ];

  var _irdSolarMes = [
    [21.888,21.42,20.232,18.54,17.208,15.372,15.804,17.712,19.764,21.6,22.68,22.608],
    [22.212,21.78,20.412,18.9,17.496,15.588,16.164,18.108,20.268,22.104,23.112,22.968],
    [22.32,22.104,20.664,19.512,18.18,16.272,16.776,19.368,21.852,23.4,23.832,23.364],
    [22.032,21.564,20.448,18.612,17.208,15.624,15.948,17.748,19.584,21.276,22.5,22.5],
    [22.032,21.528,20.304,18.612,17.244,15.408,15.912,17.748,19.8,21.672,22.824,22.788],
    [21.852,21.42,20.196,18.576,17.28,15.408,15.804,17.856,19.944,21.744,22.68,22.572],
    [22.032,21.528,20.376,18.612,17.208,15.516,16.02,17.784,19.728,21.456,22.644,22.644],
    [22.284,22.176,20.736,19.764,18.432,16.632,17.208,19.944,22.428,23.76,24.048,23.4],
    [22.212,21.744,20.448,18.936,17.604,15.696,16.164,18.324,20.52,22.392,23.256,23.112],
    [22.32,22.14,20.664,19.584,18.252,16.344,16.884,19.476,21.996,23.472,23.904,23.364],
    [22.248,21.888,20.52,19.08,17.748,15.804,16.308,18.54,20.808,22.572,23.364,23.112],
    [22.284,22.104,20.592,19.368,17.964,16.056,16.632,18.9,21.312,22.896,23.544,23.148],
    [22.32,22.212,20.664,19.62,18.216,16.344,16.956,19.476,21.96,23.4,23.868,23.292],
    [22.068,21.492,20.34,18.612,17.208,15.48,16.02,17.784,19.764,21.528,22.716,22.716],
    [22.248,21.888,20.52,19.116,17.748,15.84,16.344,18.54,20.844,22.572,23.364,23.112]
  ];

  var _cults = {
    "Abacaxi":0,
    "Alface":1,
    "Alfafa":2,
    "Algodão":3,
    "Amendoim":4,
    "Banana":5,
    "Batata":6,
    "Cana de açúcar":7,
    "Cebola":8,
    "Cereais menores":9,
    "Citros":10,
    "Ervilha":11,
    "Feijão":12,
    "Manga":13,
    "Melão":14,
    "Milho":15,
    "Milho doce":16,
    "Pepino":17,
    "Quiabo":18,
    "Soja":19,
    "Sorgo":20,
    "Tabaco":21,
    "Tomate":22,
    "Trigo":23,
    "Videira":24
  };

  var _stages = {
    "Inicial":0,
    "Des. vegetatitvo":1,
    "Meia Estação":2,
    "Final Estação":3,
    "Colheita":4
  };

  var _cultsKc = [
    [0.40, 0.45, 1.00, 0.50, 1.00],
    [1.00, 1.00, 0.97, 0.97, 1.00],
    [0.35, 1.00, 1.00, 1.00, 1.12],
    [0.45, 0.75, 1.15, 0.85, 0.67],
    [1.00, 1.00, 1.12, 1.00, 1.00],
    [0.45, 0.77, 1.05, 0.95, 0.80],
    [0.45, 0.75, 1.12, 0.90, 0.72],
    [0.45, 0.85, 1.15, 0.77, 0.55],
    [0.50, 0.68, 1.00, 1.00, 1.00],
    [1.00, 1.00, 1.12, 1.00, 1.00],
    [0.40, 0.47, 0.57, 1.00, 0.55],
    [0.45, 0.77, 1.12, 1.07, 1.02],
    [0.35, 0.67, 1.00, 0.92, 0.90],
    [0.40, 0.62, 0.87, 1.00, 0.75],
    [0.45, 0.75, 1.00, 0.85, 0.70],
    [0.40, 0.77, 1.12, 0.87, 0.57],
    [0.40, 0.80, 1.12, 1.07, 1.02],
    [1.00, 1.00, 1.00, 0.95, 1.00],
    [1.00, 1.00, 1.00, 1.00, 1.00],
    [0.35, 0.75, 1.07, 0.75, 0.45],
    [0.35, 0.72, 1.07, 0.77, 0.52],
    [0.35, 0.75, 1.10, 0.95, 0.80],
    [0.45, 0.75, 1.12, 0.87, 0.62],
    [0.35, 0.75, 1.12, 0.70, 0.22],
    [0.45, 0.75, 0.80, 0.70, 0.62]
  ];

  List history = [];
  bool hasHistory = false;

  /// Apaga o histórico que está no arquivo, e consequentemente do app.
  void clearHistory() {
    history.clear();
    saveData(history, isHistory: true);
    print("CLEAR: $history");
  }

  /// Retorna o ID da cidade, baseado no nome da cidade.
  int getCityId(String city) {
    return _ids[city];
  }

  /// Retorna uma String com o nome da cidade, baseado no ID da cidade.
  String getCityName(int id) {
    var tr = _ids.keys;
    return tr.elementAt(id);
  }

  /// Retorna o coeficiente especifico (a, b, ou c), para determinada cidade.
  /// Baseado no ID da cidade, e qual a letra do coeficiente.
  double getCfts(int idCity, String cfts) {
    if(cfts == "a") {
      return _cfts[idCity][0];
    }else if(cfts == "b") {
      return _cfts[idCity][1];
    }else if(cfts == "c") {
      return _cfts[idCity][2];
    }else {
      return null;
    }
  }

  /// Retorna uma lista com os coeficientes para calculo do ETo, baseado no ID
  /// da cidade.
  List getAllCftsCity(int idCity) {
    return _cfts[idCity];
  }

  /// Retorna o coeficiente de irradiação solar para a cidade, baseado no ID da
  /// cidade e no número do mês.
  double getIrrSolarMes(int idCity, int month) {
    return _irdSolarMes[idCity][month-1];
  }

  ///Retorna uma lista com todas as cidades que tem coeficientes calibrados.
  getCityKeys() {
    return _ids.keys;
  }

  ///Retorna o Kc da cultura, basado no ID da cultura o o ID do estágio em que
  ///se encontra a cultura.
  double getCultKc(int cult, int stageCult) {
    return _cultsKc[cult][stageCult];
  }

  /// Retorna uma lista com todas as culturas possiveis.
  getCultKeys() {
    return _cults.keys;
  }

  /// Retorna um lista com os estágios possiveis das culturas.
  getStageKeys() {
    return _stages.keys;
  }

  /// Retorna o ID da cultura, baseado no nome da cultura.
  int getCultId(String cultName) {
    return _cults[cultName];
  }

  /// Retorna o nome da cultura, baseado no ID da cultura.
  String getCultName(int id) {
    return _cults.keys.elementAt(id);
  }

  /// Retorna um inteiro com o ID do estágio em que se encontra a cultura,
  /// baseado no nome do estágio.
  int getStageId(String stageName) {
    return _stages[stageName];
  }

  /// Retorna uma String com o nome do estágio em que se encontra a cultura,
  /// baseado no id do estágio.
  String getStageName(int id) {
    return _stages.keys.elementAt(id);
  }

  ///Verifica, dado o nome de uma cidade, se ela está na lista de cidades que
  ///tem coeficientes calibrados.
  bool hasBetterCfts(String cityName) {
    return _ids.containsKey(cityName);
  }

  ///Retorna uma lista com os coeficientes padrão (é o ultimo na lista de coefici
  ///entes, e assim DEVE permanecer).
  List getDefaultCfts() {
    return _cfts.last;
  }

  //JSON manipulation
  /// Retorna o arquivo onde são guardados os dados, para escrita.
  /// Caso o arquivo ainda não exista, ele é criado.
  /// É usado o próprio arcabouço do flutter para definir o local onde esse
  /// arquivo deve ser salvo.
  Future<File> getFile({bool isHistory}) async {
    final directory = await getApplicationDocumentsDirectory();
    try {
      if(isHistory != null && isHistory) {
        print("history - GF");
        return File("${directory.path}/chicoHistory.json").create(recursive: true);
      }
      return File("${directory.path}/chicoData.json").create(recursive: true);
    }on FileSystemException {
      File file;
      if(isHistory != null && isHistory) {
        file = File("${directory.path}/chicoHistory.json");
        file.create(recursive: true).then((File fl) {
          file = fl;
        });
        file.open(mode: FileMode.write);
        return file;
      }
      file = File("${directory.path}/chicoData.json");
      file.create(recursive: true).then((File fl) {
        file = fl;
      });
      file.open(mode: FileMode.write);
      return file;
    } catch (e) {
      return null;
    }

  }

  ///Recebe os dados em formato de lista e escreve no arquivo JSON.
  ///Como parametro opcional verifica se é dados de histórico, caso esse paramêtro
  ///não seja definido, encara como sendo dados normais.
  Future<File> saveData(List listData, {bool isHistory}) async {
    if(isHistory != null && isHistory) {
      print("saveHistoryData $listData");
      String data = json.encode(listData);

      final file = await getFile(isHistory: true);
      return file.writeAsString(data);
    }
    print("saveData $listData");
    String data = json.encode(listData);
    final file = await getFile();
    return file.writeAsString(data);

  }

  ///Lê os dados do arquivo JSON.
  ///Tem como paramêtro opcional se é para ler o histórico, caso não, encara como
  ///sendo os dados normais.
  Future<String> readData({bool isHistory}) async {
    try {
      if(isHistory != null && isHistory) {
        print("history - RD");
        final file = await getFile(isHistory: true);
        return file.readAsString();
      }
      final file = await getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

}
