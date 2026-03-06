import 'package:enreda_empresas/app/models/education.dart';
import 'package:enreda_empresas/app/models/motivation.dart';
import 'addressUser.dart';
import 'interests.dart';
import 'profilepic.dart';

class UnemployedUser {
  UnemployedUser({
    required this.email,
    this.firstName,
    this.lastName,
    this.userId,
    this.country,
    this.province,
    this.city,
    this.address,
    this.role,
    this.profilePic,
    this.gender,
    this.phone,
    this.birthday,
    this.postalCode,
    this.motivation,
    this.interests,
    this.educationId,
    this.unemployedType,
    this.belongOrganization,
    this.assignedById,
    this.assignedEntityId,
    this.nationality,
    this.checkAgreeCV,
    this.gamificationFlags = const {},
    this.newsletter,
  });

  String? email;
  final String? firstName;
  final String? lastName;
  String? userId;
  String? photo;
  final String? country;
  final String? province;
  final String? city;
  final Address? address;
  final String? role;
  final ProfilePic? profilePic;
  final String? gender;
  final String? phone;
  final DateTime? birthday;
  final String? postalCode;
  final Motivation? motivation;
  final Interests? interests;
  final String? unemployedType;
  final String? belongOrganization;
  final String? assignedById;
  final String? assignedEntityId;
  final String? nationality;
  final String? educationId;
  final Map<String, bool> gamificationFlags;
  final bool? checkAgreeCV;
  final bool? newsletter;

  factory UnemployedUser.fromMap(Map<String, dynamic> data, String documentId) {

    final List<String> abilities = [];
    if (data['abilities'] != null) {
      data['abilities'].forEach((ability) {abilities.add(ability.toString());});
    }

    final List<String> interests = [];
    if (data['interests'] != null) {
      data['interests'].forEach((interest) {interests.add(interest.toString());});
    }

    final List<String> specificInterests = [];
    if (data['specificInterests'] != null) {
      data['specificInterests'].forEach((specificInterest) {specificInterests.add(specificInterest.toString());});
    }

    final Address? address = new Address(
        country: data['address']['country'],
        province: data['address']['province'],
        city: data['address']['city'],
        postalCode: data['address']['postalCode']
    );

    final Motivation? motivation = new Motivation(
        abilities: abilities,
        dedication: data['dedication'],
        timeSearching: data['timeSearching'],
        timeSpentWeekly: data['timeSpentWeekly']
    );

    final Interests? interestsUser = new Interests(
      interests: interests,
      specificInterests: specificInterests,
      continueLearning: data['interests']['continueLearning'],
      surePurpose: data['interests']['surePurpose'],
    );

    final ProfilePic? profilePic = new ProfilePic(
        src: data['profilePic']['src'],
        title: 'photo.jpg'
    );

    Map<String, bool> gamificationFlags = {};
    if (data['gamificationFlags'] != null) {
      (data['gamificationFlags'] as Map<String, dynamic>).forEach((key, value) {
        gamificationFlags[key] = value as bool;
      });
    }

    final bool? checkAgreeCV = data['checkAgreeCV'];

    return UnemployedUser(
        email: data['email'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        userId: data['userId'],
        profilePic: profilePic,
        address: address,
        role: data['role'],
        gender: data['gender'],
        phone: data['phone'],
        birthday: data['birthday'],
        motivation: motivation,
        interests: interestsUser,
        unemployedType: data['unemployedType'],
        belongOrganization: data['belongOrganization'],
        assignedById: data['assignedById'],
        assignedEntityId: data['assignedEntityId'],
        nationality: data['nationality'],
        educationId: data['educationId'],
        gamificationFlags: gamificationFlags,
        checkAgreeCV: checkAgreeCV,
        newsletter: data['newsletter'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'address': address?.toMap(),
      'role' : role,
      'gender': gender,
      'phone': phone,
      'birthday': birthday,
      'motivation': motivation?.toMap(),
      'interests': interests?.toMap(),
      'unemployedType': unemployedType,
      'belongOrganization': belongOrganization,
      'assignedById': assignedById,
      'assignedEntityId': assignedEntityId,
      'nationality' : nationality,
      'gamificationFlags': gamificationFlags,
      'educationId': educationId,
      'checkAgreeCV': checkAgreeCV,
      'newsletter': newsletter,
    };
  }
}