import 'package:flutter/material.dart';
import 'package:shiftapp/util/string.dart';

class ValidatorsHelper {
  String requiredMessage = '';
  String invalid;

  ValidatorsHelper({required this.requiredMessage, this.invalid = ''});

  static bool? validateEmail(String input) {
    const String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return (!RegExp(emailPattern, caseSensitive: false).hasMatch(input));
  }

  static String? validateSecurityPhrase(String input) {
    if (input.isEmpty) {
      return 'Required';
    }
    const String pt = r'^[a-zA-Z0-9]+$';
    if (!RegExp(pt).hasMatch(input))
      return 'Security invalid';
    else {
      return null;
    }
  }

  static bool isAlphaNumericOnly(String input) {
    const String pt = r'^[a-zA-Z0-9]+$';
    return RegExp(pt).hasMatch(input);
  }

  static bool? checkLeastOneUperCase(String input) {
    const String pt = r'^(?=.*[A-Z])';
    return RegExp(pt).hasMatch(input);
  }

  static bool? checkLeastOneLowerCase(String input) {
    const String pt = r'^(.*[a-z].*)';
    return RegExp(pt).hasMatch(input);
  }

  static bool? checkLeastOneDigit(String input) {
    const String pt = r'^(?=.*?[0-9])';
    return RegExp(pt).hasMatch(input);
  }

  static bool? checkLeastSpecialCharacter(String input) {
    const String pt = r'^(?=.*[@#$%^&+=])';
    return RegExp(pt).hasMatch(input);
  }

  static bool? checkAllCharacterUpperCase(String input) {
    const String pt = r'^[A-Z\s]+';
    return RegExp(pt).hasMatch(input);
  }

  static bool? checkAllCharacterLowerCase(String input) {
    const String pt = r'^[a-z\s]+';
    return RegExp(pt).hasMatch(input);
  }

  static bool containerSpace(String str) {
    if (str.indexOf(' ') >= 0) {
      return true;
    }
    return false;
  }

  static bool isTextOnlyNumber(String text) {
    bool tmp = text.contains(new RegExp(r'[a-z]')) ||
        text.contains(new RegExp(r'[A-Z]')) ||
        text.contains(new RegExp(r'[!@#$%^&*()+,.?":{}|<>]'));
    return !tmp;
  }

  String valideIdNumber(String idNum, String type, String fieldName,
      {bool checkEmpty = true}) {
    if (fieldName == 'IC') {
      fieldName = 'New IC';
    }
    if (idNum.isEmpty) {
      return checkEmpty ? requiredMessage : '';
    }
    if (type == '') {
      return '$invalid ID Number';
    }
    String errorText = '';

    if (idNum.length == 0) {
      return this.requiredMessage;
    } else {
      if (type == 'New IC' || type == 'IC') {
        bool tmp = idNum.contains(new RegExp(r'[a-z]')) ||
            idNum.contains(new RegExp(r'[A-Z]')) ||
            idNum.contains(new RegExp(r'[!@#$%^&*()+,.?":{}|<> ]'));
        if (tmp) {
          return '$invalid $fieldName';
        }

        bool tmp2 = (idNum.length == 12);
        bool tmp3 = true;

        if (idNum.length > 6) {
          String subDateString = idNum.substring(0, 6);

          bool dateFlag = ValidatorsHelper.isValidDate(subDateString);
          if (!dateFlag) {
            return '$invalid $fieldName';
          }
        }
        if (tmp2 == false) {
          return '$invalid $fieldName';
        }

        if (tmp3 && tmp2 && !tmp) {
          return '';
        } else {
          return errorText;
        }
      } else if (type == 'Passport No.') {
        bool tmp = idNum.contains(RegExp(r'[!@#$%^&*()+,.?":{}|<> ]'));

        if (tmp) {
          return '$invalid $fieldName';
        }

        bool tmp2 = (idNum.length < 20);
        if (tmp2 == false) {
          return '$invalid $fieldName';
        }

        if (tmp2 && !tmp) {
          errorText = '';
        } else {
          return errorText;
        }
      } else if (type == 'PR No.') {
        bool tmp = idNum.contains(RegExp(r'[!@#$%^&*()+,.?":{}| <>]'));

        if (tmp) {
          return '$invalid $fieldName';
        }

        bool tmp2 = (idNum.length > 4 && idNum.length < 21);
        if (tmp2 == false) {
          return '$invalid $fieldName';
        }

        if (tmp2 && !tmp) {
          return errorText = '';
        } else {
          return errorText;
        }
      } else {
        bool tmp = idNum.contains(RegExp(r'[!@#$%^&*()+,.?":{}|<> ]'));

        if (tmp) {
          return '$invalid $fieldName';
        }
        bool tmp2 = (idNum.length > 4 && idNum.length < 21);
        if (tmp2 == false) {
          return '$invalid $fieldName';
        }

        return errorText;
      }
    }
    return '';
  }

  String checkAdress(String address, String fieldName,
      {bool checkEmpty = true}) {
    if (address.length == 0) {
      return checkEmpty ? this.requiredMessage : '';
    }

    bool tmp = address.contains(RegExp(r'[<>^]')); //|:.

    if (tmp) {
      return '$invalid $fieldName';
    }

    return '';
  }

