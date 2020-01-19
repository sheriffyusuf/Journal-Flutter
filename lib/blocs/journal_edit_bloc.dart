import 'dart:async';

import 'package:journal/models/journal.dart';
import 'package:journal/services/db_firestore_api.dart';

class JournalEditBloc {
  final DbApi dbApi;
  final bool add;
  Journal selectedJournal;

  final StreamController<String> _dateController =
      StreamController<String>.broadcast();
  Sink<String> get dateEditChanged => _dateController.sink;
  Stream<String> get dateEdit => _dateController.stream;

  final StreamController<String> _moodController =
      StreamController<String>.broadcast();
  Sink<String> get moodEditChanged => _moodController.sink;
  Stream<String> get moodEdit => _moodController.stream;

  final StreamController<String> _noteController =
      StreamController<String>.broadcast();
  Sink<String> get noteEditChanged => _noteController.sink;
  Stream<String> get noteEdit => _noteController.stream;

  final StreamController<String> _saveJournalController =
      StreamController<String>.broadcast();
  Sink<String> get saveJournalChanged => _saveJournalController.sink;
  Stream<String> get saveJournal => _saveJournalController.stream;

  JournalEditBloc(this.add, this.selectedJournal, this.dbApi) {
    _startEditListeners().then((finished) => _getJournal(add, selectedJournal));
  }

  void dispose() {
    _dateController.close();
    _moodController.close();
    _noteController.close();
    _saveJournalController.close();
  }

  Future<bool> _startEditListeners() async {
    _dateController.stream.listen((date) {
      selectedJournal.date = date;
    });
    _moodController.stream.listen((mood) {
      selectedJournal.mood = mood;
    });
    _noteController.stream.listen((note) {
      selectedJournal.note = note;
    });
    _saveJournalController.stream.listen((action) {
      if (action == "Save") {
        _saveJournal();
      }
    });
    return true;
  }

  void _getJournal(bool add, Journal journal) {
    if (add) {
      selectedJournal = Journal();
      selectedJournal.date = DateTime.now().toString();
      selectedJournal.mood = 'Satisfied';
      selectedJournal.note = '';
      selectedJournal.uid = journal.uid;
    } else {
      selectedJournal.date = journal.date;
      selectedJournal.mood = journal.mood;
      selectedJournal.note = journal.note;
    }
    dateEditChanged.add(selectedJournal.date);
    moodEditChanged.add(selectedJournal.mood);
    noteEditChanged.add(selectedJournal.note);
  }

  void _saveJournal() {
    Journal journal = Journal(
        documentID: selectedJournal.documentID,
        date: DateTime.parse(selectedJournal.date).toIso8601String(),
        mood: selectedJournal.mood,
        note: selectedJournal.note,
        uid: selectedJournal.uid);
    add ? dbApi.addJournal(journal) : dbApi.updateJournal(journal);
  }
}
