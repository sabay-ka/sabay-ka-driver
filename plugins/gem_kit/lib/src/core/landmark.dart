// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// This class will not be documented.
/// @nodoc
///
/// {@category Places}
class LandmarkList extends GemList<Landmark> {
  factory LandmarkList() {
    return LandmarkList._create();
  }

  factory LandmarkList.fromList(List<Landmark> landmarks) {
    final landmarkList = LandmarkList();
    for (final wp in landmarks) {
      landmarkList.add(wp);
    }
    return landmarkList;
  }

  LandmarkList.init(dynamic id, int mapId)
      : super(id, mapId, "LandmarkList", (data, mapId) => Landmark.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  static LandmarkList _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "LandmarkList"}));
    final decodedVal = jsonDecode(resultString!);
    return LandmarkList.init(decodedVal['result'], 0);
  }

  void add(Landmark landmmark) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(this,
          jsonEncode({'id': pointerId, 'class': "LandmarkList", 'method': "push_back", 'args': landmmark.pointerId}));
    } catch (e) {
      rethrow;
    }
  }

  static LandmarkList _fromLandmarkListJson(List<LandmarkJson> landmarks) {
    final resultString =
        GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "LandmarkList", 'args': landmarks}));
    final decodedVal = jsonDecode(resultString!);
    return LandmarkList.init(decodedVal['result'], 0);
  }

  factory LandmarkList.fromJsonList(List<LandmarkJson> landmarks) {
    return _fromLandmarkListJson(landmarks);
  }
}

/// Type of an entrance location.
///
/// {@category Places}
enum EntranceLocationType {
  /// Unknown access type
  unknownAccessType,

  /// Access for vehicles
  vehicleAccess,

  /// Access for pedestrians
  pedestrianAccess,
}

extension EntranceLocationTypeExtension on EntranceLocationType {
  int get id {
    switch (this) {
      case EntranceLocationType.unknownAccessType:
        return 0;
      case EntranceLocationType.vehicleAccess:
        return 1;
      case EntranceLocationType.pedestrianAccess:
        return 2;
    }
  }

