
import 'package:enreda_empresas/app/models/addressUser.dart';

class Resource {
  Resource({
    required this.title,
    required this.description,
    this.resourceId,
    required this.organizer,
    this.organizerType,
    this.organizerName,
    this.organizerImage,
    this.promotor,
    this.resourceType,
    this.resourceCategory,
    this.resourceTypeName,
    this.resourceCategoryName,
    this.capacity,
    this.duration,
    this.modality,
    this.place,
    this.street,
    this.country,
    this.countryName,
    this.province,
    this.provinceName,
    this.city,
    this.cityName,
    this.maximumDate,
    this.start,
    this.end,
    this.temporality,
    this.resourceLink,
    this.status,
    this.participants,
    this.assistants,
    this.likes,
    this.contractType,
    this.salary,
    this.contactEmail,
    this.contactPhone,
    this.resourcePictureId,
    this.resourcePhoto,
    this.searchText,
    required this.createdate,
    this.address,
    this.link,
    this.notExpire,
    this.interests,
    this.degree,
  });

  factory Resource.fromMap(Map<String, dynamic> data, String documentId) {

    final String title = data['title'];
    final String description = data['description'];
    final String organizer = data['organizer'];
    final String? organizerType = data['organizerType'];
    final String? organizerName = data['organizerName'];
    final String? organizerImage = data['organizerImage'];
    final String? promotor = data['promotor'];
    final String? resourceType = data['resourceType'];
    final String? resourceCategory = data['resourceCategory'];
    final String? contractType = data['contractType'];
    final String? salary = data['salary'];
    final String? resourceTypeName = data['resourceTypeName'];
    final String? resourceCategoryName = data['resourceCategoryName'];
    final int? capacity = data['capacity'];
    final String? duration = data['duration'];
    final String? modality = data['modality'];
    final String? country = data['address']['country'];
    final String? countryName = data['countryName'];
    final String? province = data['address']['province'];
    final String? provinceName = data['provinceName'];
    final String? city = data['address']['city'];
    final String? cityName = data['cityName'];
    final String? place = data['address']['place'];
    final String? street = data['address']['street'];
    final DateTime? maximumDate = data['maximumDate'].toDate();
    final DateTime? start = DateTime.parse(data['start'].toDate().toString());
    final DateTime? end =  DateTime.parse(data['end'].toDate().toString());
    final String? temporality = data['temporality'];
    final String? resourceLink = data['resourceLink'];
    final String? status = data['status'];
    final String? resourcePictureId = data['resourcePictureId'];
    final String? degree = data['degree'];
    List<String>? participants = [];
    if (data['participants'] != null) {
      data['participants'].forEach((participant) {participants.add(participant.toString());});
    }
    List<String>? interests = [];
    if (data['interests'] != null) {
      data['interests'].forEach((interest) {interests.add(interest.toString());});
    }
    final String assistants = data['assistants'].toString();
    List<String>? likes = [];
    if (data['likes'] != null) {
      data['likes'].forEach((like) {likes.add(like.toString());});
    }
    final String? contactEmail = data['contactEmail'];
    final String? contactPhone = data['contactPhone'];
    final String? resourcePhoto = data['resourcePhoto'];
    final String? searchText = data['searchText'];
    final String? link = data['link'];
    final bool? notExpire = data['notExpire'];
    final DateTime createdate = data['createdate'].toDate();

    final Address address = Address(
        country: country,
        province: province,
        city: city,
        place: place,
        street: street
    );

    return Resource(
      resourceId: documentId,
      title: title,
      description: description,
      organizer: organizer,
      organizerType : organizerType,
      organizerName: organizerName,
      organizerImage: organizerImage,
      promotor: promotor,
      resourceType: resourceType,
      resourceCategory: resourceCategory,
      resourceTypeName:  resourceTypeName,
      resourceCategoryName:  resourceCategoryName,
      capacity: capacity,
      duration: duration,
      modality: modality,
      country: country,
      countryName: countryName,
      province: province,
      provinceName: provinceName,
      city: city,
      cityName: cityName,
      maximumDate: maximumDate,
      start: start,
      end: end,
      temporality: temporality,
      resourceLink: resourceLink,
      status: status,
      participants: participants,
      assistants: assistants,
      interests: interests,
      likes: likes,
      salary: salary,
      contractType: contractType,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      resourcePictureId: resourcePictureId,
      resourcePhoto: resourcePhoto,
      searchText: searchText,
      link: link,
      notExpire: notExpire,
      createdate: createdate,
      address: address,
      degree: degree,
    );
  }

