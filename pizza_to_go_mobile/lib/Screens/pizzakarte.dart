import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_to_go_mobile/Database/pizzakarteData.dart' as pizzaData;
import 'package:pizza_to_go_mobile/Widgets/PizzakarteItem.dart';

class Pizzakarte extends StatefulWidget {
  static const String routeName = "/karte";

  @override
  _PizzakarteState createState() => _PizzakarteState();
}

class _PizzakarteState extends State<Pizzakarte> {
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
              }),
          elevation: 10,
          shadowColor: Colors.black54,
          centerTitle: true,
          backgroundColor: Colors.white.withOpacity(0.5),
          title: Text(
            "Menü",
            style: TextStyle(
              color: Colors.black,
              fontSize: 27,
            ),
          ),
        ),
        body: Center(
          ///Die Liste, ruft Widget "pizzakarteItem" für jede Pizza auf
          child: ListView.builder(
            padding:
                const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 72),
            itemCount: pizzaData.pizzaListe.length,
            itemBuilder: (context, index) => PizzakarteItem(
              pizzaF: pizzaData.pizzaListe[index],
            ),
          ),
        ),
      ),
    );
  }
}
