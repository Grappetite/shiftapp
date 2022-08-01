class ShiftsResponse {
  int? status;
  String? message;
  List<ShiftItem>? data;

  ShiftsResponse({this.status, this.message, this.data});

  ShiftsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ShiftItem>[];
      json['data'].forEach((v) {
        data!.add(ShiftItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
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

  ShiftItem({this.id, this.name, this.startTime, this.endTime});

  ShiftItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
