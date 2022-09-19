class LoginResponse {
  //int? status;
  String? token;
  Data? data;
  String? message;

  //this.status
  LoginResponse({this.token, this.data, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];

    print('');

    /**/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['token'] = token;

    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }

    data['message'] = message;
    return data;
  }
}

class Data {
  User? user;
  List<Process>? process;
  ShiftStartDetails? shiftDetails;

  Data({this.user, this.process});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['process'] != null) {
      process = <Process>[];
      json['process'].forEach((v) {
        process!.add(Process.fromJson(v));
      });
    }

    if (json.keys.contains('shiftStartDetails')) {
      shiftDetails = json['shiftStartDetails'] != null
          ? ShiftStartDetails.fromJson(json['shiftStartDetails'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (process != null) {
      data['process'] = process!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? lastName;
  String? key;

  User({this.id, this.name, this.lastName, this.key});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['last_name'];
    key = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['last_name'] = lastName;
    data['key'] = key;
    return data;
  }
}

class Process {
  int? id;
  String? name;
  String? unit;
  String? baseline;
  String? headCount;

  Process({this.id, this.name});

  Process.fromJson(Map<String, dynamic> json) {
    if (json.keys.contains('process_id')) {
      id = json['process_id'];
    } else {
      id = json['id'];
    }

    name = json['processName'] ?? json['name'];
    unit = json['unit'];
    baseline = json['baseline'];
    headCount = json['head_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class ShiftStartDetails {
  int? executeShiftId;
  String? executeShiftStatus;
  String? executeShiftStartTime;
  String? executeShiftEndTime;
  int? processId;
  int? shiftId;
  String? shiftName;
  String? shiftStartTime;
  String? shiftEndTime;

  Process? process;

  ShiftStartDetails(
      {this.executeShiftId,
      this.executeShiftStatus,
      this.executeShiftStartTime,
      this.executeShiftEndTime,
      this.processId,
      this.shiftId,
      this.shiftName,
      this.shiftStartTime,
      this.shiftEndTime});

  ShiftStartDetails.fromJson(Map<String, dynamic> json) {
    executeShiftId = json['execute_shift_id'];
    executeShiftStatus = json['execute_shift_status'];
    executeShiftStartTime = json['execute_shift_start_time'];
    executeShiftEndTime = json['execute_shift_end_time'];
    processId = json['process_id'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
    shiftStartTime = json['shift_start_time'];
    shiftEndTime = json['shift_end_time'];
    process = Process.fromJson(json);
    print('object');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['execute_shift_id'] = this.executeShiftId;
    data['execute_shift_status'] = this.executeShiftStatus;
    data['execute_shift_start_time'] = this.executeShiftStartTime;
    data['execute_shift_end_time'] = this.executeShiftEndTime;
    data['process_id'] = this.processId;
    data['shift_id'] = this.shiftId;
    data['shift_name'] = this.shiftName;
    data['shift_start_time'] = this.shiftStartTime;
    data['shift_end_time'] = this.shiftEndTime;

    return data;
  }
}
