import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(NotificatorApp());

var warningLevels = [Colors.green, Colors.yellow, Colors.red];

class NotificatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'F5 Notificator',
      theme: ThemeData(
        primaryColor: Colors.orange[800],
        primaryColorDark: Colors.orange[900],
        primaryColorBrightness: Brightness.light,
        accentColor: Colors.grey[400],
        accentColorBrightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HomePageScaffold();
  }
}

class HomePageScaffold extends StatefulWidget {

  @override
  _HomePageScaffoldState createState() => _HomePageScaffoldState();
}

class _HomePageScaffoldState extends State<HomePageScaffold> {

  String lastMessage = "Default message";
  Color backgroundPriorityColor = Colors.white;

  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
    //log(username + " saved as username");
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username") ?? null;
    //log(username + " is the saved username");

    return username;
  }

  showInitialUserDialog(BuildContext context) {
    log("showInitialUserDialog called!");
    TextEditingController userNameController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Introduce tu nombre de usuario"),
            TextField(
              controller: userNameController,
            ),
            MaterialButton(
              child: Text("Guardar"),
              onPressed: (){
                if(userNameController.text != null){
                  setUsername(userNameController.text.toString());
                  Navigator.of(context).pop();
                }
                else {
                  Navigator.of(context).pop("Username vacío");
                }
              },
            ),
          ],
        ),
      );
    });
  }

  Future<String> showNotificationDialog(BuildContext context){

    TextEditingController inputMessageController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Input Usuario"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: inputMessageController,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    splashColor: Colors.white,
                    onPressed: (){
                      backgroundPriorityColor = Colors.green;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.yellow,
                    splashColor: Colors.white,
                    onPressed: (){
                      backgroundPriorityColor = Colors.yellow;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    splashColor: Colors.white,
                    onPressed: (){
                      backgroundPriorityColor = Colors.red;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Enviar"),
            onPressed: (){
              if(inputMessageController.text != null){
                Navigator.of(context).pop(inputMessageController.text.toString());
              }
              else {
                Navigator.of(context).pop("Mensaje vacío");
              }
            },
          ),
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    log("executing initState usernameCheck");
    getUsername().then((savedUsername){
      if(savedUsername == null) {
        log("savedUsername is null");
        WidgetsBinding.instance
            .addPostFrameCallback((_) => showInitialUserDialog(context));
      }
      else{
        log("savedUsername is: " + savedUsername);
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundPriorityColor,
      appBar: AppBar(
        title: Text("F5 Notificator"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Último mensaje:"),
            Text(lastMessage),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: (){
              showNotificationDialog(context).then((userMessage){
                getUsername().then((String username){
                  lastMessage =  (username + ": " + userMessage);
                  setState(() {});
                });

              });
            },
            child: Center(
              child: Icon(Icons.add),
            ),
          ),
    );
  }
}