  static EntranceLocationType fromId(int id) {
    switch (id) {
      case 0:
        return EntranceLocationType.unknownAccessType;
      case 1:
        return EntranceLocationType.vehicleAccess;
      case 2:
        return EntranceLocationType.pedestrianAccess;
      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Store locations & access type for entrances to landmarks.
///
/// This class should not be instantiated directly. Instead, use the [Landmark.entrances] getter to obtain an instance.
///
/// {@category Places}
class EntranceLocations {
  int _id;
  int _mapId;
  int get id => _id;
  int get mapId => _mapId;

  // ignore: unused_element
  EntranceLocations._()
      : _id = 0,
        _mapId = 0;

  EntranceLocations.init(int id, int mapId)
      : _id = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _id);
  }

  /// Get the entrances count.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int get count {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _id, 'class': "EntranceLocations", 'method': "getCount", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the coordinates specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** index - Index of entrance location for which the coordinates will be returned.
  ///
  /// **Returns**
  ///
  /// * Coordinates - Coordinates of the entrance location specified by index.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  Coordinates getCoordinates(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _id, 'class': "EntranceLocations", 'method': "getCoordinates", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the entrance type specified by index.
  ///
  /// **Parameters**
  ///
  /// * **IN** index - Index of entrance location for which the type will be returned.
  ///
  /// **Returns**
  ///
  /// * EntranceLocationType - Type of the entrance location specified by index.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  EntranceLocationType getType(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _id, 'class': "EntranceLocations", 'method': "getType", 'args': index}));
      final decodedVal = jsonDecode(resultString!);
      return EntranceLocationTypeExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Add new entrance location.
  ///
  /// **Parameters**
  ///
  /// * **IN** coordinates - Coordinates of the entrance location.
  /// * **IN** type - Type of the entrance location.
  ///
  /// **Returns**
  ///
  /// * bool - true if the entrance location was added successfully, false otherwise.
  bool addEntranceLocation({required Coordinates coordinates, required EntranceLocationType type}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _id,
            'class': "EntranceLocations",
            'method': "addEntranceLocation",
            'args': {
              'entranceType': type.id,
              'coordinates': coordinates,
            }
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async => await GemKitPlatform.instance
      .getChannel(mapId: mapId)
      .invokeMethod<String>('callObjectDestructor', jsonEncode({'class': "EntranceLocations", 'id': _id}));
}

/// Landmark class. This is the core class for location information.
///
/// {@category Places}
class Landmark {
  final int _pointerId;
  final int _mapId;

  dynamic get pointerId => _pointerId;
  int get mapId => _mapId;

  /// Creates a new landmark
  factory Landmark() {
    return Landmark._create();
  }

  /// Creates a new landmark with the given latitude and longitude
  factory Landmark.withLatLng({required double latitude, required double longitude}) =>
      Landmark()..coordinates = Coordinates(latitude: latitude, longitude: longitude);

  /// Creates a new landmark with the given coordinates
  factory Landmark.withCoordinates(Coordinates coordinates) => Landmark()..coordinates = coordinates;

  Landmark.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get the address of this landmark.
  ///
  /// On return the parameter fields are set to the correct values. Some of them (or all) may be empty.
  ///
  /// **Returns**
  ///
  /// * [AddressInfo] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  AddressInfo get address {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getAddress", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return AddressInfo.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the author of this landmark.
  ///
  /// On return the parameter is set to the field value. It may be empty.
  ///
  /// **Returns**
  ///
  /// * The author
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get author {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getAuthor", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get landmark categories list.
  ///
  /// **Returns**
  ///
  /// * List<[LandmarkCategory]>
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<LandmarkCategory> get categories {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getCategories", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkCategoryList.init(decodedVal['result'], 0).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get contact info attached to this landmark Phone numbers & descriptions, email addresses & descriptions, URLs & descriptions.
  ///
  /// **Returns**
  ///
  /// * [ContactInfo] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  ContactInfo get contactInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getContactInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return ContactInfo.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get contour rectangle geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *relevantOnly* If true, it will return the relevant contour bounding box if it exists, otherwise the full contour bounding box.
  ///
  /// **Returns**
  ///
  /// * [RectangleGeographicArea] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RectangleGeographicArea getContourGeograficArea({bool relevantOnly = true}) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode(
              {'id': _pointerId, 'class': "Landmark", 'method': "getContourGeograficArea", 'args': relevantOnly}));
      final decodedVal = jsonDecode(resultString!);
      return RectangleGeographicArea.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get direct access to the coordinates attached to this landmark (centroid coordinates).
  ///
  /// **Returns**
  ///
  /// * [Coordinates] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Coordinates get coordinates {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getCoordinates", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get the description of this landmark.
  ///
  /// On return the parameter is set to the field value. It may be empty.
  ///
  /// **Returns**
  ///
  /// * The description
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get description {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getDescription", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get direct access to the entrance locations.
  ///
  /// Locations & access type for entrances to the landmark.
  ///
  /// **Returns**
  ///
  /// * [EntranceLocations] object. Locations & access type for entrances to the landmark.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  EntranceLocations get entrances {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getEntrances", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return EntranceLocations.init(decodedVal['result'], _mapId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get extra image
  ///
  /// **Returns**
  ///
  /// * Extra image
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List getExtraImage({Size? size, ImageFileFormat? format}) {
    try {
      return GemKitPlatform.instance.callGetImage(
          _pointerId, "LandmarkgetExtraImage", size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1);
    } catch (e) {
      rethrow;
    }
  }

  /// Get direct access to the extra info attached to this landmark.
  ///
  /// **Returns**
  ///
  /// * [ExtraInfo] object.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  ExtraInfo get extraInfo {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getExtraInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return ExtraInfo.fromList(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get geographic area.
  ///
  /// **Returns**
  ///
  /// * [RectangleGeographicArea] object.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  GeographicArea get geographicArea {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getGeographicArea", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      switch (GeographicAreaTypeExtension.fromId(decodedVal['result']['type'])) {
        case GeographicAreaType.rectangle:
          return RectangleGeographicArea.fromJson(decodedVal['result']);
        case GeographicAreaType.circle:
          return CircleGeographicArea.fromJson(decodedVal['result']);
        case GeographicAreaType.polygon:
          return PolygonGeographicArea.fromJson(decodedVal['result']);
        default:
          return RectangleGeographicArea.fromJson(decodedVal['result']);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get the landmark ID.
  ///
  /// **Returns**
  /// * landmark id
  /// * [GemError.general] (-1) if it does not have an associated ID, i.e. the landmark doesn't belong to a landmark store.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getLandmarkId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the landmark image.
  ///
  /// The API user is responsible to check if the image is valid.
  ///
  /// **Returns**
  ///
  /// * image
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List getImage({Size? size, ImageFileFormat? format}) {
    try {
      return GemKitPlatform.instance.callGetImage(
          _pointerId, "Landmark", size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the unique ID of the image.
  ///
  /// **Returns**
  /// * int
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get imageUid {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getImageUid", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// If the landmark store is set then it returns the landmark store ID (>0).
  ///
  /// **Returns**
  /// * [GemError.general] (-1) on error.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get landmarkStoreId {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getLandmarkStoreId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// If the landmark store is set then it returns the landmark store type (>0).
  ///
  /// **Returns**
  /// * landmark id
  /// * [GemError.general] (-1) on error.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get landmarkStoreType {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getLandmarkStoreType", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the name of this landmark.
  ///
  /// On return the parameter is set to the field value. It may be empty.
  ///
  /// **Returns**
  ///
  /// * The landmark name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get provider id of this landmark.
  ///
  /// **Returns**
  ///
  /// * The provider ID
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get providerId {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getProviderId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the timestamp.
  ///
  /// If no value is set by the user, the timestamp will be set to current time when the landmark is inserted in a landmark store.
  ///
  /// * [DateTime] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  DateTime get timeStamp {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "getTimeStamp", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return DateTime.fromMillisecondsSinceEpoch(decodedVal['result'], isUtc: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Set the address of this landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *addr* [AddressInfo] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set address(AddressInfo addr) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setAddress", 'args': addr.pointerId}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the author of this landmark.
  ///
  /// On return the parameter is set to the field value. It may be empty.
  ///
  /// **Parameters**
  ///
  /// * **IN** *auth* The author
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set author(String auth) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setAuthor", 'args': auth}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the contact info.
  ///
  /// Phone numbers & descriptions, email addresses & descriptions, URLs & descriptions.
  ///
  /// **Parameters**
  ///
  /// * **IN** *ci* [ContactInfo] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set contactInfo(ContactInfo ci) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setContactInfo", 'args': ci.pointerId}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the centroid coordinates.
  ///
  /// **Parameters**
  ///
  /// * **IN** *coords* [Coordinates] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set coordinates(Coordinates coords) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setCoordinates", 'args': coords.toJson()}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the description of this landmark.
  ///
  /// On return the parameter is set to the field value. It may be empty.
  ///
  /// **Parameters**
  ///
  /// * **IN** *desc* The description
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set description(String desc) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setDescription", 'args': desc}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the landmark extra image.
  ///
  /// **Parameters**
  ///
  /// * **IN** *imageData* The image
  /// * **IN** *format* [ImageFileFormat] of the image.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setExtraImage({required Uint8List imageData, required ImageFileFormat format}) {
    final gemImage = GemKitPlatform.instance.createGemImage(imageData, format.id);
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setExtraImage", 'args': gemImage}));
    } catch (e) {
      rethrow;
    } finally {
      GemKitPlatform.instance.deleteCPointer(gemImage);
    }
  }

  /// Set extra info.
  ///
  /// **Parameters**
  ///
  /// * **IN** *list* [ExtraInfo] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set extraInfo(ExtraInfo list) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setExtraInfo", 'args': list.toInputFormat()}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set geographic area.
  ///
  /// **Parameters**
  ///
  /// * **IN** *ga* [RectangleGeographicArea] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set geographicArea(GeographicArea ga) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Landmark",
            'method': "setGeographicArea",
            'args': {'geographicAreaType': ga.type.id, 'geographicArea': ga}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the image of this landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *imageData* The image
  /// * **IN** *format* [ImageFileFormat] of the image.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setImage({required Uint8List imageData, ImageFileFormat format = ImageFileFormat.png}) {
    final gemImage = GemKitPlatform.instance.createGemImage(imageData, format.id);
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setImage", 'args': gemImage}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    } finally {
      GemKitPlatform.instance.deleteCPointer(gemImage);
    }
  }

  /// Set the image of the landmark with an Icon
  ///
  /// See [GemIcon].
  ///
  /// **Parameters**
  ///
  /// * **IN** *icon* [GemIcon] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  void setImageFromIcon(GemIcon icon) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setImageFromIconId", 'args': icon.id}),
          dispatchOnMainThread: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Set the name of this landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* The name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set name(String name) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setName", 'args': name}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set provider id of this landmark.
  ///
  /// **Parameters**
  ///
  /// * **IN** *providerId* The provider ID
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set providerId(int providerId) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "Landmark", 'method': "setProviderId", 'args': providerId}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the timestamp.
  ///
  /// **Parameters**
  ///
  /// * **IN** *time* [DateTime] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set timeStamp(DateTime time) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Landmark",
            'method': "setTimeStamp",
            'args': Time(epoch: time.millisecondsSinceEpoch)
          }));
    } catch (e) {
      rethrow;
    }
  }

  static Landmark _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "Landmark"}));
    final decodedVal = jsonDecode(resultString!);
    final retVal = Landmark.init(decodedVal['result'], 0);
    GemKitPlatform.instance.registerWeakRelease(retVal, retVal.pointerId);
    return retVal;
  }

  Map<String, dynamic> getJson(int landmarkImageWidth, int landmarkImageHeight) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "Landmark",
            'method': "getJson",
            'args': XyType<int>(x: landmarkImageWidth, y: landmarkImageHeight)
          }));
      final decodedVal = jsonDecode(resultString!);
      Map<String, dynamic> retMap = {};
      retMap['name'] = decodedVal['result']['name'];
      retMap['description'] = decodedVal['result']['description'];
      retMap['author'] = decodedVal['result']['author'];
      retMap['image'] = Uint8List.fromList(decodedVal['result']['image'].cast<int>());
      retMap['extrainfo'] = decodedVal['result']['extrainfo'];
      retMap['address'] = decodedVal['result']['address'];
      final categorieslist = decodedVal['result']['categories'];
      retMap['categories'] = LandmarkCategoryList.init(categorieslist, 0);
      return retMap;
    } catch (e) {
      return throw (e.toString());
    }
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "Landmark", 'id': _pointerId}));
  }
}

