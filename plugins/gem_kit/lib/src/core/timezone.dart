// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:gem_kit/src/core/time.dart';

/// Enum with all service status
///
/// {@category Core}
enum TimezoneStatus {
  /// Indicates that the request was successful
  success,

  /// Indicates that the request has called with wrong coordinate value. Coordinate is valid if -90 <= latitude <= 90 and -180 <= longitude <= 180
  invalidCoordinate,

  /// Indicates that the request has called with non existing timezones
  wrongTimezoneId,

  /// Indicates that the request has called with wrong timestamp value
  wrongTimestamp,

  /// Indicates that the request has called with non existing timezones
  timezoneNotFound,
}

/// @nodoc
///
/// {@category Core}
extension TimezoneStatusExtension on TimezoneStatus {
  int get id {
    switch (this) {
      case TimezoneStatus.success:
        return 0;
      case TimezoneStatus.invalidCoordinate:
        return 1;
      case TimezoneStatus.wrongTimezoneId:
        return 2;
      case TimezoneStatus.wrongTimestamp:
        return 3;
      case TimezoneStatus.timezoneNotFound:
        return 4;
    }
  }

  static TimezoneStatus fromId(int id) {
    switch (id) {
      case 0:
        return TimezoneStatus.success;
      case 1:
        return TimezoneStatus.invalidCoordinate;
      case 2:
        return TimezoneStatus.wrongTimezoneId;
      case 3:
        return TimezoneStatus.wrongTimestamp;
      case 4:
        return TimezoneStatus.timezoneNotFound;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Defines a timezone result.
///
/// {@category Core}
class TimezoneResult {
  /// The offset for daylight-savings time.
  int? dstoffset;

  /// The calculated offset (in seconds) for the given location.
  int? offset;

  /// The offset from UTC (in seconds) for a given location.
  int? utcoffset;

  /// Get the status of the response.
  TimezoneStatus? status;

  /// Get the ID of the timezone.
  String? timezoneid;

  /// Get the local time of the timezone in relation to query time.
  Time? localtime;

  TimezoneResult({
    this.dstoffset,
    this.offset,
    this.utcoffset,
    this.status,
    this.timezoneid,
    this.localtime,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (dstoffset != null) {
      json['dstoffset'] = dstoffset;
    }
    if (offset != null) {
      json['offset'] = offset;
    }
    if (utcoffset != null) {
      json['utcoffset'] = utcoffset;
    }
    if (status != null) {
      json['status'] = status!.id;
    }
    if (timezoneid != null) {
      json['timezoneid'] = timezoneid;
    }
    if (localtime != null) {
      json['localtime'] = localtime;
    }
    return json;
  }

  factory TimezoneResult.fromJson(Map<String, dynamic> json) {
    return TimezoneResult(
      dstoffset: json['dstoffset'],
      offset: json['offset'],
      utcoffset: json['utcoffset'],
      status: json['status'],
      timezoneid: json['timezoneid'],
      localtime: json['localtime'],
    );
  }
}
