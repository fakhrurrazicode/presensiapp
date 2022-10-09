import 'dart:developer';

import 'package:app_v2/app_state_provider.dart';
import 'package:app_v2/constants/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ApiServices {
  String getAccessToken(BuildContext context) {
    String accessToken =
        Provider.of<AppStateProvider>(context, listen: false).accessToken;
    return accessToken;
  }

  Map<String, String>? getAuthHeaders(BuildContext context) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${getAccessToken(context)}',
    };
  }

  Future<http.Response> login(
      String nip, String password, String? fcmToken) async {
    var url = Uri.parse('${ApiConstants.baseURL}/auth/login');
    http.Response response = await http.post(url, headers: {
      'Accept': 'application/json',
    }, body: {
      'nip': nip,
      'password': password,
      'fcm_token': fcmToken
    });

    return response;
  }

  Future<http.Response> updatePassword(BuildContext context, String oldPassword,
      String newPassword, String newPasswordConfirmation) async {
    var url = Uri.parse('${ApiConstants.baseURL}/auth/update_password');
    http.Response response =
        await http.put(url, headers: getAuthHeaders(context), body: {
      'old_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    });

    return response;
  }

  Future<http.Response> auth(BuildContext context, String? fcmToken) async {
    var url = Uri.parse('${ApiConstants.baseURL}/auth');
    if (fcmToken != null) {
      url = Uri.parse('${ApiConstants.baseURL}/auth?fcm_token=$fcmToken');
    }

    log('getAuthHeaders() => ${getAuthHeaders(context)}');

    http.Response response =
        await http.get(url, headers: getAuthHeaders(context));
    // .timeout(Duration(milliseconds: 1));
    return response;
  }

  Future<http.Response> polygonPoints(BuildContext context) async {
    var url = Uri.parse('${ApiConstants.baseURL}/polygon_points');

    log(url.toString());

    http.Response response =
        await http.get(url, headers: getAuthHeaders(context));
    // .timeout(Duration(milliseconds: 1));

    log('polygonPoints() => $response');
    return response;
  }

  Future<http.Response> latestAbsensiRequest({
    required BuildContext context,
    required int month,
    required int year,
    int? limit,
  }) async {
    var url = Uri.parse(
        '${ApiConstants.baseURL}/absensi_request/index/$month/$year/$limit');

    log('getAuthHeaders() => ${getAuthHeaders(context)}');

    http.Response response =
        await http.get(url, headers: getAuthHeaders(context));
    return response;
  }

  Future<http.Response> getInitialData(BuildContext context) async {
    var url = Uri.parse('${ApiConstants.baseURL}/initial_data');
    http.Response response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    return response;
  }

  Future<http.Response> latestPresensi({
    required BuildContext context,
    required int month,
    required int year,
    int? limit,
  }) async {
    var url =
        Uri.parse('${ApiConstants.baseURL}/presensi/index/$month/$year/$limit');

    log('getAuthHeaders() => ${getAuthHeaders(context)}');

    http.Response response =
        await http.get(url, headers: getAuthHeaders(context));
    return response;
  }

  // Future<http.Response> getInitialData(BuildContext context) async {
  //   var url = Uri.parse('${ApiConstants.baseURL}/initial_data');
  //   http.Response response = await http.get(url, headers: {
  //     'Accept': 'application/json',
  //   });
  //   return response;
  // }

  Future<http.StreamedResponse> createAbsensiRequest({
    required BuildContext context,
    required int pegawaiId,
    required int bidangId,
    required String type,
    required String requestDate,
    required String keterangan,
    required String attachmentFilePath,
  }) async {
    // try {
    Uri uri = Uri.parse('${ApiConstants.baseURL}/absensi_request');

    String accessToken = getAccessToken(context);

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.fields['type'] = type;
    request.fields['pegawai_id'] = pegawaiId.toString();
    request.fields['bidang_id'] = bidangId.toString();
    request.fields['request_date'] = requestDate;
    request.fields['keterangan'] = keterangan;

    request.files.add(await http.MultipartFile.fromPath(
        'attachment_file', attachmentFilePath));

    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> checkIn({
    required BuildContext context,
    required int pegawaiId,
    required int bidangId,
    required String checkedInAt,
    required double checkedInLatitude,
    required double checkedInLongitude,
    required String imagePath,
  }) async {
    // try {
    Uri uri = Uri.parse('${ApiConstants.baseURL}/presensi/check_in');

    String accessToken = getAccessToken(context);

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.fields['pegawai_id'] = pegawaiId.toString();
    request.fields['bidang_id'] = bidangId.toString();
    request.fields['checked_in_at'] = checkedInAt;
    request.fields['checked_in_latitude'] = checkedInLatitude.toString();
    request.fields['checked_in_longitude'] = checkedInLongitude.toString();

    request.files
        .add(await http.MultipartFile.fromPath('checked_in_image', imagePath));

    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> checkOut({
    required BuildContext context,
    required int presensiId,
    required String checkedOutAt,
    required double checkedOutLatitude,
    required double checkedOutLongitude,
    required String imagePath,
  }) async {
    // try {
    Uri uri = Uri.parse('${ApiConstants.baseURL}/presensi/check_out');

    String accessToken = getAccessToken(context);

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.fields['presensi_id'] = presensiId.toString();
    request.fields['checked_out_at'] = checkedOutAt;
    request.fields['checked_out_latitude'] = checkedOutLatitude.toString();
    request.fields['checked_out_longitude'] = checkedOutLongitude.toString();

    request.files
        .add(await http.MultipartFile.fromPath('checked_out_image', imagePath));

    http.StreamedResponse response = await request.send();

    return response;
  }
}
