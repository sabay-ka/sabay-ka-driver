// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/position_quality.dart';
import 'package:gem_kit/src/core/position_road_modifier.dart';

/// Position class
///
/// {@category Sensor Data Source}
class GemPosition {
  Coordinates _coords = Coordinates(latitude: 0.0, longitude: 0.0);
  double _alt = 0;
  double _speed = 0;
  double _course = 0;
  double _accuracyH = 0;
  double _accuracyV = 0;
  bool _hasCoordinates = false;
  bool _hasSpeed = false;
  PositionQuality _fixQuality = PositionQuality.invalid;
  final Set<RoadModifier> _roadModifiers = {};
  double _speedLimit = 0;
  DateTime _stamp = DateTime.fromMicrosecondsSinceEpoch(0);

  GemPosition();

  GemPosition.fromJson(Map<String, dynamic> json)
      : _coords = Coordinates.fromJson(json['coordinates']),
        _alt = json['alt'],
        _speed = json['kspeed'],
        _course = json['course'],
        _accuracyH = json['accuracyH'],
        _hasCoordinates = json["hasCoordinates"],
        _hasSpeed = json["hasSpeed"],
        _accuracyV = json['accuracyV'],
        _fixQuality = PositionQualityExtension.fromId(json['fix']) {
    _coords.altitude = _alt;
    _stamp = DateTime.fromMicrosecondsSinceEpoch(json['timestamp'] * 1000,
        isUtc: true);
    var speedLimit = json['speedLimit'];
    if (speedLimit != null) _speedLimit = speedLimit;

    var modifiers = json['roadModifiers'];
    if (modifiers != null && modifiers.isNotEmpty) {
      if (modifiers.indexOf("tunnel") != -1) {
        _roadModifiers.add(RoadModifier.tunnel);
      }
      if (modifiers.indexOf("bridge") != -1) {
        _roadModifiers.add(RoadModifier.bridge);
      }
      if (modifiers.indexOf("ramp") != -1) {
        _roadModifiers.add(RoadModifier.ramp);
      }
      if (modifiers.indexOf("tollway") != -1) {
        _roadModifiers.add(RoadModifier.tollway);
      }
      if (modifiers.indexOf("roundabout") != -1) {
        _roadModifiers.add(RoadModifier.roundabout);
      }
      if (modifiers.indexOf("oneWay") != -1) {
        _roadModifiers.add(RoadModifier.oneWay);
      }
      if (modifiers.indexOf("noUTurn") != -1) {
        _roadModifiers.add(RoadModifier.noUTurn);
      }
      if (modifiers.indexOf("leftDriveSide") != -1) {
        _roadModifiers.add(RoadModifier.leftDriveSide);
      }
    }
  }

  /// Geographical coordinates of the position.
  ///
  /// Contains given latitude, longitude and altitude
  Coordinates get coordinates => _coords;

  /// Altitude above main sea level.
  ///
  /// The altitude in meters.
  double get altitude => _alt;

  /// Travel speed in m/s.
  ///
  /// A negative value (-1 by default) means the position has no speed information.
  /// If car is going backwards, the course should change by 180, but the speed should still be non-negative.
  double get speed => _speed;

  /// The course (direction) of the movement.
  ///
  /// Represents true heading, not magnetic heading.
  /// 0 means true north, 90 east, 180 south, 270 west.
  /// A negative value (-1 by default) means the position has no course information.
  double get course => _course;

  /// Horizontal accuracy of position.
  ///
  /// Typical accuracy for consumer GPS is 5-20 meters.
  /// Valid position accuracy should always be positive.
  /// The horizontal position accuracy in meters.
  double get accuracyH => _accuracyH;

  /// Vertical accuracy of position.
  ///
  /// Valid position accuracy should always be positive.
  /// The vertical position accuracy in meters.
  double get accuracyV => _accuracyV;

  /// Query if this object has speed
  ///
  /// Returns true if speed is available and valid, false if not.
  bool get hasSpeed => _hasSpeed;

  /// Query if this object has coordinates
  ///
  /// Returns true if coordinates are available and valid, false if not.
  bool get hasCoordinates => _hasCoordinates;

  /// Fix quality (whether this position is trustworthy). See [PositionQuality] for details.
  PositionQuality get fixQuality => _fixQuality;

  //gemAddress get roadAddress => _addr;

  /// Road modifiers
  Set<RoadModifier> get roadModifiers => _roadModifiers;

  /// Get position road speed limit in m/s.
  ///
  /// If speed limit doesn't exist in map data, 0 is returned.
  double get speedLimit => _speedLimit;

  /// Satellite timestamp, milliseconds since 1970
  ///
  /// Timestamps are expected to increase monotonously for subsequent positions; data with timestamp from the past will be discarded.
  DateTime get timestamp => _stamp;
}
