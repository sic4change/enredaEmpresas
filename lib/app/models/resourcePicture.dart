class ResourcePicture {
  ResourcePicture({required this.id, required this.resourcePic, required this.name, required this.role});

  factory ResourcePicture.fromMap(Map<String, dynamic> data, String documentId) {
    return ResourcePicture(
      id: data['id'],
      resourcePic: data['resourcePhoto']['src'],
      name: data['resourcePhoto']['title'],
      role: data['role'],
    );
  }
  final String id;
  final String resourcePic;
  final String name;
  final String role;

  @override
  bool operator == (Object other){
    return identical(this, other) ||
        (other.runtimeType == this.runtimeType &&
            other is ResourcePicture &&
            other.id == this.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'resourcePic': resourcePic,
      'name': name,
      'role': role,
    };
  }
}