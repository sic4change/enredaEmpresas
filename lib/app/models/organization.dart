import 'package:enreda_empresas/app/models/scope.dart';
import 'package:enreda_empresas/app/models/size.dart';
import 'addressUser.dart';
import 'nature.dart';

class Organization {
  Organization({
    this.organizationId,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.country,
    this.province,
    this.city,
    this.postalCode,
    this.nature,
    this.scope,
    this.size,
    this.photo
  });

  final String? organizationId;
  final String name;
  final String? email;
  final String? phone;
  final String? country;
  final String? province;
  final String? city;
  final Address? address;
  final String? postalCode;
  final Nature? nature;
  final Scope? scope;
  final SizeOrg? size;
  final String? photo;

  factory Organization.fromMap(Map<String, dynamic> data, String documentId) {

    final Address address = Address(
        country: data['address']['country'],
        province: data['address']['province'],
        city: data['address']['city'],
        postalCode: data['address']['postalCode']
    );

    final String name = data['name'];
    final String? organizationId = data['organizationId'];
    final String? email = data['email'];
    final String? phone = data['phone'];

    String photo;
    try {
      photo = data['logoPic']['src'];
    } catch (e) {
      photo = '';
    }

    Nature? nature;
    String natureId;
    String labelNature;
    String valueNature;
    try {
      natureId = data['natureId'];
    } catch (e) {
      natureId = '';
    }
    try {
      labelNature = data['label'];
    } catch (e) {
      labelNature = '';
    }
    try {
      valueNature = data['value'];
    } catch (e) {
      valueNature = '';
    }

    nature = Nature(
      natureId: natureId,
      label: labelNature,
      value: valueNature,
    );

    Scope? scope;
    String scopeId;
    String labelScope;
    String valueScope;
    int orderScope;
    try {
      scopeId = data['scopeId'];
    } catch (e) {
      scopeId = '';
    }
    try {
      labelScope = data['label'];
    } catch (e) {
      labelScope = '';
    }
    try {
      valueScope = data['value'];
    } catch (e) {
      valueScope = '';
    }
    try {
      orderScope = data['order'];
    } catch (e) {
      orderScope = 0;
    }

    scope = Scope(
      scopeId: scopeId,
      label: labelScope,
      value: valueScope,
      order: orderScope,
    );

    SizeOrg? size;
    String sizeId;
    String labelSize;
    String valueSize;
    int orderSize;
    try {
      sizeId = data['sizeId'];
    } catch (e) {
      sizeId = '';
    }
    try {
      labelSize = data['label'];
    } catch (e) {
      labelSize = '';
    }
    try {
      valueSize = data['value'];
    } catch (e) {
      valueSize = '';
    }
    try {
      orderSize = data['order'];
    } catch (e) {
      orderSize = 0;
    }

    size = SizeOrg(
        sizeId: sizeId,
        label: labelSize,
        value: valueSize,
        order: orderSize
    );


    return Organization(
        organizationId: organizationId,
        name: name,
        email: email,
        phone: phone,
        address: address,
        nature: nature,
        scope: scope,
        size: size,
        photo: photo
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address?.toMap(),
      'nature': nature?.toMap(),
      'scope': scope?.toMap(),
      'size': size?.toMap(),
    };
  }
}