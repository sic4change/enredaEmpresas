class Education {
  Education({this.educationId, required this.label, required this.value, required this.order });

  final String? educationId;
  final String label;
  final String value;
  final int order;

  factory Education.fromMap(Map<String, dynamic> data, String documentId) {
    return Education(
        educationId: data['educationId'],
        label: data['label'],
        value: data['value'],
        order: data['order']
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Education &&
            other.educationId == educationId);
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
      'order' : order,
    };
  }
}