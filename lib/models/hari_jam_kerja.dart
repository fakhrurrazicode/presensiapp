import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `HariJamKerja` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'hari_jam_kerja.g.dart';

List<HariJamKerja> listHariJamKerjaFromJson(String str) {
  return List<HariJamKerja>.from(
    json.decode(str).map(
          (x) => HariJamKerja.fromJson(x),
        ),
  );
}

String listHariJamKerjaToJson(List<HariJamKerja> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable(fieldRename: FieldRename.snake)
@JsonSerializable(fieldRename: FieldRename.snake)
class HariJamKerja {
  final int id;
  final int hariId;
  final String namaHari;
  final String jamMasukStart;
  final String jamMasukEnd;
  final String jamKeluarStart;
  final String jamKeluarEnd;

  final String? createdAt;
  final String? updatedAt;
  final int? libur;

  HariJamKerja(
    this.id,
    this.hariId,
    this.namaHari,
    this.jamMasukStart,
    this.jamMasukEnd,
    this.jamKeluarStart,
    this.jamKeluarEnd,
    this.createdAt,
    this.updatedAt,
    this.libur,
  );

  /// A necessary factory constructor for creating a new HariJamKerja instance
  /// from a map. Pass the map to the generated `_$HariJamKerjaFromJson()` constructor.
  /// The constructor is named after the source class, in this case, HariJamKerja.
  factory HariJamKerja.fromJson(Map<String, dynamic> json) =>
      _$HariJamKerjaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$HariJamKerjaToJson`.
  Map<String, dynamic> toJson() => _$HariJamKerjaToJson(this);
}
