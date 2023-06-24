import 'dart:developer';

import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/models/chat_models.dart';
import 'package:chatgpt_course/providers/chats_provider.dart';
import 'package:chatgpt_course/providers/models_provider.dart';
import 'package:chatgpt_course/services/api_service.dart';
import 'package:chatgpt_course/services/services.dart';
import 'package:chatgpt_course/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../services/assets_manager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  late FocusNode _focusNode;
  late ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text('ChatBelzze'),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalShee(context: context);
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Flexible(
            child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: chatProvider.chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.chatList[index].msg,
                    chatIndex: chatProvider.chatList[index].chatIndex,
                  );
                }),
          ),
          // _isTyping ? Container(): SizedBox.shrink()
          if (_isTyping) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 20,
            ),
          ],
          const SizedBox(
            height: 15,
          ),
          Material(
            color: cardColor,
            child: Row(children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  onSubmitted: (value) async {
                    try {
                      await sendMessage(
                          modelProvider: modelProvider,
                          chatProvider: chatProvider);
                    } catch (e) {
                      // print(e);
                    }
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Como puedo ayudate aventurero?',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await sendMessage(
                      modelProvider: modelProvider, chatProvider: chatProvider);
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              )
            ]),
          ),
        ]),
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessage({
    required ModelProvider modelProvider,
    required ChatProvider chatProvider,
  }) async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          label: 'No puedes enviar un mensaje vacio',
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: _controller.text, chatIndex: 0));
        chatProvider.addUserMessageToList(message: _controller.text);
      });

      await chatProvider.sendMessageAngGetAnswers(
          message: _controller.text, chosenModel: modelProvider.currentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //     message: _controller.text, modelId: modelProvider.currentModel));
      _focusNode.unfocus();
      _controller.clear();
      // log(chatList.toString());
      setState(() {});
    } catch (e) {
      // log('error $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: e.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _scrollToBottom();
        _isTyping = false;
      });
    }
  }
}
