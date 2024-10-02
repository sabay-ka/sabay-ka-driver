// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'package:gem_kit/src/core/gem_error.dart';
import 'package:gem_kit/src/core/landmark.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/core/task_handler.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';

/// Address level of detail.
///
/// {@category Places}
enum AddressDetailLevel {
  /// No address details available.
  noDetail,

  /// Country.
  country,

  /// State or province.
  state,

  /// County, which is an intermediate entity between a state and a city.
  county,

  /// Municipal district.
  district,

  /// Town or city.
  city,

  /// Settlement.
  settlement,

  /// Zip or postal code.
  postalCode,

  /// Street/road name.
  street,

  /// Street section subdivision.
  streetSection,

  /// Street lane subdivision.
  streetLane,

  /// Street alley subdivision.
  streetAlley,

  /// Address field denoting house number.
  houseNumber,

  /// Address field denoting a street in a crossing.
  crossing,
}

/// @nodoc
///
/// {@category Places}
extension AddressDetailLevelExtension on AddressDetailLevel {
  int get id {
    switch (this) {
      case AddressDetailLevel.noDetail:
        return 0;
      case AddressDetailLevel.country:
        return 1;
      case AddressDetailLevel.state:
        return 2;
      case AddressDetailLevel.county:
        return 3;
      case AddressDetailLevel.district:
        return 4;
      case AddressDetailLevel.city:
        return 5;
      case AddressDetailLevel.settlement:
        return 6;
      case AddressDetailLevel.postalCode:
        return 7;
      case AddressDetailLevel.street:
        return 8;
      case AddressDetailLevel.streetSection:
        return 9;
      case AddressDetailLevel.streetLane:
        return 10;
      case AddressDetailLevel.streetAlley:
        return 11;
      case AddressDetailLevel.houseNumber:
        return 12;
      case AddressDetailLevel.crossing:
        return 13;
    }
  }

