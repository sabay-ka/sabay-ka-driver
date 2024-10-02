// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:gem_kit/src/core/coordinates.dart';

/// Timestamp & distance & coordinates structure
///
/// {@category Core}
class TimeDistanceCoordinate {
  /// WGS coordinates.
  Coordinates? coords;

  /// Relative distance in meters.
  int? distance;

  /// Time stamp in milliseconds.
  int? stamp;

  /// Creates a new time distance coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinates.
  /// * **IN** *distance* The distance in meters.
  /// * **IN** *stamp* The time stamp in milliseconds.
  TimeDistanceCoordinate({
    this.coords,
    this.distance,
    this.stamp,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (coords != null) {
      json['coords'] = coords;
    }
    if (distance != null) {
      json['distance'] = distance;
    }
    if (stamp != null) {
      json['stamp'] = stamp;
    }
    return json;
  }

  factory TimeDistanceCoordinate.fromJson(Map<String, dynamic> json) {
    return TimeDistanceCoordinate(
      coords: Coordinates.fromJson(json['coords']),
      distance: json['distance'],
      stamp: json['stamp'],
    );
  }

  @override
  bool operator ==(covariant TimeDistanceCoordinate other) {
    if (identical(this, other)) return true;

    return other.coords == coords &&
        other.distance == distance &&
        other.stamp == stamp;
  }

  @override
  int get hashCode {
    return coords.hashCode ^ distance.hashCode ^ stamp.hashCode;
  }
}
