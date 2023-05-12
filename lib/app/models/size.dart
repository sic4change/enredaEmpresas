class SizeOrg {
  SizeOrg({this.sizeId, required this.label, required this.value, required this.order});
  final String? sizeId;
  final String label;
  final String value;
  final int order;

  factory SizeOrg.fromMap(Map<String, dynamic> data, String documentId) {
    return SizeOrg(
      sizeId: data['sizeId'],
      label: data['label'],
      value: data['value'],
      order: data['order'],
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SizeOrg &&
            other.sizeId == sizeId);
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
      'order': order,
    };
  }
}