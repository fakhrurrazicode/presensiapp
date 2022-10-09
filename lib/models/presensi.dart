import 'package:json_annotation/json_annotation.dart';

/// This allows the `Presensi` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'presensi.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable(fieldRename: FieldRename.snake)
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: true)
class Presensi {
  final int id;
  final int? pegawaiId;
  final int? bidangId;
  final String? checkedInAt;
  final double? checkedInLatitude;
  final double? checkedInLongitude;
  final String? checkedInImage;
  final String? checkedInImageUrl;
  final String? checkedOutAt;
  final double? checkedOutLatitude;
  final double? checkedOutLongitude;
  final String? checkedOutImage;
  final String? checkedOutImageUrl;
  final String? status;
  final int terlambat;
  final int cepatPulang;

  final String? createdAt;
  final String? updatedAt;

  Presensi(
    this.id,
    this.pegawaiId,
    this.bidangId,
    this.checkedInAt,
    this.checkedInLatitude,
    this.checkedInLongitude,
    this.checkedInImage,
    this.checkedInImageUrl,
    this.checkedOutAt,
    this.checkedOutLatitude,
    this.checkedOutLongitude,
    this.checkedOutImage,
    this.checkedOutImageUrl,
    this.terlambat,
    this.cepatPulang,
    this.createdAt,
    this.updatedAt,
    this.status,
  );

  /// A necessary factory constructor for creating a new Presensi instance
  /// from a map. Pass the map to the generated `_$PresensiFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Presensi.
  factory Presensi.fromJson(Map<String, dynamic> json) =>
      _$PresensiFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PresensiToJson`.
  Map<String, dynamic> toJson() => _$PresensiToJson(this);
}
