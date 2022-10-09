import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:app_v2/app_state_provider.dart';
import 'package:app_v2/models/hari_jam_kerja.dart';
import 'package:app_v2/models/user.dart';
import 'package:app_v2/screens/home_screen.dart';
import 'package:app_v2/screens/login_screen.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      authenticate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Loading.Data..',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> authenticate() async {
    bool authenticated = await _authenticate();
    bool initialDataFetched = await _getInitialData();

    if (authenticated && initialDataFetched) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    }
  }

  Future<bool> _getInitialData() async {
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

        return true;
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
        return false;
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
    return false;
  }

  Future<bool> _authenticate() async {
    log('_SplashScreenState.authenticate()');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    log('accessToken: $accessToken');

    if (accessToken == null || accessToken == '') {
      log('_SplashScreenState.authenticate() 1');
      // ignore: use_build_context_synchronously
      return false;
    } else {
      AppStateProvider appStateProvider =
          // ignore: use_build_context_synchronously
          Provider.of<AppStateProvider>(context, listen: false);
      appStateProvider.accessToken = accessToken;

      log('_SplashScreenState.authenticate() 2');
      // ignore: use_build_context_synchronously

      try {
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        log('fcmToken: $fcmToken');
        // ignore: use_build_context_synchronously
        http.Response response = await ApiServices().auth(context, fcmToken);
        if (response.statusCode == 200) {
          log('_SplashScreenState.authenticate() 2.1');
          var responseData = json.decode(response.body);
          var accessToken = responseData['access_token'];
          var user = User.fromJson(responseData['user']);

          appStateProvider.accessToken = accessToken;
          appStateProvider.authenticated = true;
          appStateProvider.user = user;

          log('appStateProvider.accessToken: ${appStateProvider.accessToken}');

          return true;
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

      return false;
    }
  }
}
