// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pegawai.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pegawai _$PegawaiFromJson(Map<String, dynamic> json) => Pegawai(
      json['id'] as int,
      json['nip'] as String?,
      json['nama'] as String?,
      json['jenis_kelamin'] as int?,
      json['tempat_lahir'] as String?,
      json['tanggal_lahir'] as String?,
      json['golongan_id'] as int?,
      json['jabatan'] as String?,
      json['bidang_id'] as int?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['today_presensi'] == null
          ? null
          : Presensi.fromJson(json['today_presensi'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PegawaiToJson(Pegawai instance) => <String, dynamic>{
      'id': instance.id,
      'nip': instance.nip,
      'nama': instance.nama,
      'jenis_kelamin': instance.jenisKelamin,
      'tempat_lahir': instance.tempatLahir,
      'tanggal_lahir': instance.tanggalLahir,
      'golongan_id': instance.golonganId,
      'jabatan': instance.jabatan,
      'bidang_id': instance.bidangId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'today_presensi': instance.todayPresensi,
    };
