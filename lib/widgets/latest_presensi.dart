import 'dart:convert';
import 'dart:developer';

import 'package:app_v2/models/presensi.dart';
import 'package:app_v2/screens/presensi_screen.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:app_v2/widgets/presensi_list_item.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LatestPresensi extends StatefulWidget {
  const LatestPresensi({
    Key? key,
  }) : super(key: key);

  @override
  State<LatestPresensi> createState() => _LatestPresensiState();
}

class _LatestPresensiState extends State<LatestPresensi> {
  bool _isLoading = true;
  List<Presensi> _listLatestPresensi = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() {
      _isLoading = true;
    });
    http.Response response = await ApiServices()
        .latestPresensi(context: context, month: 12, year: 2022, limit: 5);
    log('_init() => response.body : ${response.body}');

    if (response.statusCode == 200) {
      var decodedResponseBody = json.decode(response.body);

      List<Presensi> listLatestPresensi = [];

      for (var presensi in decodedResponseBody['presensi']) {
        listLatestPresensi.add(Presensi.fromJson(presensi));
      }

      setState(() {
        _listLatestPresensi = listLatestPresensi;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sejarah Presensi Terbaru'),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, PresensiScreen.routeName);
                },
                child: const Text('Lihat Selengkapnya'),
              )
            ],
          ),
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : _listLatestPresensi.isEmpty
                  ? const Text('Belum ada sejarah presensi')
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        Presensi presensi = _listLatestPresensi[index];
                        return PresensiListItem(presensi: presensi);
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: _listLatestPresensi.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
        ],
      ),
    );
  }
}
