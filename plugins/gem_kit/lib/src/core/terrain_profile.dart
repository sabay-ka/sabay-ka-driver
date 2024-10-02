// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Route terrain profile
///
/// This class should not be instantiated directly. Instead, use the [RouteBase.terrainProfile] getter to obtain an instance.
/// Note that the [RoutePreferences.buildTerrainProfile] setting should be configured correctly when calling the [RoutingService.calculateRoute] method for the [RouteBase.terrainProfile] getter to return a valid object.
///
/// {@category Routes & Navigation}
class RouteTerrainProfile {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  RouteTerrainProfile._()
      : _pointerId = -1,
        _mapId = -1;

  RouteTerrainProfile.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get list of route climb sections.
  ///
  /// Climb sections are the difficult climbing parts of a route. The climb categories are defined in [Grade].
  ///
  /// If any of the climbing parts of a route is not at least Grade4 the list will be empty
  ///
  /// **Returns**
  ///
  /// * The climb sections list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<ClimbSection> get climbSections {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getClimbSections", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final listJson = decodedVal['result'] as List<dynamic>;
      List<ClimbSection> retList = listJson.map((categoryJson) => ClimbSection.fromJson(categoryJson)).toList();
      return retList;
    } catch (e) {
      rethrow;
    }
  }

  /// Get elevation at the given distance in meters from departure point/start of route.
  ///
  /// **Returns**
  ///
  /// * [GemError.outOfRange] if distance is bigger than the route length.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double getElevation(int distance) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getElevation", 'args': distance}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get elevation samples list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *countSamples* Number of samples.
  /// * **IN** *distBegin* Begin distance on route for sample interval.
  /// * **IN** *distEnd* End distance on route for sample interval.
  ///
  /// **Returns**
  ///
  /// * Pair(samples, resolution)
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Pair<List<dynamic>, double> getElevationSamples(int countSamples, int distBegin, int distEnd) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "RouteTerrainProfile",
            'method': "getElevationSamples",
            'args': {'countSamples': countSamples, 'distBegin': distBegin, 'distEnd': distEnd}
          }));
      final decodedVal = jsonDecode(resultString!);
      final listFloat = decodedVal['result']['floatlist'];
      final sample = decodedVal['result']['sample'];

      return Pair(listFloat, sample);
    } catch (e) {
      rethrow;
    }
  }

  /// Get terrain maximum elevation.
  ///
  /// **Returns**
  ///
  /// * Terrain maximum elevation
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get maxElevation {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getMaxElevation", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get terrain maximum elevation distance (from route start)
  ///
  /// **Returns**
  ///
  /// * Terrain maximum elevation distance
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get maxElevationDistance {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getMaxElevationDistance", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get terrain minimum elevation.
  ///
  /// **Returns**
  ///
  /// * Terrain minimum elevation
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  double get minElevation {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getMinElevation", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get terrain minimum elevation distance (from route start)
  ///
  /// **Returns**
  ///
  /// * Terrain minimum elevation distance
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get minElevationDistance {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getMinElevationDistance", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get list of route type sections.
  ///
  /// Each section has the start distance from route start and the road type (see [RoadType]).
  ///
  /// The end of the section is the distance from start of the next section or route total length (for the last section)
  ///
  /// **Returns**
  ///
  /// * The road type sections list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<RoadTypeSection> get roadTypeSections {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getRoadTypeSections", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final listJson = decodedVal['result'] as List<dynamic>;
      List<RoadTypeSection> retList = listJson.map((categoryJson) => RoadTypeSection.fromJson(categoryJson)).toList();
      return retList;
    } catch (e) {
      rethrow;
    }
  }

  /// Get list of route sections which are abrupt, that is, they have a significant elevation change.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categs* The user list of steep categories. Each entry contains the max slope for the steep category as diffX / diffY.
  ///
  /// A common steep categories list is `{-16.f, -10.f, -7.f, -4.f, -1.f, 1.f, 4.f, 7.f, 10.f, 16.f}`
  ///
  /// A positive value is for an ascension category, a negative value if a descent category.
  ///
  /// Each section has the start distance from route start and the category (index in user defined steep categories).
  ///
  /// The end of the section is the distance from start of the next section or route total length (for the last section)
  ///
  /// **Returns**
  ///
  /// * The steep sections list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<SteepSection> getSteepSections(List<double> categs) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getSteepSections", 'args': categs}));
      final decodedVal = jsonDecode(resultString!);
      final listJson = decodedVal['result'] as List<dynamic>;
      List<SteepSection> retList = listJson.map((categoryJson) => SteepSection.fromJson(categoryJson)).toList();
      return retList;
    } catch (e) {
      rethrow;
    }
  }

  /// Get list of route surface sections.
  ///
  /// Each section has the start distance from route start and the surface type (see [SurfaceType]).
  ///
  /// The end of the section is the distance from start of the next section or route total length (for the last section)
  ///
  /// **Returns**
  ///
  /// * The surface sections list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<SurfaceSection> get surfaceSections {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getSurfaceSections", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final listJson = decodedVal['result'] as List<dynamic>;
      List<SurfaceSection> retList = listJson.map((categoryJson) => SurfaceSection.fromJson(categoryJson)).toList();
      return retList;
    } catch (e) {
      rethrow;
    }
  }

  /// Get total terrain elevation down.
  ///
  /// **Returns**
  ///
  /// * Total terrain elevation down
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  double get totalDown {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getTotalDown", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get total terrain elevation up.
  ///
  /// **Returns**
  ///
  /// * Total terrain elevation up
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  double get totalUp {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "RouteTerrainProfile", 'method': "getTotalUp", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "RouteTerrainProfile", 'id': _pointerId}));
}

