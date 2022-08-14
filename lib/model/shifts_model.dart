import 'package:intl/intl.dart';

class ShiftsResponse {
  //int? status;
  String? message;
  List<ShiftItem>? data;

  //this.status
  ShiftsResponse({this.message, this.data});

  ShiftsResponse.fromJson(Map<String, dynamic> json) {
   // status = json['status'];
    print(json);

    message = json['message'];
    if (json['data'] != null) {
      data = <ShiftItem>[];
      data!.add(ShiftItem.fromJson(json['data']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    //data['status'] = status;
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

  String get showStartTime {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(startTime!);
    String date = DateFormat("hh:mm a").format(tempDate);
    return date;
  }

  String get showEndTime {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(endTime!);
    String date = DateFormat("hh:mm a").format(tempDate);
    return date;
  }

  /*
  {id: 1, name: Shift 1, start_time: 2022-01-01 06:00:00, end_time: 2022-01-01 14:00:00, display_screen: 2}}

  * */
  ShiftItem({this.id, this.name, this.startTime, this.endTime});

  ShiftItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startTime = json['start_time'];
    endTime = json['end_time'];

    displayScreen = int.parse(json['display_screen']);;
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
    data = json['data'] != null ?  ShiftStartData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['shift_id'] = shiftId;
    data['process_id'] = processId;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}