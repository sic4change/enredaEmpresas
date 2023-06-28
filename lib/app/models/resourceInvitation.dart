class ResourceInvitation {
  ResourceInvitation({
    this.resourceInvitationId,
    required this.resourceId,
    required this.resourceTitle,
    required this.resourceDates,
    required this.resourceDuration,
    required this.resourceDescription,
    required this.unemployedId,
    required this.unemployedName,
    required this.unemployedEmail,
  });

  factory ResourceInvitation.fromMap(Map<String, dynamic> data, String documentId) {
    final String resourceInvitationId = data['resourceInvitationId'];
    final String resourceId = data['resourceId'];
    final String resourceTitle = data['resourceTitle'];
    final String resourceDates = data['resourceDates'];
    final String resourceDuration = data['resourceDuration'];
    final String resourceDescription = data['resourceDescription'];
    final String unemployedId = data['unemployedId'];
    final String unemployedName = data['unemployedName'];
    final String unemployedEmail = data['unemployedEmail'];

    return ResourceInvitation(
      resourceInvitationId: resourceInvitationId,
      resourceId: resourceId,
      resourceTitle: resourceTitle,
      resourceDates: resourceDates,
      resourceDuration: resourceDuration,
      resourceDescription: resourceDescription,
      unemployedId: unemployedId,
      unemployedName: unemployedName,
      unemployedEmail: unemployedEmail,
    );
  }

  final String? resourceInvitationId;
  final String resourceId;
  final String resourceTitle;
  final String resourceDates;
  final String resourceDuration;
  final String resourceDescription;
  final String unemployedId;
  final String unemployedName;
  final String unemployedEmail;

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResourceInvitation &&
            other.resourceInvitationId == resourceInvitationId);
  }

  Map<String, dynamic> toMap() {
    return {
      'resourceId' : resourceId,
      'resourceTitle' : resourceTitle,
      'resourceDates' : resourceDates,
      'resourceDuration' : resourceDuration,
      'resourceDescription' : resourceDescription,
      'unemployedId' : unemployedId,
      'unemployedName' : unemployedName,
      'unemployedEmail' : unemployedEmail,
    };
  }

  @override
  // TODO: implement hashCode
  int get hashCode => resourceInvitationId.hashCode;

}
