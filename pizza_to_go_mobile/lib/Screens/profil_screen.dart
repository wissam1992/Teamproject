import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pizza_to_go_mobile/Model/User.dart';

class UserProfilScreen extends StatefulWidget {
  static const String routeName = "/userProfil";
  final User benutzer;
  UserProfilScreen({Key key, this.benutzer}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserProfilScreenState();
  }
}

// ProfilScreen
class _UserProfilScreenState extends State<UserProfilScreen> {
  @override
  /*
  void initState() {
    super.initState();
    loadData("username").then((value) => username = value);
    loadData("email").then((value) => email = value);
  }

  Future<String> loadData(String key) async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getString(key) ?? null;
    return data;
  }

  String username = "username";
  String email = "email";

   */
  Color mainColor = Colors.black54;
  Color secColor = Colors.red[200];

  // Layout der Profilseite

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    User _input = ModalRoute.of(context).settings.arguments;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/whiteTable.jpg"),
        fit: BoxFit.fill,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.red[200].withOpacity(0.8),
          // title: Text(user.userName),
          leading: IconButton(
            /*
             Column(
              children: [
                Container(
                  height: _height - 55,
                ),
                Container(
                  height: 55,
                )
              ],
            ),
             */
            icon: Icon(Icons.arrow_back),
            color: Colors.black54,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.transparent,
                  height: 450,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),

                  ///Userdetails hier drunter; Placeholder drüber
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textfield(hintText: _input.vorname),
                      textfield(hintText: _input.nachname),
                      textfield(hintText: _input.email),
                      textfield(hintText: (_input.plz + " " + _input.stadt)),
                      textfield(hintText: (_input.strasse + " " + _input.nr)),
                      Container(height: 5),
                      //textfield(hintText: 'Password'),
                      // textfield(hintText: 'Confirm password'),
                      Container(height: 55)
                    ],
                  ),
                ),
              ],
            ),

            ///Roter Halbkreis
            CustomPaint(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              painter: HeaderCurvedContainer(),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///Schrift Usernaame
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    _input.username,
                    style: TextStyle(
                      fontSize: 35,
                      letterSpacing: 1.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                ///Bild Usernaame
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  height: MediaQuery.of(context).size.width / 2 - 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/userimage.png'),
                    ),
                  ),
                )
              ],
            ),
            /*
            Padding(
              padding: EdgeInsets.only(bottom: 250, left: 184),
              child: CircleAvatar(
                backgroundColor: mainColor,

                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
            )
             */
            Column(
              children: [
                Container(height: _height - 150),

                ///Oben:Placeholder; unten Logout-Knopf
                Container(
                  height: 60,
                  width: _width - 20,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () => _logout(),
                      color: Colors.red[200].withOpacity(0.8),
                      child: Center(
                        child: Text("Logout",
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                            )),
                      )),
                ),
                Container(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pop(context);
  }
}

/// Textfeld Widget
Widget textfield({@required String hintText}) {
  return Material(
    elevation: 4,
    shadowColor: Colors.grey[200],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          letterSpacing: 2,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        fillColor: Colors.transparent,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none),
      ),
    ),
  );
}

/// Painter für den gebogenen Rahmen
class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.red[200].withOpacity(0.8);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
