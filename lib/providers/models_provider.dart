import 'package:chatgpt_course/models/models_models.dart';
import 'package:chatgpt_course/services/api_service.dart';
import 'package:flutter/material.dart';

class ModelProvider with ChangeNotifier {
  List<ModelsModel> _models = [];
  String _currentModel = 'gpt-3.5-turbo';

  List<ModelsModel> get models => _models;

  void setModels(List<ModelsModel> value) {
    _models = value;
    notifyListeners();
  }

  String get currentModel => _currentModel;
  void setCurrentModel(String value) {
    _currentModel = value;
    notifyListeners();
  }

  Future<List<ModelsModel>> getAllModels() async {
    _models = await ApiService.getModels();
    return _models;
  }
}
