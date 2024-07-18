import 'dart:convert';
import 'package:app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Digite seu e-mail',
                        style: TextStyle(
                          color: Color.fromARGB(255, 98, 100, 100),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          email = value;
                        },
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromARGB(255, 232, 235, 235),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Digite sua senha',
                        style: TextStyle(
                          color: Color.fromARGB(255, 98, 100, 100),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromARGB(255, 232, 235, 235),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40, top: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        login(context, email, password);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 5, 85, 177)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xff012044),
    );
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    final url = Uri.parse('http://192.168.15.4/api/login');

    try {
      final response = await http.post(
        url,
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['access_token'];
        final userName = responseData['profile']['name'];

        final prefs = await SharedPreferences.getInstance();
        final expiryDate = DateTime.now().add(const Duration(hours: 3));
        await prefs.setString('jwt_token', token);
        await prefs.setString('expiry_date', expiryDate.toIso8601String());
        await prefs.setString('user_name', userName);

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao realizar login')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão')),
      );
    }
  }
}
