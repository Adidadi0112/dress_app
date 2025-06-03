import 'dart:convert';

import 'package:dress_app/service/auth_token_controller.dart';
import 'package:http/http.dart' as http;

class Api {
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal();

  String? authUrl = "https://x8ki-letl-twmt.n7.xano.io/api:HRhza3RP";
  String? baseUrl = "https://x8ki-letl-twmt.n7.xano.io/api:8aUUoezg";
  Future<Map<String, dynamic>> login(Map<String, dynamic> userData) async {
    Map<String, dynamic> response = await sendRequest(
      endpoint: '/auth/login',
      method: "post",
      body: userData,
      authToken: null,
      otherBaseUrl: authUrl,
    );
    if (response['type'] == 'success') {
      await AuthTokenController().saveAuthToken(response['data']['authToken']);
    }
    return response;
  }

  Future<Map<String, dynamic>> signUp(Map<String, dynamic> userData) async {
    Map<String, dynamic> response = await sendRequest(
      endpoint: '/auth/signup',
      method: "post",
      body: userData,
      authToken: null,
      otherBaseUrl: authUrl,
    );
    if (response['type'] == 'success') {
      await AuthTokenController().saveAuthToken(response['data']['authToken']);
    }
    return response;
  }

  Future<Map<String, dynamic>> getItems() async {
    return await sendRequest(
      endpoint: '/item',
      method: 'get',
      authToken: await AuthTokenController().getAuthToken(),
    );
  }

  Future<Map<String, dynamic>> sendRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    String? authToken,
    String? otherBaseUrl,
  }) async {
    final url = Uri.parse('${otherBaseUrl ?? baseUrl}$endpoint');

    try {
      http.Response response;

      Map<String, String> headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json; charset=UTF-8',
      };

      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        case 'GET':
        default:
          response = await http.get(url, headers: headers);
          break;
      }

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        return {'type': 'success', 'data': data};
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        return {
          "type": "error",
          "data": {"message": data['message'] ?? 'Unknown error'},
        };
      }
    } catch (e) {
      return {
        "type": "error",
        "data": {"message": "Request failed: ${e.toString()}"},
      };
    }
  }
}
