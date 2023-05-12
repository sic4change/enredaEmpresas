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
}