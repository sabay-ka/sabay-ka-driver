// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:ui';

import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/core/signpost_details.dart';
import 'package:gem_kit/src/core/turn_details.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';
import 'dart:typed_data';

/// Road shield type
///
/// {@category Routes & Navigation}
enum RoadShieldType {
  /// Invalid
  invalid,

  /// County
  county,

  /// State
  state,

  /// Federal
  federal,

  /// Interstate
  interstate,

  /// Four
  four,

  /// Five
  five,

  /// Six
  six,

  /// Seven
  seven,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RoadShieldTypeExtension on RoadShieldType {
  int get id {
    switch (this) {
      case RoadShieldType.invalid:
        return 0;
      case RoadShieldType.county:
        return 1;
      case RoadShieldType.state:
        return 2;
      case RoadShieldType.federal:
        return 3;
      case RoadShieldType.interstate:
        return 4;
      case RoadShieldType.four:
        return 5;
      case RoadShieldType.five:
        return 6;
      case RoadShieldType.six:
        return 7;
      case RoadShieldType.seven:
        return 8;
    }
  }

  static RoadShieldType fromId(int id) {
    switch (id) {
      case 0:
        return RoadShieldType.invalid;
      case 1:
        return RoadShieldType.county;
      case 2:
        return RoadShieldType.state;
      case 3:
        return RoadShieldType.federal;
      case 4:
        return RoadShieldType.interstate;
      case 5:
        return RoadShieldType.four;
      case 6:
        return RoadShieldType.five;
      case 7:
        return RoadShieldType.six;
      case 8:
        return RoadShieldType.seven;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Signpost item type
///
/// {@category Routes & Navigation}
enum SignpostItemType {
  /// Invalid
  invalid,

  /// Place name
  placeName,

  /// Route number
  routeNumber,

  /// Route name
  routeName,

  /// Exit number
  exitNumber,

  /// Exit name
  exitName,

  /// Pictogram
  pictogram,

  /// Other
  otherDestination,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension SignpostItemTypeExtension on SignpostItemType {
  int get id {
    switch (this) {
      case SignpostItemType.invalid:
        return 0;
      case SignpostItemType.placeName:
        return 1;
      case SignpostItemType.routeNumber:
        return 2;
      case SignpostItemType.routeName:
        return 3;
      case SignpostItemType.exitNumber:
        return 4;
      case SignpostItemType.exitName:
        return 5;
      case SignpostItemType.pictogram:
        return 6;
      case SignpostItemType.otherDestination:
        return 7;
    }
  }

  static SignpostItemType fromId(int id) {
    switch (id) {
      case 0:
        return SignpostItemType.invalid;
      case 1:
        return SignpostItemType.placeName;
      case 2:
        return SignpostItemType.routeNumber;
      case 3:
        return SignpostItemType.routeName;
      case 4:
        return SignpostItemType.exitNumber;
      case 5:
        return SignpostItemType.exitName;
      case 6:
        return SignpostItemType.pictogram;
      case 7:
        return SignpostItemType.otherDestination;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Signpost pictogram type.
///
/// {@category Routes & Navigation}
enum SignpostPictogramType {
  /// Invalid
  invalid,

  /// Airport
  airport,

  /// Bus station
  busStation,

  /// Fair ground
  fairGround,

  /// Ferry
  ferry,

  /// First aid post
  firstAidPost,

  /// Harbour
  harbour,

  /// Hospital
  hospital,

  /// Hotel/motel
  hoteMotel,

  /// Industrial area
  industrialArea,

  /// Information centre
  informationCentre,

  /// Parking facility
  parkingFacility,

  /// Petrol station
  petrolStation,

  /// Railway station
  railwayStation,

  /// Rest area
  restArea,

  /// Restaurant
  restaurant,

  /// Toilet
  toilet,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension SignpostPictogramTypeExtension on SignpostPictogramType {
  int get id {
    switch (this) {
      case SignpostPictogramType.invalid:
        return 0;
      case SignpostPictogramType.airport:
        return 1;
      case SignpostPictogramType.busStation:
        return 2;
      case SignpostPictogramType.fairGround:
        return 3;
      case SignpostPictogramType.ferry:
        return 4;
      case SignpostPictogramType.firstAidPost:
        return 5;
      case SignpostPictogramType.harbour:
        return 6;
      case SignpostPictogramType.hospital:
        return 7;
      case SignpostPictogramType.hoteMotel:
        return 8;
      case SignpostPictogramType.industrialArea:
        return 9;
      case SignpostPictogramType.informationCentre:
        return 10;
      case SignpostPictogramType.parkingFacility:
        return 11;
      case SignpostPictogramType.petrolStation:
        return 12;
      case SignpostPictogramType.railwayStation:
        return 13;
      case SignpostPictogramType.restArea:
        return 14;
      case SignpostPictogramType.restaurant:
        return 15;
      case SignpostPictogramType.toilet:
        return 16;
    }
  }

  static SignpostPictogramType fromId(int id) {
    switch (id) {
      case 0:
        return SignpostPictogramType.invalid;
      case 1:
        return SignpostPictogramType.airport;
      case 2:
        return SignpostPictogramType.busStation;
      case 3:
        return SignpostPictogramType.fairGround;
      case 4:
        return SignpostPictogramType.ferry;
      case 5:
        return SignpostPictogramType.firstAidPost;
      case 6:
        return SignpostPictogramType.harbour;
      case 7:
        return SignpostPictogramType.hospital;
      case 8:
        return SignpostPictogramType.hoteMotel;
      case 9:
        return SignpostPictogramType.industrialArea;
      case 10:
        return SignpostPictogramType.informationCentre;
      case 11:
        return SignpostPictogramType.parkingFacility;
      case 12:
        return SignpostPictogramType.petrolStation;
      case 13:
        return SignpostPictogramType.railwayStation;
      case 14:
        return SignpostPictogramType.restArea;
      case 15:
        return SignpostPictogramType.restaurant;
      case 16:
        return SignpostPictogramType.toilet;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Signpost connection info.
///
/// {@category Routes & Navigation}
enum SignpostConnectionInfo {
  /// Invalid
  invalid,

  /// Branch
  branch,

  /// Towards
  towards,

  /// Exit
  exit,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension SignpostConnectionInfoExtension on SignpostConnectionInfo {
  int get id {
    switch (this) {
      case SignpostConnectionInfo.invalid:
        return 0;
      case SignpostConnectionInfo.branch:
        return 1;
      case SignpostConnectionInfo.towards:
        return 2;
      case SignpostConnectionInfo.exit:
        return 3;
    }
  }

  static SignpostConnectionInfo fromId(int id) {
    switch (id) {
      case 0:
        return SignpostConnectionInfo.invalid;
      case 1:
        return SignpostConnectionInfo.branch;
      case 2:
        return SignpostConnectionInfo.towards;
      case 3:
        return SignpostConnectionInfo.exit;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Navigation states
///
/// {@category Routes & Navigation}
enum NavigationStatus {
  /// Running, this is the normal state
  running,

  /// Paused, waiting for route to update
  ///
  /// Check navigation route status for details about route update
  waitingRoute,

  /// Paused, waiting for GPS location to recover
  waitingGps,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension NavigationStatusExtension on NavigationStatus {
  int get id {
    switch (this) {
      case NavigationStatus.running:
        return 0;
      case NavigationStatus.waitingRoute:
        return 1;
      case NavigationStatus.waitingGps:
        return 2;
    }
  }

  static NavigationStatus fromId(int id) {
    switch (id) {
      case 0:
        return NavigationStatus.running;
      case 1:
        return NavigationStatus.waitingRoute;
      case 2:
        return NavigationStatus.waitingGps;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Road Info object
///
/// {@category Routes & Navigation}
class RoadInfo {
  /// The road name
  String? roadname;

  /// The road shield type
  RoadShieldType? shieldtype;

  RoadInfo({
    this.roadname,
    this.shieldtype,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (roadname != null) {
      json['roadname'] = roadname;
    }
    if (shieldtype != null) {
      json['shieldtype'] = shieldtype!.id;
    }
    return json;
  }

  factory RoadInfo.fromJson(Map<String, dynamic> json) {
    return RoadInfo(
      roadname: json['roadname'],
      shieldtype: RoadShieldTypeExtension.fromId(json['shieldtype']),
    );
  }
}

/// Navigation instruction class
///
/// This class should not be instantiated directly. Instead, use the related methods from [NavigationService] an instance.
///
/// {@category Routes & Navigation}
class NavigationInstruction {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  NavigationInstruction._()
      : _pointerId = -1,
        _mapId = -1;

  NavigationInstruction.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get the ISO 3166-1 alpha-3 country code for the current navigation instruction.
  ///
  /// Empty string means no country. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
  ///
  /// **Returns**
  ///
  /// * The ISO 3166-1 alpha-3 country code for the current navigation instruction.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get currentCountryCodeISO {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getCurrentCountryCodeISO", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the current street name.
  ///
  /// **Returns**
  ///
  /// * The current street name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get currentStreetName {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getCurrentStreetName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the maximum speed limit on the current street in meters per second.
  ///
  /// **Returns**
  ///
  /// * 0 if maximum speed limit is not available.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get currentStreetSpeedLimit {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "NavigationInstruction",
            'method': "getCurrentStreetSpeedLimit",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get drive side flag of the current traveled road.
  ///
  /// **Returns**
  ///
  /// * The drive side flag of the current traveled road, [DriveSide] value
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  DriveSide get driveSide {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "NavigationInstruction", 'method': "getDriveSide", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return DriveSideExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Check if next next turn information is available.
  ///
  /// **Returns**
  ///
  /// * True if next next turn information is available, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasNextNextTurnInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "hasNextNextTurnInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if next next turn information is available.
  ///
  /// **Returns**
  ///
  /// * True if next turn information is available, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasNextTurnInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "NavigationInstruction", 'method': "hasNextTurnInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the index of the current route instruction on the current route segment.
  ///
  /// **Returns**
  ///
  /// * The index of the next route instruction on the current route segment
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get instructionIndex {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getInstructionIndex", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get an image representation of current lane configuration.
  ///
  /// Return empty if no lane information is currently available
  ///
  /// **Returns**
  ///
  /// * The lane image
  Uint8List getLaneImage(
      {Size? size, ImageFileFormat? format, LaneImageRenderSettings renderSettings = const LaneImageRenderSettings()}) {
    return GemKitPlatform.instance.callGetImage(pointerId, "NavigationInstructionGetLaneImage",
        size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1,
        arg: jsonEncode(renderSettings));
  }

  /// Get the navigation/simulation status.
  ///
  /// **Returns**
  ///
  /// * The navigation/simulation status
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  NavigationStatus get navigationStatus {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getNavigationStatus", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return NavigationStatusExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the ISO 3166-1 alpha-3 country code for the next navigation instruction.
  ///
  /// Empty string means no country. See: http://en.wikipedia.org/wiki/ISO_3166-1 for the list of codes.
  ///
  /// **Returns**
  ///
  /// * The ISO 3166-1 alpha-3 country code for the next navigation instruction
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get nextCountryCodeISO {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getNextCountryCodeISO", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the next next street name.
  ///
  /// **Returns**
  ///
  /// * The next street name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get nextNextStreetName {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getNextNextStreetName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the full details for the next-next turn.
  ///
  /// This may be used instead of `_getNextNextTurnIcon_` in order to customize turn display in UI.
  ///
  /// **Returns**
  ///
  /// * The full details for the next-next turn
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TurnDetails get nextNextTurnDetails {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getNextNextTurnDetails", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TurnDetails.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the schematic image of the next next turn.
  ///
  /// A simplified representation of the next next turn image. A detailed representation can be obtained with [nextNextTurnDetails].abstractGeometryImage.
  ///
  /// **Returns**
  ///
  /// * The image of the next next turn
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List getNextNextTurnImage({Size? size}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "NavigationInstruction",
            'method': "getNextNextTurnImage",
            'args': XyType<int>(x: size?.width.toInt(), y: size?.height.toInt())
          }));
      final decodedVal = jsonDecode(resultString!);
      return Uint8List.fromList(decodedVal['result'].cast<int>());
    } catch (e) {
      rethrow;
    }
  }

  /// Get the textual description for the next next turn.
  ///
  /// **Returns**
  ///
  /// * The textual description for the next next turn
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get nextNextTurnInstruction {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "NavigationInstruction",
            'method': "getNextNextTurnInstruction",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the next speed limit variation.
  ///
  /// **Parameters**
  ///
  /// * **IN** *checkDistance*	The speed limit variation search distance.
  ///
  /// **Returns**
  ///
  /// * [NextSpeedLimit] if a speed limit variation was found.
  ///
  /// { [Coordinates], 0, 0 } if speed limit doesn't change in the specified interval.
  ///
  /// { [Coordinates], distance, 0 } if speed limit value changed from <value> to <not available>.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  NextSpeedLimit getNextSpeedLimitVariation({int? checkDistance}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "NavigationInstruction",
            'method': "getNextSpeedLimitVariation",
            'args': (checkDistance != null) ? checkDistance : {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return NextSpeedLimit.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the next next street name.
  ///
  /// **Returns**
  ///
  /// * The next next street name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get nextStreetName {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "NavigationInstruction", 'method': "getNextStreetName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the full details for the next turn.
  ///
  /// This may be used instead of [getNextTurnImage] in order to customize turn display in UI.
  ///
  /// **Returns**
  ///
  /// * The full details for the next turn
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TurnDetails get nextTurnDetails {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "NavigationInstruction", 'method': "getNextTurnDetails", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TurnDetails.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the Schematic image of the next turn.
  ///
  /// A simplified representation of the next turn image. A detailed representation can be obtained with [nextTurnDetails].abstractGeometryImage.
  ///
  /// **Returns**
  ///
  /// * The image of the next turn
  Uint8List getNextTurnImage({Size? size, ImageFileFormat? format}) {
    return GemKitPlatform.instance.callGetImage(pointerId, "NavigationInstructionGetNextTurnImage",
        size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1);
  }

  /// Get the textual description for the next turn.
  ///
  /// **Returns**
  ///
  /// * The textual description for the next turn
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get nextTurnInstruction {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getNextTurnInstruction", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get remaining travel time in seconds and remaining travel distance in meters.
  ///
  /// **Returns**
  ///
  /// * The remaining travel time in seconds and remaining travel distance in meters.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get remainingTravelTimeDistance {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "NavigationInstruction",
            'method': "getRemainingTravelTimeDistance",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get remaining traveling time in seconds to the next way point and the remaining travel distance in meters to the next way point.
  ///
  /// **Returns**
  ///
  /// * Remaining travel time in seconds to the next way point and the remaining travel distance in meters to the next waypoint.
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
            'class': "NavigationInstruction",
            'method': "getRemainingTravelTimeDistanceToNextWaypoint",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the index of the current route segment.
  ///
  /// **Returns**
  ///
  /// * The index of the current route segment
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get segmentIndex {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "NavigationInstruction", 'method': "getSegmentIndex", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the extended signpost details.
  ///
  /// **Returns**
  ///
  /// * The extended signpost details.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  SignpostDetails get signpostDetails {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "NavigationInstruction", 'method': "getSignpostDetails", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return SignpostDetails.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the textual description for the signpost information.
  ///
  /// **Returns**
  ///
  /// * The textual description for the signpost information.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get signpostInstruction {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getSignpostInstruction", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the distance to the next-next turn in meters and time in seconds.
  ///
  /// If there are no next next turn available, the time distance to next turn will be returned
  ///
  /// **Returns**
  ///
  /// * The time to the next-next turn in seconds and distance in meters
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get timeDistanceToNextNextTurn {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "NavigationInstruction",
            'method': "getTimeDistanceToNextNextTurn",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the time to the next turn in seconds, distance in meters.
  ///
  /// **Returns**
  ///
  /// * The time to the next turn in seconds, distance in meters.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get timeDistanceToNextTurn {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getTimeDistanceToNextTurn", 'args': {}}));
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
  /// * The traveled time in seconds and the the traveled distance in meters
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  TimeDistance get traveledTimeDistance {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "NavigationInstruction", 'method': "getTraveledTimeDistance", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return TimeDistance.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "NavigationInstruction", 'id': _pointerId}));
  }
}

/// Next speed limit info
///
/// {@category Routes & Navigation}
class NextSpeedLimit {
  /// Coordinates where the next speed limit begins
  Coordinates? coords;

  /// Distance where the next speed limit begins
  int? distance;

  /// Next speed limit value
  double? speed;

  NextSpeedLimit({
    this.coords,
    this.distance,
    this.speed,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (coords != null) {
      json['coords'] = coords;
    }
    if (distance != null) {
      json['distance'] = distance;
    }
    if (speed != null) {
      json['speed'] = speed;
    }
    return json;
  }

  factory NextSpeedLimit.fromJson(Map<String, dynamic> json) {
    return NextSpeedLimit(
      coords: json['coords'],
      distance: json['distance'],
      speed: json['speed'],
    );
  }
}
