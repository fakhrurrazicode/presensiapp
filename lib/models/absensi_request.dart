import 'package:json_annotation/json_annotation.dart';

/// This allows the `AbsensiRequest` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'absensi_request.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
// @JsonSerializable(fieldRename: FieldRename.snake)
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: true)
class AbsensiRequest {
  final int id;
  final int? pegawaiId;
  final int? bidangId;

  final String? type;
  final String? requestDate;
  final String? keterangan;
  final int? approval;
  final String? alasanPenolakan;
  final String? attachmentFile;
  final String? attachmentFileUrl;
  final String? createdAt;
  final String? updatedAt;

  AbsensiRequest(
    this.id,
    this.pegawaiId,
    this.bidangId,
    this.type,
    this.requestDate,
    this.keterangan,
    this.approval,
    this.attachmentFile,
    this.attachmentFileUrl,
    this.createdAt,
    this.updatedAt,
    this.alasanPenolakan,
  );

  /// A necessary factory constructor for creating a new AbsensiRequest instance
  /// from a map. Pass the map to the generated `_$AbsensiRequestFromJson()` constructor.
  /// The constructor is named after the source class, in this case, AbsensiRequest.
  factory AbsensiRequest.fromJson(Map<String, dynamic> json) =>
      _$AbsensiRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AbsensiRequestToJson`.
  Map<String, dynamic> toJson() => _$AbsensiRequestToJson(this);
}
