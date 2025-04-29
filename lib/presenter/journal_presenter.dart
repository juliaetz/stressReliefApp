import '../model/journal_model.dart';
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
                Entry.fromMap(doc.data(), doc.id)).toList();
        });
    }

    Future<void> deleteEntry(String entryId) async {
        final userDocRef = await getUserDocument();
        await userDocRef.collection('entries').doc(entryId).delete();
    }


}
