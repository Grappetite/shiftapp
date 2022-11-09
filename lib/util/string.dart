import 'dart:math';

import 'package:intl/intl.dart';

extension StringExtension on String {
  formatDateTime(String format) =>
      DateFormat(format).format(DateTime.parse(this).toLocal());

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length,
          (_) => allChars.codeUnitAt(Random().nextInt(allChars.length))));

  static String get allChars {
    return 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  }

  String get timeToShow {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(this);
    String date = DateFormat("hh:mm a").format(tempDate);
    if (tempDate.hour == 00 && date.contains("AM")) {
      if (DateTime.now().day == tempDate.day &&
          DateTime.now().month == tempDate.month) {
        date = date.replaceAll("AM", "PM");
      }
    }
    return date;
  }

  static String makeYearMonthDateStringFromDigits(String newValue) {
    String tmpString = newValue;
    var year = tmpString.substring(0, 2);
    var month = tmpString.substring(2, 4);
    var date = tmpString.substring(4, 6);
    if (int.parse(year) > 0 && int.parse(year) < 22) {
      year = '20' + year;
    } else {
      year = '19' + year;
    }
    return year + month + date;
  }

  static String makeDDMMYYYYString(String input, {String gapString = '/'}) {
    String tmpString = input;
    var year = tmpString.substring(0, 2);
    var month = tmpString.substring(2, 4);
    var date = tmpString.substring(4, 6);
    if (int.parse(year) > 0 && int.parse(year) < 21) {
      year = '20' + year;
    } else {
      year = '19' + year;
    }

    String dateString = date + gapString + month + gapString + year;
    return dateString;
  }

  String makeGenderString() {
    var lastCharaater = '';

    if (this.length == 12) {
      lastCharaater = substring(11, 12);
    } else {
      return '';
    }

    int genderNumber = int.parse(lastCharaater);

    try {
      if (genderNumber % 2 == 0) {
        return 'Female';
      } else if (genderNumber % 2 == 1) {
        return 'Male';
      }
    } catch (e) {
      return '';
    }

    return '';
  }

  String stringBeforeCharacter({String sub = '|'}) {
    String tmp = this.substring(0, this.indexOf(sub));

    return tmp;
  }

  String removeExtraFromCountry({String characted = '-'}) {
    String tmp = this.substring(this.indexOf(characted) + 1, this.length);

    return tmp;
  }

  bool containsIgnoreCase(String keyword) {
    return this.toLowerCase().contains(keyword.toLowerCase());
  }
}
