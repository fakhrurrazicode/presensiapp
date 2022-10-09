// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['name'] as String?,
      json['email'] as String?,
      json['email_verified_at'] as String?,
      json['is_admin'] as int?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      Pegawai.fromJson(json['pegawai'] as Map<String, dynamic>),
      json['fcm_token'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt,
      'is_admin': instance.isAdmin,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'pegawai': instance.pegawai,
      'fcm_token': instance.fcmToken,
    };
