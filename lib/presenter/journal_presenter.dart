import '../model/journal_model.dart';
import '../view/journal_view.dart';

class JournalPresenter{
    final List<JournalModel> entries = [];


    //creates a new journal entry
    void addEntry(String text){
        //creates a JournalModel object and adds it to the list
        JournalModel entry = JournalModel(text: text, timestamp: DateTime.now());
        entries.add(entry);

        //logs the journal entry being added, remove after testing is done
        print('Journal Entry Saved: ${entry.text} at ${entry.timestamp}');

    }

    List<JournalModel> getEntries(){
        return entries;
    }

    JournalModel getEntry(DateTime timestamp){
        for(int x = 0; x<entries.length; x++){
            if(entries[x].timestamp == timestamp){
                return entries[x];
            }
        }
        return new JournalModel(text: 'No Entries Found', timestamp: timestamp);
    }
}