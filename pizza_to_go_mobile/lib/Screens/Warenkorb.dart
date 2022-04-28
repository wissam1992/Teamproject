import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pizza_to_go_mobile/Database/WarenkorbData.dart' as warenkorb;
import 'package:pizza_to_go_mobile/Model/Pizza.dart';
import 'package:pizza_to_go_mobile/Widgets/WarenkorbItem.dart';
import 'package:pizza_to_go_mobile/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Warenkorb extends StatefulWidget {
  static const String routeName = "/Warenkorb";

  @override
  _WarenkorbState createState() => _WarenkorbState();
}

class _WarenkorbState extends State<Warenkorb> {
  @override
  Widget build(BuildContext context) {
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
            },
          ),
          title: Text(
            "Warenkorb",
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
        body: Column(
          children: [
            Container(
              height: 10,
            ),

            ///Reihe für übersicht der "Spalten"
            Row(
              children: [
                Container(width: 10),
                Text("Anzahl",
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Spacer(),
                Text("Details",
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Spacer(),
                Text("Preis",
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Container(width: 70),
              ],
            ),

            ///Abstandthalter Oben
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width + 10,
              color: Colors.black,
            ),
            new Expanded(
              ///Liste der Pizzen im Warenkorb, ruft Widget "WarenkorbItem"auf
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 8, left: 4, right: 4, bottom: 72),
                itemCount: warenkorb.WarenkorbListe.length,
                itemBuilder: (context, index) => WarenkorbItem(
                  pizzaF: warenkorb.WarenkorbListe[index],
                ),
              ),
            ),
            //Spacer(),
            ///Abstandthalter Unten
            Container(
              height: 3,
              width: MediaQuery.of(context).size.width + 10,
              color: Colors.black,
            ),
            Container(height: 10),

            ///Preis
            Row(
              children: [
                Container(width: 20),
                Text("Gesammtpreis: ",
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Spacer(),
                Text(_PreisBerechen(),
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Container(width: 70),
              ],
            ),
            Container(height: 10),
            Row(
              children: [
                Spacer(),

                ///Bestell-Knopf
                Container(
                  width: 400,
                  height: 60,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () => _Bestellen(),
                      color: Colors.red[200].withOpacity(0.8),
                      child: Center(
                        child: Text("Bestellen",
                            style:
                                TextStyle(fontSize: 25, color: Colors.white)),
                      )),
                ),
                Spacer(),
              ],
            ),
            Container(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _Bestellen() async {
    //warenkorb.WarenkorbListe.removeRange(0, warenkorb.WarenkorbListe.length);

    //print("Länge: " + warenkorb.WarenkorbListe.length.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool bedA = false;
    bool bedB = false;

    ///Wenn Warenkorb leer ist
    if (warenkorb.WarenkorbListe.length < 1) {
      Flushbar(
        title: "Warenkorb leer",
        message: "fügen sie dem Warenkob eine wenigstens eine Pizza hinzu",
        duration: Duration(seconds: 3),
      ).show(context);
    } else {
      bedA = true;

      ///Wenn niemand eingeloggt ist
      if (prefs.getString('username') == null) {
        Navigator.pushNamed(context, LoginUser.routeName);
      } else {
        bedB = true;
      }
    }

    ///Ab hier Pizzabestellung
    if (bedA && bedB) {
      double gesammtPreis = 0;
      for (int i = 0; i < warenkorb.WarenkorbListe.length; i++) {
        gesammtPreis =
            gesammtPreis + warenkorb.WarenkorbListe.elementAt(i).pizza.price;
      }
      gesammtPreis = gesammtPreis / 100; //von Cent zu €

      //print("plz" + prefs.getString('plz'));
      //print("Bestelle " +warenkorb.WarenkorbListe.length.toString() +       " Pizzen für " +       gesammtPreis.toString() +       "mit |Methode" +       _PreisBerechen());

      ///header
      var buffer = new StringBuffer();
      buffer.write("{");
      //buffer.write('"username": "App",');
      buffer.write(' "username": "' + prefs.getString('username') + '",');
      buffer.write('"totalPrice":  "' + _PreisBerechen().toString() + '",');
      //buffer.write('"address": "hier",');

      buffer.write('"address":  "' +
          prefs.getString('plz') +
          " " +
          prefs.getString('city') +
          ": " +
          prefs.getString('street') +
          " " +
          prefs.getString('houseNumber') +
          '", ');
      buffer.write(' "pizzas": [ ');

      ///Pizzen Encodieren

      for (int i = 0; i < warenkorb.WarenkorbListe.length; i++) {
        Pizza temp = warenkorb.WarenkorbListe.elementAt(i).pizza;
        buffer.write("{");
        //Name
        buffer.write('"name": "');
        buffer.write(temp.name);
        buffer.write('",');
        //Preis
        buffer.write('"price": "');
        buffer.write(temp.price / 100);
        buffer.write('",');
        //Größe
        buffer.write('"size": "');
        buffer.write(temp.groesse.toString());
        buffer.write('",');
        //Beläge
        buffer.write(_belag(temp));
        buffer.write("}");
        if (i < warenkorb.WarenkorbListe.length - 1) {
          buffer.write(",");
        }
      }
      buffer.write("]}");
      //print("buffer: ");
      //print(buffer.toString());

      /*
      print("bodyDecoded:");
      final bodyDecoded = json.decode(buffer.toString());
      print(bodyDecoded);

      print("Encode");
      print(json.encode(bodyDecoded));

       */

      ///An Server schicken
      final response = await post(
          'http://192.168.0.2:9080/pizza-to-go-server/app/orders/addJson',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: buffer.toString()); //Ende post

      print("Es ist eine Antwort gekoommen mit Statuscode");
      print(response.statusCode);

      if (response.statusCode == 200) {
        //200 = okay
        warenkorb.WarenkorbListe.clear();
        Navigator.pop(context);
        Flushbar(
          title: "Ihre Pizza ist auf dem Weg ",
          message: "Vielen Dank für ihre Bestellung",
          isDismissible: true,
          duration: Duration(seconds: 7),
        ).show(context);
      } else {
        //nicht okay
        Flushbar(
          title: "Etwas ist schief gegeangen",
          message: "Errorcode" + response.statusCode.toString(),
          isDismissible: true,
          duration: Duration(seconds: 7),
        ).show(context);
      }
    }
  }

  ///Rechnet Preis aller bestellungen zusammen
  String _PreisBerechen() {
    int preis = 0;

    for (int i = 0; i < warenkorb.WarenkorbListe.length; i++) {
      preis += warenkorb.WarenkorbListe[i].pizza.price;
      //print("Preis " + i.toString() + " :" + warenkorb.WarenkorbListe[i].pizza.price.toString());
    }

    //print(preis);

    return _intToPreis(preis);
  }

  ///ToJson für Belage einer Pizza
  String _belag(Pizza p) {
    var bufferL = new StringBuffer();
    String belagPreis = _grosseZuBelagPreis(p.groesse);
    bufferL.write('"supplements": [');
    for (int j = 0; j < p.schinken; j++) {
      bufferL.write('{"name": "Schinken", ');
      bufferL.write('"price": "');
      bufferL.write(belagPreis);
      bufferL.write('"},');
    }
    for (int j = 0; j < p.salami; j++) {
      bufferL.write('{"name": "Salami", ');
      bufferL.write('"price": "');
      bufferL.write(belagPreis);
      bufferL.write('"},');
    }
    for (int j = 0; j < p.kaese; j++) {
      bufferL.write('{"name": "Käse", ');
      bufferL.write('"price": "');
      bufferL.write(belagPreis);
      bufferL.write('"},');
    }
    for (int j = 0; j < p.pepperoni; j++) {
      bufferL.write('{"name": "Pepperoni", ');
      bufferL.write('"price": "');
      bufferL.write(belagPreis);
      bufferL.write('"},');
    }
    for (int j = 0; j < p.pilze; j++) {
      bufferL.write('{"name": "Pilze", ');
      bufferL.write('"price": "');
      bufferL.write(belagPreis);
      bufferL.write('"},');
    }
    for (int j = 0; j < p.thunfisch; j++) {
      bufferL.write('{"name": "Thunfisch", ');
      bufferL.write('"price": "');
      bufferL.write(belagPreis);
      bufferL.write('"},');
    }
    for (int j = 0; j < p.zwiebel; j++) {
      bufferL.write('{"name": "Zwiebel", ');
      bufferL.write('"price": "');
      bufferL.write(belagPreis);
      bufferL.write('"},');
    }

    String temp = bufferL.toString();

    // - 1 um ein Komma zu entfernen
    return (temp.substring(0, temp.length - 1) + "]");
  }

  ///Rechnet int-Größe zu String-Belagpreis (ohne € Zeichen)
  String _grosseZuBelagPreis(int rein) {
    switch (rein) {
      case 1:
        return "0.40";
        break;
      case 2:
        return "0.50";
        break;
      case 3:
        return "0.60";
        break;
    }
  }

  ///Gibt einen Preis in Cent schön aus
  String _intToPreis(int rein) {
    return ((rein ~/ 100).toString() +
        "," +
        ((rein % 100) ~/ 10).toString() +
        ((rein % 100) % 10).toString() +
        "€");
  }
}
