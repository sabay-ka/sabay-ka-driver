// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

/// @nodoc
///
/// {@category Core}
class Time {
  int? epoch;
  Time? localtime;
  Time? universaltime;
  int? year;
  int? month;
  int? day;
  int? dayofweek;
  int? hour;
  int? minute;
  int? second;
  int? millisecond;
  int? timezonemilliseconds;
  Time({
    this.epoch,
    this.localtime,
    this.universaltime,
    this.year,
    this.month,
    this.day,
    this.dayofweek,
    this.hour,
    this.minute,
    this.second,
    this.millisecond,
    this.timezonemilliseconds,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (epoch != null) {
      json['epoch'] = epoch;
    }
    if (localtime != null) {
      json['localtime'] = localtime;
    }
    if (universaltime != null) {
      json['universaltime'] = universaltime;
    }
    if (year != null) {
      json['year'] = year;
    }
    if (month != null) {
      json['month'] = month;
    }
    if (day != null) {
      json['day'] = day;
    }
    if (dayofweek != null) {
      json['dayofweek'] = dayofweek;
    }
    if (hour != null) {
      json['hour'] = hour;
    }
    if (minute != null) {
      json['minute'] = minute;
    }
    if (second != null) {
      json['second'] = second;
    }
    if (millisecond != null) {
      json['millisecond'] = millisecond;
    }
    if (timezonemilliseconds != null) {
      json['timezonemilliseconds'] = timezonemilliseconds;
    }
    return json;
  }

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      epoch: json['epoch'],
      localtime: json['localtime'],
      universaltime: json['universaltime'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      dayofweek: json['dayofweek'],
      hour: json['hour'],
      minute: json['minute'],
      second: json['second'],
      millisecond: json['millisecond'],
      timezonemilliseconds: json['timezonemilliseconds'],
    );
  }
}
