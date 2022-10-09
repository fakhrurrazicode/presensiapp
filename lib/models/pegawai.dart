import 'package:app_v2/models/presensi.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `Pegawai` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'pegawai.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable(fieldRename: FieldRename.snake)
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: true)
class Pegawai {
  final int id;
  final String? nip;
  final String? nama;
  final int? jenisKelamin;
  final String? tempatLahir;
  final String? tanggalLahir;
  final int? golonganId;
  final String? jabatan;
  final int? bidangId;
  final String? createdAt;
  final String? updatedAt;
  final Presensi? todayPresensi;

  Pegawai(
    this.id,
    this.nip,
    this.nama,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.golonganId,
    this.jabatan,
    this.bidangId,
    this.createdAt,
    this.updatedAt,
    this.todayPresensi,
  );

  /// A necessary factory constructor for creating a new Pegawai instance
  /// from a map. Pass the map to the generated `_$PegawaiFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Pegawai.
  factory Pegawai.fromJson(Map<String, dynamic> json) =>
      _$PegawaiFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PegawaiToJson`.
  Map<String, dynamic> toJson() => _$PegawaiToJson(this);
}
