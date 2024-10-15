import 'package:enreda_empresas/app/models/scope.dart';
import 'package:enreda_empresas/app/models/size.dart';
import 'addressUser.dart';

class Company {
  Company({
    this.companyId,
    required this.name,
    this.cifGroup,
    this.cifDocument,
    this.groupCompany,
    this.mission,
    this.email,
    this.phone,
    this.address,
    this.country,
    this.countryName,
    this.province,
    this.provinceName,
    this.city,
    this.cityName,
    this.postalCode,
    this.website,
    this.scope,
    this.size,
    this.photo,
    this.types,
    this.actionScope,
    this.category,
    this.subCategory,
    this.entityPhone,
    this.entityMobilePhone,
    this.contactPhone,
    this.contactMobilePhone,
    this.geographicZone,
    this.subGeographicZone,
    this.linkedin,
    this.twitter,
    this.otherSocialMedia,
    this.contactName,
    this.contactEmail,
    this.contactPosition,
    this.contactChoiceGrade,
    this.contactKOL,
    this.contactProject,
    this.signedAgreements,
    this.trust,
  });

  late final String? companyId;
  final String name;
  final String? cifGroup;
  final String? cifDocument;
  final String? groupCompany;
  final String? mission;
  final String? email;
  final String? phone;
  final String? country;
  String? countryName;
  final String? province;
  String? provinceName;
  final String? city;
  String? cityName;
  final Address? address;
  final String? postalCode;
  final String? website;
  final Scope? scope;
  final SizeOrg? size;
  final String? photo;
  final List<String>? types;
  final String? actionScope;
  final String? category;
  final String? subCategory;
  final String? entityPhone;
  final String? entityMobilePhone;
  final String? contactPhone;
  final String? contactMobilePhone;
  final String? geographicZone;
  final String? subGeographicZone;
  final String? linkedin;
  final String? twitter;
  final String? otherSocialMedia;
  final String? contactName;
  final String? contactEmail;
  final String? contactPosition;
  final String? contactChoiceGrade;
  final String? contactKOL;
  final String? contactProject;
  final String? signedAgreements;
  final bool? trust;


  factory Company.fromMap(Map<String, dynamic> data, String documentId) {

    Address? address;
    try{
      address = Address(
          country: data['address']['country'],
          province: data['address']['province'],
          city: data['address']['city'],
          postalCode: data['address']['postalCode']
      );
    } catch(e) {
      address = null;
    }


    final String name = data['name'];
    final String? cifGroup = data['cifGroup'] ?? '';
    final String? groupCompany = data['groupCompany'] ?? '';
    final String? mission = data['mission'] ?? '';
    final String? companyId = data['companyId'];
    final String email = data['email']??"";

    String photo;
    try {
      photo = data['logo']['src'];
    } catch (e) {
      photo = '';
    }

    String cifDocument;
    try {
      cifDocument = data['file']['src'];
    } catch (e) {
      cifDocument = '';
    }

    final String website = data['website']??"";

    final List<String> types = [];
    if (data['types'] != null) {
      data['types'].forEach((type) {types.add(type.toString());});
    }

    final String actionScope = data['actionScope'] ?? '';
    final String category = data['category'] ?? '';
    final String subCategory = data['subCategory'] ?? '';
    final String entityPhone = data['entityPhone'] ?? '';
    final String entityMobilePhone = data['entityMobilePhone'] ?? '';
    final String contactPhone = data['contactPhone'] ?? '';
    final String contactMobilePhone = data['contactMobilePhone'] ?? '';
    final String geographicZone = data['geographicZone'] ?? '';
    final String subGeographicZone = data['subGeographicZone'] ?? '';
    final String linkedin = data['linkedin'] ?? '';
    final String twitter = data['twitter'] ?? '';
    final String otherSocialMedia = data['otherSocialMedia'] ?? '';
    final String contactName = data['contactName'] ?? '';
    final String contactEmail = data['contactEmail'] ?? '';
    final contactPosition = data['contactPosition'] ?? '';
    final contactChoiceGrade = data['contactChoiceGrade'] ?? '';
    final contactKOL = data['contactKOL'] ?? '';
    final contactProject = data['contactProject'] ?? '';
    final trust = data['trust'] ?? false;
    final String? country = data['address']['country'];
    final String? province = data['address']['province'];
    final String? city = data['address']['city'];
    final String signedAgreements = data['signedAgreements'] ?? '';

    return Company(
        companyId: companyId,
        name: name,
        cifGroup: cifGroup,
        cifDocument: cifDocument,
        groupCompany: groupCompany,
        mission: mission,
        email: email,
        address: address,
        website: website,
        photo: photo,
        types: types,
        actionScope: actionScope,
        category: category,
        subCategory: subCategory,
        entityPhone: entityPhone,
        entityMobilePhone: entityMobilePhone,
        contactPhone: contactPhone,
        contactMobilePhone: contactMobilePhone,
        geographicZone: geographicZone,
        subGeographicZone: subGeographicZone,
        linkedin: linkedin,
        twitter: twitter,
        otherSocialMedia: otherSocialMedia,
        contactName: contactName,
        contactEmail: contactEmail,
        contactPosition: contactPosition,
        contactChoiceGrade: contactChoiceGrade,
        contactKOL: contactKOL,
        contactProject: contactProject,
        trust: trust,
        country: country,
        province: province,
        city: city,
        signedAgreements: signedAgreements
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'name': name,
      'cifGroup': cifGroup,
      'cifDocument': cifDocument,
      'groupCompany': groupCompany,
      'mission': mission,
      'email': email,
      'address': address?.toMap(),
      'website': website,
      'types': types,
      'actionScope': actionScope,
      'category' : category,
      'subCategory': subCategory,
      'entityPhone': entityPhone,
      'entityMobilePhone': entityMobilePhone,
      'contactPhone': contactPhone,
      'contactMobilePhone': contactMobilePhone,
      'geographicZone': geographicZone,
      'subGeographicZone': subGeographicZone,
      'linkedin': linkedin,
      'twitter': twitter,
      'otherSocialMedia': otherSocialMedia,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactPosition': contactPosition,
      'contactChoiceGrade': contactChoiceGrade,
      'contactKOL': contactKOL,
      'contactProject': contactProject,
      'trust': trust,
      'country': country,
      'province': province,
      'city': city,
      'signedAgreements': signedAgreements
    };
  }