  final String? resourceId;
  final String title;
  final String organizer;
  String? organizerType;
  String? organizerName;
  String? organizerImage;
  final String? promotor;
  final String description;
  String? resourceType;
  String? resourceCategory;
  String? resourceTypeName;
  String? resourceCategoryName;
  final int? capacity;
  final String? duration;
  final String? modality;
  final String? country;
  String? countryName;
  final String? province;
  String? provinceName;
  final String? city;
  String? cityName;
  final String? place;
  final String? street;
  final DateTime? maximumDate;
  final DateTime? start;
  final DateTime? end;
  final String? temporality;
  final String? resourceLink;
  final String? status;
  final List<String>? participants;
  final List<String>? interests;
  String? assistants;
  final List<String>? likes;
  final String? contractType;
  final String? salary;
  final String? contactEmail;
  final String? contactPhone;
  String? resourcePictureId;
  String? resourcePhoto;
  final String? searchText;
  final String? link;
  final String? degree;
  final bool? notExpire;
  final DateTime createdate;
  final Address? address;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'organizer': organizer,
      'organizerType': organizerType,
      'promotor': promotor,
      'resourceType': resourceType,
      'resourceCategory': resourceCategory,
      'assistants': assistants,
      'capacity' : capacity,
      'duration' : duration,
      'modality' : modality,
      'maximumDate' : maximumDate,
      'start' : start,
      'end' : end,
      'temporality' : temporality,
      'resourceLink' : resourceLink,
      'participants' : participants,
      'interests' : interests,
      'contractType' : contractType,
      'salary' : salary,
      'contactEmail' : contactEmail,
      'contactPhone' : contactPhone,
      'resourcePictureId': resourcePictureId,
      'link': link,
      'degree': degree,
      'notExpire': notExpire,
      'address': address?.toMap(),
      'createdate': createdate,
    };
  }

  void setResourceTypeName() {
    switch(this.resourceType) {
      case '4l9BLhP7cwXohUvQzMOT': {
        this.resourceTypeName = 'Programa de aceleración de emprendimiento';
      }
      break;

      case 'E19QFsYBxlcw3edEF2Qp': {
        this.resourceTypeName = 'Otros';
      }
      break;

      case 'EsV5yvTXtyIrVobpefB6': {
        this.resourceTypeName = 'Eventos profesionales';
      }
      break;

      case 'GOw01m2HPro4I8xd6rSj': {
        this.resourceTypeName = 'Desarrollo de habilidades sociales';
      }
      break;

      case 'LRWhKw4kpmTZtShUFiTV': {
        this.resourceTypeName = 'Prácticas';
      }
      break;

      case 'MvCHSFzASskxlkBzPElb': {
        this.resourceTypeName = 'Apoyo y orientación para el empleo';
      }
      break;

      case 'N9KdlBYmxUp82gOv8oJC': {
        this.resourceTypeName = 'Formación';
      }
      break;

      case 'PPX3Ufeg9YfzH4YA0SkU': {
        this.resourceTypeName = 'Financiación / Soporte / Ayuda económica';
      }
      break;

      case 'QBTbYYx9EUwNtKB68Xfz': {
        this.resourceTypeName = 'Bolsa de empleo';
      }
      break;

      case 'VGuwRNVjRY2bzVcVhnnN': {
        this.resourceTypeName = 'Voluntariado';
      }
      break;

      case 'iGkqdz7uiWuXAFz1O8PY': {
        this.resourceTypeName = 'Hobbies, ocio y tiempo libre';
      }
      break;

      case 'kUM5r4lSikIPLMZlQ7FD': {
        this.resourceTypeName = 'Oferta de empleo';
      }
      break;

      case 'lUubulxiAGo4llxFJrkl': {
        this.resourceTypeName = 'Mentoría';
      }
      break;

      case 'r8ynPX9Y4P3WLtec2z21': {
        this.resourceTypeName = 'Beca';
      }
      break;

      default: {
        this.resourceTypeName = 'Otros';
      }
      break;
    }
  }

  void setResourceCategoryName() {
    switch(this.resourceCategory) {
      case 'POUBGFk5gU6c5X1DKo1b': {
        this.resourceCategoryName = 'Empleo';
      }
      break;

      case '6ag9Px7zkFpHgRe17PQk': {
        this.resourceCategoryName = 'Formación';
      }
      break;

      case 'PlaaW4L4Z36Wu1V6HuBa': {
        this.resourceCategoryName = 'Ocio y tiempo libre';
      }
      break;

      case 'LNj2FMTEBsNtBYCRo0MQ': {
        this.resourceCategoryName = 'Otros';
      }
      break;

      case 'zVusrwQkVoAca9R6iuQo': {
        this.resourceCategoryName = 'Prácticas';
      }
      break;

      case 'FNAcayruXghBMjj3RD9h': {
        this.resourceCategoryName = 'Voluntariado';
      }
      break;

      default: {
        this.resourceCategoryName = 'Otros';
      }
      break;
    }
  }

}
