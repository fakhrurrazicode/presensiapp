// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presensi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Presensi _$PresensiFromJson(Map<String, dynamic> json) => Presensi(
      json['id'] as int,
      json['pegawai_id'] as int?,
      json['bidang_id'] as int?,
      json['checked_in_at'] as String?,
      (json['checked_in_latitude'] as num?)?.toDouble(),
      (json['checked_in_longitude'] as num?)?.toDouble(),
      json['checked_in_image'] as String?,
      json['checked_in_image_url'] as String?,
      json['checked_out_at'] as String?,
      (json['checked_out_latitude'] as num?)?.toDouble(),
      (json['checked_out_longitude'] as num?)?.toDouble(),
      json['checked_out_image'] as String?,
      json['checked_out_image_url'] as String?,
      json['terlambat'] as int,
      json['cepat_pulang'] as int,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['status'] as String?,
    );

Map<String, dynamic> _$PresensiToJson(Presensi instance) => <String, dynamic>{
      'id': instance.id,
      'pegawai_id': instance.pegawaiId,
      'bidang_id': instance.bidangId,
      'checked_in_at': instance.checkedInAt,
      'checked_in_latitude': instance.checkedInLatitude,
      'checked_in_longitude': instance.checkedInLongitude,
      'checked_in_image': instance.checkedInImage,
      'checked_in_image_url': instance.checkedInImageUrl,
      'checked_out_at': instance.checkedOutAt,
      'checked_out_latitude': instance.checkedOutLatitude,
      'checked_out_longitude': instance.checkedOutLongitude,
      'checked_out_image': instance.checkedOutImage,
      'checked_out_image_url': instance.checkedOutImageUrl,
      'status': instance.status,
      'terlambat': instance.terlambat,
      'cepat_pulang': instance.cepatPulang,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
