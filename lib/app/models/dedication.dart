class Dedication {
  Dedication({this.dedicationId, required this.label, required this.value });

  final String? dedicationId;
  final String label;
  final int value;

  factory Dedication.fromMap(Map<String, dynamic> data, String documentId) {
    return Dedication(
      dedicationId: data['dedicationId'],
      label: data['label'],
      value: data['value'],
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Dedication &&
            other.dedicationId == dedicationId);
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
    };
  }
}