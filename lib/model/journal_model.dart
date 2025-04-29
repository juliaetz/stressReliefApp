class Entry{
    final String text;
    final String date;
    final String? id;

    Entry({
        required this.text,
        required this.date,
        this.id,
    });

    Map<String, dynamic> toMap(){
        return{
            'text': text,
            'date': date,
        };
    }

    factory Entry.fromMap(Map<String, dynamic> map, String id){
        if(!map.containsKey('text') || !map.containsKey('date')){
            throw Exception('Invalid entry map');
        }

        return Entry(
            text: map['text']??'',
            date: map['date']??'',
            id: id,
        );
    }



}