import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_v2/app_state_provider.dart';
import 'package:app_v2/models/hari_jam_kerja.dart';
import 'package:app_v2/models/user.dart';
import 'package:app_v2/screens/home_screen.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  Map<String, dynamic> errors = {};

  final nipTextEditingController = TextEditingController(text: '');
  final passwordTextEditingController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              const SizedBox(
                  width: 60,
                  child: Image(image: AssetImage('assets/images/logo.png'))),
              const SizedBox(
                height: 24,
              ),
              Text(
                'SISTEM PRESENSI',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 32,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextField(
                      controller: nipTextEditingController,
                      decoration: InputDecoration(
                          hintText: 'NIP',
                          icon: const Icon(Icons.verified_user),
                          errorText: errors.containsKey('nip')
                              ? errors['nip'][0]
                              : null),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        icon: const Icon(Icons.password),
                        errorText: errors.containsKey('password')
                            ? errors['password'][0]
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : loginButtonClickHandler,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'LOGIN',
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

  Future<void> loginButtonClickHandler() async {
    setState(() {
      isLoading = true;
      errors = {};
    });
    bool authenticated = await login();
    bool initialDataFetched = await _getInitialData();

    if (authenticated && initialDataFetched) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> _getInitialData() async {
    http.Response response = await ApiServices().getInitialData(context);
    log('getInitialData() => response.body : ${response.body}');

    if (response.statusCode == 200) {
      var decodedResponseBody = json.decode(response.body);
      List<HariJamKerja> listHariJamKerja = [];

      for (var hariJamKerja in decodedResponseBody['hari_jam_kerja']) {
        listHariJamKerja.add(HariJamKerja.fromJson(hariJamKerja));
      }
      AppStateProvider appStateProvider =
          // ignore: use_build_context_synchronously
          Provider.of<AppStateProvider>(context, listen: false);

      appStateProvider.listHariJamKerja = listHariJamKerja;

      return true;
    } else if (response.statusCode == 400) {
      var decodedResponseBody = json.decode(response.body);
      setState(() {
        errors = decodedResponseBody['errors'];
      });
      return false;
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error ${response.statusCode}'),
            content: Text(response.body),
          );
        },
      );
      return false;
    }
  }

  Future<bool> login() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    log('fcmToken: $fcmToken');
    String nip = nipTextEditingController.text;
    String password = passwordTextEditingController.text;

    http.Response response = await ApiServices().login(
      nip,
      password,
      fcmToken,
    );

    log('loginButtonClickHandler() => response.body : ${response.body}');

    if (response.statusCode == 200) {
      var decodedResponseBody = json.decode(response.body);
      var accessToken = decodedResponseBody['access_token'];
      var user = User.fromJson(decodedResponseBody['user']);

      AppStateProvider appStateProvider =
          // ignore: use_build_context_synchronously
          Provider.of<AppStateProvider>(context, listen: false);

      appStateProvider.accessToken = accessToken;
      appStateProvider.authenticated = true;
      appStateProvider.user = user;

      return true;

      // ignore: use_build_context_synchronously

    } else if (response.statusCode == 400) {
      var decodedResponseBody = json.decode(response.body);

      Map<String, dynamic> err = decodedResponseBody['errors'];

      if (err.isNotEmpty) {
        setState(() {
          errors = err;
        });
      }
      return false;
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error ${response.statusCode}'),
            content: Text(response.body),
          );
        },
      );

      return false;
    }

    // if (result != null) {
    //   var accessToken = result['access_token'];
    //   var user = User.fromJson(result['user']);

    //   var prefs = await SharedPreferences.getInstance();
    //   prefs.setString('accessToken', accessToken);
    //   prefs.setString('user', jsonEncode(user.toJson()));

    //   AppStateProvider appStateProvider =
    //       // ignore: use_build_context_synchronously
    //       Provider.of<AppStateProvider>(context, listen: false);

    //   appStateProvider.accessToken = accessToken;
    //   appStateProvider.authenticated = true;
    //   appStateProvider.user = user;

    //   // ignore: use_build_context_synchronously
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const HomeScreen(),
    //       ),
    //       (route) => false);
    // }
  }
}
