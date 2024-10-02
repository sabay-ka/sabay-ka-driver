// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal
library markers;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gem_kit/map.dart';
import 'package:gem_kit/src/core/coordinates.dart';
import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/data_buffer.dart';
import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/core/geographic_area.dart';
import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import "dart:convert";

/// Marker labeling mode
///
/// {@category Maps & 3D Scene}
enum MarkerLabelingMode {
  /// None
  none,

  /// Label each marker item
  item,

  /// Label marker groups
  group,

  /// Text centered on the icon
  textCentered,

  /// Group label is centered on image
  groupCenter,

  /// Label fits the image
  fitImage,

  /// Icon is placed above the coordinates of the market
  iconBottomCenter,

  /// Text above the icon
  textAbove,

  ///Text below the icon
  textBellow,
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MarkerLabelingModeExtension on MarkerLabelingMode {
  int get id {
    switch (this) {
      case MarkerLabelingMode.none:
        return 0;
      case MarkerLabelingMode.item:
        return 1;
      case MarkerLabelingMode.group:
        return 2;
      case MarkerLabelingMode.textCentered:
        return 4;
      case MarkerLabelingMode.groupCenter:
        return 8;
      case MarkerLabelingMode.fitImage:
        return 16;
      case MarkerLabelingMode.iconBottomCenter:
        return 32;
      case MarkerLabelingMode.textAbove:
        return 64;
      case MarkerLabelingMode.textBellow:
        return 128;
    }
  }

  static MarkerLabelingMode fromId(int id) {
    switch (id) {
      case 0:
        return MarkerLabelingMode.none;
      case 1:
        return MarkerLabelingMode.item;
      case 2:
        return MarkerLabelingMode.group;
      case 4:
        return MarkerLabelingMode.textCentered;
      case 8:
        return MarkerLabelingMode.groupCenter;
      case 16:
        return MarkerLabelingMode.fitImage;
      case 32:
        return MarkerLabelingMode.iconBottomCenter;
      case 64:
        return MarkerLabelingMode.textAbove;
      case 128:
        return MarkerLabelingMode.textBellow;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Marker collection render settings
///
/// {@category Maps & 3D Scene}
class MarkerCollectionRenderSettings extends MarkerRenderSettings {
  /// The default maximum number of items in a low density points group.
  static const int lowGCountDefault = 50;

  /// The default maximum number of items in a medium density points group.
  static const int medGCountDefault = 300;

  /// The zoom level at which points grouping is enabled.
  int? pointsGroupingZoomLevel;

  /// The image for rendering low density points groups
  GemImage? lowDensityPointsGroupImage = GemImage(imageId: MarkerRenderSettings.kDefValue);

  /// The maximum number of items in a low density points group.
  ///
  /// If the group items are less than or equal to this value, the lowDensityPointsGroupImage is used for displaying the group.
  int? lowDensityPointsGroupMaxCount;

  /// The image for rendering medium density points groups
  GemImage? mediumDensityPointsGroupImage = GemImage(imageId: MarkerRenderSettings.kDefValue);

  /// The maximum number of items in a medium density points group.
  ///
  /// If the group items are less than or equal to this value, the mediumDensityPointsGroupImage is used for displaying the group.
  int? mediumDensityPointsGroupMaxCount;

  /// The image for rendering high density points groups
  GemImage? highDensityPointsGroupImage = GemImage(imageId: MarkerRenderSettings.kDefValue);

  /// The text color for group labels.
  ///
  /// Default value is obtained from the current style
  Color? labelGroupTextColor;

  /// The text size for group labels in mm.
  ///
  /// Default value is kDefGroupTextSize.
  int? labelGroupTextSize;

  /// Flag indicating whether to build points group configuration. Default value is false.
  ///
  /// If enabled, the user can access the marker -> points group relation, i.e. identify the points group head marker for every marker in the collection.
  bool? buildPointsGroupConfig;

  /// The texture for polylines. Default value is none.
  ///
  /// The polyline texture will be blended with the polylineInnerColor value. User must set polylineInnerColor to Rgba::white() in order to preserve original texture colors.
  GemImage? polylineTexture = GemImage(imageId: MarkerRenderSettings.kDefValue);

  /// The texture for polygons. Default value is none.
  ///
  /// The polygon texture will be blended with the polygonFillColor value. User must set polygonFillColor to Rgba::white() in order to preserve original texture colors.
  GemImage? polygonTexture = GemImage(imageId: MarkerRenderSettings.kDefValue);

  MarkerCollectionRenderSettings({
    this.pointsGroupingZoomLevel = MarkerRenderSettings.kDefValue,
    this.lowDensityPointsGroupImage,
    this.lowDensityPointsGroupMaxCount = lowGCountDefault,
    this.mediumDensityPointsGroupImage,
    this.mediumDensityPointsGroupMaxCount = medGCountDefault,
    this.highDensityPointsGroupImage,
    this.labelGroupTextColor,
    this.labelGroupTextSize = 2,
    this.buildPointsGroupConfig = false,
    this.polylineTexture,
    this.polygonTexture,
    super.image,
    super.imageSize = -1.0,
    super.labelingMode,
    super.labelTextSize = 1.0,
    super.labelTextColor,
    super.polylineInnerColor,
    super.polylineOuterColor,
    super.polygonFillColor,
    super.polylineInnerSize = 1.5,
    super.polylineOuterSize = 0.0,
  }) {
    lowDensityPointsGroupImage ??= GemImage(imageId: MarkerRenderSettings.kDefValue);
    mediumDensityPointsGroupImage ??= GemImage(imageId: MarkerRenderSettings.kDefValue);
    highDensityPointsGroupImage ??= GemImage(imageId: MarkerRenderSettings.kDefValue);
    polygonTexture ??= GemImage(imageId: MarkerRenderSettings.kDefValue);
    polylineTexture ??= GemImage(imageId: MarkerRenderSettings.kDefValue);
    image ??= GemImage(imageId: MarkerRenderSettings.kDefValue);
    labelingMode ??= MarkerLabelingMode.groupCenter.id | MarkerLabelingMode.fitImage.id;
    labelTextColor ??= Colors.transparent;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (pointsGroupingZoomLevel != null) {
      json['groupingLevel'] = pointsGroupingZoomLevel;
    }
    if (lowDensityPointsGroupImage != null) {
      json['lowDensityGroupImage'] = lowDensityPointsGroupImage;
    }
    if (lowDensityPointsGroupMaxCount != null) {
      json['lowGroupMaxCount'] = lowDensityPointsGroupMaxCount;
    }
    if (mediumDensityPointsGroupImage != null) {
      json['mediumDensityGroupImage'] = mediumDensityPointsGroupImage;
    }
    if (mediumDensityPointsGroupMaxCount != null) {
      json['mediumGroupMaxCount'] = mediumDensityPointsGroupMaxCount;
    }
    if (highDensityPointsGroupImage != null) {
      json['highDensityGroupImage'] = highDensityPointsGroupImage;
    }
    if (labelGroupTextColor != null) {
      json['groupLabelTextColor'] = labelGroupTextColor!.toRgba();
    }
    if (labelGroupTextSize != null) {
      json['groupLabelTextSize'] = labelGroupTextSize;
    }
    if (buildPointsGroupConfig != null) {
      json['buildGroupConfig'] = buildPointsGroupConfig;
    }
    if (polylineTexture != null) {
      json['polylineTexture'] = polylineTexture;
    }
    if (polygonTexture != null) {
      json['polygonTexture'] = polygonTexture;
    }
    if (image != null) {
      json['image'] = image;
    }
    if (polylineInnerColor != null) {
      json['polylineInnerColor'] = polylineInnerColor!.toRgba();
    }
    if (polylineOuterColor != null) {
      json['polylineOuterColor'] = polylineOuterColor!.toRgba();
    }
    if (polygonFillColor != null) {
      json['polygonFillColor'] = polygonFillColor!.toRgba();
    }
    if (labelTextColor != null) {
      json['labelTextColor'] = labelTextColor!.toRgba();
    }
    if (_imagePointer != null) {
      json['imagePointer'] = _imagePointer;
    }
    if (_imagePointerSize != null) {
      json['imagePointerSize'] = _imagePointerSize;
    }

    json['imageSize'] = imageSize;
    json['labelingMode'] = labelingMode;
    json['labelTextSize'] = labelTextSize;
    json['labelTextColor'] = labelTextColor!.toRgba();
    json['hashCode'] = json.hashCode;
    json['polylineInnerSize'] = polylineInnerSize;
    json['polylineOuterSize'] = polylineOuterSize;
    return json;
  }

  factory MarkerCollectionRenderSettings.fromJson(Map<String, dynamic> json) {
    return MarkerCollectionRenderSettings(
      pointsGroupingZoomLevel: json['groupingLevel'],
      lowDensityPointsGroupImage: json['lowDensityGroupImage'],
      lowDensityPointsGroupMaxCount: json['lowGroupMaxCount'],
      mediumDensityPointsGroupImage: json['mediumDensityGroupImage'],
      mediumDensityPointsGroupMaxCount: json['mediumGroupMaxCount'],
      highDensityPointsGroupImage: json['highDensityGroupImage'],
      labelGroupTextColor: Color.fromARGB(255, (json['groupLabelTextColor'] as Rgba).r,
          (json['groupLabelTextColor'] as Rgba).g, (json['groupLabelTextColor'] as Rgba).b),
      labelGroupTextSize: json['groupLabelTextSize'],
      buildPointsGroupConfig: json['buildGroupConfig'],
      polylineTexture: json['polylineTexture'],
      polygonTexture: json['polygonTexture'],
      image: json['image'],
      imageSize: json['imageSize'],
      labelingMode: json['labelingMode'],
      labelTextSize: json['labelTextSize'],
      labelTextColor: Color.fromARGB(255, (json['labelTextColor'] as Rgba).r, (json['labelTextColor'] as Rgba).g,
          (json['labelTextColor'] as Rgba).b),
      polylineInnerColor: json['polylineInnerColor'],
      polylineOuterColor: json['polylineOuterColor'],
      polygonFillColor: Color.fromARGB(255, (json['polygonFillColor'] as Rgba).r, (json['polygonFillColor'] as Rgba).g,
          (json['polygonFillColor'] as Rgba).b),
      polylineInnerSize: json['polylineInnerSize'] ?? 1.5,
      polylineOuterSize: json['polylineOuterSize'] ?? 0.0,
    );
  }
}

/// Marker custom rendering information
///
/// {@category Maps & 3D Scene}
class MarkerCustomRenderData {
  /// Grouped markers count
  ///
  /// A value > 1 means that the marker is the header of a points group containing pointsGroupCount markers
  int? pointsGroupCount;

  MarkerCustomRenderData({
    this.pointsGroupCount,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (pointsGroupCount != null) {
      json['pointsGroupCount'] = pointsGroupCount;
    }
    return json;
  }

  factory MarkerCustomRenderData.fromJson(Map<String, dynamic> json) {
    return MarkerCustomRenderData(
      pointsGroupCount: json['pointsGroupCount'],
    );
  }
}

/// Marker type
///
/// {@category Maps & 3D Scene}
enum MarkerType {
  /// Multi-point marker
  point,

  /// Polyline marker
  polyline,

  /// Polygon marker
  polygon,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MarkerTypeExtension on MarkerType {
  int get id {
    switch (this) {
      case MarkerType.point:
        return 0;
      case MarkerType.polyline:
        return 1;
      case MarkerType.polygon:
        return 2;
    }
  }

  static MarkerType fromId(int id) {
    switch (id) {
      case 0:
        return MarkerType.point;
      case 1:
        return MarkerType.polyline;
      case 2:
        return MarkerType.polygon;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Marker match type
///
/// {@category Maps & 3D Scene}
enum MarkerMatchType {
  /// None
  none,

  /// Match on a coordinate
  coordinate,

  /// Match on a coordinate group
  coordinateGroup,

  /// Match on marker contour ( for polyline and polygon types )
  contour,

  /// Match inside marker ( for polygon types )
  inside,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension MarkerMatchTypeExtension on MarkerMatchType {
  int get id {
    switch (this) {
      case MarkerMatchType.none:
        return 0;
      case MarkerMatchType.coordinate:
        return 1;
      case MarkerMatchType.coordinateGroup:
        return 2;
      case MarkerMatchType.contour:
        return 3;
      case MarkerMatchType.inside:
        return 4;
    }
  }

  static MarkerMatchType fromId(int id) {
    switch (id) {
      case 0:
        return MarkerMatchType.none;
      case 1:
        return MarkerMatchType.coordinate;
      case 2:
        return MarkerMatchType.coordinateGroup;
      case 3:
        return MarkerMatchType.contour;
      case 4:
        return MarkerMatchType.inside;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Marker
///
/// {@category Maps & 3D Scene}
class Marker {
  final dynamic _pointerId;
  final int _mapId;

  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;

  factory Marker() {
    return Marker._create(0);
  }

  Marker.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Add a new coordinate to the marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* The coordinate to be added.
  /// * **IN** *index* The position where the coordinate is added, default -1 (append at the end).
  /// * **IN** *part* The marker part index to which the function applies, default 0 (first part).
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void add(
    Coordinates coord, {
    int? index,
    int? part,
  }) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Marker",
            'method': "add",
            'args': {'coord': coord, if (index != null) 'index': index, if (part != null) 'part': part}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a coordinate from the marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index*	The position of the deleted coordinate
  /// * **IN** *part*	The marker part index to which the function applies, default 0 (first part).
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void delete(
    int index, {
    int? part,
  }) async {
    try {
      await GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Marker",
            'method': "del",
            'args': {'index': index, if (part != null) 'part': part}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a part from marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *part*	The marker part index to be deleted.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void deletePart(int part) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Marker", 'method': "delPart", 'args': part}));
    } catch (e) {
      rethrow;
    }
  }

  // /// Get marker enclosing area.
  // ///
  // /// **Returns**
  // ///
  // /// * [RectangleGeographicArea] object
  // ///
  // /// **Throws**
  // ///
  // /// * An exception if it fails.
  // RectangleGeographicArea get area {
  //   try {
  //     final resultString = GemKitPlatform.instance.callObjectMethodffi(
  //         this, jsonEncode({'id': _pointerId, 'class': "Marker", 'method': "getArea", 'args': {}}));
  //     final decodedVal = jsonDecode(resultString!);
  //     return RectangleGeographicArea.fromJson(decodedVal['result']);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  /// Get marker coordinates list.
  ///
  /// **Parameters**
  ///
  /// * **IN** *part*	The marker part index to which the function applies, default 0 (first part).
  ///
  /// **Returns**
  ///
  /// * [Coordinates] list
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<Coordinates> getCoordinates({int part = 0}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Marker", 'method': "getCoordinates", 'args': part}));
      final decodedVal = jsonDecode(resultString!);
      final listJson = decodedVal['result'] as List<dynamic>;
      List<Coordinates> retList = listJson.map((categoryJson) => Coordinates.fromJson(categoryJson)).toList();
      return retList;
//return CoordinatesList.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get marker unique id.
  ///
  /// **Returns**
  ///
  /// * marker id
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethodffi(this, jsonEncode({'id': _pointerId, 'class': "Marker", 'method': "getId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get marker name.
  ///
  /// **Returns**
  ///
  /// * marker name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Marker", 'method': "getName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get marker part enclosing area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *part*	The marker part index to which the function applies.
  ///
  /// **Returns**
  ///
  /// * [RectangleGeographicArea] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea getPartArea(int part) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Marker", 'method': "getPartArea", 'args': part}));
      final decodedVal = jsonDecode(resultString!);
      return RectangleGeographicArea.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get marker parts count.
  ///
  /// **Returns**
  ///
  /// * marker parts count
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get partCount {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Marker", 'method': "getPartCount", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set marker part coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords*	The coordinates list to be set as marker part.
  /// * **IN** *part*	The marker part index to which the function applies, default 0 (first part).
  ///
  /// If part == [partCount], a new part is automatically added to the marker and the coordinate is assigned to it.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void setCoordinates(
    List<Coordinates> coords, {
    int? part,
  }) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Marker",
            'method': "setCoordinates",
            'args': {'coords': coords, if (part != null) 'part': part}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set marker name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The name.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  set name(String name) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Marker", 'method': "setName", 'args': name}));
    } catch (e) {
      rethrow;
    }
  }

  /// Update a coordinate in the marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords*	The new coordinate value.
  /// * **IN** *index*	The position of the updated coordinate.
  /// * **IN** *part*	The marker part index to which the function applies, default 0 (first part).
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void update(
    Coordinates coord,
    int index, {
    int? part,
  }) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          dispatchOnMainThread: true,
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Marker",
            'method': "update",
            'args': {'coord': coord, 'index': index, if (part != null) 'part': part}
          }));
    } catch (e) {
      rethrow;
    }
  }

  static Marker _create(int mapId) {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "Marker"}));
    final decodedVal = jsonDecode(resultString!);
    return Marker.init(decodedVal['result'], mapId);
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "Marker", 'id': _pointerId}));
  }
}

/// Marker collection class
///
/// {@category Maps & 3D Scene}
class MarkerCollection {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  factory MarkerCollection({required MarkerType markerType, required String name}) {
    return MarkerCollection._create(0, markerType, name);
  }
  MarkerCollection.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Delete all markers.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "clear", 'args': {}}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Add a new marker to collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *marker*	The marker added to the collection.
  /// * **IN** *index*	The new marker position in collection. -1 means at the collection end (topmost).
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void add(Marker marker, {int index = -1}) {
    try {
      GemKitPlatform.instance.registerWeakRelease(marker, marker.pointerId);
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "add", 'args': marker.pointerId}));
      marker.dispose();
    } catch (e) {
      rethrow;
    }
  }

