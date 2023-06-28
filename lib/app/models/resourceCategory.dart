class ResourceCategory {
  ResourceCategory({required this.name, required this.id, required this.order});

  factory ResourceCategory.fromMap(Map<String, dynamic>? data, String documentId) {
    final String name = data?['name'];
    final int order = data?['order'];
    final String id = documentId;

    return ResourceCategory(
        name: name,
        order: order,
        id: id,
    );
  }

  final String name;
  final String id;
  final int order;

  @override
  bool operator == (Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResourceCategory &&
            other.id == id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id' : id,
      'order' : order,
    };
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

}