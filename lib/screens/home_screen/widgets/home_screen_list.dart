import '../../../models/journal.dart';
import 'journal_card.dart';

List<JournalCard> generateListJournalCards({
  required int windowPage,
  required DateTime currentDay,
  required Map<String, Journal> database,
  required Function refreshFunction,
  required int userId,
}) {
  // Cria uma lista de Cards vazios
  List<JournalCard> list = List.generate(
    windowPage + 1,
    (index) => JournalCard(
      // Cria um card vazio e insere na lista, cada card contém um dia de journal já com o evento de click no card para chamar a tela de edição de dentro do JournalCard
      userId: userId,
      refreshFunction: refreshFunction,
      showedDate: currentDay.subtract(Duration(
        days: (windowPage) - index,
      )),
    ),
  );

  //Preenche os espaços que possuem entradas no banco
  database.forEach(
    (key, value) {
      if (value.createdAt
          .isAfter(currentDay.subtract(Duration(days: windowPage)))) {
        int difference = value.createdAt
            .difference(currentDay.subtract(Duration(days: windowPage)))
            .inDays
            .abs();

        list[difference] = JournalCard(
          userId: userId,
          showedDate: list[difference].showedDate,
          journal: value,
          refreshFunction: refreshFunction,
        );
      }
    },
  );
  return list;
}
