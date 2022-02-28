

import 'package:chico_dagua/ui/session_flow/eto_page.dart';
import 'package:chico_dagua/ui/session_flow/kc_page.dart';
import 'package:chico_dagua/ui/session_flow/kc_page_alt.dart';
import 'package:chico_dagua/ui/session_flow/result_page.dart';
import 'package:flutter_test/flutter_test.dart';

final etoPage = EToPage().createState();
final kcPage = KcPage().createState();
final kcPageAlt = KcPageAlt().createState();
final resPage = ResultPage().createState();

void calcETo() {
  group("ETo - cálculo ordinário", () {
    test("Retorna o dia juliano dada determinada data", () {
      int day = etoPage.ordinalDay(1998, 04, 17);

      expect(day, 107);
    });
  });

  group("ETo - Só precisa do dia juliano como entrada", () {
    int julianDay = 107;

    test("Retorna a distância terra-sol", () {
      double distance = etoPage.calcDistanceEarthSun(julianDay);
      String d = distance.toStringAsFixed(6);
      distance = double.parse(d);

      expect(distance, 0.991162);
    });

    test("Retorna a contante psicométrica 'd'", () {
      double psiD = etoPage.calcPsychometricConstD(julianDay);
      String d = psiD.toStringAsFixed(6);
      psiD = double.parse(d);

      expect(psiD, 0.178608);
    });

    //need mock test
    test("Retorna a contante psicométrica 'j'", () {
      double psiJ = new EToPage().createState().calcPsychometricConstJ(julianDay);
      String d = psiJ.toStringAsFixed(6);
      psiJ = double.parse(d);

      expect(psiJ, 0.178608);
    });

  });

  group("ETo - cálculo principal", () {
    //need mock test
    test("realiza o cálculo de ETo", () {
      double eto = etoPage.resETo("Arapiraca", 32.0, 26.0);

      expect(eto, 2.5);
    });
  });
}

void calcETc() {
  group("ETc - cálculo principal", () {
    test("Retorna o ETc", () {
      double etc = kcPage.getETc(4.3, 1.2);
      double etcAlt = kcPageAlt.getETc(4.3, 1.2);

      expect(etc, 5.16);
      expect(etcAlt, 5.16);
    });
  });
}

void calcTime() {
  group("Time - cálculos auxiliares", () {
    test("Retorna o tempo formatado", () {
      String time = resPage.formatTime(73);

      expect(time, "1 hora e 13 minutos");
    });
  });

  group("Time - cálculo principal", () {
    test("Retorna a quantidade de minutos que o equipamento de irrigação deve permanecer ligado.", () {
      int time = resPage.timeIrrig(5.16, 1.0, 0.4, 0.8, 4.5);

      expect(time, 61);
    });
  });

  group("Time - próximos passos", () {
    test("retorna um Map com os dados para entrada no histórico.", () {
      Map entry = resPage.entryHistory(DateTime.now().toString(), "Tomate", "Colheita", 61, 5.16);

      expect(entry, isA<Map>());
      expect(entry.isNotEmpty, true);
    });
  });
}

void main() {
  calcETo();
  calcETc();
  calcTime();
}