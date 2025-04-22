import 'package:flutter/material.dart';
import '../presenter/journal_presenter.dart';
import '../model/journal_model.dart';

class JournalView extends StatefulWidget {
  final JournalPresenter presenter;

  const JournalView({
    super.key,
    required this.presenter
  });

  @override
  _JournalViewState createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView>{
  final controller = TextEditingController();

  void addEntry(String text) async{
    Entry entry = Entry(
        text: text,
        date: DateTime.now().toString()
    );

    await widget.presenter.addEntry(entry);
    controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Entry added!')),
    );
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
        backgroundColor: Colors.deepPurple.shade200,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<List<Entry>>(
                stream: widget.presenter.getEntries(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No entries yet!'));
                    }
                    List<Entry> entries = snapshot.data!;
                    return ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          Entry entry = entries[index];
                          return ListTile(
                            title: Text(entry.text),
                            subtitle: Text('${entry.date}'.split(' ')[0]),
                          );
                        }
                    );
                  }
            ),
            ),
            //creates a textbox to enter journal entries into
            SizedBox(
              width: 250,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'New Journal Entry'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed: (){
                  if(controller.text.trim().isNotEmpty){
                    addEntry(controller.text.trim());
                  }
                },
                child: Text('Add Entry'),
            ),
          ],
        ),
      ),
    );
  }
}

