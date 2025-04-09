import '../model/journal_model.dart';
import '../view/journal_view.dart';

class JournalPresenter{
    final JournalView view;
    JournalPresenter(this.view);

    //creates a new journal entry
    void addEntry(String text){
        JournalModel entry = JournalModel(text: text, timestamp: DateTime.now());

        //logs the journal entry being added
        print('Journal Entry Saved: ${entry.text} at ${entry.timestamp}');

    }
}