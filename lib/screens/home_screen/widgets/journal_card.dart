import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_second_course/enums/enums.dart';
import 'package:flutter_webapi_second_course/helpers/logout.dart';
import 'package:flutter_webapi_second_course/screens/commom/alert_dialog.dart';
import 'package:flutter_webapi_second_course/screens/commom/confirmation_dialog.dart';
import 'package:flutter_webapi_second_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_second_course/services/journal_service.dart';
import 'package:uuid/uuid.dart';
import '../../../helpers/weekday.dart';
import '../../../models/journal.dart';

//Cada linha no list_view é um JournalCard e um journal é passado por parametro na construção do widget JournalCard
class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refreshFunction;
  final int userId;

  const JournalCard({
    Key? key,
    this.journal,
    required this.showedDate,
    required this.refreshFunction,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (journal != null) {
      //Se journal tem conteudo
      return InkWell(
        onTap: () {
          //Chama a tela de edição passando o journal como parâmetro

          print("chama journal card $journal");

          callAddJournalScreen(context, journal: journal);
        },
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(journal!.createdAt).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    removeJournal(context);
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      );
    } else {
      //Se é um novo journal
      return InkWell(
        onTap: () {
          //Chama a tela de adicionar passando um journal vazio
          callAddJournalScreen(
            context,
          );
        },
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

// Resposanvel por chamar a tela de adicionar ou editar de dentro do widget home_screen.dart e manipular o retorno
// Não seria necessáro passar o journal como parametro, pois ele é passado por parametro na construção do widget JournalCard, mas só por clareza e simplicidade está sendo deixado claro o que é o journal que é passado como parametro na construção do widget JournalCard
  callAddJournalScreen(BuildContext context, {Journal? journal}) {
    print("callAddJournalScreen $journal");

    // Cria um novo journal vazio, porém mantem a data showedDate que vem por parametro, pois e um novo journal referente a data showedDate clicada no calendario.
    Journal innerJournal = Journal(
      id: const Uuid().v1(),
      content: "",
      createdAt: showedDate,
      updatedAt: showedDate,
      userId: userId,
    );

    bool isEditng = false;

    Map<String, dynamic> map = {};

    // Se o não for nulo, significa que é uma edição de um journal existente setando is_editing como true que são passados como parametro para a tela de adicionar AddJournalScreen em um map com o journal como parâmetro e o is_editing como true
    if (journal != null) {
      innerJournal = journal;
      map['is_editing'] = true;
      isEditng = true;
    } else {
      map['is_editing'] = false;
    }
    map['journal'] = innerJournal;
    //Chama a tela de adicionar AddJournalScreen passando um map como paramentro.
    // Quem faz a extração do parâmetro é o onGenerateRoute do MaterialApp que está na main.dart, ele é responsável por chamar o widget AddJournalScreen e passar o map como parâmetro.
    Navigator.pushNamed(
      context,
      'add-journal',
      arguments: map,
    ).then((value) {
      //Depois que chama a tela de adicionar AddJournalScreen e retorna o DisposeStatus dele aqui, mostra a snackbar de acordo com o DisposeStatus retornado no AddJournalScreen

      /*Depois de mostrar o snackbar, atualiza a lista com o novo registro na tela HomeScreen usando a função refreshFunction que foi passda por parametro no construtor do widget essa função está originalmente na classe HomeScreen que foi passada por parametro no construtor do widget generateListJournalCards na classe HomeScreen sendo filha de um listview.

      O widget generateListJournalCards pode ser visto no arquivo lib/screens/home_screen/home_screen.dart, ele chama o widget JournalCard e passa como parametro o journal que foi passado por parametro no construtor do widget e o showedDate que foi passado por parametro no construtor do widgete também a função refreshFunction.

      Esse widget JournalCard é exibido na HomeScreen e chamado pelo widget generateListJournalCards, que é chamado pelo widget HomeScreen e e chamado pelo widget Scaffold.
      */

      if (value == DisposeStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: isEditng == true
                ? Text("Registro editado com sucesso.")
                : Text("Registro criado com sucesso."),
          ),
        );
      } else if (value == DisposeStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Houve uma falha ao registar."),
          ),
        );
      }
      refreshFunction();
    });
  }

// Não está sendo passado journal por parametro, pois ele é passado por parametro na construção do widget JournalCard
  removeJournal(BuildContext context) {
    JournalService service = JournalService();

    if (journal != null) {
      showConfirmationDialog(
        context,
        content:
            "Deseja realmente remover o diário de ${WeekDay(journal!.createdAt)}?",
        affirmativeOption: "Remover",
      ).then((value) {
        if (value != null) {
          if (value) {
            service.delete(journal!.id).then(
              (value) {
                if (value == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Registro excluído com sucesso."),
                    ),
                  );
                  refreshFunction();
                }
              },
            ).catchError(
              test: (error) => error is TimeoutException,
              (error) {
                showExceptionDialog(context,
                    content: "O servidor demorou muito, tente mais tarde.");
              },
            ).catchError(
              test: (error) => error is TokenNotValidException,
              (error) {
                logout(context);
              },
            ).catchError((error) {
              var innerError = error as HttpException;
              showExceptionDialog(context, content: innerError.message);
            }, test: (error) => error is HttpException);
          }
        }
      });
    }
  }
}
