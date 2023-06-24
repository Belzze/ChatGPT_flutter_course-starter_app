import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModalShee({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) => Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Flexible(
                      child: TextWidget(
                    label: 'Escoje el modelo:',
                    fontSize: 16,
                  )),
                  Flexible(child: DropdownWidget())
                ],
              ),
            ));
  }
}
