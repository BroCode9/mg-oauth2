// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mg_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MgUser _$MgUserFromJson(Map<String, dynamic> json) {
  return MgUser(
      displayName: json['displayName'] as String,
      givenName: json['givenName'] as String,
      jobTitle: json['jobTitle'] as String,
      mail: json['mail'] as String,
      mobilePhone: json['mobilePhone'] as String,
      officeLocation: json['officeLocation'] as String)
    ..id = json['id'] as String;
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
