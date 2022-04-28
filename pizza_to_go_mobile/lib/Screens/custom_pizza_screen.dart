import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_to_go_mobile/Database/WarenkorbData.dart' as warenkorb;
import 'package:pizza_to_go_mobile/Model/Pizza.dart';
import 'package:pizza_to_go_mobile/Model/PizzaMitAnzahl.dart';
import 'package:pizza_to_go_mobile/Screens/Warenkorb.dart';

class CustomPizza extends StatefulWidget {
  static const routeName = "/customPizza";

  @override
  _CustomPizzaState createState() => _CustomPizzaState();
}

class _CustomPizzaState extends State<CustomPizza> {
  TextStyle belagStyle =
      TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.7));
  TextStyle belagMengeStyle =
      TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7));
  Color _linien = Color.fromARGB(255, 230, 230, 230);
  double _belagSize = 60;
  String dropdownValueGroesse;
  Map<String, dynamic> preise = {
    'Klein': "4,00€",
    'Mittel': "5,00€",
    'Groß': "6,00€"
  };
  ValueNotifier valueNotifierGroesse = ValueNotifier("Mittel");
  ValueNotifier valueNotifierBelagBasisPreis = ValueNotifier(50);
  //Salami
  ValueNotifier valueNotifierSalamiAnzahl = ValueNotifier(0);
  int dropdownValueSalamiSetState;
  ValueNotifier valueNotifierSalamiPreisTotal = ValueNotifier(0);
  //Schinken
  ValueNotifier valueNotifierSchinkenAnzahl = ValueNotifier(0);
  int dropdownValueSchinkenSetState;
  ValueNotifier valueNotifierSchinkenPreisTotal = ValueNotifier(0);
  //Pilze
  ValueNotifier valueNotifierPilzeAnzahl = ValueNotifier(0);
  int dropdownValuePilzeSetState;
  ValueNotifier valueNotifierPilzePreisTotal = ValueNotifier(0);
  //Tunfisch
  ValueNotifier valueNotifierTunfischAnzahl = ValueNotifier(0);
  int dropdownValueTunfischSetState;
  ValueNotifier valueNotifierTunfischPreisTotal = ValueNotifier(0);
  //Zwiebeln
  ValueNotifier valueNotifierZwiebelnAnzahl = ValueNotifier(0);
  int dropdownValueZwiebelnSetState;
  ValueNotifier valueNotifierZwiebelnPreisTotal = ValueNotifier(0);
  //Pepperoni
  ValueNotifier valueNotifierPepperoniAnzahl = ValueNotifier(0);
  int dropdownValuePepperoniSetState;
  ValueNotifier valueNotifierPepperoniPreisTotal = ValueNotifier(0);
  //ExtraKaese
  ValueNotifier valueNotifierExtraKaeseAnzahl = ValueNotifier(0);
  int dropdownValueExtraKaeseSetState;
  ValueNotifier valueNotifierExtraKaesePreisTotal = ValueNotifier(0);
  //Anzahl Pizzen
  ValueNotifier valueNotifierPizzenAnzahl = ValueNotifier(1);
  int dropdownValuePizzenSetState;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.red[200].withOpacity(1)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black54,
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            "Eigene Pizza erstellen",
            style: TextStyle(
              color: Colors.black,
              fontSize: 27,
            ),
          ),
          elevation: 10,
          shadowColor: Colors.black54,
          centerTitle: true,
          backgroundColor: Colors.white.withOpacity(0.5),
        ),
        body: Container(
          child: Column(children: [
            Container(
              height: 20,
            ),
            Text(
              "Alle Pizzen werden mit Tomatensoße und Käse belegt",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            Container(height: 20),
            ///////////////////////////////////////// DropdownButton für die Größe
            DropdownButton<String>(
              value: valueNotifierGroesse.value,
              icon: Icon(Icons.arrow_downward),
              iconSize: 35,
              elevation: 16,
              itemHeight: 50,
              style: TextStyle(color: Colors.black, fontSize: 20),
              underline: Container(
                height: 2,
                color: _linien,
              ),
              onChanged: (String newValue) {
                _belagBasisPreisAnGroesseAnpassen(newValue);
                valueNotifierGroesse.value = newValue;
                setState(() {
                  dropdownValueGroesse = newValue;
                });
              },
              items: <String>['Klein', 'Mittel', 'Groß']
                  .map<DropdownMenuItem<String>>((String valueGroesseDropdown) {
                return DropdownMenuItem<String>(
                  value: valueGroesseDropdown,
                  child: Container(
                    height: 30,
                    width: _screenWidth - 50,
                    child: Row(
                      children: [
                        Text(valueGroesseDropdown, textAlign: TextAlign.left),
                        Spacer(),
                        Text(preise[valueGroesseDropdown],
                            textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Container(height: 10),
            Text(
              "Maximal 8 extra Beläge pro Pizza",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            Container(height: 10),
            /////////////////////////////////////////////Ab hier Reihen der Beläge
            //
            /////////////////////////////////////////////////////////////////Salami
            Container(
              width: _screenWidth - 20,
              child: Row(
                children: [
                  //Bild:
                  Container(
                    height: _belagSize,
                    width: _belagSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(width: 1),
                        image: DecorationImage(
                          image: AssetImage("assets/salami.webp"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  //Belag:
                  Text(" Salami", style: belagStyle),
                  //Belagmengenangabe
                  Column(
                    children: [
                      Container(
                          height:
                              5), //damit Belag und Mengenangabe auf der selben Höhe sind
                      Text(_salamiMenge(valueNotifierBelagBasisPreis.value),
                          style: belagMengeStyle),
                    ],
                  ),

                  Spacer(),
                  //Dropdown Menge:
                  DropdownButton<int>(
                    value: valueNotifierSalamiAnzahl.value,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: belagStyle,
                    underline: Container(
                      height: 2,
                      color: _linien,
                    ),
                    onChanged: (int newValue) {
                      valueNotifierSalamiAnzahl.value = newValue;
                      valueNotifierSalamiPreisTotal.value =
                          newValue * valueNotifierBelagBasisPreis.value;
                      setState(() {
                        dropdownValueSalamiSetState = newValue;
                      });
                    },
                    items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8]
                        .map<DropdownMenuItem<int>>((int valueHier) {
                      return DropdownMenuItem<int>(
                        value: valueHier,
                        child: Text(
                          valueHier.toString(),
                          style: belagStyle,
                        ),
                      );
                    }).toList(),
                  ),
                  Container(width: 20),
                  //Preis des belags
                  Text(
                    "+" + _intToPreis(valueNotifierSalamiPreisTotal.value),
                    style: belagStyle,
                  ),
                  Container(width: 30),
                ],
              ),
            ),
            Container(height: 2),
            //////////////////////////////////////////////////////////////Schinken
            Container(
              width: _screenWidth - 20,
              child: Row(
                children: [
                  Container(
                    height: _belagSize,
                    width: _belagSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(width: 1),
                        image: DecorationImage(
                          image: AssetImage("assets/ham.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text(" Schinken", style: belagStyle),
                  Column(children: [
                    Container(height: 5),
                    Text(_schinkenMenge(valueNotifierBelagBasisPreis.value),
                        style: belagMengeStyle),
                  ]),
                  Spacer(),
                  DropdownButton<int>(
                    value: valueNotifierSchinkenAnzahl.value,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: belagStyle,
                    underline: Container(
                      height: 2,
                      color: _linien,
                    ),
                    onChanged: (int newValue) {
                      valueNotifierSchinkenAnzahl.value = newValue;
                      valueNotifierSchinkenPreisTotal.value =
                          newValue * valueNotifierBelagBasisPreis.value;
                      setState(() {
                        dropdownValueSchinkenSetState = newValue;
                      });
                    },
                    items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8]
                        .map<DropdownMenuItem<int>>((int valueHier) {
                      return DropdownMenuItem<int>(
                        value: valueHier,
                        child: Text(
                          valueHier.toString(),
                          style: belagStyle,
                        ),
                      );
                    }).toList(),
                  ),
                  Container(width: 20),
                  Text(
                    "+" + _intToPreis(valueNotifierSchinkenPreisTotal.value),
                    style: belagStyle,
                  ),
                  Container(width: 30),
                ],
              ),
            ),
            Container(height: 2),
            /////////////////////////////////////////////////////////////////Pilze
            Container(
              width: _screenWidth - 20,
              child: Row(
                children: [
                  Container(
                    height: _belagSize,
                    width: _belagSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(width: 1),
                        image: DecorationImage(
                          image: AssetImage("assets/pilz.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text(" Pilze", style: belagStyle),
                  Column(children: [
                    Container(height: 5),
                    Text(_pilzeMenge(valueNotifierBelagBasisPreis.value),
                        style: belagMengeStyle),
                  ]),
                  Spacer(),
                  DropdownButton<int>(
                    value: valueNotifierPilzeAnzahl.value,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: belagStyle,
                    underline: Container(
                      height: 2,
                      color: _linien,
                    ),
                    onChanged: (int newValue) {
                      valueNotifierPilzeAnzahl.value = newValue;
                      valueNotifierPilzePreisTotal.value =
                          newValue * valueNotifierBelagBasisPreis.value;
                      setState(() {
                        dropdownValuePilzeSetState = newValue;
                      });
                    },
                    items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8]
                        .map<DropdownMenuItem<int>>((int valueHier) {
                      return DropdownMenuItem<int>(
                        value: valueHier,
                        child: Text(
                          valueHier.toString(),
                          style: belagStyle,
                        ),
                      );
                    }).toList(),
                  ),
                  Container(width: 20),
                  Text(
                    "+" + _intToPreis(valueNotifierPilzePreisTotal.value),
                    style: belagStyle,
                  ),
                  Container(width: 30),
                ],
              ),
            ),
            Container(height: 2),
            ////////////////////////////////////////////////////////////////Tuhnfisch
            Container(
              width: _screenWidth - 20,
              child: Row(
                children: [
                  Container(
                    height: _belagSize,
                    width: _belagSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(width: 1),
                        image: DecorationImage(
                          image: AssetImage("assets/tuna.webp"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text(" Thunfisch", style: belagStyle),
                  Column(children: [
                    Container(height: 5),
                    Text(_thunfischMenge(valueNotifierBelagBasisPreis.value),
                        style: belagMengeStyle),
                  ]),
                  Spacer(),
                  DropdownButton<int>(
                    value: valueNotifierTunfischAnzahl.value,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: belagStyle,
                    underline: Container(
                      height: 2,
                      color: _linien,
                    ),
                    onChanged: (int newValue) {
                      valueNotifierTunfischAnzahl.value = newValue;
                      valueNotifierTunfischPreisTotal.value =
                          newValue * valueNotifierBelagBasisPreis.value;
                      setState(() {
                        dropdownValueTunfischSetState = newValue;
                      });
                    },
                    items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8]
                        .map<DropdownMenuItem<int>>((int valueHier) {
                      return DropdownMenuItem<int>(
                        value: valueHier,
                        child: Text(
                          valueHier.toString(),
                          style: belagStyle,
                        ),
                      );
                    }).toList(),
                  ),
                  Container(width: 20),
                  Text(
                    "+" + _intToPreis(valueNotifierTunfischPreisTotal.value),
                    style: belagStyle,
                  ),
                  Container(width: 30),
                ],
              ),
            ),
            Container(height: 2),
            ////////////////////////////////////////////////////////////////Zwiebeln
            Container(
              width: _screenWidth - 20,
              child: Row(
                children: [
                  Container(
                    height: _belagSize,
                    width: _belagSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(width: 1),
                        image: DecorationImage(
                          image: AssetImage("assets/onion.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text(" Zwiebeln", style: belagStyle),
                  Column(children: [
                    Container(height: 5),
                    Text(_zwiebelMenge(valueNotifierBelagBasisPreis.value),
                        style: belagMengeStyle),
                  ]),
                  Spacer(),
                  DropdownButton<int>(
                    value: valueNotifierZwiebelnAnzahl.value,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: belagStyle,
                    underline: Container(
                      height: 2,
                      color: _linien,
                    ),
                    onChanged: (int newValue) {
                      valueNotifierZwiebelnAnzahl.value = newValue;
                      valueNotifierZwiebelnPreisTotal.value =
                          newValue * valueNotifierBelagBasisPreis.value;
                      setState(() {
                        dropdownValueZwiebelnSetState = newValue;
                      });
                    },
                    items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8]
                        .map<DropdownMenuItem<int>>((int valueHier) {
                      return DropdownMenuItem<int>(
                        value: valueHier,
                        child: Text(
                          valueHier.toString(),
                          style: belagStyle,
                        ),
                      );
                    }).toList(),
                  ),
                  Container(width: 20),
                  Text(
                    "+" + _intToPreis(valueNotifierZwiebelnPreisTotal.value),
                    style: belagStyle,
                  ),
                  Container(width: 30),
                ],
              ),
            ),
            Container(height: 2),
            ////////////////////////////////////////////////////////////////Pepperoni
            Container(
              width: _screenWidth - 20,
              child: Row(
                children: [
                  Container(
                    height: _belagSize,
                    width: _belagSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(width: 1),
                        image: DecorationImage(
                          image: AssetImage("assets/peperoni.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text(" Pepperoni", style: belagStyle),
                  Column(children: [
                    Container(height: 5),
                    Text(_pepperoniMenge(valueNotifierBelagBasisPreis.value),
                        style: belagMengeStyle),
                  ]),
                  Spacer(),
                  DropdownButton<int>(
                    value: valueNotifierPepperoniAnzahl.value,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: belagStyle,
                    underline: Container(
                      height: 2,
                      color: _linien,
                    ),
                    onChanged: (int newValue) {
                      valueNotifierPepperoniAnzahl.value = newValue;
                      valueNotifierPepperoniPreisTotal.value =
                          newValue * valueNotifierBelagBasisPreis.value;
                      setState(() {
                        dropdownValuePepperoniSetState = newValue;
                      });
                    },
                    items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8]
                        .map<DropdownMenuItem<int>>((int valueHier) {
                      return DropdownMenuItem<int>(
                        value: valueHier,
                        child: Text(
                          valueHier.toString(),
                          style: belagStyle,
                        ),
                      );
                    }).toList(),
                  ),
                  Container(width: 20),
                  Text(
                    "+" + _intToPreis(valueNotifierPepperoniPreisTotal.value),
                    style: belagStyle,
                  ),
                  Container(width: 30),
                ],
              ),
            ),
            Container(height: 2),
            ////////////////////////////////////////////////////////////////ExtraKaese
            Container(
              width: _screenWidth - 20,
              child: Row(
                children: [
                  Container(
                    height: _belagSize,
                    width: _belagSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(width: 1),
                        image: DecorationImage(
                          image: AssetImage("assets/cheese.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text(" Extra Käse", style: belagStyle),
                  Column(children: [
                    Container(height: 5),
                    Text(_extraKaeseMenge(valueNotifierBelagBasisPreis.value),
                        style: belagMengeStyle),
                  ]),
                  Spacer(),
                  DropdownButton<int>(
                    value: valueNotifierExtraKaeseAnzahl.value,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: belagStyle,
                    underline: Container(
                      height: 2,
                      color: _linien,
                    ),
                    onChanged: (int newValue) {
                      valueNotifierExtraKaeseAnzahl.value = newValue;
                      valueNotifierExtraKaesePreisTotal.value =
                          newValue * valueNotifierBelagBasisPreis.value;
                      setState(() {
                        dropdownValueExtraKaeseSetState = newValue;
                      });
                    },
                    items: <int>[0, 1, 2, 3, 4, 5, 6, 7]
                        .map<DropdownMenuItem<int>>((int valueHier) {
                      return DropdownMenuItem<int>(
                        value: valueHier,
                        child: Text(
                          valueHier.toString(),
                          style: belagStyle,
                        ),
                      );
                    }).toList(),
                  ),
                  Container(width: 20),
                  Text(
                    "+" + _intToPreis(valueNotifierExtraKaesePreisTotal.value),
                    style: belagStyle,
                  ),
                  Container(width: 30),
                ],
              ),
            ),
            ////////////////////////////////////////////////////////////Gesammpreis
            Container(height: 10),
            Container(
              height: 3,
              width: _screenWidth + 10,
              color: _linien,
            ),
            Container(
              height: 40,
              child: Row(
                children: [
                  Container(width: 20),
                  //Anzahl der Pizzen
                  DropdownButton<int>(
                    value: valueNotifierPizzenAnzahl.value,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: belagStyle,
                    underline: Container(
                      height: 2,
                      color: _linien,
                    ),
                    onChanged: (int newValue) {
                      valueNotifierPizzenAnzahl.value = newValue;
                      setState(() {
                        dropdownValuePizzenSetState = newValue;
                      });
                    },
                    items: <int>[1, 2, 3, 4, 5, 6, 7, 8]
                        .map<DropdownMenuItem<int>>((int valueHier) {
                      return DropdownMenuItem<int>(
                        value: valueHier,
                        child: Text(
                          valueHier.toString(),
                          style: TextStyle(fontSize: 25),
                        ),
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  Text(
                    "Gesammtperis:",
                    style: TextStyle(fontSize: 25),
                  ),
                  Spacer(),
                  Text(
                    _intToPreis(_Gesammtpreisberechnen()),
                    style: TextStyle(fontSize: 25),
                  ),
                  Container(width: 30),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () => _toWarenkorb(),
              textColor: Colors.black,
              color: Colors.white.withOpacity(0.8), //_linien,
              child: Text("In den Warenkorb", style: TextStyle(fontSize: 30)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
            )
          ]),
        ),
      ),
    );
  }

  /////////////////Vielleicht brauche ich das noch...
  /*
        ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (context, value, child) {
            return Text("value = " + value.toString());
          },
        ),
        */

  ///////////////////////////////////////////////////////////////Ab hier:Metoden

  int _Gesammtpreisberechnen() {
    return valueNotifierPizzenAnzahl.value *
        (valueNotifierSalamiPreisTotal.value +
            valueNotifierSchinkenPreisTotal.value +
            valueNotifierPilzePreisTotal.value +
            valueNotifierTunfischPreisTotal.value +
            valueNotifierZwiebelnPreisTotal.value +
            valueNotifierPepperoniPreisTotal.value +
            valueNotifierExtraKaesePreisTotal.value +
            //Das ist der Basispreis der Pizza:
            valueNotifierBelagBasisPreis.value * 10);
  }

  void _toWarenkorb() {
    if (valueNotifierSalamiAnzahl.value +
            valueNotifierSchinkenAnzahl.value +
            valueNotifierPilzeAnzahl.value +
            valueNotifierTunfischAnzahl.value +
            valueNotifierZwiebelnAnzahl.value +
            valueNotifierPepperoniAnzahl.value +
            valueNotifierExtraKaeseAnzahl.value >
        8) {
      Flushbar(
        title: "Fehler",
        message: "Zu viele Beläge ",
        duration: Duration(seconds: 5),
      ).show(context);
    } else {
      print("Länge vor:" + warenkorb.WarenkorbListe.length.toString());

      Pizza sdf = new Pizza(
          "Eigenkreation",
          _GroesseZuInt(),
          _Gesammtpreisberechnen(),
          valueNotifierSchinkenAnzahl.value,
          valueNotifierSalamiAnzahl.value,
          valueNotifierPilzeAnzahl.value,
          valueNotifierTunfischAnzahl.value,
          valueNotifierZwiebelnAnzahl.value,
          valueNotifierPepperoniAnzahl.value,
          valueNotifierExtraKaeseAnzahl.value + 1);

      warenkorb.WarenkorbListe.add(
          new PizzaMitAnzahl(sdf, valueNotifierPizzenAnzahl.value));

      print("Länge nach:" + warenkorb.WarenkorbListe.length.toString());

      Navigator.pop(context);
      Navigator.pushNamed(context, Warenkorb.routeName);
    }
  }

  //Übersetzen String größe zu int BelagBasisPreis
  void _belagBasisPreisAnGroesseAnpassen(String grosse) {
    if (grosse.contains("Groß")) {
      valueNotifierBelagBasisPreis.value = 60;
      _totalpreisBelaegeNeu(60);
    }
    if (grosse.contains("Mittel")) {
      valueNotifierBelagBasisPreis.value = 50;
      _totalpreisBelaegeNeu(50);
    }
    if (grosse.contains("Klein")) {
      valueNotifierBelagBasisPreis.value = 40;
      _totalpreisBelaegeNeu(40);
    }
  }

  int _GroesseZuInt() {
    String grosse = valueNotifierGroesse.value;
    if (grosse.contains("Groß")) {
      return 3;
    }
    if (grosse.contains("Mittel")) {
      return 2;
    }
    if (grosse.contains("Klein")) {
      return 1;
    }
  }

  //Alle TotalPreisBelag werden mit neuem Basispreis neu berechnet
  void _totalpreisBelaegeNeu(int basisPreis) {
    valueNotifierSalamiPreisTotal.value =
        basisPreis * valueNotifierSalamiAnzahl.value;
    valueNotifierSchinkenPreisTotal.value =
        basisPreis * valueNotifierSchinkenAnzahl.value;
    valueNotifierPilzePreisTotal.value =
        basisPreis * valueNotifierPilzeAnzahl.value;
    valueNotifierPepperoniPreisTotal.value =
        basisPreis * valueNotifierPepperoniAnzahl.value;
    valueNotifierTunfischPreisTotal.value =
        basisPreis * valueNotifierTunfischAnzahl.value;
    valueNotifierZwiebelnPreisTotal.value =
        basisPreis * valueNotifierZwiebelnAnzahl.value;
    valueNotifierExtraKaesePreisTotal.value =
        basisPreis * valueNotifierExtraKaeseAnzahl.value;
  }

  //TotalPreisBelag wird schön ausgegeben
  String _intToPreis(int rein) {
    return ((rein ~/ 100).toString() +
        "," +
        ((rein % 100) ~/ 10).toString() +
        ((rein % 100) % 10).toString() +
        "€");
  }

  //Berechnung Belag mengen:

  String _salamiMenge(int groesse) {
    switch (groesse) {
      case 40:
        return " je 120 g";
      case 50:
        return " je 150 g";
      case 60:
        return " je 210 g";
    }
    return "";
  }

  String _schinkenMenge(int groesse) {
    switch (groesse) {
      case 40:
        return " je 120 g";
      case 50:
        return " je 150 g";
      case 60:
        return " je 210 g";
    }
    return "";
  }

  String _pilzeMenge(int groesse) {
    switch (groesse) {
      case 40:
        return " je 2 St.";
      case 50:
        return " je 3 St.";
      case 60:
        return " je 4 St.";
    }
    return "";
  }

  String _thunfischMenge(int groesse) {
    switch (groesse) {
      case 40:
        return " je 120 g";
      case 50:
        return " je 150 g";
      case 60:
        return " je 210 g";
    }
    return "";
  }

  String _zwiebelMenge(int groesse) {
    switch (groesse) {
      case 40:
        return " je 65 g";
      case 50:
        return " je 80 g";
      case 60:
        return " je 110 g";
    }
    return "";
  }

  String _pepperoniMenge(int groesse) {
    switch (groesse) {
      case 40:
        return " je 4 St.";
      case 50:
        return " je 5 St.";
      case 60:
        return " je 7 St.";
    }
    return "";
  }

  String _extraKaeseMenge(int groesse) {
    switch (groesse) {
      case 40:
        return " je 80 g";
      case 50:
        return " je 100 g";
      case 60:
        return " je 140 g";
    }
    return "";
  }
}