  /// Get the index of the given marker.
  ///
  /// **Parameters**
  ///
  /// * **IN** *marker*	The marker.
  ///
  /// **Returns**
  ///
  /// * The index of the given marker.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int indexOf(Marker marker) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "indexOf", 'args': marker.pointerId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a marker by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index*	The index of the marker to be deleted.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void delete(int index) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "del", 'args': index}));
    } catch (e) {
      rethrow;
    }
  }

  /// Get whole collection enclosing area.
  ///
  ///  **Returns**
  ///
  /// * [RectangleGeographicArea] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea get area {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "getArea", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return RectangleGeographicArea.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get collection id.
  ///
  /// **Returns**
  ///
  /// * collection id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "getId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the marker at the given index.
  ///
  /// Return empty if index is not valid.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index*	The marker index.
  ///
  /// **Returns**
  ///
  /// * [Marker] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Marker getMarkerAt(int index) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "getMarkerAt", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return Marker.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the marker with the given id.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id*	The marker id.
  ///
  /// **Returns**
  ///
  /// * [Marker] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Marker getMarkerById(int id) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "getMarkerById", 'args': id}));
      final decodedVal = jsonDecode(resultString!);
      return Marker.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the points group head for the given marker id.
  ///
  /// This requires the collection to be added to a map view collection with [MarkerCollectionRenderSettings.buildPointsGroupConfig] set to true
  ///
  /// If points group head info is not available the function will return a reference to the queried marker and will set the API error accordingly
  ///
  /// If markerId is already a points group head the function will return a reference to the queried marker and will set the API error accordingly
  ///
  /// **Parameters**
  ///
  /// * **IN** *id*	The group id.
  ///
  /// **Returns**
  ///
  /// * Points group head marker
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Marker getPointsGroupHead(int id) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "getPointsGroupHead", 'args': id}));
      final decodedVal = jsonDecode(resultString!);
      return Marker.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the points group components.
  ///
  /// This requires the collection to be added to a map view collection with [MarkerCollectionRenderSettings.buildPointsGroupConfig] set to true
  ///
  /// If points group head info is not available the function will return a default list and will set the API error accordingly
  ///
  /// **Parameters**
  ///
  /// * **IN** *id*	The group id.
  ///
  /// **Returns**
  ///
  /// * Points group components list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<Marker> getPointsGroupComponents(int id) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MarkerCollection", 'method': "getPointsGroupComponents", 'args': id}));
      final decodedVal = jsonDecode(resultString!);
      return MarkerList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get collection name.
  ///
  /// **Returns**
  ///
  /// * collection name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "getName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get marker count.
  ///
  /// **Returns**
  ///
  /// * collection size
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "size", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get collection type.
  ///
  /// **Returns**
  ///
  /// * collection type
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  MarkerType get type {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "getType", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return MarkerTypeExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Set collection name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* Collection name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set name(String name) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MarkerCollection", 'method': "setName", 'args': name}));
    } catch (e) {
      rethrow;
    }
  }

  static MarkerCollection _create(int mapId, MarkerType markerType, String name) {
    final resultString = GemKitPlatform.instance
        .callCreateObject(jsonEncode({'class': "MarkerCollection", 'type': markerType.id, 'name': name}));
    final decodedVal = jsonDecode(resultString!);
    return MarkerCollection.init(decodedVal['result'], mapId);
  }

  Future<void> dispose() async {
    await GemKitPlatform.instance
        .getChannel(mapId: mapId)
        .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "MarkerCollection", 'id': _pointerId}));
  }
}

