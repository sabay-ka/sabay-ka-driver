// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:convert';
import 'dart:typed_data';

import '../../core.dart';
import '../gem_kit_platform_interface.dart';

/// Overlay Ids enumeration
///
/// {@category Maps & 3D Scene}

enum CommonOverlayId {
  /// Safety overlay ID
  safety,

  /// PublicTransport overlay ID
  publicTransport,

  /// SocialLabels overlay ID
  socialLabels,

  /// SocialReports overlay ID
  socialReports;
}

/// This class will not be documented
/// @nodoc
///
/// {@category Maps & 3D Scene}
extension CommonOverlayIdExtension on CommonOverlayId {
  int get id {
    switch (this) {
      case CommonOverlayId.safety:
        return 0x8100;

      case CommonOverlayId.publicTransport:
        return 0x2EEFAA;

      case CommonOverlayId.socialLabels:
        return 0xA200;

      case CommonOverlayId.socialReports:
        return 0xA300;

      default:
        throw ArgumentError('Invalid enum');
    }
  }

  static CommonOverlayId fromId(int id) {
    switch (id) {
      case 0x8100:
        return CommonOverlayId.safety;
      case 0x2EEFAA:
        return CommonOverlayId.publicTransport;
      case 0xA200:
        return CommonOverlayId.socialLabels;
      case 0xA300:
        return CommonOverlayId.socialReports;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
class OverlayUuidCategoryUuid extends Pair<int, int> {
  OverlayUuidCategoryUuid({required int overlayUuid, int categoryUuid = -1}) : super(overlayUuid, categoryUuid);
}

/// Overlay category
///
/// {@category Maps & 3D Scene}
class OverlayCategory {
  /// The category icon
  Uint8List? image;

  /// The category name
  String? name;

  /// The parent overlay ID
  int? overlayuid;

  /// The subcategories
  List<OverlayCategory>? subcategories;

  /// The category ID
  int? uid;

  OverlayCategory({
    this.image,
    this.name,
    this.overlayuid,
    this.subcategories,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (image != null) {
      json['image'] = base64Encode(image!);
    }
    if (name != null) {
      json['name'] = name;
    }
    if (overlayuid != null) {
      json['overlayuid'] = overlayuid;
    }

    if (subcategories != null) {
      json['subcategories'] = subcategories!.map((subcategory) => subcategory.toJson()).toList();
    }

    if (uid != null) {
      json['uid'] = uid;
    }

    return json;
  }

  factory OverlayCategory.fromJson(Map<String, dynamic> json) {
    return OverlayCategory(
      image: base64Decode(json['image']),
      name: json['name'],
      overlayuid: json['overlayuid'],
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List<dynamic>)
              .map((item) => OverlayCategory.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      uid: json['uid'],
    );
  }
}

/// Overlay info class
///
/// {@category Maps & 3D Scene}
class OverlayInfo {
  final int _pointerId;
  int get id => _pointerId;
  OverlayInfo() : _pointerId = -1;
  OverlayInfo.init(int id) : _pointerId = id {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get the overlay categories.
  ///
  /// **Returns**
  ///
  /// * Empty if no categories are available.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  List<OverlayCategory> get categories {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayInfo", 'method': "categories", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final overlayCategories = (decodedVal['result'] as List<dynamic>)
          .map<OverlayCategory>((item) => OverlayCategory.fromJson(item as Map<String, dynamic>))
          .toList();
      return overlayCategories;
    } catch (e) {
      rethrow;
    }
  }

  /// Get the overlay category by Id.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categId* The category id
  ///
  /// **Returns**
  ///
  /// * Empty if no category is found.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  OverlayCategory getCategory(int categId) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "OverlayInfo", 'method': "getCategory", 'args': categId}));
      final decodedVal = jsonDecode(resultString!);
      return OverlayCategory.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the image of the overlay.
  ///
  /// **Returns**
  ///
  /// * Empty if image is not available.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  Uint8List get image {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayInfo", 'method': "image", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return base64Decode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the name of the overlay.
  ///
  /// **Returns**
  ///
  /// * The overlay name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  String get name {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayInfo", 'method': "name", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the unique Id of the overlay.
  ///
  /// **Returns**
  ///
  /// * The overlay Id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  int get uid {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayInfo", 'method': "uid", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if category has subcategories.
  ///
  /// **Parameters**
  ///
  /// * **IN** *categId* The category id
  ///
  /// **Returns**
  ///
  /// * True if category has subcategories, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  bool hasCategories(int categId) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "OverlayInfo", 'method': "hasCategories", 'args': categId}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "OverlayInfo", 'id': _pointerId}));
  }
}

/// Overlays collection.
///
/// {@category Maps & 3D Scene}
class OverlayCollection {
  final int _pointerId;
  int get pointerId => _pointerId;

  OverlayCollection() : _pointerId = -1;

  OverlayCollection.init(int id) : _pointerId = id {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get the number of overlay datasets in this collection.
  ///
  /// **Returns**
  ///
  /// * The number of overlays
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  int get size {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayCollection", 'method': "size", 'args': {}}));
      return jsonDecode(resultString!)['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the overlay at the specified index.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* The index of the overlay
  ///
  /// **Returns**
  ///
  /// * Empty if the index is out of bounds
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  OverlayInfo getOverlayAt(int index) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "OverlayCollection", 'method': "getOverlayAt", 'args': index}));
      final result = jsonDecode(resultString!);
      return OverlayInfo.init(result['result']);
    } catch (e) {
      rethrow;
    }
  }
}