/// Prefefined custom landmark extra info keys
///
/// {@category Places}
abstract class PredefinedExtraInfoKey {
  /// Full contour landmark bounding box
  static const String gmContourBox = 'gm_display_box';

  /// Landmark relevant contour partial bounding box
  static const String gmRelevantContourBox = 'gm_display_box_relevant';

  /// Search result link position side
  static const String gmSearchResultSidePosition = 'gm_search_result_side';

  /// Search result distance relative to search position reference
  static const String gmSearchResultDistance = 'gm_search_result_dist';

  /// Search result detailed type
  static const String gmSearchResultType = 'gm_search_result_type';

  /// Wiki info
  static const String wikiInfo = 'gm_wiki_info';

  /// Wiki native name
  static const String gmWikiNativeName = 'gm_wiki_native_name';

  /// Wiki English name
  static const String gmWikiEngName = 'gm_wiki_eng_name';

  /// Population
  static const String gmPopulation = 'gm_population';

  /// External provider
  static const String gmExtProvider = 'gm_ext_provider';
}

/// Extra info
///
/// {@category Places}
class ExtraInfo {
  final Map<dynamic, dynamic> data;
  ExtraInfo() : data = {};
  ExtraInfo.fromList(List<dynamic> input) : data = _parseInput(input);
  static Map<dynamic, dynamic> _parseInput(List<dynamic> input) {
    final Map<dynamic, dynamic> parsedData = {};
    int index = 0;

    for (final line in input) {
      final parts = line.split('=');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();
        parsedData[key] = value;
      } else if (parts.length == 1) {
        final value = parts[0].trim();
        final key = index.toString();
        parsedData[key] = value;
        index++;
      }
    }