/// Marker match
///
/// {@category Maps & 3D Scene}

class MarkerMatch {
  final int _pointerId;
  final int _mapId;
  int get pointerId => _pointerId;
  MarkerMatch()
      : _pointerId = -1,
        _mapId = -1;
  MarkerMatch.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get matched marker.
  ///
  /// **Returns**
  ///
  /// * [Marker] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Marker getMarker() {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "MarkerMatch", 'method': "getMarker", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Marker.init(decodedVal['result'], _mapId);
    } catch (e) {
      throw (e.toString());
    }
  }
}

/// Mapview marker collections class
///
/// This class should not be instantiated directly. Instead, use the [MapViewPreferences.markers] getter to obtain an instance.
///
/// {@category Maps & 3D Scene}
class MapViewMarkerCollections {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  Map<int, ExternalRendererMarkers> externalRenderers = {};

  // ignore: unused_element
  MapViewMarkerCollections._()
      : _pointerId = -1,
        _mapId = -1;

  MapViewMarkerCollections.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Add collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *col*	The markers collection to be added
  /// * **IN** *settings*	The markers collection render settings
  /// * **IN** *externalRender*	The render
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void add(
    MarkerCollection col, {
    MarkerCollectionRenderSettings? settings,
    ExternalRendererMarkers? externalRender,
  }) {
    settings ??= MarkerCollectionRenderSettings();
    if (externalRender != null) {
      externalRenderers[col.id] = externalRender;
    }
    bool hasExternalRender = externalRender != null;
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewMarkerCollections",
            'method': "add",
            'args': {
              'col': col.pointerId,
              'settings': settings,
              if (externalRender != null) 'externalRender': hasExternalRender,
              'maxzoomlevel': 10,
            }
          }),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Adds a list of markers and coresponding render settings
  ///
  /// **Parameters**
  ///
  /// * **IN** *list* The list of markers with coresponding render settings
  /// * **IN** *settings* The render settings for the marker collection
  /// * **IN** *name* The name of the collection
  /// * **IN** *markerType* The type of marker
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  List<int> addList(
      {required List<MarkerWithRenderSettings> list,
      required MarkerCollectionRenderSettings settings,
      required String name,
      MarkerType markerType = MarkerType.point}) {
    try {
      final jsonResponse = GemKitPlatform.instance.addList(object: this, list: list, settings: settings, name: name);
      final Map<String, dynamic> parsedResponse = jsonDecode(jsonResponse);
      final List<int> resultList = List<int>.from(parsedResponse['result']);
      return resultList;
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the specified collection is in the collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *col* The markers collection to be searched.
  ///
  /// **Returns**
  ///
  /// * True if the collection is in the collection, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool contains(MarkerCollection col) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewMarkerCollections", 'method': "contains", 'args': col._pointerId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get collection at index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The collection index
  ///
  /// **Returns**
  ///
  /// * The [MarkerCollection] object
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MarkerCollection getCollectionAt(int index) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewMarkerCollections", 'method': "getCollectionAt", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return MarkerCollection.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Hit test in all collections.
  ///
  /// **Parameters**
  ///
  /// * **IN** *area*	The geographic area to be tested
  ///
  /// **Returns**
  ///
  /// * The [MarkerMatchList]
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  MarkerMatchList hitTest(RectangleGeographicArea area) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewMarkerCollections",
            'method': "hitTest",
            'args': {'area': area}
          }));
      final decodedVal = jsonDecode(resultString!);
      return MarkerMatchList.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the index of the given collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *col* The markers collection to be searched
  ///
  /// **Returns**
  ///
  /// * The collection index on success, [GemError.notFound] on error
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int indexOf(MarkerCollection col) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "MapViewMarkerCollections", 'method': "indexOf", 'args': col._pointerId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the given collection is a sketches collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coll*	The collection to be checked
  ///
  /// **Returns**
  ///
  /// * True if the collection is a sketches collection, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool isSketches(MarkerCollection coll) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewMarkerCollections",
            'method': "isSketches",
            'args': coll._pointerId
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Deserialize from buffer.
  ///
  /// **Parameters**
  ///
  /// * **IN** *buffer*	The buffer to deserialize from
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<GemError> load(DataBuffer buffer) async {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewMarkerCollections", 'method': "load", 'args': buffer}));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  void onMarkerRender(GemMapController mapController, dynamic data) =>
      externalRenderers[data['sourceId']]!.processData(mapController, data);

  void onViewRendered(dynamic data) {
    if (data['markersIds']!.length > 0) {
      List<dynamic> markersIds = data['markersIds'];
      List<dynamic> sourcesIds = data['sourcesIds'];
      for (int i = 0; i < markersIds.length; ++i) {
        externalRenderers[sourcesIds.elementAt(i)]!.removeData(markersIds[i]);
      }
    }
    externalRenderers[data['sourceId']]?.onNotifyCustom!(2);
  }

  /// Remove collection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The collection index
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void removeAt(int index) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({
          'id': _pointerId,
          'class': "MapViewMarkerCollections",
          'method': "remove",
          'args': index,
        }),
        dispatchOnMainThread: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Serialize to buffer.
  ///
  /// **Parameters**
  ///
  /// * **IN** *buffer*	The buffer to serialize to
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Future<GemError> save(DataBuffer buffer) async {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewMarkerCollections", 'method': "save", 'args': buffer}));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Sets collection render settings.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The collection index
  /// * **IN** *settings* [MarkerCollectionRenderSettings]
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, otherwise see [GemError] for other values.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  GemError setRenderSettings(int index, MarkerCollectionRenderSettings settings) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "MapViewMarkerCollections",
            'method': "setRenderSettings",
            'args': {'index': index, 'settings': settings}
          }));
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get collection size.
  ///
  /// **Returns**
  ///
  /// * The number of collections
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get size {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewMarkerCollections", 'method': "size", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Remove all collections.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void clear() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "MapViewMarkerCollections", 'method': "clear", 'args': {}}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async => await GemKitPlatform.instance.getChannel(mapId: mapId).invokeMethod<String>(
      'callObjectDestructor', jsonEncode({'class': "MapViewMarkerCollections", 'id': _pointerId}));
}

