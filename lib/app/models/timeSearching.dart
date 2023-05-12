class TimeSearching {
  TimeSearching({this.timeSearchingId, required this.label, required this.value });

  final String? timeSearchingId;
  final String label;
  final int value;

  factory TimeSearching.fromMap(Map<String, dynamic> data, String documentId) {
    return TimeSearching(
      timeSearchingId: data['timeSearchingId'],
      label: data['label'],
      value: data['value'],
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimeSearching &&
            other.timeSearchingId == timeSearchingId);
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
    };
  }
}