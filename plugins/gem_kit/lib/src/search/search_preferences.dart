// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'package:gem_kit/src/core/landmark_category.dart';
import 'package:gem_kit/src/map/overlays.dart';

/// Search preferences
///
/// {@category Places}
class SearchPreferences {
  /// Enable or disable the inclusion of fuzzy search results
  ///
  /// Default is true
  bool allowFuzzyResults;

  /// Enable or disable the inclusion of interpolated house number results
  ///
  /// Default is true
  bool estimateMissingHouseNumbers;

  /// Enable or disable if only exact match is used.
  ///
  /// Default is false
  bool exactMatch;

  /// The maximum number of matches
  ///
  /// Default is 40
  int maxMatches;

  /// Enable or disable search through addresses.
  ///
  /// Default is true
  bool searchAddresses;

  /// Enable or disable search through map POIs.
  ///
  /// Default is true
  bool searchMapPOIs;

  /// Set the flag for onboard search.
  ///
  /// If this flag is true then the search will be done using only onboard data.
  /// By default this flag is set to false.
  bool searchOnlyOnboard;

  /// Set the threshold distance for the operation.
  ///
  /// This may be used to control the reverse geocoding and search along route lookup area.
  /// When searching along route, the threshold is the result maximum distance from the target route
  /// When searching around position, the threshold is the result maximum distance from the reference point
  int thresholdDistance;

  /// The search target landmark categories
  List<LandmarkCategory> landmarkCategories =
      List<LandmarkCategory>.empty(growable: true);

  /// The search target overlays collection
  List<OverlayUuidCategoryUuid> overlays =
      List<OverlayUuidCategoryUuid>.empty(growable: true);

  /// All store categories list
  List<int> allStoreCategoriesList = List<int>.empty(growable: true);

  /// Check if [landmarkCategories] is empty
  bool get hasLandmarkCategoryList => landmarkCategories.isNotEmpty;

  SearchPreferences(
      {this.allowFuzzyResults = true,
      this.estimateMissingHouseNumbers = true,
      this.exactMatch = false,
      this.maxMatches = 40,
      this.searchAddresses = true,
      this.searchMapPOIs = true,
      this.searchOnlyOnboard = false,
      this.thresholdDistance = 2147483647});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['allowfuzzyresults'] = allowFuzzyResults;

    json['estimatemissinghousenumbers'] = estimateMissingHouseNumbers;

    json['exactmatch'] = exactMatch;

    json['maxmatches'] = maxMatches;

    json['searchaddresses'] = searchAddresses;

    json['searchmappois'] = searchMapPOIs;

    json['searchonlyonboard'] = searchOnlyOnboard;

    json['thresholddistance'] = thresholdDistance;

    return json;
  }

  factory SearchPreferences.fromJson(Map<String, dynamic> json) {
    return SearchPreferences(
      allowFuzzyResults: json['allowfuzzyresults'],
      estimateMissingHouseNumbers: json['estimatemissinghousenumbers'],
      exactMatch: json['exactmatch'],
      maxMatches: json['maxmatches'],
      searchAddresses: json['searchaddresses'],
      searchMapPOIs: json['searchmappois'],
      searchOnlyOnboard: json['searchonlyonboard'],
      thresholdDistance: json['thresholddistance'],
    );
  }
}
