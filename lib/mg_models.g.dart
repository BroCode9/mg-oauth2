// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mg_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MgUser _$MgUserFromJson(Map<String, dynamic> json) {
  return MgUser(
      displayName: json['displayName'],
      givenName: json['givenName'],
      jobTitle: json['jobTitle'],
      mail: json['mail'],
      mobilePhone: json['mobilePhone'],
      officeLocation: json['officeLocation'])
    ..id = json['id'];
}

Map<String, dynamic> _$MgUserToJson(MgUser instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'givenName': instance.givenName,
      'jobTitle': instance.jobTitle,
      'mail': instance.mail,
      'mobilePhone': instance.mobilePhone,
      'officeLocation': instance.officeLocation
    };
