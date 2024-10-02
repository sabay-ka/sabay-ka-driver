// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:flutter/material.dart';
import 'package:gem_kit/core.dart';

import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';
import 'package:gem_kit/src/map/map_view_render_settings.dart';
import 'package:gem_kit/src/navigation/navigation_instruction.dart';
import 'package:gem_kit/src/routing/routing_preferences.dart';

import 'dart:convert';
import 'dart:typed_data';



/// TilesCollectionGeographicArea object.
///
/// {@category Core}
class TilesCollectionGeographicArea {
  final int _pointerId;

  int get pointerId => _pointerId;

  // ignore: unused_element
  TilesCollectionGeographicArea._() : _pointerId = -1;

  TilesCollectionGeographicArea.init(int id) : _pointerId = id {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Retrieves the center point of the geographic area.
  ///
  /// Calculates and returns the geographic center of the area.
  ///
  /// **Returns**
  ///
  /// * The center point of the area, [Coordinates] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get centerPoint {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "TilesCollectionGeographicArea", 'method': "getCenterPoint", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the bounding box.
  ///
  /// This is the smallest rectangle that can be drawn around the area such that it surrounds this geographic area completely.
  ///
  /// If the area is bigger than what is allowed in the WGS 84 coordinate system, the rectangle is truncated to valid *WGS 84* coordinate values. The [RectangleGeographicArea] is always aligned with parallels and meridians.
  ///
  /// **Returns**
  ///
  /// * The bounding box, [RectangleGeographicArea] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get boundingBox {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "TilesCollectionGeographicArea", 'method': "getBoundingBox", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RectangleGeographicArea.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if the specified point is contained within the geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The point to check, [Coordinates] object.
  ///
  /// **Returns**
  ///
  /// * True if the point is within the geographic area, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool containsCoordinates(Coordinates coords) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "TilesCollectionGeographicArea",
            'method': "containsCoordinates",
            'args': coords
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
class RouteList extends GemList<Route> {
  factory RouteList() {
    return RouteList._create();
  }

  factory RouteList.fromList(List<Route> routes) {
    final routeList = RouteList._create();

    for (final r in routes) {
      routeList.add(r);
    }

    return routeList;
  }

  RouteList.init(int id, int mapId) : super(id, mapId, "RouteList", (data, mapId) => Route.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  static RouteList _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "RouteList"}));
    final decodedVal = jsonDecode(resultString!);
    return RouteList.init(decodedVal['result'], 0);
  }

  void add(Route route) {
    try {
      GemKitPlatform.instance.registerWeakRelease(route, route.pointerId);
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': pointerId, 'class': "RouteList", 'method': "push_back", 'args': route.pointerId}));
    } catch (e) {
      rethrow;
    }
  }
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
class RouteInstructionList extends GemList<RouteInstruction> {
  factory RouteInstructionList() {
    return RouteInstructionList._create();
  }
  RouteInstructionList.init(int id, int mapId)
      : super(id, mapId, "RouteInstructionList", (data, mapId) => RouteInstruction.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }
  static RouteInstructionList _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "RouteInstructionList"}));
    final decodedVal = jsonDecode(resultString!);
    return RouteInstructionList.init(decodedVal['result'], 0);
  }
}

/// Route traffic events class
///
/// This class should not be instantiated directly. Instead, use the [RouteBase.trafficEvents] getter to obtain a list of instances.
///
/// {@category Routes & Navigation}
class RouteTrafficEvent {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  RouteTrafficEvent._()
      : _pointerId = -1,
        _mapId = -1;

