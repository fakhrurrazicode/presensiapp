import 'dart:convert';
import 'dart:developer';
import 'package:app_v2/screens/splash_screen.dart';
import 'package:app_v2/services/api_services.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change_password';
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _errors = {};

  final oldPasswordTextEditingController = TextEditingController(text: '');
  final newPasswordTextEditingController = TextEditingController(text: '');
  final newPasswordConfirmationTextEditingController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errors = {};
    });

    http.Response response = await ApiServices().updatePassword(
      context,
      oldPasswordTextEditingController.text,
      newPasswordTextEditingController.text,
      newPasswordConfirmationTextEditingController.text,
    );

    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      var decodedResponseBody = json.decode(response.body);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Text(decodedResponseBody['message']),
          );
        },
      );

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, SplashScreen.routeName);
    } else if (response.statusCode == 400) {
      var decodedResponseBody = json.decode(response.body);
      setState(() {
        _errors = decodedResponseBody['errors'];
      });
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
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Ubah Password'),
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
                      controller: oldPasswordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password Lama',
                          icon: const Icon(Icons.alternate_email),
                          errorText: _errors.containsKey('old_password')
                              ? _errors['old_password'][0]
                              : null),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: newPasswordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password Baru',
                        icon: const Icon(Icons.password),
                        errorText: _errors.containsKey('new_password')
                            ? _errors['new_password'][0]
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: newPasswordConfirmationTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Ulangi Password Baru',
                        icon: const Icon(Icons.password),
                        errorText:
                            _errors.containsKey('new_password_confirmation')
                                ? _errors['new_password_confirmation'][0]
                                : null,
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
}