/// Marker render settings
///
/// {@category Maps & 3D Scene}
class MarkerRenderSettings {
  /// Default value of various members. Members assigned with this value will be changed internally to something more appropriate.
  static const int kDefValue = 2147483647;

  /// The image
  GemImage? image = GemImage(imageId: kDefValue);

  /// The polyline inner color
  Color? polylineInnerColor;

  /// The polyline outer colors
  Color? polylineOuterColor;

  /// The polygon fill color
  Color? polygonFillColor;

  /// The label text color
  Color? labelTextColor;

  /// The polyline inner size
  double polylineInnerSize;

  /// The polyline outer size
  double polylineOuterSize;

  /// The label text size
  double labelTextSize;

  /// The image size
  double imageSize;

  /// The labeling mode
  int? labelingMode;
  dynamic _imagePointer;
  dynamic _imagePointerSize;

  MarkerRenderSettings({
    this.image,
    this.polylineInnerColor,
    this.polylineOuterColor,
    this.polygonFillColor,
    this.labelTextColor,
    this.polylineInnerSize = 1.5,
    this.polylineOuterSize = 0.0,
    this.labelTextSize = 1.0,
    this.imageSize = -1.0,
    this.labelingMode,
  }) {
    labelingMode ??= MarkerLabelingMode.item.id |
        MarkerLabelingMode.group.id |
        MarkerLabelingMode.iconBottomCenter.id |
        MarkerLabelingMode.textAbove.id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (image != null) {
      json['image'] = image;
    }
    if (polylineInnerColor != null) {
      json['polylineInnerColor'] = polylineInnerColor!.toRgba();
    }
    if (polylineOuterColor != null) {
      json['polylineOuterColor'] = polylineOuterColor!.toRgba();
    }
    if (polygonFillColor != null) {
      json['polygonFillColor'] = polygonFillColor!.toRgba();
    }
    if (labelTextColor != null) {
      json['labelTextColor'] = labelTextColor!.toRgba();
    }

    json['polylineInnerSize'] = polylineInnerSize;

    json['polylineOuterSize'] = polylineOuterSize;

    json['labelTextSize'] = labelTextSize;

    json['imageSize'] = imageSize;

    if (labelingMode != null) {
      json['labelingMode'] = labelingMode;
    }
    if (_imagePointer != null) {
      json['imagePointer'] = _imagePointer;
    }
    if (_imagePointerSize != null) {
      json['imagePointerSize'] = _imagePointerSize;
    }
    json['hashCode'] = image.hashCode ^
        polylineInnerColor.hashCode ^
        polylineOuterColor.hashCode ^
        polygonFillColor.hashCode ^
        labelTextColor.hashCode ^
        polylineInnerSize.hashCode ^
        polylineOuterSize.hashCode ^
        labelTextSize.hashCode ^
        imageSize.hashCode ^
        labelingMode.hashCode ^
        _imagePointer.hashCode ^
        _imagePointerSize.hashCode;
    return json;
  }

