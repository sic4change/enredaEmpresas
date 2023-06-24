import 'package:enreda_empresas/app/models/addressUser.dart';
import 'package:enreda_empresas/app/models/education.dart';
import 'package:enreda_empresas/app/models/interestsUserEnreda.dart';
import 'package:enreda_empresas/app/models/profilepic.dart';

class UserEnreda {
  UserEnreda({
    required this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.userId,
    this.profilePic,
    this.photo,
    this.phone,
    this.birthday,
    this.country,
    this.province,
    this.city,
    this.postalCode,
    this.address,
    this.specificInterests = const [],
    this.interests = const [],
    this.abilities,
    this.certifications,
    this.unemployedType,
    this.role,
    // this.showChatWelcome,
    this.competencies = const {},
    //this.education,
    this.educationName,
    this.dataOfInterest = const [],
    this.languages = const [],
    this.aboutMe,
    this.organization,
    required this.resources,
  });

  factory UserEnreda.fromMap(Map<String, dynamic> data, String documentId) {
    final String email = data['email'];
    final String? organization = data['organization'];
    final String? role = data['role'];

    final String? firstName = data['firstName'];
    final String? lastName = data['lastName'];
    final String? gender = data['gender'];
    final String? userId = data['userId'];
    final String? unemployedType = data['unemployedType'];

    String photo;
    try {
      photo = data['profilePic']['src'];
    } catch (e) {
      photo = '';
    }

    String educationName;
    try {
      educationName = data['education']['label'];
    } catch (e) {
      educationName = '';
    }

    List<String> resources = [];
    if (data['resources'] != null) {
      data['resources'].forEach((resource) {resources.add(resource.toString());});
    }

    final String? phone = data['phone'];
    final DateTime? birthday = DateTime.parse(data['birthday'].toDate().toString());
    final String? country = data['address']['country'];
    final String? province = data['address']['province'];
    final String? city = data['address']['city'];
    final String? postalCode = data['address']['postalCode'];

    List<String> abilities = [];
    try {
      data['motivation']['abilities'].forEach((ability) {
        abilities.add(ability.toString());
      });
    } catch (e) {
      print('user not abilities');
    }

    List<String> interests = [];
    try {
      data['interests']['interests'].forEach((interest) {
        interests.add(interest.toString());
      });
    } catch (e) {
      print('user not interests');
    }

    List<String> specificInterests = [];
    try {
      data['interests']['specificInterests'].forEach((specificInterest) {
        specificInterests.add(specificInterest.toString());
      });
    } catch (e) {
      print('user not specific intersts');
    }

    List<String> certifications = [];
    try {
      data['certifications'].forEach((certification) {certifications.add(certification.toString());});
    } catch (e) {
      print('user does not have certifications');
    }

    final ProfilePic profilePic = new ProfilePic(src: photo, title: 'photo.jpg');
    final Address address = Address(
        country: country,
        province: province,
        city: city,
        postalCode: postalCode);

    // final Education education = Education(
    //   label: data['education']['label'],
    //   value: data['education']['value'],
    //   order: data['education']['order'],
    // );
    //
    // final bool? showChatWelcome = data['showChatWelcome'];

    Map<String, String> competencies = {};
    if (data['competencies'] != null) {
      (data['competencies'] as Map<String, dynamic>).forEach((key, value) {
        competencies[key] = value;
      });
    }

    List<String> dataOfInterest = [];
    try {
      data['dataOfInterest'].forEach((interest) {
        dataOfInterest.add(interest.toString());
      });
    } catch (e) {
      print('user does not have data of interest');
    }

    List<String> languages = [];
    try {
      data['languages'].forEach((language) {
        languages.add(language.toString());
      });
    } catch (e) {
      print('user does not have languages');
    }

    final String? aboutMe = data['aboutMe'];

    return UserEnreda(
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      userId: userId,
      photo: photo,
      profilePic: profilePic,
      phone: phone,
      birthday: birthday,
      country: country,
      province: province,
      city: city,
      address: address,
      postalCode: postalCode,
      specificInterests: specificInterests,
      interests: interests,
      unemployedType: unemployedType,
      role: role,
      abilities: abilities,
      certifications: certifications,
      // showChatWelcome: showChatWelcome,
      competencies: competencies,
      //education: education,
      educationName: educationName,
      dataOfInterest: dataOfInterest,
      languages: languages,
      aboutMe: aboutMe,
      organization: organization,
      resources: resources,
    );
  }

  final String email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? userId;
  String? photo;
  String? educationName;
  final ProfilePic? profilePic;
  // final Education? education;
  final String? phone;
  final DateTime? birthday;
  final String? country;
  final String? province;
  final String? city;
  final String? postalCode;
  final Address? address;
  final List<String> interests;
  final List<String> specificInterests;
  final String? unemployedType;
  final List<String>? abilities;
  final List<String>? certifications;
  final String? role;
  // bool? showChatWelcome;
  final Map<String, String> competencies;
  final List<String> dataOfInterest;
  final List<String> languages;
  final String? aboutMe;
  final String? organization;
  final List<String> resources;

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserEnreda &&
            other.userId == userId);
  }

  Map<String, dynamic> toMap() {
    InterestsUserEnreda interestUserEnreda = InterestsUserEnreda(
        interests: interests, specificInterests: specificInterests);
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'userId': userId,
      //'profilePic': profilePic.toMap(),
      'phone': phone,
      'birthday': birthday,
      'address': address?.toMap(),
      'interests': interestUserEnreda.toMap(),
      'unemployedType': unemployedType,
      'abilities': abilities,
      'certifications': certifications,
      'role': role,
      //'unemployedType': unemployedType,
      // 'showChatWelcome': showChatWelcome,
      'competencies': competencies,
      'dataOfInterest': dataOfInterest,
      'languages': languages,
      'aboutMe': aboutMe,
      //'education': education?.toMap(),
      'organization': organization,
      'resources': resources,
    };
  }

  // void updateShowChatWelcome(bool newValue) {
  //   showChatWelcome = newValue;
  // }

  UserEnreda copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? userId,
    ProfilePic? profilePic,
    // String? photo,
    String? phone,
    DateTime? birthday,
    String? country,
    String? province,
    String? city,
    String? postalCode,
    Address? address,
    List<String>? specificInterests,
    List<String>? interests,
    List<String>? abilities,
    List<String>? resources,
    String? unemployedType,
    String? role,
    // bool? showChatWelcome,
    Map<String, String>? competencies,
    Education? education,
    List<String>? dataOfInterest,
    List<String>? languages,
    String? aboutMe,
    String? organization,

  }) {
    return UserEnreda(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      userId: userId ?? this.userId,
      profilePic: profilePic ?? this.profilePic,
      // photo: photo ?? this.photo,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      country: country ?? this.country,
      province: province ?? this.province,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      address: address ?? this.address,
      specificInterests: specificInterests ?? this.specificInterests,
      interests: interests ?? this.interests,
      abilities: abilities ?? this.abilities,
      unemployedType: unemployedType ?? this.unemployedType,
      role: role ?? this.role,
      // showChatWelcome: showChatWelcome ?? this.showChatWelcome,
      competencies: competencies ?? this.competencies,
      //education: education ?? this.education,
      dataOfInterest: dataOfInterest ?? this.dataOfInterest,
      languages: languages ?? this.languages,
      aboutMe: aboutMe ?? this.aboutMe,
      organization: organization ?? this.organization,
      resources: resources ?? this.resources,
    );
  }

  @override
  // TODO: implement hashCode
  int get hashCode => userId.hashCode;

}