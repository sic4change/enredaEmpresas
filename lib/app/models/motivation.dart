import 'package:enreda_empresas/app/models/timeSearching.dart';
import 'package:enreda_empresas/app/models/timeSpentWeekly.dart';
import 'dedication.dart';

class Motivation {
  Motivation({ this.abilities, this.dedication, this.timeSearching, this.timeSpentWeekly});
  final List? abilities;
  final Dedication? dedication;
  final TimeSearching? timeSearching;
  final TimeSpentWeekly? timeSpentWeekly;

  factory Motivation.fromMap(Map<String, dynamic> data, String documentId) {

    final Dedication? dedication = new Dedication(
        label: data['dedication']['label'],
        value: data['dedication']['value']
    );

    final TimeSearching? timeSearching = new TimeSearching(
        label: data['timeSearching']['label'],
        value: data['timeSearching']['value']
    );

    final TimeSpentWeekly? timeSpentWeekly = new TimeSpentWeekly(
        label: data['timeSpentWeekly']['label'],
        value: data['timeSpentWeekly']['value']
    );

    return Motivation(
      abilities: data['abilities'],
      dedication: dedication,
      timeSearching: timeSearching,
      timeSpentWeekly: timeSpentWeekly,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'abilities': abilities,
      'dedication': dedication?.toMap(),
      'timeSearching': timeSearching?.toMap(),
      'timeSpentWeekly': timeSpentWeekly?.toMap(),
    };
  }
}