  RouteTrafficEvent.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get the distance in meters from starting point on current route of the traffic event to the destination.
  ///
  /// **Returns**
  ///
  /// * The distance in meters
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get distanceToDestination {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getDistanceToDestination", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the route traffic event start point.
  ///
  /// **Returns**
  ///
  /// * The start point, [Coordinates] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get from {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getFrom", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the route traffic event end point.
  ///
  /// **Returns**
  ///
  /// * The end point, [Coordinates] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get to {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getTo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the traffic event end point as landmark.
  ///
  /// * Data locally cached flag
  /// * If the landmark has no local data cached the description and address info is empty.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get toLandmark {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getToLandmark", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
  /// Checks if this traffic event is a roadblock.
  ///
  /// **Returns**
  ///
  /// * True if the traffic event is a roadblock.
  bool get isRoadblock {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "isRoadblock", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the estimated delay in seconds caused by the traffic event.
  ///
  /// **Returns**
  ///
  /// * The delay in seconds.
  int get getDelay {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getDelay", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the length in meters of the road segment affected by the traffic event.
  ///
  /// **Returns**
  ///
  /// * The length in meters.
  int get getLength {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getLength", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the traffic event impact zone
  ///
  /// **Returns**
  ///
  /// * The impact zone type
  TrafficEventImpactZone get getImpactZone {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getImpactZone", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TrafficEventImpactZoneExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the traffic event reference point
  ///
  /// **Returns**
  ///
  /// * The reference point
  Coordinates get getReferencePoint {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getReferencePoint", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the bounding box of the traffic event.
  ///
  /// **Returns**
  ///
  /// * The bounding box
  RectangleGeographicArea get getBoundingBox {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getBoundingBox", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RectangleGeographicArea.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the traffic event area
  ///
  /// **Returns**
  ///
  /// * The area
  // int64_t get area {
  //   try {
  //     final resultString = GemKitPlatform.instance.callObjectMethod(
  //         jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getArea", 'args': {}}));
  //     final decodedVal = jsonDecode(resultString!);
  //     return decodedVal['result'];
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  /// Gets the traffic event description
  ///
  /// **Returns**
  ///
  /// * The description
  String get description {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getDescription", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the traffic event class
  ///
  /// **Returns**
  ///
  /// * The event class
  TrafficEventClass get eventClass {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getEventClass", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TrafficEventClassExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the traffic event severity
  ///
  /// **Returns**
  ///
  /// * The event severity
  TrafficEventSeverity get getEventSeverity {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getEventSeverity", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TrafficEventSeverityExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the traffic event image
  ///
  /// **Returns**
  ///
  /// * The image
  // int64_t get getImage {
  //   try {
  //     final resultString = GemKitPlatform.instance.callObjectMethod(
  //         jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getImage", 'args': {}}));
  //     final decodedVal = jsonDecode(resultString!);
  //     return decodedVal['result'];
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  /// Gets the traffic event preview URL
  ///
  /// **Returns**
  ///
  /// * The preview URL
  String get getPreviewUrl {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getPreviewUrl", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Return true if the traffic event is a user roadblock
  bool get isUserRoadblock {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "isUserRoadblock", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets affected transport modes
  int get getAffectedTransportMode {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getAffectedTransportMode", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets start time ( UTC )
  DateTime get getStartTime {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getStartTime", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final miliseconds = decodedVal['result'];
      return DateTime.fromMillisecondsSinceEpoch(miliseconds, isUtc: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets end time ( UTC )
  DateTime get getEndTime {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getEndTime", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return DateTime.fromMillisecondsSinceEpoch(decodedVal['result'], isUtc: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if event has a sibling on opposite direction
  bool get hasOppositeSibling {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "hasOppositeSibling", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the traffic event start point as landmark.
  ///
  /// **Returns**
  ///
  /// * The pair of <Landmark, data locally cached flag>. If the landmark has no local data cached the description and address info is empty.
  /// A call to asyncUpdateToFromData must be done in order gather information from server.
  Pair<Landmark, bool> get fromLandmark {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getFromLandmark", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Pair<Landmark, bool>(Landmark.init(decodedVal['result']['first'],0), decodedVal['result']['second']);
    } catch (e) {
      rethrow;
    }
  }



  /// Gets the traffic event end point as landmark.
  ///
  /// **Returns**
  ///
  /// * The pair of <Landmark, data locally cached flag>. If the landmark has no local data cached the description and address info is empty.
  /// A call to asyncUpdateToFromData must be done in order gather information from server.
  Pair<Landmark, bool> getToLandmark() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "getToLandmark", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Pair(Landmark.init(decodedVal['result']['first'],0), decodedVal['result']['second']);
    } catch (e) {
      rethrow;
    }
  }

  /// Start asynchronous data update for the from and to points (landmarks).
  ///
  /// **Parameters**
  ///
  /// * **IN**	*listener*	The progress listener
  ///
  /// **Returns**
  ///
  /// * true if the update was requested
  bool asyncUpdateToFromData(ProgressListener listener) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "asyncUpdateToFromData", 'args': listener}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel the update request.
  void cancelUpdate() {
    try {
      GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteTrafficEvent", 'method': "cancelUpdate", 'args': {}}));
    } catch (e) {
      rethrow;
    }
  }

  void dispose() =>
      GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "RouteTrafficEvent", 'id': _pointerId}));
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
class RouteTrafficEventList extends GemList<RouteTrafficEvent> {
  factory RouteTrafficEventList() {
    return RouteTrafficEventList._create();
  }
  RouteTrafficEventList.init(int id, int mapId)
      : super(id, mapId, "RouteTrafficEventList", (data, mapId) => RouteTrafficEvent.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }
  static RouteTrafficEventList _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "RouteTrafficEventList"}));
    final decodedVal = jsonDecode(resultString!);
    return RouteTrafficEventList.init(decodedVal['result'], 0);
  }
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
class RouteSegmentList extends GemList<RouteSegment> {
  factory RouteSegmentList() {
    return RouteSegmentList.create();
  }
  RouteSegmentList.init(int id, int mapId)
      : super(id, mapId, "RouteSegmentList", (data, mapId) => RouteSegment.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }
  static RouteSegmentList create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "RouteSegmentList"}));
    final decodedVal = jsonDecode(resultString!);
    return RouteSegmentList.init(decodedVal['result'], 0);
  }
}

/// Enumeration used to specify the sort order of the routes
///
/// {@category Routes & Navigation}
enum RouteBookmarksSortOrder {
  /// Sort descending by update time (most recent at top).
  sortByDate,

  /// Sort ascending by name.
  sortByName,
}

/// Step unit type
///
/// {@category Routes & Navigation}
enum StepType { distance, time }

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteBookmarksSortOrderExtension on RouteBookmarksSortOrder {
  int get id {
    switch (this) {
      case RouteBookmarksSortOrder.sortByDate:
        return 0;
      case RouteBookmarksSortOrder.sortByName:
        return 1;
    }
  }

  static RouteBookmarksSortOrder fromId(int id) {
    switch (id) {
      case 0:
        return RouteBookmarksSortOrder.sortByDate;
      case 1:
        return RouteBookmarksSortOrder.sortByName;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Status of routing service
///
/// {@category Routes & Navigation}
enum RouteStatus {
  /// Uninitialized
  uninitialized,

  /// Calculating
  calculating,

  /// Waiting for internet connection
  waitingInternetConnection,

  /// Ready
  ready,

  /// Error
  error,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RouteStatusExtension on RouteStatus {
  int get id {
    switch (this) {
      case RouteStatus.uninitialized:
        return 0;
      case RouteStatus.calculating:
        return 1;
      case RouteStatus.waitingInternetConnection:
        return 2;
      case RouteStatus.ready:
        return 3;
      case RouteStatus.error:
        return 4;
    }
  }

  static RouteStatus fromId(int id) {
    switch (id) {
      case 0:
        return RouteStatus.uninitialized;
      case 1:
        return RouteStatus.calculating;
      case 2:
        return RouteStatus.waitingInternetConnection;
      case 3:
        return RouteStatus.ready;
      case 4:
        return RouteStatus.error;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Type of transit
///
/// {@category Routes & Navigation}
enum TransitType {
  /// Walk
  walk,

  /// Bus
  bus,

  /// Underground
  underground,

  /// Railway
  railway,

  /// Tram
  tram,

  /// Water transport
  waterTransport,

  /// Other
  other,

  /// Shared bike
  sharedBike,

  /// Shared scooter
  sharedScooter,

  /// Shared car
  sharedCar,

  /// Unknown
  unknown,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension TransitTypeExtension on TransitType {
  int get id {
    switch (this) {
      case TransitType.walk:
        return 0;
      case TransitType.bus:
        return 1;
      case TransitType.underground:
        return 2;
      case TransitType.railway:
        return 3;
      case TransitType.tram:
        return 4;
      case TransitType.waterTransport:
        return 5;
      case TransitType.other:
        return 6;
      case TransitType.sharedBike:
        return 7;
      case TransitType.sharedScooter:
        return 8;
      case TransitType.sharedCar:
        return 9;
      case TransitType.unknown:
        return 10;
    }
  }

  static TransitType fromId(int id) {
    switch (id) {
      case 0:
        return TransitType.walk;
      case 1:
        return TransitType.bus;
      case 2:
        return TransitType.underground;
      case 3:
        return TransitType.railway;
      case 4:
        return TransitType.tram;
      case 5:
        return TransitType.waterTransport;
      case 6:
        return TransitType.other;
      case 7:
        return TransitType.sharedBike;
      case 8:
        return TransitType.sharedScooter;
      case 9:
        return TransitType.sharedCar;
      case 10:
        return TransitType.unknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Status of realtime information
///
/// {@category Routes & Navigation}
enum RealtimeStatus {
  /// Delay
  delay,

  /// On time
  onTime,

  /// Not available
  notAvailable,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RealtimeStatusExtension on RealtimeStatus {
  int get id {
    switch (this) {
      case RealtimeStatus.delay:
        return 0;
      case RealtimeStatus.onTime:
        return 1;
      case RealtimeStatus.notAvailable:
        return 2;
    }
  }

  static RealtimeStatus fromId(int id) {
    switch (id) {
      case 0:
        return RealtimeStatus.delay;
      case 1:
        return RealtimeStatus.onTime;
      case 2:
        return RealtimeStatus.notAvailable;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Get route waypoints options
///
/// {@category Routes & Navigation}
enum GetWaypointsOptions {
  /// Initial route calculation waypoints
  initial,

  /// Remaining to travel set from the initial calculation waypoints
  ///
  /// Navigating a route will remove all passed by intermediate waypoints.
  remainingInitial,

  /// Remaining to travel set ( user set + service added set )
  ///
  /// Routing service may add additional waypoints to route result, e.g. for follow track and EV routing
  remaining
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension GetWaypointsOptionsExtension on GetWaypointsOptions {
  int get id {
    switch (this) {
      case GetWaypointsOptions.initial:
        return 0;
      case GetWaypointsOptions.remainingInitial:
        return 1;
      case GetWaypointsOptions.remaining:
        return 2;
    }
  }

  static GetWaypointsOptions fromId(int id) {
    switch (id) {
      case 0:
        return GetWaypointsOptions.initial;
      case 1:
        return GetWaypointsOptions.remainingInitial;
      case 2:
        return GetWaypointsOptions.remaining;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
class RouteInstructionBase {
  SignpostDetails? signpostDetails;
  String? signpostInstruction;
  TimeDistance? timeDistanceToNextTurn;
  TimeDistance? remainingTravelTimeDistance;
  TimeDistance? remainingTravelTimeDistanceToNextWaypoint;
  TimeDistance? traveledTimeDistance;
  String? countryCodeISO;
  Uint8List? turnImage;
  TurnDetails? turnDetails;
  String? turnInstruction;
  String? followRoadInstruction;
  Coordinates? coordinates;
  RouteInstructionBase({
    this.signpostDetails,
    this.signpostInstruction,
    this.timeDistanceToNextTurn,
    this.remainingTravelTimeDistance,
    this.remainingTravelTimeDistanceToNextWaypoint,
    this.traveledTimeDistance,
    this.countryCodeISO,
    this.turnImage,
    this.turnDetails,
    this.turnInstruction,
    this.followRoadInstruction,
    this.coordinates,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (signpostDetails != null) {
      json['signpostdetails'] = signpostDetails;
    }
    if (signpostInstruction != null) {
      json['signpostinstruction'] = signpostInstruction;
    }
    if (timeDistanceToNextTurn != null) {
      json['timedistancetonextturn'] = timeDistanceToNextTurn;
    }
    if (remainingTravelTimeDistance != null) {
      json['remainingtraveltimedistance'] = remainingTravelTimeDistance;
    }
    if (remainingTravelTimeDistanceToNextWaypoint != null) {
      json['remainingtraveltimedistancetonextwaypoint'] = remainingTravelTimeDistanceToNextWaypoint;
    }
    if (traveledTimeDistance != null) {
      json['traveledtimedistance'] = traveledTimeDistance;
    }
    if (countryCodeISO != null) {
      json['countrycodeiso'] = countryCodeISO;
    }
    if (turnImage != null) {
      json['turnimage'] = turnImage;
    }
    if (turnDetails != null) {
      json['turndetails'] = turnDetails;
    }
    if (turnInstruction != null) {
      json['turninstruction'] = turnInstruction;
    }
    if (followRoadInstruction != null) {
      json['followroadinstruction'] = followRoadInstruction;
    }
    if (coordinates != null) {
      json['coordinates'] = coordinates;
    }
    return json;
  }

  factory RouteInstructionBase.fromJson(Map<String, dynamic> json) {
    return RouteInstructionBase(
      signpostDetails: json['signpostdetails'],
      signpostInstruction: json['signpostinstruction'],
      timeDistanceToNextTurn: json['timedistancetonextturn'],
      remainingTravelTimeDistance: json['remainingtraveltimedistance'],
      remainingTravelTimeDistanceToNextWaypoint: json['remainingtraveltimedistancetonextwaypoint'],
      traveledTimeDistance: json['traveledtimedistance'],
      countryCodeISO: json['countrycodeiso'],
      turnImage: json['turnimage'],
      turnDetails: json['turndetails'],
      turnInstruction: json['turninstruction'],
      followRoadInstruction: json['followroadinstruction'],
      coordinates: json['coordinates'],
    );
  }
}

/// Route instruction class
///
/// This class should not be instantiated directly.
///
/// {@category Routes & Navigation}
class RouteInstruction {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  RouteInstruction._()
      : _pointerId = -1,
        _mapId = -1;

  RouteInstruction.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get coordinates for this route instruction.
  ///
  /// **Returns**
  ///
  /// * Coordinates of the instruction location
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get coordinates {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "getCoordinates", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get ISO 3166-1 alpha-3 country code for the navigation instruction.
  ///
  /// Empty string means no country.
  ///
  /// **Returns**
  ///
  /// *  Country ISO code. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get countryCodeISO {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "getCountryCodeISO", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get textual description for the follow road information.
  ///
  /// **Returns**
  ///
  /// * Follow road instruction
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get followRoadInstruction {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "RouteInstruction", 'method': "getFollowRoadInstruction", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get image for the realistic turn information.
  ///
  /// **Returns**
  ///
  /// * The image for the realistic next turn. The API user is responsible to check if the image is valid.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List getRealisticNextTurnImage(
      {Size? size,
      ImageFileFormat? format,
      AbstractGeometryImageRenderSettings renderSettings = const AbstractGeometryImageRenderSettings()}) {
    return GemKitPlatform.instance.callGetImage(pointerId, "RouteInstructionGetRealisticNextTurnImage",
        size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1,
        arg: jsonEncode(renderSettings));
  }

  /// Get remaining travel distance in meters and remaining travel time in seconds.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the remaining travel time and distance.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get remainingTravelTimeDistance {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "RouteInstruction", 'method': "getRemainingTravelTimeDistance", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get remaining travel time in seconds to the next way point and the remaining travel distance in meters to the next way point.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the remaining travel time and distance to the next waypoint.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get remainingTravelTimeDistanceToNextWaypoint {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "RouteInstruction",
            'method': "getRemainingTravelTimeDistanceToNextWaypoint",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get extended signpost details.
  ///
  /// **Returns**
  ///
  /// * [SignpostDetails] object containing the signpost details.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  SignpostDetails get signpostDetails {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "getSignpostDetails", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return SignpostDetails.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get textual description for the signpost information.
  ///
  /// **Returns**
  ///
  /// * [String] containing the signpost instructions.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get signpostInstruction {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "getSignpostInstruction", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get distance to the next turn in meters, time in seconds.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the traveled time and distance.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get timeDistanceToNextTurn {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "RouteInstruction", 'method': "getTimeDistanceToNextTurn", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the traveled distance in meters and the traveled time in seconds.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the traveled time and distance.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get traveledTimeDistance {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "getTraveledTimeDistance", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get full details for the turn.
  ///
  /// **Returns**
  ///
  /// * Full details for the turn. This may be used instead of [getTurnImage] in order to customize display in UI.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TurnDetails get turnDetails {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "getTurnDetails", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TurnDetails.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get turn image.
  ///
  /// **Returns**
  ///
  /// * The image for the turn. The API user is responsible to check if the image is valid.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List getTurnImage({Size? size, ImageFileFormat? format}) {
    return GemKitPlatform.instance.callGetImage(pointerId, "RouteInstructionGetTurnImage", size?.width.toInt() ?? -1,
        size?.height.toInt() ?? -1, format?.id ?? -1);
  }

  /// Get textual description for the turn.
  ///
  /// **Returns**
  ///
  /// * The turn instruction
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get turnInstruction {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "getTurnInstruction", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if follow road information is available.
  ///
  /// **Returns**
  ///
  /// * True if follow road information is available, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasFollowRoadInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "hasFollowRoadInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if signpost information is available.
  ///
  /// **Returns**
  ///
  /// * True if signpost information is available, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasSignpostInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "hasSignpostInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if turn information is available.
  ///
  /// **Returns**
  ///
  /// * True if turn information is available, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasTurnInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "hasTurnInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if this instruction is of common type.
  ///
  /// A common type route instruction is part of a common type route segment, see [RouteSegment.isCommon].
  ///
  /// **Returns**
  ///
  /// * True if instruction is common type, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isCommon {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "isCommon", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the route instruction is a ferry.
  ///
  /// **Returns**
  ///
  /// * True if a ferry is involved, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isFerry {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "isFerry", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the route instruction is a toll road.
  ///
  /// **Returns**
  ///
  /// * True if a toll road is involved, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isTollRoad {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "isTollRoad", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Convert to a [EVRouteInstruction] from this one.
  ///
  /// **Returns**
  ///
  /// * [EVRouteInstruction] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  EVRouteInstruction toEVRouteInstruction() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "toEVRouteInstruction", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return EVRouteInstruction.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the exit route instruction text.
  ///
  /// If the instruction is not an exit, returns empty string and sets the API error to [GemError.notFound]
  ///
  /// **Returns**
  ///
  /// *  String that contains exit route instruction text
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get exitDetails {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "getExitDetails", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the route instruction is a main road exit instruction.
  ///
  /// **Returns**
  ///
  /// *  True if an exit is involved, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isExit {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "isExit", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get if road information is available.
  ///
  /// **Returns**
  ///
  /// *  True if road information is available, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasRoadInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "hasRoadInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get road information.
  ///
  /// **Returns**
  ///
  /// *  [List]<[RoadInfo]> containing the road informations.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<RoadInfo> get roadInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "getRoadInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final listJson = decodedVal['result'] as List<dynamic>;
      List<RoadInfo> retList = listJson.map((categoryJson) => RoadInfo.fromJson(categoryJson)).toList();
      return retList;
    } catch (e) {
      rethrow;
    }
  }

  /// Get road image.
  ///
  /// **Returns**
  ///
  /// * RoadInfo Image associated with the road information.
  Uint8List getRoadInfoImage({Size? size, ImageFileFormat? format, Color? backgroundColor}) {
    Rgba bkColor = backgroundColor == null ? RgbaNoColor() : backgroundColor.toRgba();
    return GemKitPlatform.instance.callGetImage(pointerId, "RouteInstructionGetRoadInfoImage",
        size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1,
        arg: jsonEncode(bkColor));
  }

  /// Convert to a PTRouteInstruction from this one.
  ///
  /// **Returns**
  ///
  /// * PTRouteInstruction
  PTRouteInstruction toPTRouteInstruction() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteInstruction", 'method': "toPTRouteInstruction", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);

      return PTRouteInstruction.init(decodedVal['result'], mapId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "RouteInstructionBase", 'id': _pointerId}));
}

/// Route segment class
///
/// This class should not be instantiated directly. Instead, use the [Route.segments] getter to obtain a list of instances.
///
/// {@category Core}
class RouteSegment {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  RouteSegment._()
      : _pointerId = -1,
        _mapId = -1;

  RouteSegment.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get geographic area of the route.
  ///
  /// The geographic area is the smallest rectangle that can be drawn around the route.
  ///
  /// **Returns**
  ///
  /// * Geographic area covered by the route, [RectangleGeographicArea] object.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get geographicArea {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteSegment", 'method': "getGeographicArea", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RectangleGeographicArea.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Method to check if traveling the route or route segment incurs cost to the user.
  ///
  /// **Returns**
  ///
  /// * True if the route incurs costs, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get incursCosts {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteSegment", 'method': "getIncursCosts", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get route instructions list.
  ///
  /// **Returns**
  ///
  /// * A list of route instructions for the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<RouteInstruction> get instructions {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteSegment", 'method': "getInstructions", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RouteInstructionList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get summary of the route segment.
  ///
  /// **Returns**
  ///
  /// * The summary of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get summary {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteSegment", 'method': "getSummary", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get length in meters and estimated travel time in seconds for the route / route segment.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the time and distance information for the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get timeDistance {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteSegment", 'method': "getTimeDistance", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the list containing segment start and end waypoints.
  ///
  /// **Returns**
  ///
  /// * A list of landmarks along the route
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> get waypoints {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteSegment", 'method': "getWaypoints", 'args': {}}),
          dispatchOnMainThread: true);
      final decodedVal = jsonDecode(resultString!);
      return LandmarkList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if this segment is of common type.
  ///
  /// A common type route segment has the same travel mode as the parent route.
  ///
  /// E.g. a walk segment in a public transport route has isCommon == false.
  ///
  /// **Returns**
  ///
  /// * True if the segment is common type, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isCommon {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteSegment", 'method': "isCommon", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Convert to a [EVRouteSegment] from this one.
  ///
  /// **Returns**
  ///
  /// * [EVRouteSegment] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  EVRouteSegment toEVRouteSegment() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteSegment", 'method': "toEVRouteSegment", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return EVRouteSegment.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Convert to a [PTRouteSegment] from this one.
  ///
  /// **Returns**
  ///
  /// * [PTRouteSegment] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  PTRouteSegment toPTRouteSegment() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteSegment", 'method': "toPTRouteSegment", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return PTRouteSegment(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "RouteSegment", 'id': _pointerId}));
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
class RouteSegmentBase {
  LandmarkList? waypoints;
  TimeDistance? timedistance;
  RectangleGeographicArea? geographicarea;
  bool? incurscosts;
  String? summary;
  RouteInstructionList? instructions;
  RouteSegmentBase({
    this.waypoints,
    this.timedistance,
    this.geographicarea,
    this.incurscosts,
    this.summary,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (waypoints != null) {
      json['waypoints'] = waypoints;
    }
    if (timedistance != null) {
      json['timedistance'] = timedistance;
    }
    if (geographicarea != null) {
      json['geographicarea'] = geographicarea;
    }
    if (incurscosts != null) {
      json['incurscosts'] = incurscosts;
    }
    if (summary != null) {
      json['summary'] = summary;
    }
    if (instructions != null) {
      json['instructions'] = instructions;
    }
    return json;
  }

  factory RouteSegmentBase.fromJson(Map<String, dynamic> json) {
    return RouteSegmentBase(
      waypoints: json['waypoints'],
      timedistance: json['timedistance'],
      geographicarea: json['geographicarea'],
      incurscosts: json['incurscosts'],
      summary: json['summary'],
      instructions: json['instructions'],
    );
  }
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
abstract class RouteBase {
  final dynamic _pointerId;
  final int _mapId;

  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  RouteBase()
      : _pointerId = -1,
        _mapId = -1;
  RouteBase.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Export route data in the requested data format.
  ///
  /// **Parameters**
  ///
  /// * **IN** *format* Data format, see [PathFileFormat]
  ///
  /// **Returns**
  ///
  /// * Route data buffer
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List exportAs(PathFileFormat format) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "exportAs", 'args': format.index}));
      final decodedVal = jsonDecode(resultString!);
      return Uint8List.fromList(utf8.encode(decodedVal['result']));
    } catch (e) {
      rethrow;
    }
  }

  /// Get index of the closest route segment to the given coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coord* The geographic coordinates to check against the route segments
  ///
  /// **Returns**
  ///
  /// * [GemError.general] (-1) on error.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int getClosestSegment(Coordinates coord) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getClosestSegment", 'args': coord}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get a coordinate on route at the given distance from the departure / starting point.
  ///
  /// **Parameters**
  ///
  /// * **IN** *distance* The distance from the route start, in meters.
  ///
  /// **Returns**
  ///
  /// * Coordinates at the specified distance along the route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Coordinates getCoordinateOnRoute(int distance) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getCoordinateOnRoute", 'args': distance}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get route distance from departure at the given coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coord* The geographic coordinates where the distance is to be measured
  /// * **IN** *distance* Boolean indicating whether to consider only the active part of the route (true) or the entire route (false).
  ///
  /// **Returns**
  ///
  /// * Coordinates at the specified distance along the route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int getDistanceOnRoute(Coordinates coords, bool activePart) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "RouteBase",
            'method': "getDistanceOnRoute",
            'args': {'coords': coords, 'activePart': activePart}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get dominant road names
  ///
  /// A road is considered dominant when it covers n% from route total length.
  ///
  /// **Returns**
  ///
  /// * The names list. If a road has multiple names, they will be presented as "name1 / name2 / ... / namex"
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<String> get dominantRoads {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getDominantRoads", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return (decodedVal['result'] as List<dynamic>).map((e) => e as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get geographic area of the route. The geographic area is the smallest rectangle that can be drawn around the route.
  ///
  /// **Returns**
  ///
  /// * The names list. If a road has multiple names, they will be presented as "name1 / name2 / ... / namex"
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get geographicArea {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getGeographicArea", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RectangleGeographicArea.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Method to check if traveling the route or route segment incurs cost to the user.
  ///
  /// **Returns**
  ///
  /// * Boolean indicating whether the route incurs additional costs (e.g., tolls)
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get incursCosts {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getIncursCosts", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Build path from route start - end segment.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* Start distance from route start.
  /// * **IN** *end* End distance from route start.
  ///
  /// **Returns**
  ///
  /// * [Path] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Path? getPath(int start, int end) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "RouteBase",
            'method': "getPath",
            'args': {'start': start, 'end': end}
          }));
      final decodedVal = jsonDecode(resultString!);
      final decodRes = decodedVal['result'];
      if (decodRes == 0) return null;
      return Path.init(decodRes, _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get polygon area of the route.
  ///
  /// **Returns**
  ///
  /// * [PolygonGeographicArea] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  PolygonGeographicArea get polygonGeographicArea {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getPolygonGeographicArea", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final listJson = (decodedVal['result'] as List<dynamic>)
          .map((item) => Coordinates.fromJson(item as Map<String, dynamic>))
          .toList();
      return PolygonGeographicArea(coordinates: listJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the route preferences.
  ///
  /// **Returns**
  ///
  /// * [RoutePreferences] object managing user preferences for route calculations.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RoutePreferences get preferences {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getPreferences", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RoutePreferences.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get route track.
  ///
  /// **Returns**
  ///
  /// * [Path] representing the route's path.
  /// If this is the navigation route, it will return the remaining travel track.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Path? get routeTrack {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getRouteTrack", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      if (decodedVal['result'] == 0) return null;
      return Path.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get route segments.
  ///
  /// **Returns**
  ///
  /// * Segments of the route, each detailed with specific route information.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<RouteSegment> get segments {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getSegments", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RouteSegmentList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get route status.
  ///
  /// **Returns**
  ///
  /// * Current status of the route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RouteStatus get status {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getStatus", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RouteStatusExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the summary of the route.
  ///
  /// **Returns**
  ///
  /// * A summary of the route, including key metrics and descriptions.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get summary {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getSummary", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get route terrain profile.
  ///
  /// The [BuildTerrainProfile.enable] parameter must be set to true in the [RoutePreferences.buildTerrainProfile] object passed to [RoutingService.calculateRoute] for this getter to work.
  ///
  /// **Returns**
  ///
  /// * Terrain profile of the route, detailing elevation changes.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RouteTerrainProfile? get terrainProfile {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getTerrainProfile", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final mId = decodedVal['result'];
      if (mId == 0) return null;
      return RouteTerrainProfile.init(mId, _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get length in meters and estimated travel time in seconds for the route / route segment.
  ///
  /// **Parameters**
  ///
  /// * **IN** *activePart* If true, returns only the active part of the route metrics, if false returns whole route metrics.
  ///
  /// **Returns**
  ///
  /// * [TimeDistance] object containing the time and distance information for the route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance getTimeDistance({bool activePart = true}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getTimeDistance", 'args': activePart}));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Build a list of timestamp coordinates from a route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *start* 	Start distance from route start.
  /// * **IN** *end* 	End distance from route start.
  /// * **IN** *step* The step on which the coordinates are created.
  /// * **IN** *stepType* The step unit type. See [StepType]
  ///
  /// **Returns**
  ///
  /// * The result list of [TimeDistanceCoordinate] objects containing the time and distance information for the route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<TimeDistanceCoordinate> getTimeDistanceCoordinates(
      {required int start, required int end, required int step, required StepType stepType}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "RouteBase",
            'method': "getTimeDistanceCoordinates",
            'args': {'start': start, 'end': end, 'step': step, 'stepType': stepType == StepType.distance}
          }));
      final decodedVal = jsonDecode(resultString!);
      final timeDistanceJson = decodedVal['result'] as List<dynamic>;

      return timeDistanceJson.map((e) => TimeDistanceCoordinate.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get a time-distance coordinate on route closest to the given reference coordinate.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coordinates* The reference coordinate.
  ///
  /// **Returns**
  ///
  /// * [TimeDistanceCoordinate] Time-distance coordinate on route closest to the reference coordinate
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistanceCoordinate getTimeDistanceCoordinateOnRoute(Coordinates coordinates) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "RouteBase",
            'method': "getTimeDistanceCoordinateOnRoute",
            'args': coordinates.toJson()
          }));
      final decodedVal = jsonDecode(resultString!);
      final timeDistanceJson = decodedVal['result'] as Map<String, dynamic>;

      return TimeDistanceCoordinate.fromJson(timeDistanceJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Get list of traffic events affecting the route.
  ///
  /// **Returns**
  ///
  /// * List of traffic events affecting the route
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<RouteTrafficEvent> get trafficEvents {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getTrafficEvents", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RouteTrafficEventList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get list of route waypoints.
  ///
  /// The waypoints are ordered like: departure, first waypoint, ..., destination.
  ///
  /// If the route is target for a navigation, the list will contain the remaining to travel waypoints.
  ///
  /// **Parameters**
  ///
  /// * **IN** *options* Waypoints options
  ///
  /// **Returns**
  ///
  /// * List of [Landmark]
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getWaypoints({GetWaypointsOptions options = GetWaypointsOptions.remainingInitial}) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getWaypoints", 'args': options.id}));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get a new waypoints configuration using the given intermediate via waypoint.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark* The via waypoint to be inserted in the remaining route waypoints.
  ///
  /// **Returns**
  ///
  /// * A new route waypoints list including the given via placed in a proper position with respect to the existing route waypoints.
  ///
  /// If the route is target for a navigation, the list will contain the remaining to travel waypoints.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getWaypointsVia(Landmark landmark) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "RouteBase",
            'method': "getWaypointsVia",
            'args': {'landmark': landmark.pointerId}
          }));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the route contains ferry connections.
  ///
  /// **Returns**
  ///
  /// * Boolean indicating whether the route includes ferry connections.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasFerryConnections {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "hasFerryConnections", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the route contains toll roads.
  ///
  /// **Returns**
  ///
  /// * Boolean indicating whether the route includes toll roads.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasTollRoads {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "hasTollRoads", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get tiles collection area of the route.
  ///
  /// **Returns**
  ///
  /// * Detailed geographic area of the route represented in tiles.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TilesCollectionGeographicArea get tilesGeographicArea {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBase", 'method': "getTilesGeographicArea", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TilesCollectionGeographicArea.init(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  void keepAlive() {
    GemKitPlatform.instance.registerWeakRelease(this, pointerId);
  }
}

/// Route class
///
/// {@category Routes & Navigation}
class Route extends RouteBase {
  final dynamic _pointerId;
  final int _mapId;

  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  Route._()
      : _pointerId = -1,
        _mapId = -1;
  Route.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Comparison operator equal.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The [Route] object to be compared.
  ///
  /// **Returns**
  ///
  /// * True if the two objects are equal, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool equals(Route route) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Route", 'method': "equals", 'args': route.pointerId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  bool get isEVRoute {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Route", 'method': "isEVRoute", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if route is a Public Transport Route
  bool get isPTRoute {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Route", 'method': "isPTRoute", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the route's extra information.
  ///
  /// **Returns**
  ///
  /// * [SearchableParameterList] object containing extra information associated with the route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  SearchableParameterList get extraInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Route", 'method': "getExtraInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return SearchableParameterList.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Set user extra info.
  ///
  /// **Parameters**
  ///
  /// * **IN** *value* A [SearchableParameterList] containing extra information to be associated with the route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set extraInfo(SearchableParameterList value) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Route", 'method': "setExtraInfo", 'args': value.pointerId}));
    } catch (e) {
      rethrow;
    }
  }

  /// Convert to a [EVRoute] from this one.
  ///
  /// **Returns**
  ///
  /// * [EVRoute] object if the route is an electric vehicle route, null otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  EVRoute? toEVRoute() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Route", 'method': "toEVRoute", 'args': {}}));

      final decodedVal = jsonDecode(resultString!);
      if (decodedVal['result'] == 0) {
        return null;
      }
      return EVRoute.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Convert to a [PTRoute] from this one.
  ///
  /// **Returns**
  ///
  /// * [PTRoute] object if the route is a public transport route, null otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  PTRoute? toPTRoute() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Route", 'method': "toPTRoute", 'args': {}}));

      final decodedVal = jsonDecode(resultString!);
      if (decodedVal['result'] == 0) {
        return null;
      }
      return PTRoute.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "Route", 'id': _pointerId}));
}

/// Mapview Routes collection class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.routes] getter to obtain an instance.
///
/// {@category Routes & Navigation}
class MapViewRoutesCollection extends GemList<Route> {
  bool hasInit = false;

  // ignore: unused_element
  MapViewRoutesCollection._() : super(0, 0, "MapViewRouteCollection", (data, mapId) => Route.init(data, mapId));

  MapViewRoutesCollection(dynamic id, int mapId)
      : super(id, mapId, "MapViewRouteCollection", (data, mapId) => Route.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }
  MapViewRoutesCollection.init(int id, int mapId)
      : super(id, mapId, "MapViewRouteCollection", (data, mapId) => Route.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
    hasInit = true;
  }

  /// Add or update a route in the collection with the given render settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be added / updated.
  /// * **IN** *bMainRoute* True if the route is the main route, false if it is an alternative route.
  /// * **IN** *label* [Route] label string.
  /// * **IN** *images* [Route] label images.
  /// * **IN** *routeRenderSettings* [Route] render settings.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void add(Route route, bool bMainRoute, {String? label, RouteRenderSettings? routeRenderSettings}) {
    try {
      routeRenderSettings ??= RouteRenderSettings();
      if (bMainRoute) routeRenderSettings.options!.add(RouteRenderOptions.main);
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': pointerId,
            'class': "MapViewRouteCollection",
            'method': "add",
            'args': {
              'route': route.pointerId,
              'bMainRoute': bMainRoute,
              'routeRenderSettings': routeRenderSettings,
              if (label != null) 'label': label
            }
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Add or update a route in the collection.
  ///
  /// If the route already exists in the collection, it will be updated with the new settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be added / updated.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void addMapViewRoute(MapViewRoute route) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(this,
          jsonEncode({'id': pointerId, 'class': "MapViewRouteCollection", 'method': "add", 'args': route.pointerId}));
    } catch (e) {
      rethrow;
    }
  }

  /// Remove all routes.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': pointerId, 'class': "MapViewRouteCollection", 'method': "clear", 'args': {}}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove all routes, except the main route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void clearAllButMainRoute() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode(
              {'id': pointerId, 'class': "MapViewRouteCollection", 'method': "clearAllButMainRoute", 'args': {}}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get route label text.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route for which the label wants to be retrieved.
  ///
  /// **Returns**
  ///
  /// * The actual label
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String getLabel(Route route) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': pointerId, 'class': "MapViewRouteCollection", 'method': "getLabel", 'args': route.pointerId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the current main route.
  ///
  /// **Returns**
  ///
  /// * The main route in the collection
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Route get mainRoute {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': pointerId, 'class': "MapViewRouteCollection", 'method': "getMainRoute", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Route.init(decodedVal['result'], mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get map view route in collection by route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *idx* The map view route index in collection.
  ///
  /// The main route in the collection
  ///
  /// **Returns**
  ///
  /// * [MapViewRoute] object
  ///
  /// If idx is not valid it returns empty route
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  MapViewRoute getMapViewRoute(int idx) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': pointerId, 'class': "MapViewRouteCollection", 'method': "getMapViewRoute", 'args': idx}));
      final decodedVal = jsonDecode(resultString!);
      return MapViewRoute.init(decodedVal['result'], mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get route specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the collection
  ///
  /// The main route in the collection
  ///
  /// **Returns**
  ///
  /// * [Route] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Route getRoute(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': pointerId, 'class': "MapViewRouteCollection", 'method': "getRoute", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return Route.init(decodedVal['result'], mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Hide route label.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route for which the label should be hidden
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void hideLabel(Route route) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode(
              {'id': pointerId, 'class': "MapViewRouteCollection", 'method': "hideLabel", 'args': route.pointerId}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get index of the specified route - return < 0 for error.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be found
  ///
  /// **Returns**
  ///
  /// * The index of the route in the collection
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int indexOf(Route route) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': pointerId, 'class': "MapViewRouteCollection", 'method': "indexOf", 'args': route.pointerId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the route is the main route in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be checked
  ///
  /// **Returns**
  ///
  /// * True if the route is the main route in the collection
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool isMainRoute(Route route) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': pointerId, 'class': "MapViewRouteCollection", 'method': "isMainRoute", 'args': route.pointerId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set route bubble text.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route for which the label wants to be set.
  /// * **IN** *label* The actual label.
  ///
  /// The route label supports custom icon placement inside the text by using the icon place-mark `%icon index%%`, e.g. `"My header text %%0%%\n%%1%% my footer"`.
  ///
  /// The `_icon index_` must be a valid integer in images list container, i.e. 0 <= icon index < images.size()
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setLabel(Route route, String text) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': pointerId,
            'class': "MapViewRouteCollection",
            'method': "setLabel",
            'args': {'route': route.pointerId, 'label': text}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the route as main route in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be set as main route
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set mainRoute(Route route) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode(
              {'id': pointerId, 'class': "MapViewRouteCollection", 'method': "setMainRoute", 'args': route.pointerId}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Remove the route specified by route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route to be removed
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void remove(Route route) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode(
            {'id': pointerId, 'class': "MapViewRouteCollection", 'method': "remove", 'args': route.pointerId},
          ),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Set route render settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route for which the render settings wants to be set.
  /// * **IN** *settings* The render settings.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setRenderSettings(Route route, RouteRenderSettings settings) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': pointerId,
            'class': "MapViewRouteCollection",
            'method': "setRenderSettings",
            'args': {'route': route.pointerId, 'routeRenderSettings': settings}
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the route custom render settings(read-only)
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* route	The route for which the render settings are requested
  ///
  /// **Returns**
  ///
  /// [RouteRenderSettings] object
  ///
  ///   **Throws**
  ///
  /// * An exception if it fails.
  RouteRenderSettings getRenderSettings(Route route) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': pointerId,
            'class': "MapViewRouteCollection",
            'method': "getRenderSettings",
            'args': route.pointerId
          }));
      final decodedVal = jsonDecode(resultString!);
      return RouteRenderSettings.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    await GemKitPlatform.instance
        .getChannel(mapId: mapId)
        .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "MapViewRouteCollection", 'id': pointerId}));
  }
}

/// Mapview route class
///
/// This class should not be instantiated directly. Instead, use the [MapViewRoutesCollection.getMapViewRoute] getter to obtain an instance.
///
/// {@category Routes & Navigation}
class MapViewRoute {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  MapViewRoute._()
      : _pointerId = -1,
        _mapId = -1;

  MapViewRoute.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get route label text.
  ///
  /// **Returns**
  ///
  /// * The label text
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get labelText {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewRoute", 'method': "getLabelText", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get route render settings.
  ///
  /// **Returns**
  ///
  /// * [RouteRenderSettings] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RouteRenderSettings get renderSettings {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewRoute", 'method': "getRenderSettings", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RouteRenderSettings.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get route object.
  ///
  /// **Returns**
  ///
  /// * [Route] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Route get route {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewRoute", 'method': "getRoute", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Route.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Hide route label.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void hideLabel() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewRoute", 'method': "hideLabel", 'args': {}}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Set route label text.
  ///
  /// **Parameters**
  ///
  /// * **IN** *text* The label text to be set.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set labelText(String text) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewRoute", 'method': "setLabelText", 'args': text}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set route render settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *settings* The render settings to be set.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set renderSettings(RouteRenderSettings settings) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MapViewRoute", 'method': "setRenderSettings", 'args': settings}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set route object.
  ///
  /// **Parameters**
  ///
  /// * **IN** *route* The route object to be set.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set route(Route route) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewRoute", 'method': "setRoute", 'args': route}));
    } catch (e) {
      rethrow;
    }
  }
}

/// [RouteRenderSettings] is a class that extends [RenderSettings] to provide additional
/// rendering settings specifically for routes.
///
/// It includes colors and sizes for traveled path and turn arrows, fill color for the route,
/// text size and colors for waypoints, and the line type for the route.
///
/// The `traveledInnerColor` field defines the color for the traveled part of the route.
///
/// The `turnArrowInnerColor` and `turnArrowOuterColor` fields define the colors for the inner and outer parts of the turn arrows.
///
/// The `turnArrowInnerSz` and `turnArrowOuterSz` fields define the sizes for the inner and outer parts of the turn arrows.
///
/// The `fillColor` field defines the fill color for the route.
///
/// The `waypointTextSz` field defines the size for the waypoint text.
///
/// The `waypointTextInnerColor` and `waypointTextOuterColor` fields define the colors for the inner and outer parts of the waypoint text.
///
/// The `lineType` field defines the type of line used for the route.
///
/// {@category Routes & Navigation}
class RouteRenderSettings extends RenderSettings {
  /// The color of the traveled part of the route.
  Color? traveledInnerColor;

  /// The inner color of the turn arrows on the route.
  Color? turnArrowInnerColor;

  /// The outer color of the turn arrows on the route.
  Color? turnArrowOuterColor;

  /// The default inner size for turn arrows on the route.
  double? turnArrowInnerSz;

  /// The outer size of the turn arrows on the route.
  double? turnArrowOuterSz;

  /// The fill color for the route.
  Color? fillColor;

  /// The text size for waypoints on the route.
  double? waypointTextSz;

  /// The inner text color for waypoint labels on the route.
  Color? waypointTextInnerColor;

  /// The outer text color for waypoint labels on the route.
  Color? waypointTextOuterColor;

  /// The type of line used for the route.
  LineType? lineType;

  ///Direction arrow inner color
  Color? directionArrowInnerColor;

  /// Direction arrow outer color
  Color? directionArrowOuterColor;

  RouteRenderSettings(
      {this.traveledInnerColor,
      this.turnArrowInnerColor,
      this.turnArrowOuterColor,
      this.turnArrowInnerSz = -1.0,
      this.turnArrowOuterSz = 0.0,
      this.fillColor,
      this.waypointTextSz = 0.0,
      this.waypointTextInnerColor,
      this.waypointTextOuterColor,
      this.lineType,
      this.directionArrowInnerColor,
      this.directionArrowOuterColor,
      super.imgSz = 0.0,
      super.options,
      super.innerColor,
      super.outerColor,
      super.innerSz = -1.0,
      super.outerSz = 0.0,
      super.textSz = 0.0,
      super.textColor}) {
    traveledInnerColor = traveledInnerColor ?? Colors.transparent;
    turnArrowInnerColor = turnArrowInnerColor ?? Colors.transparent;
    turnArrowOuterColor = turnArrowOuterColor ?? Colors.transparent;
    waypointTextInnerColor = waypointTextInnerColor ?? Colors.transparent;
    waypointTextOuterColor = waypointTextOuterColor ?? Colors.transparent;
    directionArrowInnerColor = directionArrowInnerColor ?? Colors.transparent;
    directionArrowOuterColor = directionArrowOuterColor ?? Colors.transparent;
    fillColor = fillColor ?? Colors.transparent;
    lineType = lineType ?? LineType.styleDefault;
    options = options ??
        {
          RouteRenderOptions.showTraffic,
          RouteRenderOptions.showTurnArrows,
          RouteRenderOptions.showWaypoints,
          RouteRenderOptions.showHighlights,
        };
    innerColor = innerColor ?? Colors.transparent;
    outerColor = outerColor ?? Colors.transparent;
    textColor = textColor ?? Colors.transparent;
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJson();
    if (traveledInnerColor != null) {
      json['traveledInnerColor'] = traveledInnerColor!.toRgba();
    }
    if (turnArrowInnerColor != null) {
      json['turnArrowInnerColor'] = turnArrowInnerColor!.toRgba();
    }
    if (turnArrowOuterColor != null) {
      json['turnArrowOuterColor'] = turnArrowOuterColor!.toRgba();
    }
    if (turnArrowInnerSz != null) {
      json['turnArrowInnerSz'] = turnArrowInnerSz;
    }
    if (turnArrowOuterSz != null) {
      json['turnArrowOuterSz'] = turnArrowOuterSz;
    }
    if (fillColor != null) {
      json['fillColor'] = fillColor!.toRgba();
    }
    if (waypointTextSz != null) {
      json['waypointTextSz'] = waypointTextSz;
    }
    if (waypointTextInnerColor != null) {
      json['waypointTextInnerColor'] = waypointTextInnerColor!.toRgba();
    }
    if (waypointTextOuterColor != null) {
      json['waypointTextOuterColor'] = waypointTextOuterColor!.toRgba();
    }
    if (lineType != null) {
      json["lineType"] = lineType!.id;
    }
    if (options != null) {
      var el1 = (options!.first as RouteRenderOptions).id;
      for (var option in options!.skip(1)) {
        el1 |= (option as RouteRenderOptions).id;
      }
      json["options"] = el1;
    }
    if (directionArrowInnerColor != null) {
      json['dirArrowInnerColor'] = directionArrowInnerColor!.toRgba();
    }
    if (directionArrowOuterColor != null) {
      json['dirArrowOuterColor'] = directionArrowOuterColor!.toRgba();
    }
    return json;
  }

  factory RouteRenderSettings.fromJson(Map<String, dynamic> json) {
    Set<RouteRenderOptions> loptions = {};
    int id = json['options'];
    for (RouteRenderOptions option in RouteRenderOptions.values) {
      if (id & option.id != 0) {
        loptions.add(option);
      }
    }

    return RouteRenderSettings(
        traveledInnerColor: ColorExtension.fromJson(json['traveledInnerColor']),
        turnArrowInnerColor: ColorExtension.fromJson(json['turnArrowInnerColor']),
        turnArrowOuterColor: ColorExtension.fromJson(json['turnArrowOuterColor']),
        turnArrowInnerSz: json['turnArrowInnerSz'],
        turnArrowOuterSz: json['turnArrowOuterSz'],
        fillColor: ColorExtension.fromJson(json['fillColor']),
        waypointTextSz: json['waypointTextSz'],
        waypointTextInnerColor: ColorExtension.fromJson(json['waypointTextInnerColor']),
        waypointTextOuterColor: ColorExtension.fromJson(json['waypointTextOuterColor']),
        lineType: LineTypeExtension.fromId(json['lineType']),
        imgSz: json['imgSz'],
        innerColor: ColorExtension.fromJson(json['innerColor']),
        outerColor: ColorExtension.fromJson(json['outerColor']),
        innerSz: json['innerSz'],
        outerSz: json['outerSz'],
        textSz: json['textSz'],
        textColor: ColorExtension.fromJson(json['textColor']),
        options: loptions,
        directionArrowInnerColor: ColorExtension.fromJson(json['directionArrowInnerColor']),
        directionArrowOuterColor: ColorExtension.fromJson(json['directionArrowOuterColor']));
  }
}

/// Route bookmarks class
///
/// Create an instance using [RouteBookmarks.create] method
///
/// {@category Routes & Navigation}
class RouteBookmarks {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  RouteBookmarks._()
      : _pointerId = -1,
        _mapId = -1;

  RouteBookmarks.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Add a new route / update existing.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The new route name, must be unique. If a route with this name already exists, [GemError.exist] is returned.
  /// * **IN** *waypoints* [Route] waypoints list.
  /// * **IN** *preferences* [Route] preferences.
  /// * **IN** *overwrite* Overwrite route if name already exists.
  ///
  /// If a route with given name already exists and overwrite = true, the existing route is updated.
  ///
  /// Only route relevant preferences are saved: transport mode + avoid preferences.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void add(
    String name,
    List<Landmark> waypoints, {
    RoutePreferences? preferences,
    bool? overwrite,
  }) {
    try {
      final landmarkList = LandmarkList.fromList(waypoints);

      final encodedVal = jsonEncode({
        'id': _pointerId,
        'class': "RouteBookmarks",
        'method': "add",
        'args': {
          'name': name,
          'waypoints': landmarkList.pointerId,
          if (preferences != null) 'preferences': preferences,
          if (overwrite != null) 'overwrite': overwrite
        }
      });
      GemKitPlatform.instance.safecallObjectMethodffi(this, encodedVal);
    } catch (e) {
      rethrow;
    }
  }

  /// Add trips from the given filename.
  ///
  /// **Parameters**
  ///
  /// * **IN** *filename* The imported bookmarks file path.
  ///
  /// **Returns**
  ///
  /// * On success: the number of imported routes, otherwise the operation error. See [GemError] for more codes.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int addTrips(String filename) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "addTrips", 'args': filename}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Clear all routes bookmarks.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "clear", 'args': {}}));
    } catch (e) {
      rethrow;
    }
  }

  /// Export the route to the given file.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The route index to be exported.
  /// * **IN** *path* The file path where the route will be exported
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GemError exportToFile(int index, String path) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "RouteBookmarks",
            'method': "exportToFile",
            'args': {'index': index, 'path': path}
          }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Find a trip by name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The route name.
  ///
  /// **Returns**
  ///
  /// * On success - the route index in current sort order, otherwise the operation error. See [GemError] for more codes.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int find(String name) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "find", 'args': name}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get auto delete mode.
  ///
  /// If auto delete mode is true, the database if automatically deleted when object is destroyed.
  ///
  /// Default is false.
  ///
  /// **Returns**
  ///
  /// * The auto delete mode
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get autoDeleteMode {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "getAutoDeleteMode", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get Bookmarks collection path.
  ///
  /// **Returns**
  ///
  /// * The path of the bookmarks collection.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get filePath {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "getFilePath", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get name of the route specified by index.
  ///
  /// [Route] name is the unique identifier of a route.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  ///
  /// **Returns**
  ///
  /// * The route name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.s
  String getName(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "getName", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get preferences of the route specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  ///
  /// **Returns**
  ///
  /// * The route preferences
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RoutePreferences getPreferences(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "getPreferences", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return RoutePreferences.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get number of routes.
  ///
  /// **Returns**
  ///
  /// * The number of routes in the collection
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "size", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get timestamp of the route specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  ///
  /// **Returns**
  ///
  /// * The route timestamp
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  DateTime getTimestamp(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "getTimestamp", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return DateTime.fromMillisecondsSinceEpoch(decodedVal['result'], isUtc: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get waypoints of the route specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  ///
  /// **Returns**
  ///
  /// * The route waypoints
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<Landmark> getWaypoints(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "getWaypoints", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Remove the item at the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The route index to be removed.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void remove(int index) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "remove", 'args': index}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set auto delete mode.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mode* The Auto-delete mode.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set autoDeleteMode(bool mode) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "setAutoDeleteMode", 'args': mode}));
    } catch (e) {
      rethrow;
    }
  }

  /// Change the sort order of the routes.
  ///
  /// Default order is [RouteBookmarksSortOrder.sortByDate]. UI needs to refresh the list.
  ///
  /// Needs to be set after routes have been added in order to sort accordingly
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set sortOrder(RouteBookmarksSortOrder order) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteBookmarks", 'method': "setSortOrder", 'args': order.id}));
    } catch (e) {
      rethrow;
    }
  }

