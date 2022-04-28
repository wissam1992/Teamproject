import 'package:pizza_to_go_mobile/Model/Pizza.dart';

class PizzaMitAnzahl {
  final Pizza pizza;
  final int anzahl;

  PizzaMitAnzahl([this.pizza, this.anzahl]);

  bool equals(Pizza vgl) {
    if (this.pizza.price == vgl.price &&
        this.pizza.kaese == vgl.kaese &&
        this.pizza.pepperoni == vgl.pepperoni &&
        this.pizza.zwiebel == vgl.zwiebel &&
        this.pizza.thunfisch == vgl.thunfisch &&
        this.pizza.pilze == vgl.pilze &&
        this.pizza.salami == vgl.salami &&
        this.pizza.schinken == vgl.schinken &&
        this.pizza.groesse == vgl.groesse &&
        this.pizza.name == vgl.name) {
      return true;
    } else {
      return false;
    }
  }
}
