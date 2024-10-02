// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'dart:math';

/// Coordinates class
///
/// {@category Core}
class Coordinates {
  /// Latitude in degrees. Valid values -90.0 .. +90.00.
  double? latitude;

  /// Longitude in degrees. Valid values -180.0 .. +180.00.
  double? longitude;

  /// Altitude in meters.
  double? altitude;

  /// Horizontal accuracy of the location in meters.
  @Deprecated('horizontal & vertical accuracy were removed from Coordinates')
  double? horizontalaccuracy;

  /// Vertical accuracy of the location in meters.
  @Deprecated('horizontal & vertical accuracy were removed from Coordinates')
  double? verticalaccuracy;

  /// Parent scene object to which coordinates belongs.
  /// Scene object id.
  int? sceneobject;

  /// Create a coordinates object from latitude, longitude and altitude.
  ///
  /// **Parameters**
  /// * **IN** *latitude* Latitude in degrees. Valid values **-90.0 - +90.0**.
  /// * **IN** *longitude* Longitude in degrees. Valid values **-180.0 - +180.0**.
  /// * **IN** *altitude* Altitude in meters.
  /// * **IN** *horizontalaccuracy* Latitude / longitude accuracy in meters. Deprecated, will be ignored.
  /// * **IN** *verticalaccuracy* Altitude accuracy in meters. Deprecated, will be ignored.
  /// * **IN** *sceneobject* Parent scene object in which coordinates system values are expressed.
  Coordinates({
    this.latitude,
    this.longitude,
    this.altitude = 0,
    this.horizontalaccuracy = 0,
    this.verticalaccuracy = 0,
    this.sceneobject = 0,
  });

  /// Create a new coordinates object with the same proprieties as the original.
  ///
  /// **Returns**
  /// * a new Coordinates object with the same proprieties
  Coordinates get copy {
    return Coordinates(
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      horizontalaccuracy: horizontalaccuracy,
      verticalaccuracy: verticalaccuracy,
      sceneobject: sceneobject,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (latitude != null) {
      json['latitude'] = latitude;
    }
    if (longitude != null) {
      json['longitude'] = longitude;
    }
    if (altitude != null) {
      json['altitude'] = altitude;
    }
    if (horizontalaccuracy != null) {
      json['horizontalaccuracy'] = horizontalaccuracy;
    }
    if (verticalaccuracy != null) {
      json['verticalaccuracy'] = verticalaccuracy;
    }
    if (sceneobject != null) {
      json['sceneobject'] = sceneobject;
    }
    return json;
  }

  /// Calculate the distance in meters between two WGS84 coordinates.
  ///
  /// **Parameters**
  /// * **IN** *other* The other coordinates
  ///
  /// **Returns**
  /// Distance in meters between current current coordinates and the [other] parameter
  double distance(Coordinates other) {
    const double earthRadius = 6371000; // Earth's radius in meters

    double toRadians(double value) {
      return value * pi / 180; // Convert degrees to radians
    }

    double deltaLatitude = toRadians(other.latitude! - latitude!);
    double deltaLongitude = toRadians(other.longitude! - longitude!);

    double a = sin(deltaLatitude / 2) * sin(deltaLatitude / 2) +
        cos(toRadians(latitude!)) *
            cos(toRadians(other.latitude!)) *
            sin(deltaLongitude / 2) *
            sin(deltaLongitude / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double altitudeDifference = 0;
    if (other.altitude != null && altitude != null) {
      altitudeDifference = other.altitude! - altitude!;
    }

    double distance = sqrt((c * c * earthRadius * earthRadius) +
        (altitudeDifference * altitudeDifference));

    return distance;
  }

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['altitude'],
      horizontalaccuracy: json['horizontalaccuracy'],
      verticalaccuracy: json['verticalaccuracy'],
      sceneobject: json['sceneobject'],
    );
  }

  /// Checks if the coordinates are valid
  bool get isValid {
    const maxInt32 = (1 << 31) - 1;

    return (latitude?.toInt() != maxInt32 && longitude?.toInt() != maxInt32) &&
        (latitude != -99999 && longitude != -99999);
  }

  /// Creates a new coordinates object with the given meters offset
  ///
  /// **Parameters**
  /// * **IN** *metersLatitude* Latitude offset in meters
  /// * **IN** *metersLongitude* Longitude offset in meters
  ///
  /// **Returns**
  /// * a new Coordinates object with the given meters offset
  Coordinates copyWithMetersOffset(
      {required int metersLatitude, required int metersLongitude}) {
    if (latitude == null || longitude == null) return Coordinates();

    const double earthRadius = 6371000; // Earth's radius in meters
    double latitudeInDegrees = metersLatitude / earthRadius * (180 / pi);
    double longitudeInDegrees = metersLongitude /
        (earthRadius * cos(latitude! * pi / 180)) *
        (180 / pi);

    return Coordinates(
      latitude: latitude! + latitudeInDegrees,
      longitude: longitude! + longitudeInDegrees,
      altitude: altitude,
      horizontalaccuracy: horizontalaccuracy,
      verticalaccuracy: verticalaccuracy,
      sceneobject: sceneobject,
    );
  }

  @override
  bool operator ==(covariant Coordinates other) {
    if (identical(this, other)) return true;

    return other.latitude == latitude &&
        other.longitude == longitude &&
        other.altitude == altitude;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^ longitude.hashCode ^ altitude.hashCode;
  }

  @override
  String toString() {
    return 'Coordinates(lat: $latitude, long: $longitude, alt: $altitude, ha: $horizontalaccuracy, va: $verticalaccuracy, so: $sceneobject)';
  }
}
