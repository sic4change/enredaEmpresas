class Nature {
  Nature({this.natureId, required this.label, required this.value,});

  final String? natureId;
  final String label;
  final String value;

  factory Nature.fromMap(Map<String, dynamic> data, String documentId) {
    return Nature(
        natureId: data['natureId'],
        label: data['label'],
        value: data['value']
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Nature &&
            other.natureId == natureId);
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
    };
  }
}