/// Overlay service class
///
/// {@category Maps & 3D Scene}
class OverlayService {
  /// Get list of SDK available overlays.
  ///
  /// **Parameters**
  ///
  /// * **IN** *listener* Progress listener. If not all overlays info is available onboard, a notification will be sent when it will be downloaded.
  ///
  /// **Returns**
  ///
  /// * Pair <[OverlayCollection], [bool]>. If pair.second == false, some overlays information is not available, and will be downloaded when network is available.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  static Pair<OverlayCollection, bool> getAvailableOverlays({ProgressListener? listener}) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "OverlayService",
            'method': "getAvailableOverlays",
            'args': (listener != null) ? listener.id : 0
          }));
      final decodedVal = jsonDecode(resultString!);
      return Pair<OverlayCollection, bool>(
          OverlayCollection.init(decodedVal['result']['first']), decodedVal['result']['second']);
    } catch (e) {
      rethrow;
    }
  }

  /// Enables the overlay with the given uid. This will activate the overlay for all registered services ( map views, alarms, etc ).
  ///
  /// If -1 the whole overlay will be enabled.
  ///
  /// **Parameters**
  ///
  ///  * **IN** *uid* The overlay uid
  ///  * **IN** *categUid* The overlay category uid ( optional )
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  static GemError enableOverlay(int uid, {int categUid = -1}) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "OverlayService",
            'method': "enableOverlay",
            'args': {'uid': uid, 'categUid': categUid}
          }),
          dispatchOnMainThread: true);
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Disables the overlay with the given uid. This will deactivate the overlay for all registered services ( map views, alarms, etc )
  ///
  /// If -1 the whole overlay will be disabled
  ///
  /// **Parameters**
  ///
  /// * **IN** *uid* The overlay uid
  /// * **IN** *categUid* The overlay category uid ( optional )
  ///
  /// **Returns**
  ///
  /// * [GemError.success] on success, [GemError.notFound] if the overlay is not found
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  static GemError disableOverlay(int uid, {int categUid = -1}) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        Object(),
        jsonEncode({
          'id': 0,
          'class': "OverlayService",
          'method': "disableOverlay",
          'args': {'uid': uid, 'categUid': categUid}
        }),
        dispatchOnMainThread: true,
      );
      final decodedVal = jsonDecode(resultString!);
      return GemErrorExtension.fromCode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the overlay with the given uid is enabled.
  ///
  /// If -1 the whole overlay will be disabled
  ///
  /// **Parameters**
  /// * **IN** *uid* The overlay uid
  /// * **IN** *categUid* The overlay category uid ( optional )
  ///
  /// **Returns**
  ///
  /// * True if the overlay is enabled, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails
  static bool isOverlayEnabled(int uid, {int categUid = -1}) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "OverlayService",
            'method': "isOverlayEnabled",
            'args': {'uid': uid, 'categUid': categUid}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
}

/// Class representing an overlay item.
///
/// {@category Maps & 3D Scene}
class OverlayItem {
  final int _pointerId;
  int get id => _pointerId;
  OverlayItem() : _pointerId = -1;
  OverlayItem.init(int id) : _pointerId = id {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get the OverlayItem coordinates
  ///
  /// Empty if the coordinates are not available
  Coordinates get coordinates {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "OverlayItem", 'method': "coordinates", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Coordinates.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the image of the item
  ///
  /// Empty if the image is not available
  Uint8List get image {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayItem", 'method': "image", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return base64Decode(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the name of the item.
  ///
  /// Empty if the name is not available
  String get name {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayItem", 'method': "name", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the unique ID of the item within the overlay.
  ///
  /// The item ID
  int get uid {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayItem", 'method': "uid", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the parent overlay info.
  ///
  /// Empty if OverlayItem is empty
  OverlayInfo get overlayInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': _pointerId, 'class': "OverlayItem", 'method': "overlayinfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return OverlayInfo.init(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the preview URL for the item (if any).
  ///
  /// The preview URL may be opened by the UI into a web browser window to present more details to the user about this item.
  ///
  /// Empty if the item has no preview URL.
  String get previewUrl {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayItem", 'method': "previewurl", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the parent overlay UID.
  ///
  /// The parent overlay UID
  int get overlayUid {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethod(jsonEncode({'id': _pointerId, 'class': "OverlayItem", 'method': "overlayuid", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
}

/// @nodoc
///
/// {@category Maps & 3D Scene}
class OverlayItemList extends GemList<OverlayItem> {
  factory OverlayItemList() {
    return OverlayItemList._create();
  }

  factory OverlayItemList.fromList(List<OverlayItem> landmarks) {
    final landmarkList = OverlayItemList();
    for (final wp in landmarks) {
      landmarkList.add(wp);
    }
    return landmarkList;
  }

  OverlayItemList.init(dynamic id) : super(id, 0, "OverlayItemList", (data, mapId) => OverlayItem.init(data)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  static OverlayItemList _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "LandmarkList"}));
    final decodedVal = jsonDecode(resultString!);
    return OverlayItemList.init(decodedVal['result']);
  }

  void add(OverlayItem landmmark) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': pointerId, 'class': "LandmarkList", 'method': "push_back", 'args': landmmark.id}));
    } catch (e) {
      rethrow;
    }
  }
}