  static AddressDetailLevel fromId(int id) {
    switch (id) {
      case 0:
        return AddressDetailLevel.noDetail;
      case 1:
        return AddressDetailLevel.country;
      case 2:
        return AddressDetailLevel.state;
      case 3:
        return AddressDetailLevel.county;
      case 4:
        return AddressDetailLevel.district;
      case 5:
        return AddressDetailLevel.city;
      case 6:
        return AddressDetailLevel.settlement;
      case 7:
        return AddressDetailLevel.postalCode;
      case 8:
        return AddressDetailLevel.street;
      case 9:
        return AddressDetailLevel.streetSection;
      case 10:
        return AddressDetailLevel.streetLane;
      case 11:
        return AddressDetailLevel.streetAlley;
      case 12:
        return AddressDetailLevel.houseNumber;
      case 13:
        return AddressDetailLevel.crossing;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// GuidedAddressSearchPreferences object.
///
/// {@category Places}
class GuidedAddressSearchPreferences {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  factory GuidedAddressSearchPreferences() {
    return GuidedAddressSearchPreferences.create(0);
  }

  GuidedAddressSearchPreferences.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, id);
  }

  /// Test if fuzzy search results are allowed.
  ///
  /// **Returns**
  ///
  /// * True if fuzzy search results are allowed, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get allowFuzzyResults {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "GuidedAddressSearchPreferences", 'method': "getAllowFuzzyResults", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Enable or disable the inclusion of fuzzy search results.
  ///
  /// **Note**
  ///
  /// * Default is true.
  ///
  /// **Parameters**
  ///
  /// * **IN** *bAllow*	True to allow fuzzy search results
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set allowFuzzyResults(bool bAllow) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "GuidedAddressSearchPreferences",
            'method': "setAllowFuzzyResults",
            'args': bAllow
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Get the automatic level skip flag.
  ///
  /// **Returns**
  ///
  /// * True if the engine will automatically skip levels, false otherwise.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool get automaticLevelSkip {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': _pointerId,
        'class': "GuidedAddressSearchPreferences",
        'method': "getAutomaticLevelSkip",
        'args': {}
      }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set the flag for automatic level skip
  ///
  /// When there is only one result at a specific level and there is only one possible next level to search then the engine will automatically skip that level if this flag is set to true.
  ///
  /// **Parameters**
  ///
  /// * **IN** *enableAutomaticLevelSkip*	True for automatic level skip
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set automaticLevelSkip(bool enableAutomaticLevelSkip) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "GuidedAddressSearchPreferences",
            'method': "setAutomaticLevelSkip",
            'args': enableAutomaticLevelSkip
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Get the maximum number of matches.
  ///
  /// **Note**
  ///
  /// * Default is 40.
  ///
  /// **Returns**
  ///
  /// * Maximum number of matches
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  int get maximumMatches {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "GuidedAddressSearchPreferences", 'method': "getMaximumMatches", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Set the maximum number of matches.
  ///
  /// **Parameters**
  ///
  /// * **IN** *matches*	Maximum number of matches
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set maximumMatches(int matches) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "GuidedAddressSearchPreferences",
            'method': "setMaximumMatches",
            'args': matches
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the flag for onboard search
  ///
  /// If this flag is true then the search will be done using only onboard data. By default it is false.
  ///
  /// **Parameters**
  ///
  /// * **IN** *searchOnlyOnboard* Flag for onboard search.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  set searchOnlyOnboard(bool searchOnlyOnboard) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "GuidedAddressSearchPreferences",
            'method': "setSearchOnlyOnboard",
            'args': searchOnlyOnboard
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Get the flag for onboard search.
  ///
  /// **Returns**
  ///
  /// * True if the search is done using only onboard data, false otherwise.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  bool get searchOnlyOnboard {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': _pointerId, 'class': "GuidedAddressSearchPreferences", 'method': "getSearchOnlyOnboard", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  static GuidedAddressSearchPreferences create(int mapId) {
    final resultString =
        GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "GuidedAddressSearchPreferences"}));
    final decodedVal = jsonDecode(resultString!);
    return GuidedAddressSearchPreferences.init(decodedVal['result'], mapId);
  }

  void dispose() => GemKitPlatform.instance
      .callDeleteObject(jsonEncode({'class': "GuidedAddressSearchPreferences", 'id': _pointerId}));
}

/// Class representing a guided address search service session.
///
/// {@category Places}
abstract class GuidedAddressSearchService {
  static GuidedAddressSearchPreferences? _prefs;

