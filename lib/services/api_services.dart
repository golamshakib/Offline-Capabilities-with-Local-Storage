import 'package:http/http.dart' as http;

import '../utils/constants/api_endpoints.dart';

class ApiServices {

  /// Fetch all users  method
  static Future<http.Response> fetchUsers() async {
    try {
      final response = await http.get(ApiEndpoints.getUsers);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('HTTP Error: ${response.statusCode} ${response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Client Exception: ${e.message}');
    } on Exception catch (e) {
      throw Exception('Unexpected Error: ${e.toString()}');
    }
  }
}
