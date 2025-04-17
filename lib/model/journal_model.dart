class Entry{
    final String text;
    final String date;

    Entry({
        required this.text,
        required this.date,
    });

    Map<String, dynamic> toMap(){
        return{
            'text': text,
            'date': date,
        };
    }

    factory Entry.fromMap(Map<String, dynamic> map){
        return Entry(
            text: map['text']??'',
            date: map['date']??'',
        );
    }



}