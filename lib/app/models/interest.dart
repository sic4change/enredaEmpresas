class Interest {
  Interest({this.interestId, this.order, required this.name});

  final String? interestId;
  final String name;
  final int? order;

  factory Interest.fromMap(Map<String, dynamic> data, String documentId) {
    return Interest(
      interestId: data['interestId'],
      name: data['name'],
      order: data['order'] ?? 0,
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Interest &&
            other.interestId == interestId);
  }

  Map<String, dynamic> toMap() {
    return {
      'interestId': interestId,
      'name': name,
      'order': order,
    };
  }

  @override
  // TODO: implement hashCode
  int get hashCode => interestId.hashCode;

}