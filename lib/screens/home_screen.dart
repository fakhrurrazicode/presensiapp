import 'dart:convert';
import 'dart:developer';

import 'package:app_v2/app_state_provider.dart';
import 'package:app_v2/models/hari_jam_kerja.dart';
import 'package:app_v2/models/pegawai.dart';
import 'package:app_v2/models/user.dart';
import 'package:app_v2/screens/absensi_request_screen.dart';
import 'package:app_v2/screens/change_password_screen.dart';
import 'package:app_v2/screens/check_in_screen.dart';
import 'package:app_v2/screens/check_out_screen.dart';
import 'package:app_v2/screens/login_screen.dart';
import 'package:app_v2/screens/splash_screen.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:app_v2/widgets/latest_presensi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    log('_HomeScreenState.initState()');
    // _getInitialData();

    super.initState();
  }

  Future<void> _getInitialData() async {
    AppStateProvider appStateProvider =
        // ignore: use_build_context_synchronously
        Provider.of<AppStateProvider>(context, listen: false);
    try {
      http.Response response = await ApiServices().getInitialData(context);
      log('_getInitialData() => response.body : ${response.body}');

      if (response.statusCode == 200) {
        var decodedResponseBody = json.decode(response.body);
        List<HariJamKerja> listHariJamKerja = [];

        for (var hariJamKerja in decodedResponseBody['hari_jam_kerja']) {
          listHariJamKerja.add(HariJamKerja.fromJson(hariJamKerja));
        }

        appStateProvider.listHariJamKerja = listHariJamKerja;
      } else {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Response ${response.statusCode}'),
              content: Text(response.body),
            );
          },
        );

        appStateProvider.authenticated = false;
        appStateProvider.accessToken = '';
        appStateProvider.user = null;

        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    log('_HomeScreenState.build()');

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, SplashScreen.routeName, (route) => false);
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      drawer: Consumer<AppStateProvider>(
        builder: (context, AppStateProvider appStateProvider, child) => Drawer(
          child: ListView(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 18,
                ),
                tileColor: Colors.indigo,
                title: Text(
                  '${appStateProvider.user!.pegawai.nama!} ',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: ${appStateProvider.user!.email!}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'NIP: ${appStateProvider.user!.pegawai.nip}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Pengajuan Ketidakhadiran'),
                leading: const Icon(Icons.approval),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AbsensiRequestScreen.routeName,
                  );
                },
              ),
              ListTile(
                title: const Text('Ubah Password'),
                leading: const Icon(Icons.password),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ChangePasswordScreen.routeName,
                  );
                },
              ),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  appStateProvider.accessToken = '';
                  appStateProvider.authenticated = false;
                  Navigator.pushNamedAndRemoveUntil(
                      context, SplashScreen.routeName, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 16,
                right: 16,
                bottom: 32,
                left: 16,
              ),
              // height: 200,
              decoration: const BoxDecoration(
                color: Colors.indigo,
              ),
              child: Consumer<AppStateProvider>(
                builder: (context, AppStateProvider appStateProvider, child) =>
                    Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) {
                            if (appStateProvider.user != null) {
                              User user = appStateProvider.user!;
                              Pegawai pegawai = user.pegawai;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pegawai.nama!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    pegawai.jabatan!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white, height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd MMM yyyy')
                              .format(appStateProvider.currentDateTime)
                              .toString(),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          DateFormat('HH:mm:ss a')
                              .format(appStateProvider.currentDateTime)
                              .toString(),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Builder(
                      builder: (context) {
                        if (appStateProvider.getCurrentHariJamKerja().libur ==
                            1) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Hari ini adalah hari libur',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        }

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Jam Kerja',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.black54,
                                    ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Jam Masuk',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          '${appStateProvider.getCurrentHariJamKerja().jamMasukStart} s/d ${appStateProvider.getCurrentHariJamKerja().jamMasukEnd}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Colors.black54,
                                              ),
                                          textAlign: TextAlign.center,
                                          // softWrap: true,
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text('s/d'),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Jam Keluar',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          '${appStateProvider.getCurrentHariJamKerja().jamKeluarStart} s/d ${appStateProvider.getCurrentHariJamKerja().jamKeluarEnd}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Colors.black54,
                                              ),
                                          textAlign: TextAlign.center,
                                          // softWrap: true,
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Divider(
                                height: 8,
                                color: Colors.black26,
                              ),
                              Builder(builder: (context) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: checkInButton(),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: checkOutButton(),
                                    )
                                  ],
                                );
                              })
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            const LatestPresensi(),
          ],
        ),
      ),
    );
  }

  Widget checkInButton() {
    return Consumer<AppStateProvider>(
      builder: (
        context,
        appStateProvider,
        child,
      ) {
        bool hasTodayActivePresensi = false;
        bool onTime = false;
        bool hasCheckedInPresensi = false;

        hasTodayActivePresensi =
            appStateProvider.user?.pegawai.todayPresensi != null ? true : false;

        DateTime currentDatetime = appStateProvider.currentDateTime;
        HariJamKerja hariJamKerja = appStateProvider.getCurrentHariJamKerja();

        DateFormat formatter = DateFormat('yyyy-MM-dd');
        DateTime jamMasukStart = DateTime.parse(
            '${formatter.format(currentDatetime)} ${hariJamKerja.jamMasukStart}');

        onTime = currentDatetime.isAfter(jamMasukStart) ? true : false;

        hasCheckedInPresensi =
            appStateProvider.user?.pegawai.todayPresensi?.checkedInAt != null
                ? true
                : false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: hasTodayActivePresensi == false && onTime == true
                  // onPressed: true
                  ? hasCheckedInPresensi
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            CheckInScreen.routeName,
                          );
                        }
                  : null,
              child: const Text(
                'Check in',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            hasTodayActivePresensi && hasCheckedInPresensi
                ? Text(
                    'Checked in pada pukul: ${appStateProvider.user!.pegawai.todayPresensi!.checkedInAt}',
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }

  Widget checkOutButton() {
    return Consumer<AppStateProvider>(
      builder: (
        context,
        appStateProvider,
        child,
      ) {
        bool hasTodayActivePresensi = false;
        bool onTime = false;
        bool hasCheckedOutPresensi = false;

        hasTodayActivePresensi =
            appStateProvider.user?.pegawai.todayPresensi != null ? true : false;

        DateTime currentDatetime = appStateProvider.currentDateTime;
        HariJamKerja hariJamKerja = appStateProvider.getCurrentHariJamKerja();

        DateFormat formatter = DateFormat('yyyy-MM-dd');
        DateTime jamKeluarStart = DateTime.parse(
            '${formatter.format(currentDatetime)} ${hariJamKerja.jamKeluarStart}');

        onTime = currentDatetime.isAfter(jamKeluarStart) ? true : false;

        hasCheckedOutPresensi =
            appStateProvider.user?.pegawai.todayPresensi?.checkedOutAt != null
                ? true
                : false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: hasTodayActivePresensi == true && onTime == true
                  // onPressed: true
                  ? hasCheckedOutPresensi
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            CheckOutScreen.routeName,
                          );
                        }
                  : null,
              child: const Text(
                'Check out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            hasTodayActivePresensi && hasCheckedOutPresensi
                ? Text(
                    'Checked out pada pukul: ${appStateProvider.user!.pegawai.todayPresensi!.checkedOutAt}',
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