  /// Update a route
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the route in the current sort order.
  /// * **IN** *name* The new route name, must be unique. If a route with this name already exists, [GemError.exist] is returned.
  /// * **IN** *waypoints* [Route] waypoints list.
  /// * **IN** *preferences* [Route] preferences.
  ///
  /// Only route relevant preferences are saved: transport mode + avoid preferences.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void update(
    int index, {
    String? name,
    List<Landmark>? waypoints,
    RoutePreferences? preferences,
  }) {
    try {
      final landmarkList = waypoints == null ? LandmarkList() : LandmarkList.fromList(waypoints);

      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "RouteBookmarks",
            'method': "update",
            'args': {
              'index': index,
              if (name != null) 'name': name,
              'waypoints': landmarkList.pointerId,
              if (preferences != null) 'preferences': preferences
            }
          }));
    } catch (e) {
      rethrow;
    }
  }

  static RouteBookmarks create(String name) {
    final encodedVal = jsonEncode({'class': "RouteBookmarks", 'args': name});
    final resultString = GemKitPlatform.instance.callCreateObject(encodedVal);
    final decodedVal = jsonDecode(resultString!);
    return RouteBookmarks.init(decodedVal['result'], 0);
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "RouteBookmarks", 'id': _pointerId}));
}

/// Electric vehicle route instruction class
///
/// {@category Routes & Navigation}
class EVRouteInstruction {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  EVRouteInstruction._()
      : _pointerId = -1,
        _mapId = -1;

