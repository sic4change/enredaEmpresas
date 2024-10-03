import 'package:enreda_empresas/app/models/addressUser.dart';
import 'package:enreda_empresas/app/models/jobOfferApplication.dart';
import 'package:enreda_empresas/app/models/interestsUserEnreda.dart';
import 'package:enreda_empresas/app/models/language.dart';
import 'package:enreda_empresas/app/models/motivation.dart';
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
    this.keepLearningOptions = const [],
    this.abilities,
    this.certifications,
    this.unemployedType,
    this.role,
    // this.showChatWelcome,
    this.competencies = const {},
    this.educationName,
    this.dataOfInterest = const [],
    this.languagesLevels = const [],
    this.aboutMe,
    this.organization,
    this.socialEntityId,
    this.companyId,
    required this.resources,
    this.gamificationFlags = const {},
    this.assignedById,
    this.assignedEntityId,
    this.resourcesAccessCount,
    this.motivation,
    this.educationId,
    this.checkAgreeCV,
    //this.personalDocuments = const [],
    this.initialReportId,
    this.closureReportId,
    this.followReportId,
    this.derivationReportId,
    this.nationality,
    this.ipilObjectivesId,
    this.startDateItinerary,
  });

  factory UserEnreda.fromMap(Map<String, dynamic> data, String documentId) {
    final String email = data['email'];
    final String? organization = data['organization'];
    final String? socialEntityId = data['socialEntityId']?? "";
    final String? companyId = data['companyId'] ?? "";
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

    DateTime? startDateItinerary;
    if(data['startDateItinerary'] != null) {
      startDateItinerary = DateTime.parse(data['startDateItinerary'].toDate().toString());
    }

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

    List<String> keepLearningOptions = [];
    try {
      data['interests']['continueLearning'].forEach((keepLearningOption) {
        keepLearningOptions.add(keepLearningOption.toString());
      });
    } catch (e) {
      print('user not keepLearningOptions');
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

    final String educationId = data['educationId']?? "";

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

    List<Language> languagesLevels = [];
    if (data['languagesLevels'] != null) {
      data['languagesLevels'].forEach((languageLevel) {
        final languageLevelFirestore = languageLevel as Map<String, dynamic>;
        languagesLevels.add(
            Language(
              name: languageLevelFirestore['name']?? "",
              speakingLevel: languageLevelFirestore['speakingLevel']?? 1,
              writingLevel: languageLevelFirestore['writingLevel']?? 1,
            )
        );
      });
    }

    final String? aboutMe = data['aboutMe'];

    Map<String, bool> gamificationFlags = {};
    if (data['gamificationFlags'] != null) {
      (data['gamificationFlags'] as Map<String, dynamic>).forEach((key, value) {
        gamificationFlags[key] = value as bool;
      });
    }

    late String? assignedById = data['assignedById']?? "";
    final String? assignedEntityId = data['assignedEntityId']?? "";
    final int resourcesAccessCount = data['resourcesAccessCount']?? 0;

    final Motivation? motivation = new Motivation(
        abilities: abilities,
        dedication: data['dedication'],
        timeSearching: data['timeSearching'],
        timeSpentWeekly: data['timeSpentWeekly']
    );
    final bool? checkAgreeCV = data['checkAgreeCV'];
    final String? initialReportId = data['initialReportId'];
    final String? closureReportId = data['closureReportId'];
    final String? followReportId = data['followReportId'];
    final String? derivationReportId = data['derivationReportId'];
    final String? nationality = data['nationality'] ?? '';
    final String? ipilObjectivesId = data['ipilObjectivesId'];

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
      keepLearningOptions: keepLearningOptions,
      interests: interests,
      unemployedType: unemployedType,
      role: role,
      abilities: abilities,
      certifications: certifications,
      // showChatWelcome: showChatWelcome,
      competencies: competencies,
      educationId: educationId,
      educationName: educationName,
      dataOfInterest: dataOfInterest,
      languagesLevels: languagesLevels,
      aboutMe: aboutMe,
      organization: organization,
      socialEntityId: socialEntityId,
      resources: resources,
      gamificationFlags: gamificationFlags,
      assignedById: assignedById,
      assignedEntityId: assignedEntityId,
      resourcesAccessCount: resourcesAccessCount,
      motivation: motivation,
      checkAgreeCV: checkAgreeCV,
      initialReportId: initialReportId,
      closureReportId: closureReportId,
      followReportId: followReportId,
      derivationReportId: derivationReportId,
      nationality: nationality,
      ipilObjectivesId: ipilObjectivesId,
      startDateItinerary: startDateItinerary,
      companyId: companyId,
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
  final String? educationId;
  final String? phone;
  final DateTime? birthday;
  final String? country;
  final String? province;
  final String? city;
  final String? postalCode;
  final Address? address;
  final List<String> interests;
  final List<String> specificInterests;
  final List<String> keepLearningOptions;
  final String? unemployedType;
  final List<String>? abilities;
  final List<String>? certifications;
  final String? role;
  // bool? showChatWelcome;
  final Map<String, String> competencies;
  final List<String> dataOfInterest;
  final List<Language> languagesLevels;
  final String? aboutMe;
  final String? organization;
  final String? socialEntityId;
  final String? companyId;
  final List<String> resources;
  final Map<String, bool> gamificationFlags;
  late String? assignedById;
  final String? assignedEntityId;
  final int? resourcesAccessCount;
  final Motivation? motivation;
  final bool? checkAgreeCV;
  //final List<PersonalDocument> personalDocuments;
  final String? initialReportId;
  final String? closureReportId;
  final String? followReportId;
  final String? derivationReportId;
  final String? nationality;
  final String? ipilObjectivesId;
  DateTime? startDateItinerary;

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserEnreda &&
            other.userId == userId);
  }

  Map<String, dynamic> toMap() {
    InterestsUserEnreda interestUserEnreda = InterestsUserEnreda(
        interests: interests, specificInterests: specificInterests, keepLearningOptions: keepLearningOptions,);
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
      'languagesLevels': languagesLevels.map((e) => e.toMap()).toList(),
      'aboutMe': aboutMe,
      'educationId': educationId,
      'organization': organization,
      'socialEntityId': socialEntityId,
      'companyId': companyId,
      'resources': resources,
      'gamificationFlags': gamificationFlags,
      'assignedById': assignedById,
      'assignedEntityId': assignedEntityId,
      'resourcesAccessCount': resourcesAccessCount,
      'motivation': motivation?.toMap(),
      'checkAgreeCV': checkAgreeCV,
      //'personalDocuments': personalDocuments.map((e) => e.toMap()).toList(),
      'initialReportId': initialReportId,
      'closureReportId': closureReportId,
      'followReportId': followReportId,
      'derivationReportId': derivationReportId,
      'nationality' : nationality,
      'ipilObjectivesId': ipilObjectivesId,
      'startDateItinerary': startDateItinerary,
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
    List<String>? keepLearningOptions,
    List<String>? abilities,
    List<String>? resources,
    String? unemployedType,
    String? role,
    // bool? showChatWelcome,
    Map<String, String>? competencies,
    String? educationId,
    List<String>? dataOfInterest,
    List<Language>? languagesLevels,
    String? aboutMe,
    String? organization,
    String? socialEntityId,
    String? companyId,
    Map<String, bool>? gamificationFlags,
    String? assignedById,
    String? assignedEntityId,
    int? resourcesAccessCount,
    Motivation? motivation,
    bool? checkAgreeCV,
    //List<PersonalDocument>? personalDocuments,
    String? initialReportId,
    String? closureReportId,
    String? followReportId,
    String? derivationReportId,
    String? nationality,
    String? ipilObjectivesId,
    DateTime? startDateItinerary,
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
      keepLearningOptions: keepLearningOptions ?? this.keepLearningOptions,
      interests: interests ?? this.interests,
      abilities: abilities ?? this.abilities,
      unemployedType: unemployedType ?? this.unemployedType,
      role: role ?? this.role,
      // showChatWelcome: showChatWelcome ?? this.showChatWelcome,
      competencies: competencies ?? this.competencies,
      educationId: educationId ?? this.educationId,
      dataOfInterest: dataOfInterest ?? this.dataOfInterest,
      languagesLevels: languagesLevels ?? this.languagesLevels,
      aboutMe: aboutMe ?? this.aboutMe,
      organization: organization ?? this.organization,
      socialEntityId: socialEntityId ?? this.socialEntityId,
      companyId: companyId ?? this.companyId,
      resources: resources ?? this.resources,
      gamificationFlags: gamificationFlags ?? this.gamificationFlags,
      assignedById: assignedById,
      assignedEntityId: assignedEntityId,
      resourcesAccessCount: resourcesAccessCount,
      motivation: motivation,
      checkAgreeCV: checkAgreeCV ?? this.checkAgreeCV,
      //personalDocuments: personalDocuments ?? this.personalDocuments,
      initialReportId: initialReportId ?? this.initialReportId,
      closureReportId: closureReportId ?? this.closureReportId,
      followReportId: followReportId ?? this.followReportId,
      derivationReportId: derivationReportId ?? this.derivationReportId,
      nationality: nationality ?? this.nationality,
      ipilObjectivesId: ipilObjectivesId ?? this.ipilObjectivesId,
      startDateItinerary: startDateItinerary ?? this.startDateItinerary,
    );
  }

  @override
  // TODO: implement hashCode
  int get hashCode => userId.hashCode;

  static const String FLAG_SIGN_UP = "iIcnoLQfpVs7MmDzRGg7";
  static const String FLAG_PILL_WHAT_IS_ENREDA = "9tnftkYhk6xNUzokdi88";
  //static const String FLAG_PILL_TRAVEL_BEGINS = "X1Lzl17lvipjLRfXkXyB";
  static const String FLAG_PILL_COMPETENCIES = "08IEuCZq5ZpSihRHolTw";
  static const String FLAG_CHAT = "sfEkAorz3lEPflUwmfKv";
  static const String FLAG_EVALUATE_COMPETENCY = "7pFCCgX4X67ps2K3Mx0o";
  static const String FLAG_PILL_CV_COMPETENCIES = "0OSUTbLQWbQav69HBBPa";
  static const String FLAG_PILL_HOW_TO_DO_CV = "jw5RlKNEbCMeSZIwhrfo";
  static const String FLAG_CV_FORMATION = "jKZDpf8eb9iLsruDJr2H";
  static const String FLAG_CV_COMPLEMENTARY_FORMATION = "FIzQqM0tXwZoIH1V9CSP";
  static const String FLAG_CV_PERSONAL = "EDZWlWGf1IbAmQfB1TBU";
  static const String FLAG_CV_PROFESSIONAL = "PMpPOn5hMZCJR1qdU4sW";
  static const String FLAG_CV_ABOUT_ME = "KhDJqMIR6du9t4zOjKTx";
  static const String FLAG_CV_DATA_OF_INTEREST = "c6h0owyqz66P6MqbrSB6";
  static const String FLAG_CV_PHOTO = "fjr17WGx5vegzNHc9RWY";
  static const String FLAG_JOIN_RESOURCE = "oreFRQYdp5TNusvu3ubK";
}