import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterUser extends StatefulWidget {
  static const String routeName = "/register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterUser> {
  //Um Eingaben zu prüfen
  final TextEditingController _nameController1 = TextEditingController();
  final TextEditingController _nameController2 = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwort1Controller = TextEditingController();
  final TextEditingController _passwort2Controller = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _plzController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Um die Farbe des Schriftzugs "Benutzername" zu ändern
  ValueNotifier _valueNotifierColorUsername =
      ValueNotifier(Color.fromARGB(255, 158, 158, 158));
  //Um die Farbe des des "Registrieren!"-Knopfs zu ändern
  bool _registerBtnSucces = false;
  //"Registrieren!"-Knopf-Kontoller
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
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
          elevation: 0.0,
          backgroundColor: Colors.grey.withOpacity(0.5),
          title: Text(
            "Registrierung",
            style: TextStyle(
              fontSize: 27,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              //Feld für Username, muss Text enthalten und unique in der Datenbank sein
              Material(
                elevation: 4,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Benutzername",
                    errorStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    labelStyle: TextStyle(
                      letterSpacing: 2,
                      color: _valueNotifierColorUsername.value,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bitte einen Benutzernamen eingeben";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 10,
              ),
              //Vorname
              _NamensFeld1(nameController1: _nameController1),
              Container(
                height: 10,
              ),
              //Nachname
              _NamensFeld2(nameController2: _nameController2),
              Container(
                height: 10,
              ),
              //Email
              _EmailFeld(emailController: _emailController),
              Container(
                height: 10,
              ),
              //Passwortfeld1, muss Text enthalten
              Material(
                elevation: 4,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _passwort1Controller,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Passwort",
                    errorStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    labelStyle: TextStyle(
                      letterSpacing: 2,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Bitte geben sie ein Passwort ein';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 10,
              ),
              //Passworfeld2, muss den selben text enthalten wie Passortfeld1
              Material(
                elevation: 4,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _passwort2Controller,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Passwort wiederholen",
                    errorStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    labelStyle: TextStyle(
                      letterSpacing: 2,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Bitte ein Passwort eingeben';
                    }
                    if (value != _passwort1Controller.text)
                      return "Passwörter müssen überinstimmen!";
                    return null;
                  },
                ),
              ),
              Container(height: 20),
              //Reihe Für PLZ und Ort
              Row(
                children: [
                  Container(
                    width: 80,
                    child: _PlzFeld(plzController: _plzController),
                  ),
                  Container(width: 20),
                  Container(
                    width: (_screenWidth - 117),
                    child: _OrtsFeld(cityController: _cityController),
                  ),
                ],
              ),
              Container(height: 10),
              //Reihe für Straße udn Hausnummer
              Row(
                children: [
                  Container(
                    width: (_screenWidth - 152),
                    child: _StrassenFeld(streetController: _streetController),
                  ),
                  Container(width: 20),
                  Container(
                    width: 115,
                    child: _HausNrFeld(
                        houseNumberController: _houseNumberController),
                  ),
                ],
              ),
              Container(height: 25),
              // "Registrieren!"-Knopf
              RoundedLoadingButton(
                color: _registerBtnSucces
                    ? Colors.lightGreenAccent
                    : Color.fromARGB(255, 200, 200, 200),
                child: Text(
                  "Registrieren!",
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                controller: _btnController,
                onPressed: () => _registerSend(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Methode für "Registrieren!"-Knopf
  Future<void> _registerSend(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //Daten einlesen
      Map<String, dynamic> body = {
        'firstname': _nameController1.text,
        'lastname': _nameController2.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwort1Controller.text,
        'address': _plzController.text +
            "§" +
            _cityController.text +
            "§" +
            _streetController.text +
            "§" +
            _houseNumberController.text,
      };

      //Daten encodieren
      String encodedBody =
          body.keys.map((key) => "$key=${body[key]}").join("&");

      //print("Es wird gesendet: " + body.toString());

      ///////////////////////////////////////////////////////////////////////////////////////////
      // Hier IP-Adresse ändern
      ///////////////////////////////////////////////////////////////////////////////////////////
      final response =
          await post("http://192.168.0.2:9080/pizza-to-go-server/app/users/add",
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                //'accept': 'application/json',
              },
              body: encodedBody);

      print("Es ist eine Antwort gekoommen mit Statuscode");
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 204) {
        //Status 204 = no Content
        //Status 200 = ok

        Timer(Duration(seconds: 1), () {
          setState(() {
            _registerBtnSucces = true;
            //Knopf wird grün
          });
          _btnController.success();
          // Knopf zeigt Haken an
          Timer(Duration(seconds: 3), () {
            Navigator.pop(context);
          });
        });
      } else {
        // Wenn registrierung fehlschägt:
        Timer(Duration(seconds: 1), () {
          _btnController.reset();
          //Knopf reset
        });

        //Fehlermeldung anzeigen
        Flushbar(
          title: "Registrierung fehlgeschlagen",
          message: "Benutzername ist bereits vergeben ",
          duration: Duration(seconds: 5),
          isDismissible: true,
        ).show(context);
      }
    } else {
      //Wenn Validatoren nicht ok sind:
      _btnController.reset();
    }
  }
}

//
//Ab hier sehr viel copy+paste:
//
///////////////////////////Feld für Voranamen, muss text enthalten
class _NamensFeld1 extends StatelessWidget {
  const _NamensFeld1({
    Key key,
    @required this.nameController1,
  }) : super(key: key);

  final TextEditingController nameController1;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: nameController1,
        decoration: InputDecoration(
          labelText: "Vorname",
          errorStyle: TextStyle(
            fontSize: 15.0,
          ),
          labelStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.grey,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Bitte Vornamen eingeben";
          }
          return null;
        },
      ),
    );
  }
}