  factory MarkerRenderSettings.fromJson(Map<String, dynamic> json) {
    return MarkerRenderSettings(
      image: json['image'],
      polylineInnerColor: json['polylineInnerColor'],
      polylineOuterColor: json['polylineOuterColor'],
      polygonFillColor: json['polygonFillColor'],
      labelTextColor: json['labelTextColor'],
      polylineInnerSize: json['polylineInnerSize'] ?? 1.5,
      polylineOuterSize: json['polylineOuterSize'] ?? 0.0,
      labelTextSize: json['labelTextSize'] ?? 0x7FFFFFFF,
      imageSize: json['imageSize'] ?? -1.0,
      labelingMode: json['labelingMode'],
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MarkerRenderSettings &&
        other.image == image &&
        other.polylineInnerColor == polylineInnerColor &&
        other.polylineOuterColor == polylineOuterColor &&
        other.polygonFillColor == polygonFillColor &&
        other.labelTextColor == labelTextColor &&
        other.polylineInnerSize == polylineInnerSize &&
        other.polylineOuterSize == polylineOuterSize &&
        other.labelTextSize == labelTextSize &&
        other.imageSize == imageSize &&
        other.labelingMode == labelingMode;
  }

  @override
  int get hashCode =>
      image.hashCode ^
      polylineInnerColor.hashCode ^
      polylineOuterColor.hashCode ^
      polygonFillColor.hashCode ^
      labelTextColor.hashCode ^
      polylineInnerSize.hashCode ^
      polylineOuterSize.hashCode ^
      labelTextSize.hashCode ^
      imageSize.hashCode ^
      labelingMode.hashCode ^
      _imagePointer.hashCode;
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Maps & 3D Scene}
class MarkerMatchList extends GemList<MarkerMatch> {
  factory MarkerMatchList() {
    return MarkerMatchList._create();
  }

