
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("main flow - ", () {
    FlutterDriver driver;

    final startButtonFinder = find.byValueKey('startButton');

    final maxTempFinder = find.byValueKey("maxTemp");
    final minTempFinder = find.byValueKey("minTemp");
    final tempFormButtonFinder = find.byValueKey("tempFormButton");

    final dropdownKcFinder = find.byValueKey("dropdownKc");
    final dropItemFinder = find.byValueKey("dropItem_Colheita_text");
    final manualKcCheckFinder = find.byValueKey('manualKcCheck');
    final kcFormButtonFinder = find.byValueKey("kcFormButton");
    final manualKcFormFinder = find.byValueKey('manualKcForm');
    
    final finalResultButtonFinder = find.byValueKey('finalResultButton');

    setUpAll(() async{
      driver = await FlutterDriver.connect();
      //l = [{"hasCity": true, "city": {"cityId": 15, "cityName": "Craíbas", "stateName": "Alagoas", "latitude": -9.6848039}, "cult": {"cultId": 22, "cultName": "Tomate", "Ep": 40.0}, "irrig": {"q": 4.8, "Eem": 90.0, "El": 100.0}}];
      //ds.saveData(l);
    });

    tearDownAll(() async {
      driver.close();
    });

    test("initial page assurance", () async{
      expect(await driver.getText(find.text("Vamos começar?")), "Vamos começar?");
      await driver.tap(startButtonFinder);
    });

    test("temperature form test #1 - max", () async {
      expect(await driver.getText(find.text("Inicialmente, precisamos das temperaturas do dia anterior.")),
          "Inicialmente, precisamos das temperaturas do dia anterior.");

      await driver.tap(tempFormButtonFinder);

      await driver.tap(maxTempFinder);
      await driver.enterText("26,5");
      expect(await driver.getText(find.text("26,5")), "26,5");

      await driver.tap(tempFormButtonFinder);
      expect(await driver.getText(find.text("Decimais devem ser separados por \"ponto\"")),
          "Decimais devem ser separados por \"ponto\"");

      await driver.tap(maxTempFinder);
      await driver.enterText("26.5");
      expect(await driver.getText(find.text("26.5")), "26.5");

    });

    test("temperature form test #2 - min", () async {
      await driver.tap(tempFormButtonFinder);

      await driver.tap(minTempFinder);
      await driver.enterText("19,5");
      expect(await driver.getText(find.text("19,5")), "19,5");

      await driver.tap(tempFormButtonFinder);
      expect(await driver.getText(find.text("Decimais devem ser separados por \"ponto\"")),
          "Decimais devem ser separados por \"ponto\"");

      await driver.tap(minTempFinder);
      await driver.enterText("19.5");
      expect(await driver.getText(find.text("19.5")), "19.5");

      await driver.tap(tempFormButtonFinder);
    });

    // test("Kc input test", () async {
    //   await driver.tap(dropdownKcFinder);
    //
    //   await driver.waitFor(dropItemFinder);
    //   await driver.tap(dropItemFinder);
    //
    //   await driver.tap(manualKcCheckFinder);
    //
    //   await driver.tap(kcFormButtonFinder);
    //   expect(await driver.getText(find.text("Todos os campos são obrigatórios.")),
    //       "Todos os campos são obrigatórios.");
    //   await driver.tap(find.text("Okay"));
    //
    //   await driver.tap(manualKcFormFinder);
    //   await driver.enterText("0,7");
    //
    //   await driver.tap(kcFormButtonFinder);
    //   expect(await driver.getText(find.text("Decimais devem ser separados por \"ponto\".")),
    //       "Decimais devem ser separados por \"ponto\".");
    //   await driver.tap(find.text("Okay"));
    //
    //   await driver.tap(manualKcFormFinder);
    //   await driver.enterText("0.7");
    //
    //   await driver.tap(kcFormButtonFinder);
    // });


    test("Kc manual input test", () async {
      await driver.tap(manualKcFormFinder);
      await driver.enterText("0,7");

      await driver.tap(kcFormButtonFinder);
      expect(await driver.getText(find.text("Decimais devem ser separados por \"ponto\".")),
          "Decimais devem ser separados por \"ponto\".");
      await driver.tap(find.text("Okay"));

      await driver.tap(manualKcFormFinder);
      await driver.enterText("0.7");

      await driver.tap(kcFormButtonFinder);
    });

    test("result page test", () async{
      expect(await driver.getText(find.text("Baseado no que você contou, "
          "o equipamento deve permanecer ligado por:")),
          "Baseado no que você contou, "
              "o equipamento deve permanecer ligado por:");

      await driver.tap(finalResultButtonFinder);
      expect(await driver.getText(find.text("Vamos começar?")), "Vamos começar?");
    });

  });
}