  EVRouteInstruction.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get SoC at the instruction begin.
  ///
  /// **Returns**
  ///
  /// * The SoC percentage at the segment start.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get beginSoC {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRouteInstruction", 'method': "getBeginSoC", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get charge time during instruction begin - end interval.
  ///
  /// **Returns**
  ///
  /// * Charging time in seconds required for this segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get chargingTime {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRouteInstruction", 'method': "getChargingTime", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get SoC at the instruction end.
  ///
  /// **Returns**
  ///
  /// * The SoC percentage at the segment end.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get endSoC {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRouteInstruction", 'method': "getEndSoC", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if instruction is a stop for battery charge.
  ///
  /// **Returns**
  ///
  /// * True if there is a charging stop in this segment, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isChargeStop {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRouteInstruction", 'method': "isChargeStop", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
}

/// Electric vehicle route class
///
/// {@category Routes & Navigation}
class EVRoute extends RouteBase {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  EVRoute._()
      : _pointerId = -1,
        _mapId = -1;

  EVRoute.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get departure SoC.
  ///
  /// **Returns**
  ///
  /// * The state of charge at the departure point, as a percentage.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get departureSoC {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRoute", 'method': "getDepartureSoC", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get destination SoC.
  ///
  /// **Returns**
  ///
  /// * The state of charge at the destination point, as a percentage.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get destinationSoC {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRoute", 'method': "getDestinationSoC", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get total charging time in seconds.
  ///
  /// **Returns**
  ///
  /// * Total charging time required for the trip, in seconds.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get totalChargingTime {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRoute", 'method': "getTotalChargingTime", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "EVRoute", 'id': _pointerId}));
}