  MarkerMatchList.init(dynamic id, int mapId)
      : super(id, mapId, "MarkerMatchList", (data, mapId) => MarkerMatch.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  static MarkerMatchList _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "MarkerMatchList"}));
    final decodedVal = jsonDecode(resultString!);
    return MarkerMatchList.init(decodedVal['result'], 0);
  }
}

/// Marker info
///
/// {@category Maps & 3D Scene}
class MarkerInfo {
  /// The marker coordinates
  late Coordinates coordinates;

  /// The marker screen coordinates
  late XyType<double> screenCoordinates;
  late GemMapController _mapController;
  late ValueNotifier<XyType<double>> screenCoordinatesNotifier;

  MarkerInfo() {
    screenCoordinatesNotifier = ValueNotifier<XyType<double>>(XyType(x: 0.0, y: 0.0));
  }

  /// Extra info
  dynamic info;
  set mapController(GemMapController mapController) {
    _mapController = mapController;
  }

  GemMapController get mapController => _mapController;
  //  MarkerInfo({
  //   required this.coordinates,
  //   required this.screenCoordinates,
  //   required this.mapController,
  //   this.info,
  // }) {
  //   // Initialize the positionNotifier with the initial screen coordinates
  //   positionNotifier = ValueNotifier(_calculateInitialOffset());
  // }
  Offset _calculateInitialOffset() {
    return Offset(screenCoordinates.x!, screenCoordinates.y!);
  }

