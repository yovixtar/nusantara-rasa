import 'package:flutter/material.dart';
import 'package:nusantara/color.dart';
import 'package:nusantara/main.dart';
import 'package:nusantara/services/session.dart';
import 'package:nusantara/services/apis/pengguna.dart';
import 'package:nusantara/vews/snackbar_utils.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _passwordError;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await SessionManager.getReqUsername();
    if (userData != null) {
      setState(() {
        _usernameController.text = userData;
      });
    }
  }

  void _logout() async {
    final shouldLogout = await _showLogoutConfirmation();
    if (shouldLogout) {
      await SessionManager.clearUsername();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const FirstScreen(),
        ),
      );
    }
  }

  Future<bool> _showLogoutConfirmation() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Konfirmasi Logout'),
            content: Text('Apakah Anda yakin ingin logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Ya'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _updateProfile() async {
    setState(() {
      isLoading = true;
      _passwordError = null;
    });

    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      final repassword = _repasswordController.text;

      if (password.isNotEmpty && password != repassword) {
        setState(() {
          _passwordError = 'Password baru dan konfirmasi password tidak cocok.';
        });
        return;
      }

      final success = await PenggunaService().perbaruiProfile(
        username: username,
        password: password.isNotEmpty ? password : null,
      );

      if (success) {
        SnackbarUtils.showSuccessSnackbar(
            context, 'Profile berhasil diperbarui.');
        await SessionManager.clearUsername();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FirstScreen(),
          ),
        );
      } else {
        SnackbarUtils.showErrorSnackbar(context, 'Gagal memperbarui profile.');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgCream,
        appBar: AppBar(
          backgroundColor: bgCream,
          title: Text("Profile"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            TextButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout, color: Colors.white),
              label: Text('Logout', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        bg: bgCream,
                        label: 'Username',
                        hint: 'Username',
                        controller: _usernameController,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        label: 'Password Baru',
                        hint: 'Ganti Password Baru',
                        controller: _passwordController,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        label: 'RePassword baru',
                        hint: 'Konfirmasi Password Baru',
                        controller: _repasswordController,
                        errorText: _passwordError,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: (isLoading)
                              ? CircularProgressIndicator()
                              : Text(
                                  'Perbarui Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    Color bg = Colors.white,
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
    String? errorText,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: hint,
              filled: true,
              fillColor: bg,
              border: UnderlineInputBorder(),
              hintStyle: TextStyle(color: Colors.black54),
              errorText: errorText,
            ),
            style: TextStyle(color: Colors.black),
            validator: validator,
            readOnly: readOnly,
          ),
        ],
      ),
    );
  }
}