///////////////////////////Feld für Nachanamen, muss text enthalten
class _NamensFeld2 extends StatelessWidget {
  const _NamensFeld2({
    Key key,
    @required this.nameController2,
  }) : super(key: key);

  final TextEditingController nameController2;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: nameController2,
        decoration: InputDecoration(
          labelText: "Nachname",
          errorStyle: TextStyle(
            fontSize: 15.0,
          ),
          labelStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Bitte Nachnamen eingeben";
          }
          return null;
        },
      ),
    );
  }
}

///////////////////////////Feld für Email, muss text enthalten
class _EmailFeld extends StatelessWidget {
  const _EmailFeld({
    Key key,
    @required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: "E-Mail:",
          errorStyle: TextStyle(
            fontSize: 15.0,
          ),
          labelStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Bitte E-Mail eingeben";
          }
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) return "Bitte gültige Email eingeben";
          return null;
        },
      ),
    );
  }
}

///////////////////////////Feld für PLZ, muss eine Nummer zwischen 0 und 99999 enthalten
class _PlzFeld extends StatelessWidget {
  const _PlzFeld({
    Key key,
    @required this.plzController,
  }) : super(key: key);

  final TextEditingController plzController;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: plzController,
        decoration: InputDecoration(
          labelText: "PLZ",
          errorStyle: TextStyle(
            fontSize: 15.0,
          ),
          labelStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.grey,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (int.parse(value) < 0 || int.parse(value) > 99999)
            return "Ungültig";
          if (value == null || value.isEmpty) {
            return "PLZ";
          }
          return null;
        },
      ),
    );
  }
}

///////////////////////////Feld für Ort, muss text enthalten, darf kein § entahlten
class _OrtsFeld extends StatelessWidget {
  const _OrtsFeld({
    Key key,
    @required this.cityController,
  }) : super(key: key);

  final TextEditingController cityController;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: cityController,
        decoration: InputDecoration(
          labelText: "Ort",
          errorStyle: TextStyle(
            fontSize: 15.0,
          ),
          labelStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.grey,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Bitte Ort eingeben";
          }
          if (value.contains("§")) return "Ungültiges Zeichen: §";
          return null;
        },
      ),
    );
  }
}

///////////////////////////Feld für Straße, muss text enthalten, darf kein § entahlten
class _StrassenFeld extends StatelessWidget {
  const _StrassenFeld({
    Key key,
    @required this.streetController,
  }) : super(key: key);

  final TextEditingController streetController;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: streetController,
        decoration: InputDecoration(
          labelText: "Straße",
          errorStyle: TextStyle(
            fontSize: 15.0,
          ),
          labelStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.grey,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Bitte Straße eingeben";
          }
          if (value.contains("§")) {
            return "Ungültiges Zeichen: §";
          }
          return null;
        },
      ),
    );
  }
}

///////////////////////////Feld für Email, muss eine Nummer enthalten
class _HausNrFeld extends StatelessWidget {
  const _HausNrFeld({
    Key key,
    @required this.houseNumberController,
  }) : super(key: key);

  final TextEditingController houseNumberController;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: houseNumberController,
        decoration: InputDecoration(
          labelText: "Hausnr",
          errorStyle: TextStyle(
            fontSize: 15.0,
          ),
          labelStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.grey,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Hausnr!";
          }
          return null;
        },
      ),
    );
  }
}