  /// Set coordinates
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* the new coordinates
  void setCoordinates(Coordinates coords) {
    coordinates = coords;
  }

  @override
  bool operator ==(covariant MarkerInfo other) {
    if (identical(this, other)) return true;
    return other.coordinates == coordinates && other.screenCoordinates == screenCoordinates && other.info == info;
  }

  @override
  int get hashCode => coordinates.hashCode ^ screenCoordinates.hashCode ^ info.hashCode;
}

/// External renderer markers
///
/// {@category Maps & 3D Scene}
class ExternalRendererMarkers {
  Map<int, MarkerInfo> visiblePoints = {};
  GemMapController? mapController;
  void Function(dynamic value)? onNotifyCustom;

  void processData(GemMapController mapController, dynamic data) {
    final listJson = data['coordinates'] as List<dynamic>;
    List<Coordinates> retList = listJson.map((categoryJson) => Coordinates.fromJson(categoryJson)).toList();

    MarkerInfo markerInfo = MarkerInfo();
    markerInfo.setCoordinates(retList[0]);
    XyType<double> theF = XyType<double>(x: data['screen_coordinates_x'], y: data['screen_coordinates_y']);
    if (visiblePoints.containsKey(data['dataMarkerId'])) {
      visiblePoints[data['dataMarkerId']]!.screenCoordinates = theF;
      visiblePoints[data['dataMarkerId']]!.screenCoordinatesNotifier.value = XyType<double>(x: theF.x, y: theF.y);
      //visiblePoints[data['dataMarkerId']]!.screenCoordinates.x = visiblePoints[data['dataMarkerId']]!.screenCoordinates.x! * mapController.viewport.width!;
      //visiblePoints[data['dataMarkerId']]!.screenCoordinates.y = visiblePoints[data['dataMarkerId']]!.screenCoordinates.y! * mapController.viewport.height!;
    } else {
      markerInfo.screenCoordinates = theF;
      //  markerInfo.screenCoordinates.x = markerInfo.screenCoordinates.x! * mapController.viewport.width!;
      // markerInfo.screenCoordinates.y = markerInfo.screenCoordinates.y! * mapController.viewport.height!;
      markerInfo.info = jsonDecode(data['info']);
      markerInfo.mapController = mapController;
      // Add to the map
      visiblePoints[data['dataMarkerId']] = markerInfo;
    }
    dynamic customD = 2;
    if (onNotifyCustom != null) onNotifyCustom!(customD);
  }

  void removeData(dynamic markerId) {
    visiblePoints.remove(markerId);
    //visiblePoints.remove();
  }
}

/// Serializes a list of MarkerWithRenderSettings
///
/// {@category Maps & 3D Scene}
Uint8List serializeListOfMarkers(List<MarkerWithRenderSettings> markers) {
  int totalLength = 4; // Initial 4 bytes for the length of the list

  // Calculate the total length of the binary data
  for (var marker in markers) {
    totalLength += marker.toBinary().length;
  }

  final buffer = ByteData(totalLength);
  int offset = 0;

  // Write the length of the list
  buffer.setInt32(offset, markers.length, Endian.little);
  offset += 4;

  // Serialize each MarkerWithRenderSettings and append to the buffer
  for (var marker in markers) {
    Uint8List markerData = marker.toBinary();
    buffer.buffer.asUint8List().setRange(offset, offset + markerData.length, markerData);
    offset += markerData.length;
  }

  return buffer.buffer.asUint8List();
}

/// Contains a marker and its render settings
///
/// {@category Maps & 3D Scene}
class MarkerWithRenderSettings {
  /// The marker to be rendered
  MarkerJson marker;

  /// The marker render settings
  MarkerRenderSettings settings;

