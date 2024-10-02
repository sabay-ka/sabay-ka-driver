// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/core/coordinates.dart';

/// Types of geographic areas
///
/// {@category Core}
enum GeographicAreaType {
  // Undefined
  undefined,

  // Circle area
  circle,

  // Rectangle area
  rectangle,

  // Polygon area
  polygon,

  // Area representing as a collection of tiles
  tileCollection,
}

/// @nodoc
///
/// {@category Core}
extension GeographicAreaTypeExtension on GeographicAreaType {
  int get id {
    switch (this) {
      case GeographicAreaType.undefined:
        return 0;
      case GeographicAreaType.circle:
        return 1;
      case GeographicAreaType.rectangle:
        return 2;
      case GeographicAreaType.polygon:
        return 3;
      case GeographicAreaType.tileCollection:
        return 4;
    }
  }

  static GeographicAreaType fromId(int id) {
    switch (id) {
      case 0:
        return GeographicAreaType.undefined;
      case 1:
        return GeographicAreaType.circle;
      case 2:
        return GeographicAreaType.rectangle;
      case 3:
        return GeographicAreaType.polygon;
      case 4:
        return GeographicAreaType.tileCollection;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// This object represents a geographical area on the surface of a WGS 84 Ellipsoid.
///
/// In the calculations related to these geographical areas the altitude information contained in the Coordinates
/// object is ignored. All geographical areas deal with [Coordinates] objects.
///
/// {@category Core}
abstract class GeographicArea {
  /// Checks if the specified point is contained within the geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *point* A [Coordinates] object representing the point to check.
  ///
  /// **Returns**
  ///
  /// * True if the point is within the geographic area, false otherwise.
  bool containsCoordinates(Coordinates point);

  /// Get the bounding box.
  /// This is the smallest rectangle that can be drawn around the area such that it surrounds this geographic area
  /// completely.
  ///
  /// If the area is bigger than what is allowed in the WGS 84 coordinate system, the rectangle is truncated to valid
  /// WGS 84 coordinate values. The RectangleGeographicArea is always aligned with parallels and meridians.
  ///
  /// **Returns**
  /// * A [RectangleGeographicArea] object representing the bounding box.
  RectangleGeographicArea get boundingBox;

  /// Retrieves the center point of the geographic area.
  /// Calculates and returns the geographic center of the area.
  ///
  /// **Returns**
  ///
  /// * [Coordinates] object representing the center point of the area.
  Coordinates get centerPoint;

  /// Checks if the geographic area is empty.
  ///
  /// **Returns**
  ///
  /// * true if the area is empty, false otherwise.
  bool get isEmpty;

  /// Retrieves the specific type of the geographic area.
  ///
  /// **Returns**
  ///
  /// * The [GeographicAreaType] of the area.
  GeographicAreaType get type;
}

/// RectangleGeographicArea object.
///
/// {@category Core}
class RectangleGeographicArea implements GeographicArea {
  Coordinates? topLeft;
  Coordinates? bottomRight;
  RectangleGeographicArea({
    this.topLeft,
    this.bottomRight,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (topLeft != null) {
      json['topleft'] = topLeft!.toJson();
    }
    if (bottomRight != null) {
      json['bottomright'] = bottomRight!.toJson();
    }
    return json;
  }

  factory RectangleGeographicArea.fromJson(Map<String, dynamic> json) {
    return RectangleGeographicArea(
      topLeft: Coordinates.fromJson(json['topleft']),
      bottomRight: Coordinates.fromJson(json['bottomright']),
    );
  }

  /// Checks if this rectangle intersects with another rectangle.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The [RectangleGeographicArea] to check intersection with.
  ///
  /// **Returns**
  ///
  /// * True if the rectangles intersect, false otherwise.
  bool intersects(RectangleGeographicArea area) {
    if (_hasNullLongitudeOrLatitude) return false;
    if (area._hasNullLongitudeOrLatitude) return false;

    return bottomRight!.longitude! >= area.topLeft!.longitude! &&
        area.bottomRight!.longitude! >= topLeft!.longitude! &&
        topLeft!.latitude! >= area.bottomRight!.latitude! &&
        area.topLeft!.latitude! >= bottomRight!.latitude!;
  }

  /// Checks if this rectangle completely contains another rectangle.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The [RectangleGeographicArea] to check containment of.
  ///
  /// **Returns**
  ///
  /// * True if this rectangle contains the other, false otherwise.
  bool contains(RectangleGeographicArea area) {
    if (_hasNullLongitudeOrLatitude) return false;
    if (area._hasNullLongitudeOrLatitude) return false;

    return bottomRight!.longitude! >= area.bottomRight!.longitude! &&
        topLeft!.longitude! <= area.topLeft!.longitude! &&
        topLeft!.latitude! >= area.topLeft!.latitude! &&
        bottomRight!.latitude! <= area.bottomRight!.latitude!;
  }

  /// Creates a new RectangleGeographicArea as the union of this rectangle and another.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The [RectangleGeographicArea] to unite with.
  ///
  /// **Returns**
  ///
  /// * A new [RectangleGeographicArea] object representing the union.
  RectangleGeographicArea makeUnion(RectangleGeographicArea area) {
    if (_hasNullLongitudeOrLatitude) return RectangleGeographicArea();
    if (area._hasNullLongitudeOrLatitude) return RectangleGeographicArea();

    return RectangleGeographicArea(
      topLeft: Coordinates(
        longitude: min(topLeft!.longitude!, area.topLeft!.longitude!),
        latitude: max(topLeft!.latitude!, area.topLeft!.latitude!),
      ),
      bottomRight: Coordinates(
        longitude: max(bottomRight!.longitude!, area.bottomRight!.longitude!),
        latitude: min(bottomRight!.latitude!, area.bottomRight!.latitude!),
      ),
    );
  }

  /// Creates a new RectangleGeographicArea as the intersection of this rectangle and another.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The [RectangleGeographicArea] to intersect with.
  ///
  /// **Returns**
  ///
  /// * A new [RectangleGeographicArea] object representing the intersection.
  RectangleGeographicArea makeIntersection(RectangleGeographicArea area) {
    if (_hasNullLongitudeOrLatitude) return RectangleGeographicArea();
    if (area._hasNullLongitudeOrLatitude) return RectangleGeographicArea();

    return RectangleGeographicArea(
      topLeft: Coordinates(
        longitude: max(topLeft!.longitude!, area.topLeft!.longitude!),
        latitude: min(topLeft!.latitude!, area.topLeft!.latitude!),
      ),
      bottomRight: Coordinates(
        longitude: min(bottomRight!.longitude!, area.bottomRight!.longitude!),
        latitude: max(bottomRight!.latitude!, area.bottomRight!.latitude!),
      ),
    );
  }

  /// Create a new RectangleGeographicArea object with the same proprieties as the original.
  ///
  /// **Returns**
  /// * a new Coordinates object with the same proprieties
  RectangleGeographicArea get copy {
    return RectangleGeographicArea(
        topLeft: topLeft?.copy, bottomRight: bottomRight?.copy);
  }

  @override
  bool get isEmpty {
    if (_hasNullLongitudeOrLatitude) return true;

    return topLeft!.longitude! - bottomRight!.longitude! == 0.0 &&
        topLeft!.latitude! - bottomRight!.latitude! == 0.0;
  }

  @override
  RectangleGeographicArea get boundingBox => copy;

  @override
  bool containsCoordinates(Coordinates point) {
    if (point.longitude == null || point.latitude == null) return false;
    if (_hasNullLongitudeOrLatitude) return false;

    return (point.longitude! >= topLeft!.longitude! &&
            point.longitude! <= bottomRight!.longitude!) &&
        (point.latitude! <= topLeft!.latitude! &&
            point.latitude! >= bottomRight!.latitude!);
  }

  @override
  Coordinates get centerPoint {
    if (topLeft == null || bottomRight == null) return Coordinates();

    bool isLatitudeNull =
        topLeft!.latitude == null || bottomRight!.latitude == null;
    bool isLongitudeNull =
        topLeft!.longitude == null || bottomRight!.longitude == null;
    bool isAltitudeNull =
        topLeft!.altitude == null || bottomRight!.altitude == null;

    return Coordinates(
      latitude: isLatitudeNull
          ? null
          : (topLeft!.latitude! + bottomRight!.latitude!) * 0.5,
      longitude: isLongitudeNull
          ? null
          : (topLeft!.longitude! + bottomRight!.longitude!) * 0.5,
      altitude: isAltitudeNull
          ? null
          : (topLeft!.altitude! + bottomRight!.altitude!) * 0.5,
    );
  }

  bool get _hasNullLongitudeOrLatitude {
    if (topLeft == null ||
        topLeft!.longitude == null ||
        topLeft!.latitude == null) return true;
    if (bottomRight == null ||
        bottomRight!.longitude == null ||
        bottomRight!.latitude == null) return true;
    return false;
  }

  @override
  bool operator ==(covariant RectangleGeographicArea other) {
    if (identical(this, other)) return true;

    return other.topLeft == topLeft && other.bottomRight == bottomRight;
  }

  @override
  int get hashCode => topLeft.hashCode ^ bottomRight.hashCode;

  @override
  String toString() =>
      'RectangleGeographicArea(topleft: $topLeft, bottomright: $bottomRight)';

  @override
  GeographicAreaType get type => GeographicAreaType.rectangle;
}

/// CircleGeographicArea object.
///
/// {@category Core}
class CircleGeographicArea implements GeographicArea {
  int? radius;
  Coordinates? centerCoordinates;

  CircleGeographicArea({
    this.radius,
    this.centerCoordinates,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (radius != null) {
      json['radius'] = radius;
    }
    if (centerCoordinates != null) {
      json['centerCoordinates'] = centerCoordinates;
    }
    return json;
  }

  factory CircleGeographicArea.fromJson(Map<String, dynamic> json) {
    return CircleGeographicArea(
      radius: json['radius'],
      centerCoordinates: json['centerCoordinates'],
    );
  }

  @override
  RectangleGeographicArea get boundingBox {
    if (centerCoordinates == null ||
        centerCoordinates!.latitude == null ||
        centerCoordinates!.longitude == null ||
        radius == null) {
      return RectangleGeographicArea();
    }

    return RectangleGeographicArea(
      topLeft: centerCoordinates!.copyWithMetersOffset(
          metersLatitude: -radius!, metersLongitude: -radius!),
      bottomRight: centerCoordinates!.copyWithMetersOffset(
          metersLatitude: radius!, metersLongitude: radius!),
    );
  }

  @override
  Coordinates get centerPoint {
    if (centerCoordinates == null) return Coordinates();

    return Coordinates(
      latitude: centerCoordinates!.latitude,
      longitude: centerCoordinates!.longitude,
      altitude: centerCoordinates!.altitude,
    );
  }

  @override
  bool containsCoordinates(Coordinates point) {
    if (radius == null || centerCoordinates == null) return false;
    return point.distance(centerCoordinates!) <= radius!;
  }

  @override
  bool get isEmpty => radius == null || radius == 0;

  @override
  bool operator ==(covariant CircleGeographicArea other) {
    if (identical(this, other)) return true;

    return other.radius == radius &&
        other.centerCoordinates == centerCoordinates;
  }

  @override
  int get hashCode => radius.hashCode ^ centerCoordinates.hashCode;

  @override
  String toString() =>
      'CircleGeographicArea(radius: $radius, centerCoordinates: $centerCoordinates)';
  @override
  GeographicAreaType get type => GeographicAreaType.circle;
}

/// PolygonGeographicArea object.
///
/// {@category Core}
class PolygonGeographicArea implements GeographicArea {
  List<Coordinates> coordinates;
  PolygonGeographicArea({
    this.coordinates = const [],
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['coordinates'] = coordinates;
    return json;
  }

  factory PolygonGeographicArea.fromJson(Map<String, dynamic> json) {
    return PolygonGeographicArea(
      coordinates: json['coordinates'],
    );
  }

  @override
  RectangleGeographicArea get boundingBox {
    if (coordinates.isEmpty) return RectangleGeographicArea();
    if (coordinates
        .any((coord) => coord.latitude == null || coord.longitude == null))
      return RectangleGeographicArea();

    late double left, right, top, bottom;
    left = right = coordinates.first.longitude!;
    top = bottom = coordinates.first.latitude!;

    for (final coordinate in coordinates) {
      right = max(right, coordinate.longitude!);
      bottom = min(bottom, coordinate.latitude!);
      left = min(left, coordinate.longitude!);
      top = max(top, coordinate.latitude!);
    }

    return RectangleGeographicArea(
      topLeft: Coordinates(longitude: left, latitude: top),
      bottomRight: Coordinates(longitude: right, latitude: bottom),
    );
  }

  @override
  Coordinates get centerPoint {
    final nVecs = coordinates.length;

    if (nVecs < 3) return Coordinates();

    double ai, atmp = 0, xtmp = 0, ytmp = 0;

    int i = nVecs - 1;
    int j = 0;

    while (j < nVecs) {
      final ci = coordinates[i];
      final cj = coordinates[j];

      ai = _crossProductScalarValue(
          ci.longitude!, ci.latitude!, cj.longitude!, cj.latitude!);
      atmp += ai;

      xtmp += (cj.longitude! + ci.longitude!) * ai;
      ytmp += (cj.latitude! + ci.latitude!) * ai;

      i = j++;
    }

    if (atmp == 0) return Coordinates();

    return Coordinates(
      longitude: xtmp / (3 * atmp),
      latitude: ytmp / (3 * atmp),
    );
  }

  @override
  bool containsCoordinates(Coordinates point) {
    if (point.latitude == null || point.longitude == null) return false;

    final nVecs = coordinates.length;
    if (nVecs < 3) return false;

    int i = 0;
    int j = nVecs - 1;

    bool status = false;

    while (i < nVecs) {
      final ci = coordinates[i];
      final cj = coordinates[j];

      if ((ci.latitude! > point.latitude!) !=
          (cj.latitude! > point.latitude!)) {
        double intersectLongitude = (point.latitude! - ci.latitude!) *
                (cj.longitude! - ci.longitude!) /
                (cj.latitude! - ci.latitude!) +
            ci.longitude!;

        if (point.longitude! < intersectLongitude) {
          status = !status;
        }
      }

      j = i++;
    }

    return status;
  }

  @override
  bool get isEmpty => boundingBox.isEmpty;

  double _crossProductScalarValue(double ax, double ay, double bx, double by) {
    return ax * by - ay * bx;
  }

  @override
  bool operator ==(covariant PolygonGeographicArea other) {
    if (identical(this, other)) return true;

    return listEquals(other.coordinates, coordinates);
  }

  @override
  int get hashCode {
    var hash = 0;
    for (final coordinate in coordinates) {
      hash = hash ^ coordinate.hashCode;
    }

    return hash;
  }

  @override
  String toString() => 'PolygonGeographicArea(coordinates: $coordinates)';

  @override
  GeographicAreaType get type => GeographicAreaType.polygon;
}
