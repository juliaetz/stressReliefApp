import 'package:flutter/material.dart';
import '../presenter/journal_presenter.dart';

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
            Text(
                'placeholder journal text'
            ),
            //creates a textbox to enter journal entries into
            SizedBox(
              width: 250,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'New Journal Entry'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                //onSubmitted: addEntry(),
              ),
            )

          ],
        ),
      ),
    );
  }
}

