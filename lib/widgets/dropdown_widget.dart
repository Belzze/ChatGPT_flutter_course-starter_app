import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/providers/models_provider.dart';
import 'package:chatgpt_course/services/api_service.dart';
import 'package:chatgpt_course/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? _currentModel;
  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelProvider>(context, listen: false);
    return FutureBuilder(
      future: modelProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: TextWidget(label: snapshot.error.toString()));
        } else {
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: List<DropdownMenuItem<String>>.generate(
                        snapshot.data!.length,
                        (index) => DropdownMenuItem(
                              value: snapshot.data![index].id,
                              child: TextWidget(
                                label: snapshot.data![index].id,
                                fontSize: 15,
                              ),
                            )),
                    value: modelProvider.currentModel,
                    onChanged: (value) {
                      setState(() {
                        _currentModel = value.toString();
                      });
                      modelProvider.setCurrentModel(value.toString());
                    },
                  ),
                );
        }
      },
    );
  }
}
