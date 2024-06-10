import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/journal.dart';
import '../../services/journal_service.dart';
import 'widgets/home_screen_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();
  final JournalService _journalService = JournalService();

  int? userId;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
            onPressed: () {
              refresh();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      drawer: ListView(
        children: [
          ListTile(
            onTap: () {
              logout();
            },
            title: const Text("Sair"),
            leading: const Icon(Icons.logout),
          )
        ],
      ),
      body: (userId != null)
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                // Cria uma lista de Cards vazios e insere na home_screen com o widget JournalCard
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
                refreshFunction: refresh,
                userId: userId!,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

// Atualiza a base de dados e a lista na home_screen
  void refresh() async {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString("accessToken");
      String? email = prefs.getString("email");
      int? userIdPref = prefs.getInt("id");

      if (token != null && email != null && userIdPref != null) {
        setState(() {
          userId = userIdPref;
        });

        _journalService
            .getAll(id: userIdPref.toString(), token: token)
            .then((List<Journal> listJournal) {
          setState(() {
            database = {};
            for (Journal journal in listJournal) {
              database[journal.id] = journal;
            }

            if (_listScrollController.hasClients) {
              final double position =
                  _listScrollController.position.maxScrollExtent;
              _listScrollController.jumpTo(position);
            }
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, "login");
      }
    });
  }

  void logout() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      Navigator.pushReplacementNamed(context, "login");
    });
  }
}