  String checkName(String businessName, String fieldName,
      {bool allowSpace = false, bool isRequired = true}) {
    if (businessName.length == 0) {
      return isRequired ? this.requiredMessage : '';
    }
    bool tmp = businessName.contains(RegExp(r'[!#$%^&*()+,?":{}|<>]'));

    String error = '';

    if (tmp) {
      return '$invalid $fieldName';
    }
    if (!allowSpace) {
      bool tmp2 = containerSpace(businessName);
      if (tmp2) {
        return '$invalid $fieldName';
      }
    }

    return '';
  }

  String checkBuisinessName(String businessName, String fieldName,
      {bool allowSpace = false, bool isRequired = true}) {
    if (businessName.length == 0) {
      return isRequired ? this.requiredMessage : '';
    }
    bool tmp = businessName.contains(RegExp(r'[(;%:^+|<>)]'));

    String error = '';

    if (tmp) {
      return '$invalid $fieldName';
    }
    if (!allowSpace) {
      bool tmp2 = containerSpace(businessName);
      if (tmp2) {
        return '$invalid $fieldName';
      }
    }

    return '';
  }

  String validateEmailString(String email, {bool checkEmpty = true}) {
    if (email.isEmpty) {
      return checkEmpty ? this.requiredMessage : '';
    }

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (!emailValid) {
      return 'Invalid email address';
    }
    return '';
  }

  String validateOnlyNumberEntered(String number, String fieldName,
      {bool checkEmpty = true}) {
    if (number.isEmpty) {
      return checkEmpty ? this.requiredMessage : '';
    }

    if (isTextOnlyNumber(number)) {
      return '';
    }
    return '$invalid $fieldName';
  }

  String validateMobileNo(String mobileNo, String nameOfField,
      {bool checkEmpty = true, bool checkStarting = true}) {
    if (mobileNo.length == 0) {
      return checkEmpty ? requiredMessage : '';
    }

    /*
    if (secondPossibleInitiital.length > 0 && mobileNo.length > 3) {
      String tmp = mobileNo.substring(0, secondPossibleInitiital.length);
      if (tmp != secondPossibleInitiital) {
        return this.invalid + ' ' + nameOfField;
      }
    }*/
    if (mobileNo.contains(RegExp(r'[A-Z]'))) {
      return this.invalid + ' ' + nameOfField;
    } else if (mobileNo.contains(RegExp(r'[a-z]'))) {
      return this.invalid + ' ' + nameOfField;
    }

    if (!checkStarting) {
      if (mobileNo.contains(RegExp(r'[!@#$%^/&*+(),?.":{}|<>]')) ||
          mobileNo.length < 8 ||
          (mobileNo.length > 11) ||
          (mobileNo.length > 12)) {
        return this.invalid + ' ' + nameOfField;
      }
    } else if (mobileNo.characters.first == '6') {
      if (mobileNo.length > 3) {
        if (mobileNo.substring(0, 3) == '601') {
          if (mobileNo.contains(RegExp(r'[!@#$%^/&*+(),?.":{}|<>]')) ||
              !(mobileNo.characters.first == '6' ||
                  mobileNo.characters.first == '0') ||
              mobileNo.length < 10 ||
              (mobileNo.length > 11 && mobileNo.characters.first == '0') ||
              (mobileNo.length > 12 && mobileNo.characters.first == '6')) {
            return this.invalid + ' ' + nameOfField;
          }
        } else {
          return this.invalid + ' ' + nameOfField;
        }
      } else {
        return this.invalid + ' ' + nameOfField;
      }
    } else if (mobileNo.characters.first == '0') {
      if (mobileNo.length > 2) {
        if (mobileNo.substring(0, 2) == '01') {
          if (mobileNo.contains(RegExp(r'[!@#$%^/&*+(),?.":{}|<>]')) ||
              !(mobileNo.characters.first == '6' ||
                  mobileNo.characters.first == '0') ||
              mobileNo.length < 10 ||
              (mobileNo.length > 11 && mobileNo.characters.first == '0') ||
              (mobileNo.length > 12 && mobileNo.characters.first == '6')) {
            return invalid + ' ' + nameOfField;
          }
        } else {
          return invalid + ' ' + nameOfField;
        }
      } else {
        return invalid + ' ' + nameOfField;
      }
    } else {
      return invalid + ' ' + nameOfField;
    }

    return '';
  }

  String checkWebAddress(String input, String fieldName,
      {bool checkEmpty = true}) {
    if (input.isEmpty) {
      return checkEmpty ? this.requiredMessage : '';
    }
    bool _validURL = Uri.parse(input).isAbsolute;
    if (!_validURL) {
      if (!input.contains('http:\\')) {
        return this.checkWebAddress('http:\\' + '\\' + input, fieldName,
            checkEmpty: checkEmpty);
      }
      return this.invalid + ' ' + fieldName;
    }
    return '';
  }

  static bool isValidDate(String input /*yyyyMMdd*/) {
    try {
      input = StringExtension.makeYearMonthDateStringFromDigits(input);

      final date = DateTime.parse(input);
      final originalFormatString = toOriginalFormatString(date);

      return input == originalFormatString;
    } catch (e) {
      return false;
    }
  }

  static String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }
}
