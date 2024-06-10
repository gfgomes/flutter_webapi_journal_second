import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'models/journal.dart';
import 'screens/add_journal_screen/add_journal_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLogged = await verifyToken();

  runApp(MyApp(
    isLogged: isLogged,
  ));

  // print(UriHelper.getBaseURL());
  // print(UriHelper.getResourceURL(resource: ""));
  // print(UriHelper.getUri(""));
  // print(UriHelper.getUri("login"));
  // print(UriHelper.getUri("home"));
  // print(UriHelper.getUriWithId("edit", "1"));
  // print(UriHelper.getUriWithParams("home", {"page": "1"}));
  // print(UriHelper.getUriWithIdAndParams("edit", "1", {"page": "1"}));
}

Future<bool> verifyToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.clear();
  String? token = prefs.getString('accessToken');
  print("SharedPreferences token: $token");
  if (token != null) {
    return true;
  }

  return false;
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  MyApp({Key? key, required this.isLogged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        //textTheme: GoogleFonts.bitterTextTheme(),
      ),
      initialRoute: (isLogged) ? "home" : "login",
      routes: {
        "home": (context) => const HomeScreen(),
        "login": (context) => LoginScreen(),
      },
      //Responsavel por lidar com as rotas e extrair os argumentos para passar nos construtuores das respectivas telas
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == "add-journal") {
          Map<String, dynamic> map =
              routeSettings.arguments as Map<String, dynamic>;

          final Journal journal = map["journal"] as Journal;

          print("onGenerateRoute:$journal");

          final bool isEditing = map["is_editing"];

          return MaterialPageRoute(
            builder: (context) {
              return AddJournalScreen(
                paramJournal: journal,
                isEditing: isEditing,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
