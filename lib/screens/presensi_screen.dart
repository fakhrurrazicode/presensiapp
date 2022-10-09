import 'dart:convert';
import 'dart:developer';

import 'package:app_v2/models/presensi.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:app_v2/widgets/presensi_list_item.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PresensiScreen extends StatefulWidget {
  static const routeName = '/presensi';
  const PresensiScreen({Key? key}) : super(key: key);

  @override
  State<PresensiScreen> createState() => _PresensiScreenState();
}

class _PresensiScreenState extends State<PresensiScreen> {
  bool isLoading = false;
  List<Presensi> listLatestPresensi = [];

  int year = DateTime.now().year;
  int month = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  Future<void> initStateAsync() async {
    setState(() {
      isLoading = true;
    });

    http.Response response = await ApiServices()
        .latestPresensi(context: context, month: month, year: year, limit: 5);
    log('initStateAsync() => response.body : ${response.body}');

    if (response.statusCode == 200) {
      var decodedResponseBody = json.decode(response.body);

      List<Presensi> newListLatestPresensi = [];

      for (var presensi in decodedResponseBody['presensi']) {
        newListLatestPresensi.add(Presensi.fromJson(presensi));
      }

      setState(() {
        listLatestPresensi = newListLatestPresensi;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Sejarah Presensi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  Presensi presensi = listLatestPresensi[index];
                  return PresensiListItem(presensi: presensi);
                  // ignore: prefer_const_constructors
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: listLatestPresensi.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
      ),
    );
  }
}
