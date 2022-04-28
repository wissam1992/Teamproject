class PizzaFuerKarte {
  final String name;
  final int preisKlein;
  final int preisMittel;
  final int preisGross;
  final int schinken;
  final int salami;
  final int pilze;
  final int thunfisch;
  final int zwiebel;
  final int pepperoni;
  final int kaese;
  final String beschreibung;
  final String imgPath;

  PizzaFuerKarte([
    this.name,
    this.preisKlein,
    this.preisMittel,
    this.preisGross,
    this.schinken,
    this.salami,
    this.pilze,
    this.thunfisch,
    this.zwiebel,
    this.pepperoni,
    this.kaese,
    this.beschreibung,
    this.imgPath,
  ]);

  @override
  String toString() {
    return "name:" +
        name +
        " pK-pG:" +
        preisKlein.toString() +
        "-" +
        preisGross.toString() +
        " Schinken:" +
        schinken.toString() +
        " Salami:" +
        salami.toString() +
        " Pilze" +
        pilze.toString() +
        " tunfisch:" +
        thunfisch.toString() +
        " zwiebel:" +
        zwiebel.toString() +
        " Pepperoni:" +
        pepperoni.toString() +
        " Käse:" +
        kaese.toString() +
        " beschreibung:" +
        beschreibung;
  }
}
