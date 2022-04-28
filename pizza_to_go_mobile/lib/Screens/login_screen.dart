import 'dart:async';
import 'dart:convert';
import 'package:pizza_to_go_mobile/Screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flushbar/flushbar.dart';
import 'register_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginUser extends StatefulWidget {
  static const String routeName = "/login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwortController = TextEditingController();
  //Login Knopf Controller
  final RoundedLoadingButtonController _btnControllerLogin =
      new RoundedLoadingButtonController();
  //Register Knopf Controller
  final RoundedLoadingButtonController _btnControllerRegister =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    double _screenheight = MediaQuery.of(context).size.height;
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
          title: Text(
            "Login",
            style: TextStyle(
              fontSize: 27,
            ),
          ),
          elevation: 10,
          shadowColor: Colors.black54,
          backgroundColor: Colors.grey.withOpacity(0.5),
        ),
        body: Form(
          key: _formKey,
          child: ListView(padding: const EdgeInsets.all(8), children: [
            //Hier ist das Logo drin
            Container(
              height: (_screenheight / 3),
              width: (_screenheight / 3),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/logo.png"),
              )),
            ),

            //Feld für Usernamen
            _NamensFeld(nameController: nameController),
            Container(
              height: 10,
            ),

            //Feld für Passwort
            _PasswortFeld(passwortController: passwortController),
            Container(
              height: 20,
            ),

            //Login Button
            RoundedLoadingButton(
              color: Color.fromARGB(255, 200, 200, 200),
              child: Text(
                "Login!",
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
              controller: _btnControllerLogin,
              onPressed: () => _loginSend(context),
            ),
            Container(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "oder",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              height: 20,
            ),

            //Registrieren-Button
            RoundedLoadingButton(
              color: Color.fromARGB(255, 200, 200, 200),
              child: Text(
                "Registrieren",
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
              controller: _btnControllerRegister,
              onPressed: () => _goToRegister(context, _btnControllerRegister),
            ),
          ]),
        ),
      ),
    );
  }

  //geht zu Register
  void _goToRegister(
      BuildContext context, RoundedLoadingButtonController ctrl) {
    ctrl.reset();
    Navigator.pushNamed(context, RegisterUser.routeName);
  }

  //Login-Methode
  void _loginSend(BuildContext context) async {
    FocusScope.of(context).unfocus();
    //Sind Felder ausgefüllt?
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      String toBeEncoded = nameController.text + ":" + passwortController.text;

      //Encodierung
      String basicAuth2 = 'Basic ' + base64.encode(utf8.encode(toBeEncoded));
      print("Authentification:  " + basicAuth2);

      //Temorär
      String basicAuthTemp =
          'Basic ' + base64.encode(utf8.encode("user:password"));
      print("Authentification:  " + basicAuthTemp);

      //////////////////////////////////////////////////////////////////////////
      //Hier IP Adresse ändern
      //////////////////////////////////////////////////////////////////////////
      final response = await get(
        "http://192.168.0.2:9080/pizza-to-go-server/app/secured/" +
            nameController.text,
        headers: {
          //'Content-Type': 'application/json',
          'authorization': basicAuth2,
          'accept': 'application/json',
        },
      );

      print("Es ist eine Antwort gekommen mit Statuscode");
      print(response.statusCode);

      if (response.statusCode == 200) {
        //200 = ok
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("response Data: " + responseData.toString());

        var _list = responseData.values.toList();

        print("Das ist die Liste:");
        print(_list);

        //Userdaten in SharedPreferences speichern
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('address', _list.elementAt(0));
        prefs.setString('plz', _list.elementAt(0).split("Â§").elementAt(0));
        prefs.setString('city', _list.elementAt(0).split("Â§").elementAt(1));
        prefs.setString('street', _list.elementAt(0).split("Â§").elementAt(2));
        prefs.setString(
            'houseNumber', _list.elementAt(0).split("Â§").elementAt(3));
        prefs.setString('email', _list.elementAt(1));
        prefs.setString('firstname', _list.elementAt(2));
        prefs.setString('id', _list.elementAt(3).toString());
        prefs.setString('lastname', _list.elementAt(4));
        //prefs.setString('password', _list.elementAt(5));
        prefs.setString('username', _list.elementAt(_list.length - 1));

        /*
        print("prefs");
        print(prefs.getString("id"));
        print(prefs.getString("email"));
        print(prefs.getString("firstname"));
        print(prefs.getString("lastname"));
        print(prefs.getString("username"));
        print(prefs.getString("plz"));
        print(prefs.getString("city"));
        print(prefs.getString("street"));
        print(prefs.getString("houseNumber"));
         */

        _btnControllerLogin.success();
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context);
          //Navigator.pushNamed(context, HomeScreen.routeName);
        });
      } else {
        //Wenn Login nicht erfolgreich war
        _btnControllerLogin.reset();
        FocusScope.of(context).unfocus();
        Flushbar(
          isDismissible: true,
          title: "Failed Login",
          message: "Passwort oder Benutzername falsch ",
          duration: Duration(seconds: 5),
        ).show(context);
      }
    } else {
      //Wenn Validator falsch war
      _btnControllerLogin.reset();
    }
  }
}

//Username-Feld, muss text enthalten
class _NamensFeld extends StatelessWidget {
  const _NamensFeld({
    Key key,
    @required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: "Name",
          labelStyle: new TextStyle(fontSize: 35.0, color: Colors.black),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Bitte benutzernamen eingeben";
          }
          return null;
        },
      ),
    );
  }
}

//Passwort-Feld, muss Text enthalten
class _PasswortFeld extends StatelessWidget {
  const _PasswortFeld({
    Key key,
    @required this.passwortController,
  }) : super(key: key);

  final TextEditingController passwortController;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: passwortController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Passwort",
          labelStyle: new TextStyle(fontSize: 35.0, color: Colors.black),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Bitte Passwort eingeben";
          }
          return null;
        },
      ),
    );
  }
}
