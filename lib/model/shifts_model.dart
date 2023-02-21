import 'package:intl/intl.dart';

class ShiftsResponse {
  String? message;
  List<ShiftItem>? data;

  ShiftsResponse({this.message, this.data});

  ShiftsResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    print(json['data'].first["shifts"]);

    message = json['message'];
    if (json['data'] != null) {
      data = [];
      data!.addAll(
        List<ShiftItem>.from(
            json['data'].first["shifts"].map((x) => ShiftItem.fromJson(x)))
          ..sort((a, b) => a.startDateObject.compareTo(b.startDateObject)),
      );
      data!.removeWhere((element) {
        if (element.started!) {
          return true;
        } else if (DateTime.now().isAfter(element.endDateObject)) {
          return true;
        } else {
          return false;
        }
      });
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
  int? patternId;
  int? breakTime;
  int? shiftMinutes;
  String? shiftDuration;
  bool? started;

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
      return _printDuration(check1);
    }
    return '';
  }

  String get timeRemaining {
    var check1 = endDateObject.difference(DateTime.now());
    if (check1.inSeconds > 0) {
      return _printDuration(check1);
    } else {
      check1 = endDateObject.difference(DateTime.now());
      return 'Over ' + "-" + _printDuration(check1).replaceAll("-", "");
    }
  }

  DateTime get startDateObject {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime!);
    return tempDate;
  }

  DateTime get endDateObject {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime!);
    return tempDate;
  }

  String get showStartTime {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime!);
    String date = DateFormat("hh:mm a").format(tempDate);
    if (tempDate.hour == 00 && date.contains("AM")) {
      date = date.replaceAll("AM", "PM");
    }
    return date;
  }

  String get showDate {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime!);
    String date = DateFormat("yyyy-MM-dd").format(tempDate);
    return date;
  }

  String get showStartDateOnly {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime!);
    String date = DateFormat("yyyy-MM-dd").format(tempDate);
    return date;
  }

  int get showStartTimeHour {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime!);
    String date = DateFormat("hh a")
        .format(tempDate)
        .replaceAll(' AM', '')
        .replaceAll(' PM', '');
    return int.parse(date);
  }

  int get showStartTimeMinute {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime!);
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

  String makeTimeStringFromHourMinuteMahboob(
      DateTime date, int hour, int minute) {
    final f = DateFormat('yyyy-MM-dd ');
    String hourString = hour.toString();
    String minuteString = minute.toString();
    if (hourString.length == 1) {
      hourString = '0' + hourString;
    }
    if (minuteString.length == 1) {
      minuteString = '0' + minuteString;
    }
    return f.format(date) + hourString + ':' + minuteString + ':00';
  }

  int get showEndTimeHour {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime!);
    String date = DateFormat("hh a")
        .format(tempDate)
        .replaceAll(' AM', '')
        .replaceAll(' PM', '');
    return int.parse(date);
  }

  int get showEndTimeMinute {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime!);
    String date = DateFormat("mm a")
        .format(tempDate)
        .replaceAll(' AM', '')
        .replaceAll(' PM', '');
    return int.parse(date);
  }

  String get showEndTime {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(endTime!);
    String date = DateFormat("hh:mm a").format(tempDate);
    return date;
  }

  ShiftItem({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.patternId,
    this.breakTime,
    this.shiftMinutes,
    this.shiftDuration,
    this.started,
  });

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
    String nextDate = DateFormat("yyyy-MM-dd")
        .format(startDateObject.add(Duration(minutes: json["shift_minutes"])));
    result = endTime!.replaceRange(0, 10, nextDate);
    endTime = result;
    displayScreen = int.parse(json['display_screen'] ?? 2.toString());
    if (displayScreen == 1) {
      displayScreen = 2;
    }
    patternId = json["pattern_id"] == null ? null : json["pattern_id"];
    breakTime = json["break_time"] == null ? null : json["break_time"];
    shiftMinutes = json["shift_minutes"] == null ? null : json["shift_minutes"];
    shiftDuration =
        json["shift_duration"] == null ? null : json["shift_duration"];
    started = json["started"] == null ? true : json["started"];
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