/// Public transport route class
/// 
/// {@category Routes & Navigation}
class PTRoute extends RouteBase {
  PTRoute.init(int id, int mapId) : super.init(id, mapId);

  /// Get Fare
  ///
  /// **Returns**
  ///
  /// * Fare of the route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get publicTransportFare {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "PTRoute", 'method': "getPTFare", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return (decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get Frequency
  ///
  /// **Returns**
  ///
  /// * Frequency of the route.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get publicTransportFrequency {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "PTRoute", 'method': "getPTFrequency", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the solution meets all the preferences
  ///
  /// **Returns**
  ///
  /// * True if the solution meets all the preferences, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get publicTransportRespectsAllConditions {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRoute", 'method': "getPTRespectsAllConditions", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get number of BuyTicketInformation objects for PT route.
  ///
  /// **Returns**
  ///
  /// * Number of BuyTicketInformation objects.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get countBuyTicketInformation {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRoute", 'method': "getCountBuyTicketInformation", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get buy ticket data obj specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN**	*index*	The index of the buy ticket data object.
  ///
  /// **Returns**
  ///
  /// * empty Index is out of bounds.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  PTBuyTicketInformation getBuyTicketInformation(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRoute", 'method': "getBuyTicketInformation", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return PTBuyTicketInformation(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }
}

