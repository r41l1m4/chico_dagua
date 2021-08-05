
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  group("Chico d'Agua app - ", () {

    final startButtonFinder = find.byValueKey('start');
    final ackLocButtonFinder = find.byValueKey('ackLocPerm');
    final posLocButtonFinder = find.byValueKey('posLocPerm');
    
    final dropdownFinder = find.byValueKey('dropdownCult');
    final dropdownItemFinder = find.byValueKey('dropItem_Tomate_text');
    final dropdownItem2Finder = find.byValueKey('dropItem_Outra_text');
    final espPlantasFinder = find.byValueKey('espPlantas');
    final outraCultFinder = find.byValueKey("outraCult");
    final cultNameEnterFinder = find.byValueKey("cultNameEnter");

    final vazGotFinder = find.byValueKey('irr_vazController');
    final espGotFinder = find.byValueKey('irr_espGotController');
    final espLinFinder = find.byValueKey('irr_espLinController');
    final irrDataButtonFinder = find.byValueKey("irrDataButton");

    FlutterDriver driver;

    setUpAll(() async{
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });
    
    test("tap start button", () async {
      await driver.tap(startButtonFinder);
    });

    test("don't grant location", () async {
      await driver.tap(ackLocButtonFinder);

      await driver.waitUntilNoTransientCallbacks(timeout: Duration(seconds: 4));
      expect(await driver.getText(find.text('ERRO!')), "ERRO!");

      await driver.tap(find.text('Okay'));
    });

    test("grant location", () async {
      await driver.tap(ackLocButtonFinder);

      await driver.waitUntilNoTransientCallbacks(timeout: Duration(seconds: 4));
    });

    test("post location granted", () async {
      expect(await driver.getText(find.text('Ótimo...')), "Ótimo...");
      await driver.tap(posLocButtonFinder);
    });

    test("input culture and plant space", () async {
      await driver.tap(dropdownFinder);

      await driver.scroll(dropdownFinder,
          0.0, -400.0, Duration(milliseconds: 500));

      await driver.waitFor(dropdownItemFinder);
      await driver.tap(dropdownItemFinder);


      await driver.tap(espPlantasFinder);
      await driver.enterText("45.0");

      expect(await driver.getText(espPlantasFinder), "45.0");

    });

    test("other cultures entry - cult name blank", () async{
      await driver.tap(dropdownFinder);
      await driver.waitFor(dropdownItem2Finder);
      await driver.tap(dropdownItem2Finder);

      expect(await driver.getText(dropdownItem2Finder), "Outra");

      await driver.tap(outraCultFinder);
      await driver.enterText("Melância");
      expect(await driver.getText(outraCultFinder), "Melância");

      await driver.tap(espPlantasFinder);
      await driver.enterText("80,0");
      expect(await driver.getText(espPlantasFinder), "80,0");

      await driver.tap(cultNameEnterFinder);

      expect(await driver.getText(find.text("Decimais com \"ponto\"!")), "Decimais com \"ponto\"!");

    });

    test("fix plant space", () async {
      await driver.tap(espPlantasFinder);
      await driver.enterText("80.0");
      expect(await driver.getText(espPlantasFinder), "80.0");

      await driver.tap(cultNameEnterFinder);

    });

    test("irrig data form test", () async {
      await driver.tap(irrDataButtonFinder);
      // expect(await driver.getText(find.text("Campo obrigatório!")), "Campo obrigatório!");
    });

    test("vazão gotejador form test", () async {
      await driver.tap(vazGotFinder);
      await driver.enterText("7,2");
      expect(await driver.getText(find.text("7,2")), "7,2");

      await driver.tap(irrDataButtonFinder);
      expect(await driver.getText(find.text("Decimais com \"ponto\"!")), "Decimais com \"ponto\"!");

      await driver.tap(vazGotFinder);
      await driver.enterText("7.2");
      expect(await driver.getText(find.text("7.2")), "7.2");
    });

    test("esp gotejador form test", () async {
      await driver.tap(espGotFinder);
      await driver.enterText("120,0");
      expect(await driver.getText(find.text("120,0")), "120,0");

      await driver.tap(irrDataButtonFinder);
      expect(await driver.getText(find.text("Decimais com \"ponto\"!")), "Decimais com \"ponto\"!");

      await driver.tap(espGotFinder);
      await driver.enterText("120");
      expect(await driver.getText(find.text("120")), "120");
    });

    test("esp linhas form test", () async {
      await driver.tap(espLinFinder);
      await driver.enterText("110,0");
      expect(await driver.getText(find.text("110,0")), "110,0");

      await driver.tap(irrDataButtonFinder);
      expect(await driver.getText(find.text("Decimais com \"ponto\"!")), "Decimais com \"ponto\"!");

      await driver.tap(espLinFinder);
      await driver.enterText("110");
      expect(await driver.getText(find.text("110")), "110");
    });


    test("flow finale", () async{
      await driver.tap(irrDataButtonFinder);
    });

  });

}