class ResourceType {
  ResourceType({this.createdate, this.createdby, this.description,
    this.lastupdate, required this.name, this.resourceTypeId, this.updatedby,
  });

  final DateTime? createdate;
  final String? createdby;
  final String? description;
  final DateTime? lastupdate;
  final String name;
  final String? resourceTypeId;
  final String? updatedby;

  factory ResourceType.fromMap(Map<String, dynamic> data, String documentId) {
    return ResourceType(
      resourceTypeId: data['resourceTypeId'],
      name: data['name'],
    );
  }

  @override
  bool operator == (Object other){
    return identical(this, other) ||
        (other.runtimeType == this.runtimeType &&
            other is ResourceType &&
            other.resourceTypeId == this.resourceTypeId);
  }

  Map<String, dynamic> toMap() {
    return {
      'createdate': createdate,
      'createdby': createdby,
      'description': description,
      'lastupdate': lastupdate,
      'name': name,
      'resourceTypeId' : resourceTypeId,
      'updatedby': updatedby,
    };
  }

  @override
  // TODO: implement hashCode
  int get hashCode => resourceTypeId.hashCode;

}