import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_to_go_mobile/Model/PizzaMitAnzahl.dart';
import 'package:pizza_to_go_mobile/Model/Pizza.dart';
import 'package:pizza_to_go_mobile/Database/WarenkorbData.dart' as warenkorb;
import 'package:pizza_to_go_mobile/Screens/Warenkorb.dart';

class WarenkorbItem extends StatelessWidget {
  final PizzaMitAnzahl pizzaF;

  const WarenkorbItem({Key key, this.pizzaF}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double radius = 8;
    //Höhe des Widgets
    const double itemHeight = 90;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: itemHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 10),

              ///Anzahl Pizza
              Container(
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      pizzaF.anzahl.toString(),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(width: 10),
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),

                  ///Name+Größe der Pizza
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          _groesseToString(pizzaF.pizza.groesse) +
                              " " +
                              _pizzaName(pizzaF.pizza.name),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Container(height: 5),

                      ///Beläge
                      Container(
                        child: Text(_pizzaBelaege(pizzaF.pizza)),
                      ),
                    ],
                  ),
                ),
              ),

              ///Preis
              Column(
                children: [
                  Spacer(),
                  Text(
                    _intToPreis(pizzaF.pizza.price),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                ],
              ),
              Container(width: 10),

              ///Löschen-Button
              Container(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.horizontal_rule),
                    color: Colors.black,
                    onPressed: () {
                      _loeschen();
                      //setState(() {});
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Warenkorb.routeName);
                    },
                  ),
                ),
              ),
              Container(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///Löschen-Methode
  void _loeschen() {
    bool suche = true;
    int index = 0;
    while (suche) {
      //gefährlich
      if (warenkorb.WarenkorbListe[index].equals(pizzaF.pizza)) {
        warenkorb.WarenkorbListe.removeAt(index);
        suche = false;
      }
      index++;
    }
  }

  ///Gibt String der Beläge zusammenfasst zurück
  String _pizzaBelaege(Pizza p) {
    var buffer = new StringBuffer();

    bool nurKaese = true;
    bool erster = true;

    if (p.schinken > 0) {
      buffer.write(p.schinken.toString() + " Schinken ");
      erster = false;
      nurKaese = false;
    }

    if (p.salami > 0) {
      if (!erster) {
        buffer.write(", ");
      }
      buffer.write(p.salami.toString() + " Salami ");
      nurKaese = false;
      erster = false;
    }
    if (p.pilze > 0) {
      if (!erster) {
        buffer.write(", ");
      }
      buffer.write(p.pilze.toString() + " Pilze ");
      nurKaese = false;
      erster = false;
    }
    if (p.thunfisch > 0) {
      if (!erster) {
        buffer.write(", ");
      }
      buffer.write(p.thunfisch.toString() + " Thunfisch ");
      nurKaese = false;
      erster = false;
    }
    if (p.zwiebel > 0) {
      if (!erster) {
        buffer.write(", ");
      }
      buffer.write(p.zwiebel.toString() + " Zwiebeln ");
      nurKaese = false;
      erster = false;
    }
    if (p.pepperoni > 0) {
      if (!erster) {
        buffer.write(", ");
      }
      buffer.write(p.pepperoni.toString() + " Pepperoni ");
      nurKaese = false;
      erster = false;
    }

    if (!nurKaese) {
      buffer.write(" und ");
    }

    buffer.write(p.kaese.toString() + " Käse");

    return (buffer.toString());
  }

  //Ist jetzt nutzlos weil Eigenkreation
  String _pizzaName(String name) {
    return name ?? "Pizza";
  }

  ///Rechnet int(Größe) zu String um
  String _groesseToString(int g) {
    switch (g) {
      case 1:
        {
          return "Kleine";
        }
      case 2:
        {
          return "Mittlere";
        }
      case 3:
        {
          return "Große";
        }
    }
    return "hi";
  }

  ///Die solltest du kennen
  String _intToPreis(int rein) {
    return ((rein ~/ 100).toString() +
        "," +
        ((rein % 100) ~/ 10).toString() +
        ((rein % 100) % 10).toString() +
        "€");
  }
}
