// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class Loginapi {
//   final String _baseUrl = "https://ocean-learn-api.rplrus.com/api/v1/user/auth";

//   Future<Map<String, dynamic>> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse(_baseUrl),
//         headers: {"Content-Type": "application/json", "Accept": "application/json"},
//         body: jsonEncode({
//           "email": email,
//           "password": password,
//         }),
//       );

//       // Debugging: Print status and response from API
//       print("Response Status: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         return {
//           "status": false,
//           "message": "Failed with status code: ${response.statusCode}"
//         };
//       }
//     } catch (e) {
//       print("Login API exception: ${e.toString()}");
//       return {
//         "status": false,
//         "message": "Connection error: ${e.toString()}"
//       };
//     }
//   }
// }