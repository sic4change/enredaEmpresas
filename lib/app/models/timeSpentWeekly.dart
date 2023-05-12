class TimeSpentWeekly {
  TimeSpentWeekly({this.timeSpentWeeklyId, required this.label, required this.value });

  final String? timeSpentWeeklyId;
  final String label;
  final int value;

  factory TimeSpentWeekly.fromMap(Map<String, dynamic> data, String documentId) {
    return TimeSpentWeekly(
      timeSpentWeeklyId: data['timeSpentWeeklyId'],
      label: data['label'],
      value: data['value'],

    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimeSpentWeekly &&
            other.timeSpentWeeklyId == timeSpentWeeklyId);
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
    };
  }
}