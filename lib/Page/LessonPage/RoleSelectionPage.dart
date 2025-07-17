import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  Future<void> _saveRoleAndNavigate(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
    Get.offAllNamed('/home'); // arahkan ke halaman utama setelah pilih role
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pilih Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _saveRoleAndNavigate('premium'),
              child: Text('Masuk sebagai Premium'),
            ),
            ElevatedButton(
              onPressed: () => _saveRoleAndNavigate('visitor'),
              child: Text('Masuk sebagai Visitor'),
            ),
          ],
        ),
      ),
    );
  }
}
