import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_to_go_mobile/Screens/home_screen.dart';
import 'package:pizza_to_go_mobile/Screens/register_screen.dart';
import 'package:pizza_to_go_mobile/Screens/login_screen.dart';
import 'package:pizza_to_go_mobile/Screens/custom_pizza_screen.dart';
import 'package:pizza_to_go_mobile/Screens/pizzakarte.dart';
import 'package:pizza_to_go_mobile/Screens/PizzaDetails.dart';
import 'package:pizza_to_go_mobile/Screens/Warenkorb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pizza_to_go_mobile/Screens/profil_screen.dart';
import 'package:pizza_to_go_mobile/Screens/Warenkorb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString("email");

  if (email == null) {
    print(
        "[main] email aus SharedPreferences ist null ------------------------------------------------------------------------------");
  } else {
    print("[main] email aus SharedPreferences : " +
        email +
        "---------------------------------------------------------------------------");
  }

  runApp(MyApp(email));
}

class MyApp extends StatelessWidget {
  String emailAusApp;
  MyApp(this.emailAusApp, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //    home: HomeScreen(),

        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        RegisterUser.routeName: (_) => RegisterUser(),
        LoginUser.routeName: (_) => LoginUser(),
        CustomPizza.routeName: (_) => CustomPizza(),
        Pizzakarte.routeName: (_) => Pizzakarte(),
        PizzaDetails.routeName: (_) => PizzaDetails(),
        Warenkorb.routeName: (_) => Warenkorb(),
        UserProfilScreen.routeName: (_) => UserProfilScreen(),
      },
      home: HomeScreen(),
    );
  }
}
