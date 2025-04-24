import '../model/journal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_logic.dart';



class JournalPresenter {
    final List<Entry> entries = [];

    JournalPresenter();


    Future<void> addEntry(Entry entry) async {
        final userDocRef = await getUserDocument();
        await userDocRef.collection('entries').add(entry.toMap());
    }

    Stream<List<Entry>> getEntries() async* {
        final userDocRef = await getUserDocument();
        yield* userDocRef.collection('entries').snapshots().map((snapshot) {
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
