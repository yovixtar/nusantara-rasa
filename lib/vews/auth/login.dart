import 'package:flutter/material.dart';
import 'package:nusantara/color.dart';
import 'package:nusantara/services/apis/pengguna.dart';
import 'package:nusantara/services/session.dart';
import 'package:nusantara/vews/layout_menu.dart';
import 'package:nusantara/vews/snackbar_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  String _loginMessage = '';
  bool _loginStatus = true;
  bool isLoading = false;

  handleLogin() async {
    setState(() {
      isLoading = true;
    });
    final result = await PenggunaService().login(
        username: _usernameController.text, password: _passwordController.text);
    if (result) {
      var username = _usernameController.text;
      await SessionManager.saveUsername(username);
      if (await SessionManager.hasUsername()) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LayoutMenu(),
          ),
        );
      } else {
        setState(() {
          _loginStatus = false;
        });
        SnackbarUtils.showErrorSnackbar(context, "Authentikasi gagal !");
      }
    } else {
      setState(() {
        setState(() {
          _loginStatus = false;
        });
        _loginMessage = 'Username / Password yang anda masukan salah.';
        SnackbarUtils.showErrorSnackbar(context, _loginMessage);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    iconSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: Text(
                    "Masuk Ke Akun Anda",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Username",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username harus diisi';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Password",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password harus diisi';
                            }
                            return null;
                          },
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        (!_loginStatus)
                            ? Text(
                                "Username / Password atau password anda masukan salah.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            minimumSize: const Size(double.infinity, 55),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              (isLoading) ? null : handleLogin();
                            }
                          },
                          child: (isLoading)
                              ? CircularProgressIndicator()
                              : Text(
                                  "Masuk",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 2.0,
                                        color: Color.fromARGB(64, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