  Company copyWith({
    String? companyId,
    String? name,
    String? cifGroup,
    String? cifDocument,
    String? groupCompany,
    String? mission,
    String? email,
    Address? address,
    String? website,
    List<String>? types,
    String? actionScope,
    String? category,
    String? subCategory,
    String? entityPhone,
    String? entityMobilePhone,
    String? contactPhone,
    String? contactMobilePhone,
    String? geographicZone,
    String? subGeographicZone,
    String? linkedin,
    String? twitter,
    String? otherSocialMedia,
    String? contactName,
    String? contactEmail,
    String? contactPosition,
    String? contactChoiceGrade,
    String? contactKOL,
    String? contactProject,
    String? country,
    String? countryName,
    String? province,
    String? provinceName,
    String? city,
    String? cityName,
    String? signedAgreements,
  }) {
    return Company(
        companyId: companyId ?? this.companyId,
        name: name ?? this.name,
        cifGroup: cifGroup ?? this.cifGroup,
        cifDocument: cifDocument ?? this.cifDocument,
        groupCompany: groupCompany ?? this.groupCompany,
        mission: mission ?? this.mission,
        email: email ?? this.email,
        address: address ?? this.address,
        website: website ?? this.website,
        types: types ?? this.types,
        actionScope: actionScope ?? this.actionScope,
        category: category ?? this.category,
        subCategory: subCategory ?? this.subCategory,
        entityPhone: entityPhone ?? this.entityPhone,
        entityMobilePhone: entityMobilePhone ?? this.entityMobilePhone,
        contactPhone: contactPhone ?? this.contactPhone,
        contactMobilePhone: contactMobilePhone ?? this.contactMobilePhone,
        geographicZone: geographicZone ?? this.geographicZone,
        subGeographicZone: subGeographicZone ?? this.subGeographicZone,
        linkedin: linkedin ?? this.linkedin,
        twitter: twitter ?? this.twitter,
        otherSocialMedia: otherSocialMedia ?? this.otherSocialMedia,
        contactName: contactName ?? this.contactName,
        contactEmail: contactEmail ?? this.contactEmail,
        contactPosition: contactPosition ?? this.contactPosition,
        contactChoiceGrade: contactChoiceGrade ?? this.contactChoiceGrade,
        contactKOL: contactKOL ?? this.contactKOL,
        contactProject: contactProject ?? this.contactProject,
        country: country ?? this.country,
        countryName: countryName ?? this.countryName,
        province: province ?? this.province,
        provinceName: provinceName ?? this.provinceName,
        city: city ?? this.city,
        cityName: cityName ?? this.cityName,
        signedAgreements: signedAgreements ?? this.signedAgreements
    );
  }

  @override
  bool operator ==(Object other){
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Company &&
            other.companyId == companyId);
  }


  @override
  // TODO: implement hashCode
  int get hashCode => companyId.hashCode;

}