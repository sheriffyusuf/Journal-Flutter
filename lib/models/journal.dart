class Journal{
  String documentID;
  String date;
  String mood;
  String note;
  String uid;

  Journal({this.documentID, this.date, this.mood, this.note, this.uid});

factory Journal.fromDoc(dynamic doc)=> Journal(
  documentID: doc.documentID,
  date: doc["date"],
  mood:doc["mood"],
  note: doc["note"],
  uid: doc["uid"]
);



}