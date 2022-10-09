// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absensi_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsensiRequest _$AbsensiRequestFromJson(Map<String, dynamic> json) =>
    AbsensiRequest(
      json['id'] as int,
      json['pegawai_id'] as int?,
      json['bidang_id'] as int?,
      json['type'] as String?,
      json['request_date'] as String?,
      json['keterangan'] as String?,
      json['approval'] as int?,
      json['attachment_file'] as String?,
      json['attachment_file_url'] as String?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['alasan_penolakan'] as String?,
    );

Map<String, dynamic> _$AbsensiRequestToJson(AbsensiRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pegawai_id': instance.pegawaiId,
      'bidang_id': instance.bidangId,
      'type': instance.type,
      'request_date': instance.requestDate,
      'keterangan': instance.keterangan,
      'approval': instance.approval,
      'alasan_penolakan': instance.alasanPenolakan,
      'attachment_file': instance.attachmentFile,
      'attachment_file_url': instance.attachmentFileUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
