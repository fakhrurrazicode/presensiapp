// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hari_jam_kerja.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HariJamKerja _$HariJamKerjaFromJson(Map<String, dynamic> json) => HariJamKerja(
      json['id'] as int,
      json['hari_id'] as int,
      json['nama_hari'] as String,
      json['jam_masuk_start'] as String,
      json['jam_masuk_end'] as String,
      json['jam_keluar_start'] as String,
      json['jam_keluar_end'] as String,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['libur'] as int?,
    );

Map<String, dynamic> _$HariJamKerjaToJson(HariJamKerja instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hari_id': instance.hariId,
      'nama_hari': instance.namaHari,
      'jam_masuk_start': instance.jamMasukStart,
      'jam_masuk_end': instance.jamMasukEnd,
      'jam_keluar_start': instance.jamKeluarStart,
      'jam_keluar_end': instance.jamKeluarEnd,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'libur': instance.libur,
    };
