import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/constants.dart';

class InputView extends StatelessWidget {
  late final String text;
  late final String hintText;

  String errorText;

  TextEditingController controller = TextEditingController();

  final TextInputType keyboardType;

  final Function(String) onChange;

  final bool isCreditCard;

  final IconData? suffixIcon;

  final VoidCallback? suffixIconTapped;

  final bool isCardDate;

  bool showError;
  FocusNode? doneButtonFocusNode;

  final int textLimit;

  final String? preText;

  final int maxLine;

  final String? alreadyEntered;

  final bool padding;

  final bool firstLetterCapital;
  final bool showCount;
  final bool isDisabled;

  final String cardImage;

  final bool isCvv;

  final int customHeight;

  final bool isSecure;

  InputView(
      {Key? key,
      required this.text,
      required this.controller,
      this.isDisabled = false,
      this.keyboardType = TextInputType.text,
      this.textLimit = 400,
      this.maxLine = 1,
      required this.onChange,
      required this.showError,
      this.hintText = '',
      this.errorText = '',
      this.doneButtonFocusNode,
      this.preText,
      this.alreadyEntered,
      this.padding = false,
      this.firstLetterCapital = false,
      this.showCount = false,
      this.isCreditCard = false,
      this.cardImage = '',
      this.isCvv = false,
      this.isCardDate = false,
      this.isSecure = false,
      this.suffixIcon,
      this.suffixIconTapped,
      this.customHeight = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ? EdgeInsets.symmetric(horizontal: 8) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (preText != null) ...[
            Row(
              children: [
                Text(
                  preText!,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextFormField(
                      enabled: !this.isDisabled,
                      controller: controller,
                      minLines: 1,
                      maxLines: maxLine,
                      maxLength: this.textLimit,
                      keyboardType: keyboardType,
                      textCapitalization: firstLetterCapital
                          ? TextCapitalization.words
                          : TextCapitalization.none,
                      focusNode: (this.keyboardType == TextInputType.number ||
                              this.keyboardType == TextInputType.phone)
                          ? doneButtonFocusNode!
                          : null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(this.textLimit),
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: hintText,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onChanged: this.onChange),
                ),
              ],
            ),
          ] else if (customHeight == 0) ...[
            TextFormField(
                enabled: !isDisabled,
                controller: controller,
                obscureText: isSecure,
                minLines: 1,
                maxLines: maxLine,
                maxLength: textLimit,
                keyboardType: keyboardType,
                textCapitalization: firstLetterCapital
                    ? TextCapitalization.words
                    : TextCapitalization.none,
                focusNode: (keyboardType == TextInputType.number ||
                        keyboardType == TextInputType.phone)
                    ? doneButtonFocusNode!
                    : null,
                inputFormatters: inputFormatters(),
                decoration: InputDecoration(
                  counterText: '',
                  labelText: hintText,
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  suffixIcon: makeSuffixIcon(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusColor: Colors.grey,
                ),
                onChanged: onChange),
          ] else ...[
            SizedBox(
              height: 50,
              child: TextFormField(
                  enabled: !isDisabled,
                  controller: controller,
                  obscureText: isSecure,
                  minLines: 1,
                  maxLines: maxLine,
                  maxLength: textLimit,
                  keyboardType: keyboardType,
                  textCapitalization: firstLetterCapital
                      ? TextCapitalization.words
                      : TextCapitalization.none,
                  focusNode: (keyboardType == TextInputType.number ||
                          keyboardType == TextInputType.phone)
                      ? doneButtonFocusNode!
                      : null,
                  inputFormatters: inputFormatters(),
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: hintText,
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    suffixIcon: makeSuffixIcon(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusColor: Colors.grey,
                  ),
                  onChanged: onChange),
            ),
          ],
        ],
      ),
    );
  }

  Widget? makeSuffixIcon() {
    if (this.suffixIcon != null) {
      return GestureDetector(
        onTap: suffixIconTapped,
        child: Icon(
          suffixIcon,
          color: kPrimaryColor,
        ),
      );
    }
    return isCreditCard ? buildCartIcon() : null;
  }

  List<TextInputFormatter> inputFormatters() {
    if (this.isCardDate) {
      return [
        LengthLimitingTextInputFormatter(this.textLimit),
        CardDateInputFormatter()
      ];
    }
    return isCreditCard
        ? [
            LengthLimitingTextInputFormatter(this.textLimit),
            CardInputFormatter()
          ]
        : [
            LengthLimitingTextInputFormatter(this.textLimit),
          ];
  }

  Widget buildCartIcon() {
    if (this.cardImage.isNotEmpty) {
      return Image.asset(
        'assets/images/$cardImage.png',
        width: 30,
      );
    }
    return Container(
      child: Icon(Icons.credit_card_outlined),
    );
  }
}

class CardInputFormatter extends TextInputFormatter {
  final String paddingCharacter = ' ';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    bool ignoreLatCharacted = false;

    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    if (oldValue.text.contains(paddingCharacter)) {
      if (newValue.text.length < oldValue.text.length) {
        var lastCharacter = oldValue.text
            .substring(oldValue.text.length - 2, oldValue.text.length - 1);

        if (lastCharacter == paddingCharacter) {
          ignoreLatCharacted = true;
        } else {
          ignoreLatCharacted = false;
        }
      }
      int lengthToCheck = text.length;
      if (ignoreLatCharacted) {
        lengthToCheck = lengthToCheck - 1;
      }

      for (int i = 0; i < lengthToCheck; i++) {
        buffer.write(text[i]);
        var nonZeroIndex = i + 1;
        if (i == 8 || i == 13 || i == 18) {
          addBuffer(oldValue, buffer, i);
        }
      }
    } else {
      for (int i = 0; i < text.length; i++) {
        buffer.write(text[i]);
        var nonZeroIndex = i + 1;
        if (nonZeroIndex == 4) {
          buffer.write(
              paddingCharacter); // Replace this with anything you want to put after each 4 numbers
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }

  void addBuffer(
    TextEditingValue oldValue,
    StringBuffer buffer,
    int mainIndex,
  ) {
    if (oldValue.text.length > mainIndex) {
      var cc = oldValue.text.substring(mainIndex + 1, mainIndex + 2);
    } else {
      buffer.write(
          paddingCharacter); // Replace this with anything you want to put after each 4 numbers
    }
  }
}

class CardDateInputFormatter extends TextInputFormatter {
  final String paddingCharacter = ' ';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    var buffer = new StringBuffer();

    if (newValue.text.length == 1 && newValue.text != '1') {
      if (oldValue.text.length > newValue.text.length) {
      } else {
        buffer.write('0');
      }
    }

    if (newValue.text.contains('/')) {
      for (int i = 0; i < text.length; i++) {
        buffer.write(text[i]);
      }
    } else {
      for (int i = 0; i < text.length; i++) {
        if (i == 2) {
          buffer.write('/');
        }
        buffer.write(text[i]);
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }

  void addBuffer(
    TextEditingValue oldValue,
    StringBuffer buffer,
    int mainIndex,
  ) {
    if (oldValue.text.length > mainIndex) {
      var cc = oldValue.text.substring(mainIndex + 1, mainIndex + 2);
    } else {
      buffer.write(
          paddingCharacter); // Replace this with anything you want to put after each 4 numbers
    }
  }
}
