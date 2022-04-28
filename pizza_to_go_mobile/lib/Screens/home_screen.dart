import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pizza_to_go_mobile/Screens/custom_pizza_screen.dart';
import 'package:pizza_to_go_mobile/Screens/pizzakarte.dart';
import 'package:pizza_to_go_mobile/Screens/profil_screen.dart';
import 'package:pizza_to_go_mobile/Widgets/Constants.dart';
import 'package:pizza_to_go_mobile/Screens/Warenkorb.dart';
import 'package:pizza_to_go_mobile/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pizza_to_go_mobile/Model/User.dart';
import 'custom_pizza_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homeScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//Startseite

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // max. Höhe und breite des Endgerätes abhängig im Context
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Container(
      // Screen Layout
      // Background Image
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/whiteTable.jpg"),
        fit: BoxFit.fill,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // Appbar mit Navigation
        appBar: AppBar(
          title: Text(
            "Pizza to Go",
            style: TextStyle(
              color: Colors.black45,
            ),
          ),
          elevation: 10,
          shadowColor: Colors.black54,
          centerTitle: true,
          backgroundColor: Colors.grey.withOpacity(0.5),
          /*
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: (choice) => choiceAction(choice, context),
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choices) {
                    return PopupMenuItem<String>(
                      value: choices,
                      child: Text(choices),
                    );
                  }).toList();
                }),
          ],

           */
        ),

        // Body der Startseite
        body: Column(
          children: [
            Container(
              height: 250,
              margin: EdgeInsets.only(top: 5, bottom: 5),

              // Slider mit Images, werden später aus DB genommen
              child: CarouselSlider.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int itemIndex) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Mozzarella.jpg"),
                        fit: BoxFit.fill),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
              ),
            ),

            // 4 Buttons zur Navigations - Buttons aus /Widgets
            Container(
              margin: EdgeInsets.all(9),
              child: Column(
                children: [
                  Row(
                    children: [
                      //////////////////////////////////////////////zu Custompizza
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(7),
                            height: 170,
                            width: (_width - 46) / 2,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 170,
                            width: (_width - 46) / 2,
                            child: Icon(Icons.local_pizza_outlined, size: 150),
                          ),
                          Container(
                            height: 170,
                            width: (_width - 46) / 2,
                            child: GestureDetector(onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomPizza(),
                                  ));
                            }),
                          ),
                        ],
                      ),

                      //////////////////////////////////////////////zu PizzaKarte
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(7),
                            height: 170,
                            width: (_width - 46) / 2,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 170,
                            width: (_width - 46) / 2,
                            child: Icon(Icons.menu_book_outlined, size: 150),
                          ),
                          Container(
                            height: 170,
                            width: (_width - 46) / 2,
                            child: GestureDetector(onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Pizzakarte(),
                                  ));
                            }),
                          ),
                        ],
                      ),

                      //MyContainer(),
                      //MyContainer()
                    ],
                  ),
                  Row(
                    children: [
                      //////////////////////////////////////////////zu Warenkorb
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(7),
                            height: 170,
                            width: (_width - 46) / 2,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 170,
                            width: (_width - 46) / 2,
                            child:
                                Icon(Icons.shopping_cart_outlined, size: 150),
                          ),
                          Container(
                            height: 170,
                            width: (_width - 46) / 2,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Warenkorb(),
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),

                      //////////////////////////////////////////////zu Profil
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(7),
                            height: 170,
                            width: (_width - 46) / 2,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 170,
                            width: (_width - 46) / 2,
                            child: Icon(Icons.account_circle, size: 150),
                          ),
                          Container(
                            height: 170,
                            width: (_width - 46) / 2,
                            child: GestureDetector(
                              onTap: () {
                                _profilOderLogin();

                                /*
                            Navigator.pushNamed(
                                context, UserProfilScreen.routeName,
                                arguments: jetzt);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfilScreen( )),
                            );
                             */
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //ProfilKnopf-methode
  void _profilOderLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("Username" + prefs.getString("username").toString());
    if (prefs.getString("username") != null) {
      User T = new User(
          prefs.getString("username"),
          prefs.getString("firstname"),
          prefs.getString("lastname"),
          prefs.getString("email"),
          prefs.getString("plz"),
          prefs.getString("city"),
          prefs.getString("street"),
          prefs.getString("houseNumber"));
      Navigator.pushNamed(context, UserProfilScreen.routeName, arguments: T);
    } else {
      Navigator.pushNamed(context, LoginUser.routeName);
    }
  }

  // Navigation der Appbar
  Future<void> choiceAction(String choice, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (choice == Constants.profil) {
      User T = new User(
          prefs.getString("username"),
          prefs.getString("firstname"),
          prefs.getString("lastname"),
          prefs.getString("email"),
          prefs.getString("plz"),
          prefs.getString("city"),
          prefs.getString("street"),
          prefs.getString("houseNumber"));

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (
          context,
        ) =>
                UserProfilScreen()),
      );
    }
    if (choice == Constants.logout) {
      print("Vor Löschen: ");
      print(prefs.getString("username").toString());
      print(prefs.getString('username').toString());
      prefs.clear();
      print("nach Löschen: ");
      print(prefs.getString('username').toString());
    }
  }
}
