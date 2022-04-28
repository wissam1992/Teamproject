/// Flutter code sample for DropdownButton

// This sample shows a `DropdownButton` with a large arrow icon,
// purple text style, and bold purple underline, whose value is one of "One",
// "Two", "Free", or "Four".
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/material/dropdown_button.png)

import 'package:flutter/material.dart';
import 'package:pizza_to_go_mobile/Model/Pizza.dart';
import 'package:pizza_to_go_mobile/Model/PizzaFuerKarte.dart';
import 'package:pizza_to_go_mobile/Model/PizzaMitAnzahl.dart';
import 'package:pizza_to_go_mobile/Screens/Warenkorb.dart';
import 'package:pizza_to_go_mobile/Database/WarenkorbData.dart' as warenkorb;

class PizzaDetails extends StatefulWidget {
  static const routeName = "/PizzaDetails";

  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

//PizzaMitAnzahl
class _PizzaDetailsState extends State<PizzaDetails> {
  String dropdownGroesse = 'Mittel';
  int dropdownNummer = 1;
  ValueNotifier valueNotifierAnzahl = ValueNotifier(1);
  ValueNotifier valueNotifierPreisTotal = ValueNotifier(0);
  ValueNotifier valueNotifierPreisEins = ValueNotifier(0);
  bool first = true;
  int groesse = 2;
  @override
  Widget build(BuildContext context) {
    PizzaFuerKarte pizzaF = ModalRoute.of(context).settings.arguments;
    double _screenWidth = MediaQuery.of(context).size.width;
    if (first) {
      valueNotifierPreisTotal.value = pizzaF.preisMittel;
      valueNotifierPreisEins.value = pizzaF.preisMittel;
      first = false;
    }
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/whiteTable.jpg"),
        fit: BoxFit.fill,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black54,
              onPressed: () {
                Navigator.pop(context);
              }),
          elevation: 10,
          shadowColor: Colors.white70,
          centerTitle: true,
          backgroundColor: Colors.white.withOpacity(0.5),
          title: Text(
            "Pizza " + pizzaF.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 27,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(height: 5),
            Row(
              children: [
                Spacer(),
                Container(
                  ///Pizza Bild
                  width: _screenWidth - 50,
                  height: _screenWidth - 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      image: DecorationImage(
                        image: AssetImage("assets/" + pizzaF.imgPath),
                        fit: BoxFit.fill,
                      )),
                ),
                Spacer(),
              ],
            ),
            Container(height: 10),
            Row(
              children: [
                Container(width: 25),
                Flexible(
                  child:
                      Text(pizzaF.beschreibung, style: TextStyle(fontSize: 30)),
                ),
                Container(
                  width: 25,
                ),
              ],
            ),
            Container(height: 25),
            Row(
              children: [
                Container(width: 25),
                Container(
                  width: 55,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text("  Anzahl  "),
                ),
                Container(width: 23),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text("  Größe "),
                ),
              ],
            ),

            ///Hier sind die Dropdownmenüs
            Row(children: [
              Container(width: 25),

              ///Dropdown Größe
              DropdownButton<int>(
                value: dropdownNummer,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black, fontSize: 30),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (int newValue) {
                  valueNotifierAnzahl.value = newValue;

                  ///preisTotal aktualisiert valueNotifierPreisTotal
                  _preisTotal();
                  //_printb();
                  setState(() {
                    dropdownNummer = newValue;
                  });
                },
                items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              Container(width: 20),

              ///Dropdown Anzahl
              DropdownButton<String>(
                value: dropdownGroesse,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black, fontSize: 30),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String newValue) {
                  int temp =

                      ///test rechnet den String Größe in eine int um
                      ((pizzaF.preisMittel / 5) * _test(newValue)).round();
                  // print(temp);
                  valueNotifierPreisEins.value = temp;

                  ///preisTotal aktualisiert valueNotifierPreisTotal
                  _preisTotal();
                  // _printb();
                  setState(() {
                    dropdownGroesse = newValue;
                  });
                },
                items: <String>['Klein', 'Mittel', 'Groß']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Spacer(),
              Text("Preis:  ", style: TextStyle(fontSize: 30)),
              Text(
                  (valueNotifierPreisTotal.value ~/ 100).toString() +
                      "," +
                      ((valueNotifierPreisTotal.value % 100) ~/ 10).toString() +
                      ((valueNotifierPreisTotal.value % 100) % 10).toString() +
                      "€",
                  style: TextStyle(fontSize: 30)),
              Container(width: 25),
            ]),
            Spacer(),

            ///in den Warenkorb-Knopf
            Container(
              width: 400,
              height: 60,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () => _inWarenkorb(pizzaF),
                  color: Colors.red[200].withOpacity(0.8),
                  child: Center(
                    child: Text("in den Warenkorb",
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                  )),
            ),
            Container(height: 50)
          ],
        ),
      ),
    );
  }

  ///in den Warenkorb-Methode
  void _inWarenkorb(PizzaFuerKarte pizzaF) {
    warenkorb.WarenkorbListe.add(new PizzaMitAnzahl(
        new Pizza(
            pizzaF.name,
            groesse,
            valueNotifierPreisTotal.value,
            pizzaF.schinken,
            pizzaF.salami,
            pizzaF.pilze,
            pizzaF.thunfisch,
            pizzaF.zwiebel,
            pizzaF.pepperoni,
            pizzaF.kaese),
        valueNotifierAnzahl.value));

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(context, Warenkorb.routeName);
  }

  void _printb() {
    print(" valueNotifierPreisEins:" +
        valueNotifierPreisEins.value.toString() +
        "|valueNotifierAnzahl:" +
        valueNotifierAnzahl.value.toString() +
        "|Total:" +
        valueNotifierPreisTotal.value.toString());
  }

  void _preisTotal() {
    valueNotifierPreisTotal.value =
        valueNotifierAnzahl.value * valueNotifierPreisEins.value;
  }

  ///test rechnet den String Größe in eine int um
  int _test(String neu) {
    if (neu.contains("Groß")) {
      groesse = 3;
      return 6;
    }
    if (neu.contains("Mittel")) {
      groesse = 2;
      return 5;
    }
    if (neu.contains("Klein")) {
      groesse = 1;
      return 4;
    }
  }
}