/// Climb grade - UCI based, see https://bicycles.stackexchange.com/questions/1210/how-are-the-categories-for-climbs-decided
///
/// Categories are sorted in descending order by difficulty ( EGradeHC - most difficult, EGrade4 - less difficult )
/// {@category Routes & Navigation}
enum Grade {
  gradeHC,
  grade1,
  grade2,
  grade3,
  grade4,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension GradeExtension on Grade {
  int get id {
    switch (this) {
      case Grade.gradeHC:
        return 0;
      case Grade.grade1:
        return 1;
      case Grade.grade2:
        return 2;
      case Grade.grade3:
        return 3;
      case Grade.grade4:
        return 4;
    }
  }

  static Grade fromId(int id) {
    switch (id) {
      case 0:
        return Grade.gradeHC;
      case 1:
        return Grade.grade1;
      case 2:
        return Grade.grade2;
      case 3:
        return Grade.grade3;
      case 4:
        return Grade.grade4;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Get surface type
///
/// {@category Routes & Navigation}
enum SurfaceType {
  /// Asphalt
  asphalt,

  /// Paved
  paved,

  /// Unpaved
  unpaved,

  /// Unknown
  unknown,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension SurfaceTypeExtension on SurfaceType {
  int get id {
    switch (this) {
      case SurfaceType.asphalt:
        return 0;
      case SurfaceType.paved:
        return 1;
      case SurfaceType.unpaved:
        return 2;
      case SurfaceType.unknown:
        return 3;
    }
  }

  static SurfaceType fromId(int id) {
    switch (id) {
      case 0:
        return SurfaceType.asphalt;
      case 1:
        return SurfaceType.paved;
      case 2:
        return SurfaceType.unpaved;
      case 3:
        return SurfaceType.unknown;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Get road type
///
/// {@category Routes & Navigation}
enum RoadType {
  /// Motorways
  motorways,

  /// State road
  stateRoad,

  /// Road
  road,

  /// Street
  street,

  /// Cycleway
  cycleway,

  /// Path
  path,

  /// Single track
  singleTrack,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Routes & Navigation}
extension RoadTypeExtension on RoadType {
  int get id {
    switch (this) {
      case RoadType.motorways:
        return 0;
      case RoadType.stateRoad:
        return 1;
      case RoadType.road:
        return 2;
      case RoadType.street:
        return 3;
      case RoadType.cycleway:
        return 4;
      case RoadType.path:
        return 5;
      case RoadType.singleTrack:
        return 6;
    }
  }

  static RoadType fromId(int id) {
    switch (id) {
      case 0:
        return RoadType.motorways;
      case 1:
        return RoadType.stateRoad;
      case 2:
        return RoadType.road;
      case 3:
        return RoadType.street;
      case 4:
        return RoadType.cycleway;
      case 5:
        return RoadType.path;
      case 6:
        return RoadType.singleTrack;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Climb section
///
/// {@category Routes & Navigation}
class ClimbSection {
  /// Distance in meters where this section starts.
  int? startDistanceM;

  /// Distance in meters where this section ends.
  int? endDistanceM;

  /// Slope value.
  double? slope;

  /// The grade value of this section.
  Grade? grade;

  ClimbSection({
    this.startDistanceM,
    this.endDistanceM,
    this.slope,
    this.grade,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (startDistanceM != null) {
      json['startDistanceM'] = startDistanceM;
    }
    if (endDistanceM != null) {
      json['endDistanceM'] = endDistanceM;
    }
    if (slope != null) {
      json['slope'] = slope;
    }
    if (grade != null) {
      json['grade'] = grade!.id;
    }
    return json;
  }

  factory ClimbSection.fromJson(Map<String, dynamic> json) {
    return ClimbSection(
      startDistanceM: json['startDistanceM'],
      endDistanceM: json['endDistanceM'],
      slope: json['slope'],
      grade: GradeExtension.fromId(json['grade']),
    );
  }

  @override
  bool operator ==(covariant ClimbSection other) {
    if (identical(this, other)) return true;

    return other.startDistanceM == startDistanceM &&
        other.endDistanceM == endDistanceM &&
        other.slope == slope &&
        other.grade == grade;
  }

  @override
  int get hashCode {
    return startDistanceM.hashCode ^ endDistanceM.hashCode ^ slope.hashCode ^ grade.hashCode;
  }
}

/// Surface sections
///
/// Sections list is in route begin -> end walk order.
///
/// {@category Routes & Navigation}
class SurfaceSection {
  /// Distance in meters where the section starts.
  int? startDistanceM;

  /// The type of surface.
  SurfaceType? type;

  SurfaceSection({
    this.startDistanceM,
    this.type,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (startDistanceM != null) {
      json['startDistanceM'] = startDistanceM;
    }
    if (type != null) {
      json['type'] = type!.id;
    }
    return json;
  }

  factory SurfaceSection.fromJson(Map<String, dynamic> json) {
    return SurfaceSection(
      startDistanceM: json['startDistanceM'],
      type: SurfaceTypeExtension.fromId(json['type']),
    );
  }

  @override
  bool operator ==(covariant SurfaceSection other) {
    if (identical(this, other)) return true;

    return other.startDistanceM == startDistanceM && other.type == type;
  }

  @override
  int get hashCode {
    return startDistanceM.hashCode ^ type.hashCode;
  }
}

/// Road type sections
///
/// Sections list is in route begin -> end walk orders
///
/// {@category Routes & Navigation}
class RoadTypeSection {
  /// Distance in meters where the section starts
  int? startDistanceM;

  /// The road type
  RoadType? type;

  RoadTypeSection({
    this.startDistanceM,
    this.type,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (startDistanceM != null) {
      json['startDistanceM'] = startDistanceM;
    }
    if (type != null) {
      json['type'] = type!.id;
    }
    return json;
  }

  factory RoadTypeSection.fromJson(Map<String, dynamic> json) {
    return RoadTypeSection(
      startDistanceM: json['startDistanceM'],
      type: RoadTypeExtension.fromId(json['type']),
    );
  }

  @override
  bool operator ==(covariant RoadTypeSection other) {
    if (identical(this, other)) return true;

    return other.startDistanceM == startDistanceM && other.type == type;
  }

  @override
  int get hashCode {
    return startDistanceM.hashCode ^ type.hashCode;
  }
}

/// Steep sections
///
/// Sections list is in route begin -> end walk order.
///
/// {@category Routes & Navigation}
class SteepSection {
  /// Distance in meters where the section starts.
  int? startDistanceM;

  /// The category of steep ( index in user steep categories list, see getSteepSections for details )
  int? categ;
  SteepSection({
    this.startDistanceM,
    this.categ,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (startDistanceM != null) {
      json['startDistanceM'] = startDistanceM;
    }
    if (categ != null) {
      json['categ'] = categ;
    }
    return json;
  }

  factory SteepSection.fromJson(Map<String, dynamic> json) {
    return SteepSection(
      startDistanceM: json['startDistanceM'],
      categ: json['categ'],
    );
  }
  @override
  bool operator ==(covariant SteepSection other) {
    if (identical(this, other)) return true;

    return other.startDistanceM == startDistanceM && other.categ == categ;
  }

  @override
  int get hashCode {
    return startDistanceM.hashCode ^ categ.hashCode;
  }
}
