import 'dart:convert';
import 'dart:developer';

import 'package:app_v2/models/absensi_request.dart';
import 'package:app_v2/screens/absensi_request_create_screen.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:app_v2/widgets/absensi_request_list_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AbsensiRequestScreen extends StatefulWidget {
  static const routeName = '/absensi_request';
  const AbsensiRequestScreen({Key? key}) : super(key: key);

  @override
  State<AbsensiRequestScreen> createState() => _AbsensiRequestScreenState();
}

class _AbsensiRequestScreenState extends State<AbsensiRequestScreen> {
  bool isLoading = false;
  List<AbsensiRequest> listLatestAbsensiRequest = [];

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

    http.Response response = await ApiServices().latestAbsensiRequest(
        context: context, month: month, year: year, limit: 100);
    log('initStateAsync() => response.body : ${response.body}');

    if (response.statusCode == 200) {
      var decodedResponseBody = json.decode(response.body);

      List<AbsensiRequest> newListLatestAbsensiRequest = [];

      for (var absensi_request in decodedResponseBody['absensi_request']) {
        newListLatestAbsensiRequest
            .add(AbsensiRequest.fromJson(absensi_request));
      }

      setState(() {
        listLatestAbsensiRequest = newListLatestAbsensiRequest;
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
        title: const Text('Pengajuan Ketidakhadiran'),
        actions: [
          IconButton(
            onPressed: () {
              initStateAsync();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
              context, AbsensiRequestCreateScreen.routeName);
          initStateAsync();
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    AbsensiRequest absensiRequest =
                        listLatestAbsensiRequest[index];
                    return AbsensiRequestListItem(
                      absensiRequest: absensiRequest,
                    );
                    // ignore: prefer_const_constructors
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: listLatestAbsensiRequest.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
        ),
      ),
    );
  }
}
