import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'dart:typed_data';
import 'package:app_v2/app_state_provider.dart';
import 'package:app_v2/models/user.dart';
import 'package:app_v2/screens/absensi_request_take_picture_screen.dart';
import 'package:app_v2/screens/splash_screen.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum BestTutorSite { javatpoint, w3schools, tutorialandexample }

class AbsensiRequestCreateScreen extends StatefulWidget {
  static const routeName = '/absensi_request/create';
  const AbsensiRequestCreateScreen({Key? key}) : super(key: key);

  @override
  State<AbsensiRequestCreateScreen> createState() =>
      _AbsensiRequestCreateScreenState();
}

class _AbsensiRequestCreateScreenState
    extends State<AbsensiRequestCreateScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _errors = {};

  String type = 'izin';
  DateTime requestDate = DateTime.now();
  final requestDateTextEditingController = TextEditingController(text: '');
  final keteranganTextEditingController = TextEditingController(text: '');
  String attachmentFilePath = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errors = {};
    });

    User? u = Provider.of<AppStateProvider>(context, listen: false).user;

    if (u != null) {
      User user = u;

      http.StreamedResponse response = await ApiServices().createAbsensiRequest(
        context: context,
        type: type,
        pegawaiId: user.pegawai.id,
        bidangId: user.pegawai.bidangId ?? 0,
        requestDate: DateFormat('yyyy-MM-dd').format(requestDate),
        keterangan: keteranganTextEditingController.text,
        attachmentFilePath: attachmentFilePath,
      );

      Uint8List bytes = await response.stream.toBytes();
      String responseBody = String.fromCharCodes(bytes);

      if (response.statusCode == 200) {
        var decodedResponseBody = json.decode(responseBody);
        log(responseBody);

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: Text(decodedResponseBody['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                )
              ],
            );
          },
        );
        // ignore: use_build_context_synchronously
        // Navigator.pushNamedAndRemoveUntil(
        //     context, SplashScreen.routeName, (route) => false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error ${response.statusCode}'),
              content: Text(responseBody),
            );
          },
        );
      }
    }

    // http.Response response = await ApiServices().createAbsensiRequest(
    //   context: context,
    //   pegawaiId:
    // );

    // log(response.statusCode.toString());

    // if (response.statusCode == 200) {
    //   var decodedResponseBody = json.decode(response.body);
    //   await showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Success'),
    //         content: Text(decodedResponseBody['message']),
    //       );
    //     },
    //   );

    //   // ignore: use_build_context_synchronously
    //   Navigator.pushNamed(context, SplashScreen.routeName);
    // } else if (response.statusCode == 400) {
    //   var decodedResponseBody = json.decode(response.body);
    //   setState(() {
    //     _errors = decodedResponseBody['errors'];
    //   });
    // } else {
    //   await showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Error ${response.statusCode}'),
    //         content: Text(response.body),
    //       );
    //     },
    //   );
    // }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Buat Pengajuan Absensi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextField(
                      controller: requestDateTextEditingController,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: 'Tanggal yang ingin diajukan',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Tanggal yang ingin diajukan',
                          errorText: _errors.containsKey('old_password')
                              ? _errors['old_password'][0]
                              : null),
                      onTap: () async {
                        var selectedDateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                          currentDate: DateTime.now(),
                        );

                        setState(() {
                          requestDate = selectedDateTime as DateTime;
                          requestDateTextEditingController.text =
                              DateFormat('dd MMM yyyy')
                                  .format(selectedDateTime);
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: keteranganTextEditingController,
                      decoration: InputDecoration(
                          labelText: 'Keterangan',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Keterangan',
                          errorText: _errors.containsKey('old_password')
                              ? _errors['old_password'][0]
                              : null),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jenis Absensi',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 'izin',
                                    groupValue: type,
                                    onChanged: (value) {
                                      setState(() {
                                        type = value as String;
                                      });
                                    }),
                                const Text(
                                  'Izin',
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 'sakit',
                                    groupValue: type,
                                    onChanged: (value) {
                                      setState(() {
                                        type = value as String;
                                      });
                                    }),
                                const Text('Sakit'),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 'cuti',
                                    groupValue: type,
                                    onChanged: (value) {
                                      setState(() {
                                        type = value as String;
                                      });
                                    }),
                                const Text('Cuti'),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 'dinas_luar',
                                    groupValue: type,
                                    onChanged: (value) {
                                      setState(() {
                                        type = value as String;
                                      });
                                    }),
                                const Text('Dinas Luar'),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          attachmentFilePath != ''
                              ? Image.file(
                                  File(attachmentFilePath),
                                  width: 100,
                                )
                              : const SizedBox(),
                          ElevatedButton(
                            child: const Text('Ambil Gambar Bukti'),
                            onPressed: () async {
                              final filePath = await Navigator.pushNamed(
                                context,
                                AbsensiRequestTakePictureScreen.routeName,
                              );

                              setState(() {
                                attachmentFilePath = filePath as String;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Kirim',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
