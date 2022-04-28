import 'package:flutter/material.dart';
import 'package:pizza_to_go_mobile/Model/PizzaFuerKarte.dart';
import 'package:flutter/cupertino.dart';
import 'package:pizza_to_go_mobile/Screens/PizzaDetails.dart';

class PizzakarteItem extends StatelessWidget {
  final PizzaFuerKarte pizzaF;

  const PizzakarteItem({Key key, this.pizzaF}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double radius = 8;
    //Höhe des Widgets
    const double itemHeight = 100;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: GestureDetector(
          onTap: () {
            print(pizzaF.toString());
            Navigator.pushNamed(context, PizzaDetails.routeName,
                arguments: pizzaF);
          },
          child: Container(
            height: itemHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Bild der Pizza
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/" + pizzaF.imgPath),
                      fit: BoxFit.fill,
                    )),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: _PizzaInfo(pizzaF2: pizzaF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///Beschreibeung und Preis (Min-Max)
class _PizzaInfo extends StatelessWidget {
  final PizzaFuerKarte pizzaF2;

  const _PizzaInfo({Key key, this.pizzaF2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Name der Pizza
          Text(
            pizzaF2.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(height: 5),
          //beschreibung der Pizza
          Text(
            pizzaF2.beschreibung,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Spacer(),
          //Preis der Pizza
          Text(
            "Von " +
                _intToPreis(pizzaF2.preisKlein) +
                " bis " +
                _intToPreis(pizzaF2.preisGross),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Container(height: 5),
        ],
      ),
    );
  }

  ///Gibt Preis in Cent in schön(String) aus
  String _intToPreis(int rein) {
    return ((rein ~/ 100).toString() +
        "," +
        ((rein % 100) ~/ 10).toString() +
        ((rein % 100) % 10).toString() +
        "€");
  }
}
