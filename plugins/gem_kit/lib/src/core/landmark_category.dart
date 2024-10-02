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
import 'dart:ui';

import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/images.dart';
import 'package:gem_kit/src/core/types.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// This class will not be documented.
/// @nodoc
///
/// {@category Core}
class LandmarkCategoryList extends GemList<LandmarkCategory> {
  factory LandmarkCategoryList() {
    return LandmarkCategoryList._create();
  }

  LandmarkCategoryList.init(dynamic id, int mapId)
      : super(id, mapId, "LandmarkCategoryList", (data, mapId) => LandmarkCategory.init(data, mapId)) {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  static LandmarkCategoryList _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "LandmarkCategoryList"}));
    final decodedVal = jsonDecode(resultString!);
    return LandmarkCategoryList.init(decodedVal['result'], 0);
  }

  void add(LandmarkCategory category) => GemKitPlatform.instance.callObjectMethod(jsonEncode(
      {'id': pointerId, 'class': "LandmarkCategoryList", 'method': "push_back", 'args': category.pointerId}));
}

/// Landmark category class
///
/// {@category Core}
class LandmarkCategory {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  factory LandmarkCategory() {
    return LandmarkCategory._create();
  }

  LandmarkCategory.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Get the category Id.
  ///
  /// **Returns**
  ///
  /// * The category Id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get id {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
        this,
        jsonEncode({'id': _pointerId, 'class': "LandmarkCategory", 'method': "getId", 'args': {}}),
        dispatchOnMainThread: true,
      );
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the category image.
  ///
  /// The API user is responsible to check if the image is valid.
  ///
  /// **Returns**
  ///
  /// * The category image
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List getImage({Size? size, ImageFileFormat? format}) {
    try {
      return GemKitPlatform.instance.callGetImage(
          _pointerId, "LandmarkCategory", size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the category name.
  ///
  /// **Returns**
  ///
  /// * The category name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get name {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "LandmarkCategory", 'method': "getName", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set the category name.
  ///
  /// **Parameters**
  ///
  /// * **IN** *name* Category name
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set name(String name) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this, jsonEncode({'id': _pointerId, 'class': "LandmarkCategory", 'method': "setName", 'args': name}));
    } catch (e) {
      rethrow;
    }
  }

  /// Get the category image as a bitmap.
  ///
  /// The API user is responsible to check if the image is valid.
  ///
  /// **Parameters**
  ///
  /// * **IN** *offscreenBitmap*
  ///
  /// **Returns**
  ///
  /// *
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int getImageByBitmap(OffscreenBitmap offscreenBitmap) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "LandmarkCategory",
            'method': "getImageByBitmap",
            'args': offscreenBitmap.pointerId
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get parent landmark store id. If the category doesn't belong to a landmark store the function will return [GemError.notFound]
  ///
  /// **Returns**
  ///
  /// * The landmark store id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get landmarkStoreId {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(this,
          jsonEncode({'id': _pointerId, 'class': "LandmarkCategory", 'method': "getLandmarkStoreId", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  static LandmarkCategory _create() {
    final resultString = GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "LandmarkCategory"}));
    final decodedVal = jsonDecode(resultString!);
    return LandmarkCategory.init(decodedVal['result'], 0);
  }

  void dispose() =>
      GemKitPlatform.instance.callDeleteObject(jsonEncode({'class': "LandmarkCategory", 'id': _pointerId}));
}
