class Scope {
  Scope({this.scopeId, required this.label, required this.value, required this.order});
  final String? scopeId;
  final String label;
  final String value;
  final int order;

  factory Scope.fromMap(Map<String, dynamic> data, String documentId) {
    return Scope(
      scopeId: data['scopeId'],
      label: data['label'],
      value: data['value'],
      order: data['order'],
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Scope &&
            other.scopeId == scopeId);
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
      'order': order,
    };
  }
}