    return parsedData;
  }

  /// Get the value of a key
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* [dynamic] The key
  ///
  /// **Returns**
  ///
  /// * **null** if the value doesn't exist or if the value is set to null
  /// * **bool** if the value is 'true' or 'false'
  /// * **int** if the value can be parsed as an int
  /// * **double** if the value can be parsed as a double
  /// * **dynamic** if the value can't be parsed as a bool, int, or double
  dynamic getByKey(dynamic key) {
    final value = data[key];
    if (value != null) {
      if (value == 'true' || value == 'false') {
        return value == 'true';
      }
      try {
        return int.parse(value);
      } catch (e) {
        // Not an int, try parsing as double
        try {
          return double.parse(value);
        } catch (e) {
          // Not a double, return the original string value
          return value;
        }
      }
    }
    return null;
  }

  /// Formats the data as a list of strings
  ///
  /// If the key is an integer, it means the original input was a single value.
  /// If the key is not an integer, it means the original input was a key-value pair.
  List<String> toInputFormat() {
    List<String> output = [];
    data.forEach((key, value) {
      if (key is int) {
        // If the key is an integer, it means the original input was a single value
        output.add(value);
      } else {
        // If the key is not an integer, it means the original input was a key-value pair
        output.add('$key = $value');
      }
    });
    return output;
  }

  /// Method for adding a key-value pair to data
  ///
  /// **Parameters**
  ///
  /// * **IN** *key* [dynamic]
  /// * **IN** *value* [dynamic]
  void add(dynamic key, dynamic value) {
    data[key] = value;
  }

  @override
  bool operator ==(covariant ExtraInfo other) {
    if (identical(this, other)) return true;

    return mapEquals(data, other.data);
  }

  @override
  int get hashCode {
    var hash = 0;
    for (final entry in data.entries) {
      final value = entry.value;
      final key = entry.key;
      hash = hash ^ value.hashCode ^ key.hashCode;
    }

    return hash;
  }
}

/// Landmark class idealy for setting large amount of landmarks data. eg. for List of Landmarks.
class LandmarkJson {
  String? name;
  String? description;
  String? author;
  GemImage? image;
  ExtraInfo? extrainfo;
  AddressInfo? address;
  final Coordinates? coordinates;

  LandmarkJson({
    required this.coordinates,
    this.name,
    this.description,
    this.author,
    this.image,
    this.extrainfo,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (address != null) {
      json['address'] = address!.pointerId;
    }
    if (image != null) {
      json['image'] = image;
    }
    if (coordinates != null) {
      json['coordinates'] = coordinates;
    }
    if (name != null) {
      json['name'] = name;
    }
    if (description != null) {
      json['description'] = description;
    }
    if (author != null) {
      json['author'] = author;
    }
    if (extrainfo != null) {
      json['extraInfo'] = extrainfo!.toInputFormat();
    }
    return json;
  }
}
