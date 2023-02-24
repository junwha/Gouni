import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:makerthon/model/status_model.dart';

class Api {
  static const String baseUrl = 'http://172.20.10.10';

  static Future<StatusModel?> getStatusFromAPI() async {
    final url = Uri.parse("$baseUrl/flush");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final statusData = jsonDecode(response.body);
      return StatusModel.fromJson(statusData);
    }
    return null;
  }
}