/// Public transport route segment
/// 
/// {@category Routes & Navigation}
class PTRouteSegment extends RouteSegment {
  PTRouteSegment(int pointerId) : super.init(pointerId, 0);

  /// Get name
  ///
  /// **Returns**
  ///
  /// * Name of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get platform code
  ///
  /// **Returns**
  ///
  /// * Platform code of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get platformCode {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getPlatformCode", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get arrival time
  ///
  /// **Returns**
  ///
  /// * Arrival time of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  DateTime get arrivalTime {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getArrivalTime", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return DateTime.fromMillisecondsSinceEpoch(decodedVal['result'], isUtc: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get departure time
  ///
  /// **Returns**
  ///
  /// * Departure time of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  DateTime get departureTime {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getDepartureTime", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return DateTime.fromMillisecondsSinceEpoch(decodedVal['result'], isUtc: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get wheelchair support
  ///
  /// **Returns**
  ///
  /// * True if the route segment has wheelchair support, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasWheelchairSupport {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getHasWheelchairSupport", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get short name
  ///
  /// **Returns**
  ///
  /// * Short name of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get shortName {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getShortName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get route URL
  ///
  /// **Returns**
  ///
  /// * Route URL of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get routeUrl {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getRouteUrl", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get agency name
  ///
  /// **Returns**
  ///
  /// * Agency name of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get agencyName {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getAgencyName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get agency phone
  ///
  /// **Returns**
  ///
  /// * Agency phone of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get agencyPhone {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getAgencyPhone", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get agency URL
  ///
  /// **Returns**
  ///
  /// * Agency URL of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get agencyUrl {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getAgencyUrl", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get agency fare URL
  ///
  /// **Returns**
  ///
  /// * Agency fare URL of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get agencyFareUrl {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getAgencyFareUrl", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get line from
  ///
  /// **Returns**
  ///
  /// * Line from of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get lineFrom {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getLineFrom", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get line towards
  ///
  /// **Returns**
  ///
  /// * Line towards of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get lineTowards {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getLineTowards", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get arrival delay in seconds
  ///
  /// **Returns**
  ///
  /// * Arrival delay in seconds of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get arrivalDelayInSeconds {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getArrivalDelayInSeconds", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get departure delay in seconds
  ///
  /// **Returns**
  ///
  /// * Departure delay in seconds of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get departureDelayInSeconds {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "PTRouteSegment", 'method': "getDepartureDelayInSeconds", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get if the route segment has bicycle support
  ///
  /// **Returns**
  ///
  /// * True if the route segment has bicycle support, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasBicycleSupport {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getHasBicycleSupport", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get if the route segment requires to stay on same transit
  ///
  /// **Returns**
  ///
  /// * True if the route segment requires to stay on same transit, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get stayOnSameTransit {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getStayOnSameTransit", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get transit type of the route segment
  ///
  /// **Returns**
  ///
  /// * Transit type of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TransitType get transitType {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getTransitType", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TransitTypeExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get real time status of the route segment
  ///
  /// **Returns**
  ///
  /// * Real time status of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RealtimeStatus get realtimeStatus {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getRealtimeStatus", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RealtimeStatusExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get line block ID of the route segment
  ///
  /// **Returns**
  ///
  /// * Line block ID of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get lineBlockID {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getLineBlockID", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get line color of the route segment
  ///
  /// **Returns**
  ///
  /// * Line color of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Color get lineColor {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getLineColor", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return ColorExtension.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get line text color of the route segment
  ///
  /// **Returns**
  ///
  /// * Line text color of the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Color get lineTextColor {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getLineTextColor", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return ColorExtension.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get count of alerts in the route segment
  ///
  /// **Returns**
  ///
  /// * Count of alerts in the route segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get countAlerts {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getCountAlerts", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get alert by index
  ///
  /// **Returns**
  ///
  /// * [PTAlert] object.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  PTAlert getAlert(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "getAlert", 'args': {'index': index}}));
      final decodedVal = jsonDecode(resultString!);
      return PTAlert(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Is significant route segment
  ///
  /// **Returns**
  ///
  /// * True if the route segment is significant, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isSignificant {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "isSignificant", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Is station walk route segment
  ///
  /// **Returns**
  ///
  /// * True if the route segment is station walk, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get isStationWalk {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteSegment", 'method': "isStationWalk", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
}

/// Electric vehicle segment class
///
/// {@category Routes & Navigation}
class EVRouteSegment {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  EVRouteSegment._()
      : _pointerId = -1,
        _mapId = -1;

