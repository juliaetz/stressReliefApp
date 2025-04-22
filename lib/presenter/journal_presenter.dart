import '../model/journal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class JournalPresenter {
    final FirebaseFirestore firestore;
    final List<Entry> entries = [];

    JournalPresenter({required this.firestore});


    Future<void> addEntry(Entry entry) async {
        await firestore.collection('entries').add(entry.toMap());
    }

    Stream<List<Entry>> getEntries() {
        return firestore.collection('entries').snapshots().map((snapshot) {
            return snapshot.docs.map((doc) =>
                Entry.fromMap(doc.data() as Map<String, dynamic>)).toList();
        });
    }






//creates a new journal entry
/*void addEntry(String text){
        //creates a JournalModel object and adds it to the list
        Entry entry = Entry(text: text, date: DateTime.now().toString());
        entries.add(entry);

        //logs the journal entry being added, remove after testing is done
        print('Journal Entry Saved: ${entry.text} at ${entry.date}');

    }*/
}
