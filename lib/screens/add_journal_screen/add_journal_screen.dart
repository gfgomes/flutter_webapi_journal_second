import 'package:flutter/material.dart';
import 'package:flutter_webapi_second_course/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/weekday.dart';
import '../../models/journal.dart';
import '../../services/journal_service.dart';

class AddJournalScreen extends StatefulWidget {
  final Journal paramJournal;
  final bool isEditing;

//Esse widget é chamado pelo widget journal_card.dart, porém os parametro são extraidos e a classe instanciada no metodo onGenerateRoute na main.dart

  const AddJournalScreen({
    Key? key,
    required this.paramJournal,
    required this.isEditing,
  }) : super(key: key);

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

// Como o AddJournalScreen é um statefulWidget, o acesso as variaveis de estado pode ser feito dentro do build usando o widget state
class _AddJournalScreenState extends State<AddJournalScreen> {
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(
        " AddJournalScreen widget.journal param ${widget.paramJournal.content}");
    contentController.text = widget.paramJournal.content;
    print("id ${widget.paramJournal.id}");
    return Scaffold(
      appBar: AppBar(
        title: Text(WeekDay(widget.paramJournal.createdAt).toString()),
        actions: [
          IconButton(
            onPressed: () {
              //Quando o botão de check for pressionado, o metodo registerJournal é chamado e o Navigator.pop manda de volta para o widget que chamou o AddJournalScreen passando como parâmetro o DisposeStatus success ou error, quem chamaou o AddJournalScreen foi o journal_card.dart que estava na home_screen.dart
              registerJournal(context);
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  // O Navigator.pop manda de volta para o widget que chamou o AddJournalScreen journal_card.dart que está na home_screen.dart
  registerJournal(BuildContext context) async {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString("accessToken");

      if (token != null) {
        JournalService journalService = JournalService();

        this.widget.paramJournal.content = contentController.text;

        //TODO: remover depois widget.journal.id);
        print("id ${widget.paramJournal.id}");

        if (widget.isEditing) {
          journalService
              .edit(widget.paramJournal.id, widget.paramJournal, token)
              .then((value) {
            if (value) {
              Navigator.pop(context, DisposeStatus.success);
            } else {
              Navigator.pop(context, DisposeStatus.error);
            }
          });
        } else {
          journalService.register(widget.paramJournal, token).then((value) {
            if (value) {
              Navigator.pop(context, DisposeStatus.success);
            } else {
              Navigator.pop(context, DisposeStatus.error);
            }
          });
        }
      }
    });
  }
}