  EVRouteSegment.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get SoC at route segment begin.
  ///
  /// **Returns**
  ///
  /// * The SoC percentage at the segment start.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get beginSoC {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRouteSegment", 'method': "getBeginSoC", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get SoC at route segment end.
  ///
  /// **Returns**
  ///
  /// * The SoC percentage at the segment end.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get endSoC {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRouteSegment", 'method': "getEndSoC", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get charge time during segment begin - end interval.
  ///
  /// **Returns**
  ///
  /// * Charging time in seconds required for this segment.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get chargingTime {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRouteSegment", 'method': "getChargingTime", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if segment ends with a charge stop instruction.
  ///
  /// **Returns**
  ///
  /// * True if there is a charging stop in this segment, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasChargeStop {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "EVRouteSegment", 'method': "hasChargeStop", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  void dispose() => GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "EVRouteSegment", 'id': _pointerId}));
}

/// @nodoc
///
/// {@category Routes & Navigation}
class SignpostItemList extends GemList<SignpostItem> {
  factory SignpostItemList() {
    return SignpostItemList._create();
  }
  SignpostItemList.init(int id, int mapId)
      : super(id, mapId, "RouteInstructionList", (data, mapId) => SignpostItem.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }
  static SignpostItemList _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "RouteInstructionList"}));
    final decodedVal = jsonDecode(resultString!);
    return SignpostItemList.init(decodedVal['result'], 0);
  }
}

/// Public transport buy ticket information class.
///
/// {@category Routes & Navigation}
class PTBuyTicketInformation {
  final int _pointerId;
  int get pointerId => _pointerId;
  PTBuyTicketInformation(int id) : _pointerId = id {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get buy ticket URL
  ///
  /// **Returns**
  ///
  /// * Buy ticket URL
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get buyTicketURL {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTBuyTicketInformation", 'method': "getBuyTicketURL", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get indexes of the affected solution parts
  ///
  /// **Returns**
  ///
  /// * Indexes list of the affected solution parts
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<int> get solutionPartIndexes {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "PTBuyTicketInformation", 'method': "getSolutionPartIndexes", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return List<int>.from(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  void dispose() =>
      GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "PTBuyTicketInformation", 'id': _pointerId}));
}

/// Public transport route instruction class.
/// 
/// {@category Routes & Navigation}
class PTRouteInstruction extends RouteInstruction {
  PTRouteInstruction.init(super.id, super.mapId) : super.init();

