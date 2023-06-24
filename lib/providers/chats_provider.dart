import 'package:chatgpt_course/models/chat_models.dart';
import 'package:chatgpt_course/services/api_service.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatModel> chatList = [];

  getChatList() => chatList;

  void addUserMessageToList({required String message}) {
    chatList.add(ChatModel(msg: message, chatIndex: 0));
    notifyListeners();
  }

  void addChatToList(ChatModel chatModel) {
    chatList.add(chatModel);
    notifyListeners();
  }

  Future<void> sendMessageAngGetAnswers(
      {required String message, required String chosenModel}) async {
    chatList.addAll(
        await ApiService.sendMessage(message: message, modelId: chosenModel));
  }
}
