import 'package:intl/intl.dart';

class ShiftsResponse {
  //int? status;
  String? message;
  List<ShiftItem>? data;

  ShiftsResponse({this.message, this.data});

  ShiftsResponse.fromJson(Map<String, dynamic> json) {
    print(json);

    message = json['message'];
    if (json['data'] != null) {
      data = <ShiftItem>[];
      data!.add(ShiftItem.fromJson(json['data']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShiftItem {
  int? id;
  String? name;
  String? startTime;
  String? endTime;
  int? displayScreen;
  String? displayScreenMessage;
  String? displayScreenReady;

  int? executedShiftId;

  bool shiftStartTimeCustomized = false;
  bool shiftEndTimeCustomized = false;

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String get timeElasped {
    var check1 = DateTime.now().difference(startDateObject);

    if (check1.inSeconds > 0) {
      // event already passed
      var differance = DateTime.now().difference(endDateObject);

      int sec = differance.inSeconds;

      int hoursdone = check1.inHours;
      int minutes = check1.inMinutes - (hoursdone * 60);

      int remainingSeconds = check1.inHours * 60 * 60;
      return _printDuration(check1);
    } else {}

    return '';
  }

  String get timeRemaining {
    var check1 = endDateObject.difference(DateTime.now());

    if (check1.inSeconds > 0) {
      // event already passed
      var differance = DateTime.now().difference(endDateObject);

      int sec = differance.inSeconds;

      int hoursdone = check1.inHours;
      int minutes = check1.inMinutes - (hoursdone * 60);

      int remainingSeconds = check1.inHours * 60 * 60;
      return _printDuration(check1);
    } else {
      var differance = endDateObject.difference(DateTime.now());

      check1 = DateTime.now().difference(endDateObject);

      return 'Over ' + _printDuration(check1);
    }

    return '';
  }

  DateTime get startDateObject {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(startTime!);
    return tempDate;
  }

  DateTime get endDateObject {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(endTime!);
    return tempDate;
  }

  String get showStartTime {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(startTime!);
    String date = DateFormat("hh:mm a").format(tempDate);
    return date;
  }

  String get showDate {
    //2022/12/01
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(startTime!);
    String date = DateFormat("yyyy/MM/dd").format(tempDate);
    return date;
  }

  String get showStartDateOnly {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(startTime!);
    String date = DateFormat("yyyy-MM-dd").format(tempDate);
    return date;
  }

  int get showStartTimeHour {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(startTime!);
    String date = DateFormat("hh a")
        .format(tempDate)
        .replaceAll(' AM', '')
        .replaceAll(' PM', '');
    return int.parse(date);
  }

  int get showStartTimeMinute {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(startTime!);
    String date = DateFormat("mm a")
        .format(tempDate)
        .replaceAll(' AM', '')
        .replaceAll(' PM', '');
    return int.parse(date);
  }

  String makeTimeStringFromHourMinute(int hour, int minute) {
    final f = DateFormat('yyyy-MM-dd ');

    String hourString = hour.toString();
    String minuteString = minute.toString();

    if (hourString.length == 1) {
      hourString = '0' + hourString;
    }
    if (minuteString.length == 1) {
      minuteString = '0' + minuteString;
    }
    return f.format(DateTime.now()) + hourString + ':' + minuteString + ':00';
  }

  int get showEndTimeHour {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(endTime!);
    String date = DateFormat("hh a")
        .format(tempDate)
        .replaceAll(' AM', '')
        .replaceAll(' PM', '');
    return int.parse(date);
  }

  int get showEndTimeMinute {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(endTime!);
    String date = DateFormat("mm a")
        .format(tempDate)
        .replaceAll(' AM', '')
        .replaceAll(' PM', '');
    return int.parse(date);
  }

  String get showEndTime {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(endTime!);
    String date = DateFormat("hh:mm a").format(tempDate);
    return date;
  }

  ShiftItem({this.id, this.name, this.startTime, this.endTime});

  ShiftItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startTime = json['start_time'];
    displayScreenMessage = json['display_screen_message'];
    displayScreenReady = json['display_screen_already'];

    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());

    var result = startTime!.replaceRange(0, 10, date);

    startTime = result;

    endTime = json['end_time'];

    result = endTime!.replaceRange(0, 10, date);
    endTime = result;

    displayScreen = int.parse(json['display_screen']);
    if (displayScreen == 1) {
      displayScreen = 2;
    }
    // //displayScreen = 3;
    // displayScreen = 2;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}

class ShiftStartModel {
  int? code;
  String? status;
  String? message;
  ShiftStartData? data;

  ShiftStartModel({this.code, this.status, this.message, this.data});

  ShiftStartModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ShiftStartData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ShiftStartData {
  int? id;
  int? userId;
  int? shiftId;
  int? processId;
  String? startTime;
  String? endTime;

  ShiftStartData(
      {this.id,
      this.userId,
      this.shiftId,
      this.processId,
      this.startTime,
      this.endTime});

  ShiftStartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shiftId = json['shift_id'];
    processId = json['process_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['shift_id'] = shiftId;
    data['process_id'] = processId;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