  /// Search for more details starting at the selected parent landmark.
  ///
  /// Starting at the selected parent landmark the engine will search the required detail level using the provided filter.
  ///
  /// **Parameters**
  ///
  /// * **IN** *parent*	The starting point for the search. If it is default then the only detail level that can be searched is [AddressDetailLevel.country].
  /// If the landmark address detail level is [AddressDetailLevel.street] then the next details that can be searched may be [AddressDetailLevel.houseNumber] or [AddressDetailLevel.crossing] (for example).
  /// It is also allowed to "decrease" the search level and use [AddressDetailLevel.city] (for example).
  /// * **IN** *filter*	The filter to use when searching for the required detail level. If it is empty then all items are returned (limited to the maximum number of matches from preferences).
  /// * **IN** *detailLevel*	The address detail level to search.
  /// * **IN** *onCompleteCallback*	The callback that will be called when the search is completed
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static TaskHandler search(String filter, Landmark parent, AddressDetailLevel detailLevel,
      void Function(GemError err, List<Landmark>? landmarks) onCompleteCallback) {
    try {
      final resultString = GemKitPlatform.instance.safecallObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "GuidedAddressSearchService",
            'method': "search",
            'args': {'filter': filter, 'parent': parent.pointerId, 'detailToSearch': detailLevel.id}
          }));
      final decodedVal = jsonDecode(resultString!);
      final progListener = EventDrivenProgressListener.init(decodedVal['result']);
      progListener.registerOnCompleteWithDataCallback((err, hint, json) {
        if (json.containsKey('searchId')) {
          final searchLandmark = LandmarkList.init(json['searchId'], 0);
          onCompleteCallback(GemErrorExtension.fromCode(err), searchLandmark.toList());
        } else {
          onCompleteCallback(GemErrorExtension.fromCode(err), null);
        }
      });
      GemKitPlatform.instance.registerEventHandler(progListener.id, progListener);
      return TaskHandlerImpl(progListener.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel currently active search command.
  ///
  /// **Parameters**
  ///
  /// * **IN** *progress*	Progress listener for the operation.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static void cancelSearch(TaskHandler taskHandler) {
    try {
      taskHandler as TaskHandlerImpl;

      GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': 0, 'class': "GuidedAddressSearchService", 'method': "cancelSearch", 'args': taskHandler.id}));
    } catch (e) {
      rethrow;
    }
  }

  /// Get the address detail level for a landmark
  ///
  /// When there is only one result at a specific level and there is only one possible next level to search then the engine will automatically skip that level if this flag is set to true.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark*	The landmark for which to get the address detail level.
  ///
  /// **Returns**
  ///
  /// * [AddressDetailLevel.noDetail] If landmark is not obtained via a previous call to [GuidedAddressSearchService.search] method.
  ///
  /// * Address detail level for the landmark in range of [AddressDetailLevel].
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static AddressDetailLevel getAddressDetailLevel(Landmark landmark) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "GuidedAddressSearchService",
        'method': "getAddressDetailLevel",
        'args': landmark.pointerId
      }));
      final decodedVal = jsonDecode(resultString!);
      return AddressDetailLevelExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the country level item for specific country iso code that can be used by guided address search.
  ///
  /// **Parameters**
  ///
  /// * **IN** *countryIsoCode*	The country iso code for which to get the country level item.
  ///
  /// **Returns**
  ///
  /// * _empty_ if the country code is invalid.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static Landmark getCountryLevelItem(String countryIsoCode) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode(
          {'id': 0, 'class': "GuidedAddressSearchService", 'method': "getCountryLevelItem", 'args': countryIsoCode}));
      final decodedVal = jsonDecode(resultString!);
      return Landmark.init(decodedVal['result'], 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the list of next possible address detail levels that can be searched for a landmark.
  ///
  /// It is country dependent.
  ///
  /// For example, for a street it may be possible to get [AddressDetailLevel.crossing] and [AddressDetailLevel.houseNumber] in some countries but in others to get [AddressDetailLevel.streetSection]
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark*	The landmark for which to get the next possible address detail levels to search. If the landmark is default only [AddressDetailLevel.country] will be in the list. If there are no more address detail levels available then _empty_ is returned.
  ///
  /// **Returns**
  ///
  /// * [List] next possible address detail levels. Items of the list are in range of [AddressDetailLevel] enum..
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static List<AddressDetailLevel> getNextAddressDetailLevel(Landmark landmark) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethod(jsonEncode({
        'id': 0,
        'class': "GuidedAddressSearchService",
        'method': "getNextAddressDetailLevel",
        'args': landmark.pointerId
      }));
      final decodedVal = jsonDecode(resultString!);
      final retList = decodedVal['result'].whereType<int>().toList();
      return (retList as List<int>).map((id) => AddressDetailLevelExtension.fromId(id)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get access to [GuidedAddressSearchPreferences] (for this session).
  ///
  /// **Returns**
  ///
  /// * [GuidedAddressSearchPreferences] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static GuidedAddressSearchPreferences get preferences {
    if (_prefs == null) {
      try {
        final resultString = GemKitPlatform.instance.callObjectMethod(
            jsonEncode({'id': 0, 'class': "GuidedAddressSearchService", 'method': "preferences", 'args': {}}));
        final decodedVal = jsonDecode(resultString!);
        _prefs = GuidedAddressSearchPreferences.init(decodedVal['result'], 0);
      } catch (e) {
        rethrow;
      }
    }
    return _prefs!;
  }
}
