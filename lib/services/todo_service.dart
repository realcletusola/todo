import 'dart:convert';

import 'package:http/http.dart' as http;
class TodoService {

  //delete todo
  static Future<bool> deleteById(id) async {
    final url = Uri.parse('https:/api.nstack.in/v1/todos/$id');
    final response = await http.delete(url);
    return response.statusCode == 200;
  }

  // fetch todo
  static Future<List?> fetchTodo() async {
    final url = Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=10');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }
}