import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_course/constants/api_consts.dart';
import 'package:chatgpt_course/models/chat_models.dart';
import 'package:chatgpt_course/models/models_models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var url = Uri.parse('$BASE_URL/models');
      var response =
          await http.get(url, headers: {'Authorization': 'Bearer $API_Key'});

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print('jsonResponse: $jsonResponse["error"]["message"]');
        throw HttpException(jsonResponse['error']['message']);
      }

      List temp = [];
      for (var element in jsonResponse['data']) {
        temp.add(element);
        // log(element['id']);
      }
      return ModelsModel.modelFromSnapshot(temp);
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }

  static Future<String> getResponse(String message) async {
    var url = Uri.parse(
        'https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium');
    var response = await http.post(url, body: message);
    return response.body;
  }

  // semd message to server
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var url = Uri.parse('$BASE_URL/chat/completions');
      var response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $API_Key',
            'Content-Type': 'application/json',
            'charset': 'utf-8'
          },
          body: jsonEncode({
            "model": modelId,
            "messages": [
              {"role": "user", "content": message}
            ],
            "temperature": 0.7
          }));
      //  log(decodeResponce)
      Map jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg:
                jsonResponse["choices"][index]["message"]['content'].toString(),
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }
}