  /// Get public transit route instruction name
  ///
  /// **Returns**
  ///
  /// * Instruction name
  String get name {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteInstruction", 'method': "getName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get platform code
  ///
  /// **Returns**
  ///
  /// * Platform code
  String get platformCode {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteInstruction", 'method': "getPlatformCode", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get public transit route instruction arrival time
  ///
  /// **Returns**
  ///
  /// * Arrival time in seconds
  DateTime get arrivalTime {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteInstruction", 'method': "getArrivalTime", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return DateTime.fromMillisecondsSinceEpoch(decodedVal['result'], isUtc: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get public transit route instruction departure time
  ///
  /// **Returns**
  ///
  /// * Departure time in seconds
  DateTime get departureTime {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTRouteInstruction", 'method': "getDepartureTime", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return DateTime.fromMillisecondsSinceEpoch(decodedVal['result'], isUtc: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Get if public transit route instruction has wheelchair support
  ///
  /// **Returns**
  ///
  /// * True if has wheelchair support, false otherwise
  bool get hasWheelchairSupport {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "PTRouteInstruction", 'method': "getHasWheelchairSupport", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
}

/// Public transport alert class
/// 
/// {@category Routes & Navigation}
class PTAlert{
  final int _pointerId;
  PTAlert(this._pointerId);

  /// Get number of url translations in this alert.
  ///
  /// **Returns**
  ///
  /// * Number of url translations.
  int get countUrlTranslations {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTAlert", 'method': "getCountUrlTranslations", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get number of header text translations in this alert.
  ///
  /// **Returns**
  ///
  /// * Number of header text translations.
  int get countHeaderTextTranslations {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTAlert", 'method': "getCountHeaderTextTranslations", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get number of description text translations in this alert.
  ///
  /// **Returns**
  ///
  /// * Number of description text translations.
  int get countDescriptionTextTranslations {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTAlert", 'method': "getCountDescriptionTextTranslations", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get url translation specified by index.
  ///
  /// **Parameters**
  /// 
  /// * **IN** *index* Index of the url translation
  ///
  /// **Returns**
  ///
  /// * Empty if Index is out of bounds.
  /// 
  /// **Throws**
  /// 
  /// * An exception if it fails.
  PTTranslation getUrlTranslation(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTAlert", 'method': "getUrlTranslation", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return PTTranslation.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get header text translation specified by index.
  ///
  /// **Parameters**
  /// 
  /// * **IN** *index* Index of the header text translation
  ///
  /// **Returns**
  ///
  /// * Empty if Index is out of bounds.
  /// 
  /// **Throws**
  /// 
  /// * An exception if it fails.
  PTTranslation getHeaderTextTranslation(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTAlert", 'method': "getHeaderTextTranslation", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return PTTranslation.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get description text translation specified by index.
  ///
  /// **Parameters**
  /// 
  /// * **IN** *index* Index of the description text translation
  ///
  /// **Returns**
  ///
  /// * Empty if Index is out of bounds.
  /// 
  /// **Throws**
  /// 
  /// * An exception if it fails.
  PTTranslation getDescriptionTextTranslation(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "PTAlert", 'method': "getDescriptionTextTranslation", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return PTTranslation.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }
}

/// Public transport translation class
/// 
/// {@category Routes & Navigation}
class PTTranslation {

/// The text message.
final String text;

/// The language code of the text message, in BCP-47 format.
final String language;

PTTranslation(this.text, this.language);

  factory PTTranslation.fromJson(Map<String, dynamic> json) {
    return PTTranslation(json['text'], json['language']);
  }
}

/// Traffic events classes
///
/// {@category Routes & Navigation}
enum TrafficEventClass {
  /// other
  other,

  /// congestion
  levelOfService,

  /// attention
  expectedLevelOfService,

  /// accident
  accidents,

  /// accident
  incidents,

  /// no entry
  closuresAndLaneRestrictions,

  /// no entry
  carriagewayRestrictions,

  /// no entry
  exitRestrictions,

  /// no entry
  entryRestrictions,

  /// info
  trafficRestrictions,

  /// info
  carpoolInfo,

  /// roadworks
  roadworks,

  /// slippery road
  obstructionHazards,

  /// mandatory
  dangerousSituations,

  /// slippery road
  roadConditions,

  /// temperatures
  temperatures,

  /// precipitation and visibility
  precipitationAndVisibility,

  /// wind and air quality
  windAndAirQuality,

  /// activities
  activities,

  /// security alerts
  securityAlerts,

  /// info
  delays,

  /// restrictions removal
  cancellations,

  /// warning
  travelTimeInfo,

  /// dangerous vehicles
  dangerousVehicles,

  /// exceptional loads or vehicles
  exceptionalLoadsOrVehicles,

  /// traffic equipment status
  trafficEquipmentStatus,

  /// circulation closed
  sizeAndWeightLimits,

  /// parking restrictions
  parkingRestrictions,

  /// parking
  parking,

  /// info
  referenceToAudioBroadcast,

  /// info
  serviceMessages,

  /// info
  specialMessages,

  /// user events above this value
  userEventsBase,

  /// user-defined roadblock.
  userRoadblock,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension TrafficEventClassExtension on TrafficEventClass {
  int get id {
    switch (this) {
      case TrafficEventClass.other:
        return 0;
      case TrafficEventClass.levelOfService:
        return 1;
      case TrafficEventClass.expectedLevelOfService:
        return 2;
      case TrafficEventClass.accidents:
        return 3;
      case TrafficEventClass.incidents:
        return 4;
      case TrafficEventClass.closuresAndLaneRestrictions:
        return 5;
      case TrafficEventClass.carriagewayRestrictions:
        return 6;
      case TrafficEventClass.exitRestrictions:
        return 7;
      case TrafficEventClass.entryRestrictions:
        return 8;
      case TrafficEventClass.trafficRestrictions:
        return 9;
      case TrafficEventClass.carpoolInfo:
        return 10;
      case TrafficEventClass.roadworks:
        return 11;
      case TrafficEventClass.obstructionHazards:
        return 12;
      case TrafficEventClass.dangerousSituations:
        return 13;
      case TrafficEventClass.roadConditions:
        return 14;
      case TrafficEventClass.temperatures:
        return 15;
      case TrafficEventClass.precipitationAndVisibility:
        return 16;
      case TrafficEventClass.windAndAirQuality:
        return 17;
      case TrafficEventClass.activities:
        return 18;
      case TrafficEventClass.securityAlerts:
        return 19;
      case TrafficEventClass.delays:
        return 20;
      case TrafficEventClass.cancellations:
        return 21;
      case TrafficEventClass.travelTimeInfo:
        return 22;
      case TrafficEventClass.dangerousVehicles:
        return 23;
      case TrafficEventClass.exceptionalLoadsOrVehicles:
        return 24;
      case TrafficEventClass.trafficEquipmentStatus:
        return 25;
      case TrafficEventClass.sizeAndWeightLimits:
        return 26;
      case TrafficEventClass.parkingRestrictions:
        return 27;
      case TrafficEventClass.parking:
        return 28;
      case TrafficEventClass.referenceToAudioBroadcast:
        return 29;
      case TrafficEventClass.serviceMessages:
        return 30;
      case TrafficEventClass.specialMessages:
        return 31;
      case TrafficEventClass.userEventsBase:
        return 100;
      case TrafficEventClass.userRoadblock:
        return 100;
    }
  }

  static TrafficEventClass fromId(int id) {
    switch (id) {
      case 0:
        return TrafficEventClass.other;
      case 1:
        return TrafficEventClass.levelOfService;
      case 2:
        return TrafficEventClass.expectedLevelOfService;
      case 3:
        return TrafficEventClass.accidents;
      case 4:
        return TrafficEventClass.incidents;
      case 5:
        return TrafficEventClass.closuresAndLaneRestrictions;
      case 6:
        return TrafficEventClass.carriagewayRestrictions;
      case 7:
        return TrafficEventClass.exitRestrictions;
      case 8:
        return TrafficEventClass.entryRestrictions;
      case 9:
        return TrafficEventClass.trafficRestrictions;
      case 10:
        return TrafficEventClass.carpoolInfo;
      case 11:
        return TrafficEventClass.roadworks;
      case 12:
        return TrafficEventClass.obstructionHazards;
      case 13:
        return TrafficEventClass.dangerousSituations;
      case 14:
        return TrafficEventClass.roadConditions;
      case 15:
        return TrafficEventClass.temperatures;
      case 16:
        return TrafficEventClass.precipitationAndVisibility;
      case 17:
        return TrafficEventClass.windAndAirQuality;
      case 18:
        return TrafficEventClass.activities;
      case 19:
        return TrafficEventClass.securityAlerts;
      case 20:
        return TrafficEventClass.delays;
      case 21:
        return TrafficEventClass.cancellations;
      case 22:
        return TrafficEventClass.travelTimeInfo;
      case 23:
        return TrafficEventClass.dangerousVehicles;
      case 24:
        return TrafficEventClass.exceptionalLoadsOrVehicles;
      case 25:
        return TrafficEventClass.trafficEquipmentStatus;
      case 26:
        return TrafficEventClass.sizeAndWeightLimits;
      case 27:
        return TrafficEventClass.parkingRestrictions;
      case 28:
        return TrafficEventClass.parking;
      case 29:
        return TrafficEventClass.referenceToAudioBroadcast;
      case 30:
        return TrafficEventClass.serviceMessages;
      case 31:
        return TrafficEventClass.specialMessages;
      case 100:
        return TrafficEventClass.userRoadblock;
       default:
        throw ArgumentError('Invalid id');
    }
  }

}
/// Traffic event severity enum.
/// 
/// {@category Routes & Navigation}
enum TrafficEventSeverity {
  /// Stationary
  stationary,

  /// Queuing
  queuing,

  /// Slow traffic
  slowTraffic,

  /// Possible delay
  possibleDelay,

  /// Unknown
  unknown
}

/// @nodoc
/// 
/// {@category Routes & Navigation}
extension TrafficEventSeverityExtension on TrafficEventSeverity {
  int get id {
    switch (this) {
      case TrafficEventSeverity.stationary:
        return 0;
      case TrafficEventSeverity.queuing:
        return 1;
      case TrafficEventSeverity.slowTraffic:
        return 2;
      case TrafficEventSeverity.possibleDelay:
        return 3;
      case TrafficEventSeverity.unknown:
        return 4;
    }
  }

  static TrafficEventSeverity fromId(int id) {
    switch (id) {
      case 0:
        return TrafficEventSeverity.stationary;
      case 1: 
        return TrafficEventSeverity.queuing;
      case 2:
        return TrafficEventSeverity.slowTraffic;
      case 3:
        return TrafficEventSeverity.possibleDelay;
      case 4:
        return TrafficEventSeverity.unknown;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}


/// Traffic usage type
/// 
/// Define how traffic service will be used
/// 
/// {@category Routes & Navigation}
enum TrafficUsage {
  /// No traffic
  none,

  /// Online and offline ( default )
  online,

  /// Offline only
  offline,
}

/// @nodoc
/// 
/// {@category Routes & Navigation}
extension TrafficUsageExtension on TrafficUsage {
  int get id {
    switch (this) {
      case TrafficUsage.none:
        return 0;
      case TrafficUsage.online:
        return 1;
      case TrafficUsage.offline:
        return 2;
    }
  }

  static TrafficUsage fromId(int id) {
    switch (id) {
      case 0:
        return TrafficUsage.none;
      case 1: 
        return TrafficUsage.online;
      case 2:
        return TrafficUsage.offline;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Restrictions which prevent online service functionality
/// 
/// {@category Routes & Navigation}
enum TrafficOnlineRestrictions {
  /// Service is disabled from settings
  settings,

  /// No internet connection
  connection,

  /// Restricted by network type
  networkType,

  /// Missing provider data
  providerData,

  /// Outdated world map version
  worldMapVersion,

  /// Not enough disk space to store data
  diskSpace,

  /// Failed to initialize
  initFail
}

/// @nodoc
/// 
/// {@category Routes & Navigation}
extension TrafficOnlineRestrictionsExtension on TrafficOnlineRestrictions {
  int get id {
    switch (this) {
      case TrafficOnlineRestrictions.settings:
        return 1;
      case TrafficOnlineRestrictions.connection:
        return 2;
      case TrafficOnlineRestrictions.networkType:
        return 4;
      case TrafficOnlineRestrictions.providerData:
        return 8;
      case TrafficOnlineRestrictions.worldMapVersion:
        return 16;
      case TrafficOnlineRestrictions.diskSpace:
        return 32;
      case TrafficOnlineRestrictions.initFail:
        return 64;
    }
  }

  static TrafficOnlineRestrictions fromId(int id) {
    switch (id) {
      case 1:
        return TrafficOnlineRestrictions.settings;
      case 2:
        return TrafficOnlineRestrictions.connection;
      case 4:
        return TrafficOnlineRestrictions.networkType;
      case 8:
        return TrafficOnlineRestrictions.providerData;
      case 16:
        return TrafficOnlineRestrictions.worldMapVersion;
      case 32:
        return TrafficOnlineRestrictions.diskSpace;
      case 64:
        return TrafficOnlineRestrictions.initFail;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Traffic event shape
///
/// {@category Routes & Navigation}
enum TrafficEventImpactZone {
  /// path as a collection of roads impact zone
  path,

  /// geographic area impact zone
  area,
}

/// @nodoc
/// 
/// {@category Routes & Navigation}
extension TrafficEventImpactZoneExtension on TrafficEventImpactZone {
  /// Id of ETrafficEventImpactZone
  int get id {
    switch (this) {
      case TrafficEventImpactZone.path:
        return 0;
      case TrafficEventImpactZone.area:
        return 1;
    }
  }

  /// From id
  static TrafficEventImpactZone fromId(int id) {
    switch (id) {
      case 0:
        return TrafficEventImpactZone.path;
      case 1:
        return TrafficEventImpactZone.area;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}
      
