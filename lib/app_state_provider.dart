import 'dart:async';
import 'dart:developer';

import 'package:app_v2/models/hari_jam_kerja.dart';
import 'package:app_v2/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider extends ChangeNotifier {
  // String _accessToken =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMTE5MDUzM2Y4ZGM4ZTQ2N2UxMGJkZDIwOTMyOTgwYzBiNzNhZjFhYmIwZDIxYzE4OTMxYjcwYTk5Yzc1OGRmZGI3N2I1YmM1YzkxZmU5ZDAiLCJpYXQiOjE2NTc3MzkxMjEuNjU0MzM4LCJuYmYiOjE2NTc3MzkxMjEuNjU0MzQzLCJleHAiOjE2ODkyNzUxMjEuNTY0MDM5LCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.YeaEsaZT-egHNsHuCLfsSAjqlmTGL5ZDz2gHFpXnb1kBjFqOxyHddtp9_I_KrT9ZkQoiwiTvhM9oYkkXDXwSxINWrQrnIydmouN5Is4FgfcW09BNk1JHbnPNXDgEKK0hGw01m91psBpcUOuQVJvL8aCjCD4_WxHwgPO50Oc_Sy5R1A56qU90OBqsTPVmjfIahugK-PCnKZkZqV4F4HjsmdbTxnxxEpIZjH67y1Wv3SnemrQMW9fTIAIFLrklsa-zViqbf0EsIETZjwU-muGxXPhP4cl_96n1AhMEjMKQvYGjdKZpaMPf3yxedU24fMWmohBBy5WoQK7UAkdBw65EFTkgw5vmokoIXGs2I_kK-0NUuZxOR2IB74KpczEzbSYedQ9UOayHbCa2IBy2rPgSGjXHlgbqtUYmbdT5r9Ix8Hvi9-LUNe-GDzKhmplwY3-FLhHVv2cQ4QkPSF17aF1-_xuIYh8gApeGMWLvm250qf8FkwyFRywbbzU6BKl2p7T73lYfwkJkpDbTDT8BnWVo9bFtRscagi40qIswsMmuBy890ryYhJ0IaCCuHOOtasHIwus9xx7g9HEaZznk3jmZValKrNZyN9Gb0mbrbLfoGtEdy0NdyTAT06gEEPXhXb81nPaQSZgFc2ZjdXLOLkT5Wo6xadxkSshrW1Xdx5dw_KY';
  String _accessToken = '';
  bool _authenticated = true;
  User? _user;

  DateTime? _currentDateTime;

  DateTime get currentDateTime => _currentDateTime ?? DateTime.now().toLocal();

  List<HariJamKerja> _listHariJamKerja = [];

  List<HariJamKerja> get listHariJamKerja => _listHariJamKerja;

  set listHariJamKerja(List<HariJamKerja> value) {
    _listHariJamKerja = value;
    notifyListeners();
  }

  int getCurrentKodeHari() {
    switch (DateFormat('EEEE').format(DateTime.now())) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        return 0;
    }
  }

  HariJamKerja getCurrentHariJamKerja() {
    // dapatkan nama/kode hari
    int hariId = getCurrentKodeHari();

    return listHariJamKerja.firstWhere(
        (HariJamKerja hariJamKerja) => hariJamKerja.hariId == hariId);

    // ambil dari list di atas yg cocok dengan kode/nama hari nya
  }

  AppStateProvider() {
    // _init();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _init() async {
    // DateTime startDate = new DateTime.now().toLocal();

    // int offset = await NTP.getNtpOffset(localTime: startDate);
    // log('offset: $offset');
    // _currentDateTime = await NTP.now();
    // await TrueTime.init();
    // _currentDateTime = await TrueTime.now();

    // DateTime now = await NTP.now();
    DateTime now = DateTime.now().toLocal();

    print('now: $now');

    /// Or get NTP offset (in milliseconds) and add it yourself
    final int offset = await NTP.getNtpOffset(
        localTime: now, lookUpAddress: 'id.pool.ntp.org');
    print('offset: $offset');

    DateTime ntpNow = now.add(Duration(milliseconds: offset));
    print('ntpNow: $ntpNow');

    _currentDateTime = ntpNow;

    // _currentDateTime = DateTime.now().toLocal();
  }

  String get accessToken => _accessToken;

  set accessToken(String value) {
    _accessToken = value;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('accessToken', value);
      notifyListeners();
    });
  }

  get authenticated => _authenticated;

  set authenticated(value) {
    _authenticated = value;
    notifyListeners();
  }

  User? get user => _user;

  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  void _getTime() async {
    DateTime now = DateTime.now().toLocal();

    /// Or get NTP offset (in milliseconds) and add it yourself
    final int offset = await NTP.getNtpOffset(localTime: now);
    DateTime ntpNow = now.add(Duration(milliseconds: offset));
    setCurrentDateTime(ntpNow);
  }

  void setCurrentDateTime(DateTime dateTime) {
    _currentDateTime = dateTime;
    notifyListeners();
  }
}
