// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as int,
      referralsRemaining: json['referralsRemaining'] as int,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      isEmailVerified: json['isEmailVerified'] as bool,
      hasBetaAccess: json['hasBetaAccess'] as bool,
      deviceTokens: (json['deviceTokens'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referralsRemaining': instance.referralsRemaining,
      'email': instance.email,
      'avatar': instance.avatar,
      'name': instance.name,
      'role': instance.role,
      'isEmailVerified': instance.isEmailVerified,
      'hasBetaAccess': instance.hasBetaAccess,
      'deviceTokens': instance.deviceTokens,
    };
