// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/core/generic_categories_ids.dart';
import 'package:gem_kit/src/core/landmark_category.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Generic categories class
///
/// {@category Core}
abstract class GenericCategories {
  /// Get generic categories list.
  ///
  /// **Returns**
  ///
  /// * The list of generic categories
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static List<LandmarkCategory> get categories {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "GenericCategories",
            'method': "getCategories",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return LandmarkCategoryList.init(decodedVal['result'], 0).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get generic category by id.
  ///
  /// **Parameters**
  ///
  /// * **IN** *id*	Generic category id, see [GenericCategoriesId].
  ///
  /// **Returns**
  ///
  /// * The generic category
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static LandmarkCategory? getCategory(int id) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "GenericCategories",
            'method': "getCategory",
            'args': id
          }));
      final decodedVal = jsonDecode(resultString!);
      if (decodedVal['result'] == 0) {
        return null;
      }
      return LandmarkCategory.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the generic category for the given POI category.
  ///
  /// **Parameters**
  ///
  /// * **IN** *poiCategory* POI category
  ///
  /// **Returns**
  ///
  /// * Generic category id, see [GenericCategoriesId].
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static LandmarkCategory? getGenericCategory(int poiCategory) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "GenericCategories",
            'method': "getGenericCategory",
            'args': poiCategory
          }));
      final decodedVal = jsonDecode(resultString!);
      if (decodedVal['result'] == 0) {
        return null;
      }
      return LandmarkCategory.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the generic categories landmark store id.
  ///
  /// **Returns**
  ///
  /// * The landmark store id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static int get landmarkStoreId {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "GenericCategories",
            'method': "getLandmarkStoreId",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the list of POI categories for the given generic category.
  ///
  /// **Parameters**
  ///
  /// * **IN** *genericCategory* Generic category id, see [GenericCategoriesId].
  ///
  /// **Returns**
  ///
  /// * The landmark store id
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails
  static List<LandmarkCategory> getPoiCategories(int genericCategory) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "GenericCategories",
            'method': "getPoiCategories",
            'args': genericCategory
          }));
      final decodedVal = jsonDecode(resultString!);
      if (decodedVal['result'] == 0) {
        return [];
      }
      return LandmarkCategoryList.init(decodedVal['result'], 0).toList();
    } catch (e) {
      rethrow;
    }
  }
}