  MarkerWithRenderSettings(this.marker, this.settings);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['marker'] = marker;
    json['settings'] = settings;
    return json;
  }

  Uint8List toBinary() {
    final markerCoordsLength = marker.coords.length;

    // Calculate total bytes required
    int totalBytes = 0;
    totalBytes += 4; // Number of coordinates
    totalBytes += markerCoordsLength * 16; // 8 bytes for each double (latitude, longitude)

    int nameLength = 0;
    if (marker.name != null) {
      final nameBytes = utf8.encode(marker.name!);
      nameLength = nameBytes.length;
      totalBytes += 4; // Length of the name string
      totalBytes += nameLength; // Name string bytes
    } else {
      totalBytes += 4; // Length of the name string (0)
    }

    totalBytes += 8; // polylineInnerSize
    totalBytes += 8; // polylineOuterSize
    totalBytes += 8; // labelTextSize
    totalBytes += 8; // imageSize
    totalBytes += 4; // labelingMode
    totalBytes += 8; // _imagePointer (assuming 64-bit pointer)
    totalBytes += 4; // _imagePointerSize
    totalBytes += 8; // _hashValue

    // Adding 4 bytes for each color (RGBA)
    totalBytes += 4 * 4; // polylineInnerColor, polylineOuterColor, polygonFillColor, labelTextColor

    final buffer = ByteData(totalBytes);
    int offset = 0;

    // Serialize MarkerJson
    buffer.setInt32(offset, markerCoordsLength, Endian.little);
    offset += 4;

    for (var coord in marker.coords) {
      buffer.setFloat64(offset, coord.latitude!, Endian.little);
      offset += 8;
      buffer.setFloat64(offset, coord.longitude!, Endian.little);
      offset += 8;
    }

    // Serialize the name string
    buffer.setInt32(offset, nameLength, Endian.little);
    offset += 4;

    if (nameLength > 0) {
      final nameBytes = utf8.encode(marker.name!);
      buffer.buffer.asUint8List().setAll(offset, nameBytes);
      offset += nameLength;
    }

    // Serialize MarkerRenderSettings
    buffer.setFloat64(offset, settings.polylineInnerSize, Endian.little);
    offset += 8;

    buffer.setFloat64(offset, settings.polylineOuterSize, Endian.little);
    offset += 8;

    buffer.setFloat64(offset, settings.labelTextSize, Endian.little);
    offset += 8;

    buffer.setFloat64(offset, settings.imageSize, Endian.little);
    offset += 8;

    buffer.setInt32(offset, settings.labelingMode ?? 0, Endian.little);
    offset += 4;

    buffer.setInt64(offset, settings._imagePointer ?? 0, Endian.little);
    offset += 8;

    buffer.setInt32(offset, settings._imagePointerSize ?? 0, Endian.little);
    offset += 4;

    buffer.setInt64(offset, settings.hashCode, Endian.little);
    offset += 8;

    // Serialize Colors
    if (settings.polylineInnerColor != null) {
      buffer.setUint8(offset++, settings.polylineInnerColor!.red);
      buffer.setUint8(offset++, settings.polylineInnerColor!.green);
      buffer.setUint8(offset++, settings.polylineInnerColor!.blue);
      buffer.setUint8(offset++, settings.polylineInnerColor!.alpha);
    } else {
      offset += 4; // Skip 4 bytes if color is null
    }

    if (settings.polylineOuterColor != null) {
      buffer.setUint8(offset++, settings.polylineOuterColor!.red);
      buffer.setUint8(offset++, settings.polylineOuterColor!.green);
      buffer.setUint8(offset++, settings.polylineOuterColor!.blue);
      buffer.setUint8(offset++, settings.polylineOuterColor!.alpha);
    } else {
      offset += 4;
    }

    if (settings.polygonFillColor != null) {
      buffer.setUint8(offset++, settings.polygonFillColor!.red);
      buffer.setUint8(offset++, settings.polygonFillColor!.green);
      buffer.setUint8(offset++, settings.polygonFillColor!.blue);
      buffer.setUint8(offset++, settings.polygonFillColor!.alpha);
    } else {
      offset += 4;
    }

    if (settings.labelTextColor != null) {
      buffer.setUint8(offset++, settings.labelTextColor!.red);
      buffer.setUint8(offset++, settings.labelTextColor!.green);
      buffer.setUint8(offset++, settings.labelTextColor!.blue);
      buffer.setUint8(offset++, settings.labelTextColor!.alpha);
    } else {
      offset += 4;
    }

    return buffer.buffer.asUint8List();
  }
}

/// A simplified representation of a Marker
///
/// {@category Maps & 3D Scene}
class MarkerJson {
  /// Coordinates of the marker
  final List<Coordinates> coords;

  /// Name of the marker
  String? name;

  MarkerJson({required this.coords, this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['coords'] = coords;
    if (name != null) {
      json['name'] = name;
    }
    return json;
  }
}

/// SpecialAccess class with static methods
///
/// @nodoc
class MarkerInfoSpecialAccess {
  // Static method to access the imagePointer of a MarkerJson instance
  static dynamic getImagePointer(MarkerRenderSettings markerJson) {
    return markerJson._imagePointer;
  }

  // Static method to access the imagePointerSize of a MarkerJson instance
  static dynamic getImagePointerSize(MarkerRenderSettings markerJson) {
    return markerJson._imagePointerSize;
  }

  static void updateImagePointerValueRenderSettings(MarkerRenderSettings settings, dynamic value) {
    settings._imagePointer = value;
  }

  static void updateImagePointerSizeRenderSettings(MarkerRenderSettings settings, dynamic value) {
    settings._imagePointerSize = value;
  }
}

class MarkerList extends GemList<Marker> {
  factory MarkerList() {
    return MarkerList._create();
  }

  factory MarkerList.fromList(List<MarkerList> landmarks) {
    final landmarkList = MarkerList();
    for (final wp in landmarks) {
      landmarkList.add(wp);
    }
    return landmarkList;
  }

  MarkerList.init(dynamic id, int mapId) : super(id, mapId, "MarkerList", (data, mapId) => Marker.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  static MarkerList _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "MarkerList"}));
    final decodedVal = jsonDecode(resultString!);
    return MarkerList.init(decodedVal['result'], 0);
  }

  void add(MarkerList landmmark) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(this,
          jsonEncode({'id': pointerId, 'class': "MarkerList", 'method': "push_back", 'args': landmmark.pointerId}));
    } catch (e) {
      rethrow;
    }
  }
}
