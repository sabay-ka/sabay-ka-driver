// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:typed_data';
import 'dart:ui';
import 'package:gem_kit/core.dart';

import 'package:gem_kit/navigation.dart';

import 'package:gem_kit/src/core/extensions.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Signpost details class
///
/// This class should not be instantiated directly. Instead, use the [NavigationInstruction.signpostDetails] getter to obtain an instance.
///
/// {@category Core}
class SignpostDetails {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  SignpostDetails._()
      : _pointerId = -1,
        _mapId = -1;

  SignpostDetails.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get the background color for the signpost.
  ///
  /// **Returns**
  ///
  /// * The background color for the signpost.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Color get backgroundColor {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostDetails",
            'method': "getBackgroundColor",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return ColorExtension.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the border color for the signpost.
  ///
  /// **Returns**
  ///
  /// * The border color for the signpost.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Color get borderColor {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostDetails",
            'method': "getBorderColor",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return ColorExtension.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the text color for the signpost.
  ///
  /// **Returns**
  ///
  /// * The text color for the signpost.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Color get textColor {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostDetails",
            'method': "getTextColor",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return ColorExtension.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Check the background color for the signpost.
  ///
  /// **Returns**
  ///
  /// * True if the signpost has a background color, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasBackgroundColor {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostDetails",
            'method': "hasBackgroundColor",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check the border color for the signpost.
  ///
  /// **Returns**
  ///
  /// * True if the signpost has a border color, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasBorderColor {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostDetails",
            'method': "hasBorderColor",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check the text color for the signpost.
  ///
  /// **Returns**
  ///
  /// * True if the signpost has a text color, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasTextColor {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostDetails",
            'method': "hasTextColor",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the image of this SignpostDetails.
  ///
  /// **Parameters**
  ///
  /// * **IN** *size* The image sizes
  /// * **IN** *format* [ImageFileFormat] of the image.
  /// * **IN** *renderSettings* [SignpostImageRenderSettings] of the image.
  ///
  /// **Returns**
  ///
  /// * The image
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  Uint8List getImage(
      {Size? size,
      ImageFileFormat? format,
      SignpostImageRenderSettings renderSettings =
          const SignpostImageRenderSettings()}) {
    return GemKitPlatform.instance.callGetImage(
        pointerId,
        "SignPostDetailsGetImage",
        size?.width.toInt() ?? -1,
        size?.height.toInt() ?? -1,
        format?.id ?? -1,
        arg: jsonEncode(renderSettings));
  }

  /// Get the list with SignpostItem elements.
  ///
  /// **Returns**
  ///
  /// * The list with [SignpostItem] elements.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  List<SignpostItem> get items {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostDetails",
            'method': "getItems",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return SignpostItemList.init(decodedVal['result'], _mapId).toList();
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    GemKitPlatform.instance.callDeleteObject(
        jsonEncode({'class': "SignpostDetails", 'id': _pointerId}));
  }
}

/// SignpostItem object.
///
/// This class should not be instantiated directly. Instead, use the [SignpostDetails.items] getter to a list of instances.
///
/// {@category Core}
class SignpostItem {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  // ignore: unused_element
  SignpostItem._()
      : _pointerId = -1,
        _mapId = -1;

  SignpostItem.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }

  /// Get the one based column.
  ///
  /// Not all items may have a column assigned.
  ///
  /// **Returns**
  ///
  /// * Column of the item. Zero indicates N/A
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get column {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "getColumn",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the connection.
  ///
  /// **Returns**
  ///
  /// * Connection type of the item.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  SignpostConnectionInfo get connectionInfo {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "getConnectionInfo",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return SignpostConnectionInfoExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the one based column.
  ///
  /// Not all items may have a phoneme assigned.
  ///
  /// **Returns**
  ///
  /// * Phoneme of the item
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get phoneme {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "getPhoneme",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the pictogram type for the item.
  ///
  /// Only items with type [SignpostItemType.pictogram] will return a valid value.
  ///
  /// **Returns**
  ///
  /// * The pictogram type for the signpost.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  SignpostPictogramType get pictogramType {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "getConnectionInfo",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return SignpostPictogramTypeExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the one based row.
  ///
  /// Not all items may have a row assigned.
  ///
  /// **Returns**
  ///
  /// * Row of the item. Zero indicates N/A
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get row {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "getRow",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the shield type for the item.
  ///
  /// Only items with type [SignpostItemType.routeNumber] will return a valid value.
  ///
  /// **Returns**
  ///
  /// * The shield type for the signpost.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  RoadShieldType get shieldType {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "getShieldType",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return RoadShieldTypeExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the text.
  ///
  /// Not all items may have text assigned.
  ///
  /// **Returns**
  ///
  /// * Text of the item.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  String get text {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "getText",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the type.
  ///
  /// **Returns**
  ///
  /// * Type of the item.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  SignpostItemType get type {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "getType",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return SignpostItemTypeExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the ambiguity.
  ///
  /// **Returns**
  ///
  /// * True for items with ambiguity. Don't use such items for TTS.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasAmbiguity {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "hasAmbiguity",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the shield level.
  ///
  /// **Returns**
  ///
  /// * True for road code items with same shield level as the road the signpost is attached to.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get hasSameShieldLevel {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "SignpostItem",
            'method': "hasSameShieldLevel",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
}
