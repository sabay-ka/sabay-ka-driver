// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:convert';

import '../../core.dart';
import '../gem_kit_platform_interface.dart';
import 'event_driven_progress_listener.dart';

class ExternalInfo {
  final int _pointerId;
  final int _mapId;

  int get pointerId => _pointerId;
  int get mapId => _mapId;

  factory ExternalInfo() {
    return ExternalInfo._create();
  }

  ExternalInfo.init(int id, int mapId)
      : _pointerId = id,
        _mapId = mapId {
    GemKitPlatform.instance.registerWeakRelease(this, _pointerId);
  }
  static ExternalInfo _create() {
    final resultString = GemKitPlatform.instance
        .callCreateObject(jsonEncode({'class': "ExternalInfo"}));
    final decodedVal = jsonDecode(resultString!);
    final retVal = ExternalInfo.init(decodedVal['result'], 0);
    return retVal;
  }

  /// Cancel a Wikipedia request for any reason. This method is automatically called if a new request is initiated.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void cancelWikiInfo() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "cancelWikiInfo",
            'args': {}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel a Yelp request for any reason. This method is automatically called if a new request is initiated.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void cancelYelpInfo() {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "cancelYelpInfo",
            'args': {}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Get Wikipedia image description directly, without notifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *nIndex* Index of the image to get the description of.
  ///
  /// **Returns**
  ///
  /// * The image description
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiImageDescription(int nIndex) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getWikiImageDescription",
            'args': nIndex
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get the count of the images on the Wikipedia page.
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The count of the images on the Wikipedia page
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getWikiImagesCount() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getWikiImagesCount",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get Wikipedia image title directly, without notifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *nIndex* Index of the image to get the title of.
  ///
  /// **Returns**
  ///
  /// * The image title
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiImageTitle(int nIndex) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getWikiImageTitle",
            'args': nIndex
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get Wikipedia image URL directly, without notifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *nIndex* Index of the image to get the URL of.
  ///
  /// **Returns**
  ///
  /// * The image URL
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiImageUrl(int nIndex) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getWikiImageURL",
            'args': nIndex
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get Wikipedia page summary (text).
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page summary
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiPageDescription() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getWikiPageDescription",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get Wikipedia page language.
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page language
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiPageLanguage() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getWikiPageLanguage",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get Wikipedia page title.
  ///
  /// Get the Wikipedia page title in the requested language. Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page title
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiPageTitle() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getWikiPageTitle",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get Wikipedia page URL.
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The Wikipedia page URL
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getWikiPageUrl() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getWikiPageURL",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get the Yelp location address.
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The Yelp location address
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getYelpAddress() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getYelpAddress",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get the count of the images from Yelp.
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The count of the images from Yelp
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  int getYelpImagesCount() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getYelpImagesCount",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get Wikipedia image description directly, without notifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *nIndex* Index of the image to get the path of.
  ///
  /// **Returns**
  ///
  /// * The image path
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getYelpImagePath(int nIndex) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getYelpImagePath",
            'args': nIndex
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get the location Yelp name.
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The Yelp name
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getYelpName() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getYelpName",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get the location phone number.
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The location phone number
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String getYelpPhoneNumber() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getYelpPhoneNumber",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get the Yelp rating for the location.
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The Yelp rating for the location
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  double getYelpRating() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getYelpRating",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Get the Yelp URL.
  ///
  /// Must be called only after [ProgressListener.notifyComplete] notification
  ///
  /// **Returns**
  ///
  /// * The Yelp page URL
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  String geYelpUrl() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "getYelpURL",
            'args': {}
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Checks if the landmark has Wikipedia info
  ///
  /// Requests all the wikipedia info at once (page title/url, page summary, and list of pictures - only urls of the pictures) - returns true if request successfully made, false if something went wrong. [ProgressListener] will notifyComplete with [GemError.success] once all the results are received from the Wikipedia API.
  /// It will request the info in the language of the device, and will fallback to English if a page in the main language doesn't exist. If neither the main language nor the English version exist, [ProgressListener] will notifyComplete with [GemError.general], and the request will be canceled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark* [Landmark] for which the check will be done.
  ///
  /// **Returns**
  ///
  /// * True if the landmark has Wikipedia info, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool hasWikiInfo(Landmark landmark) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "hasWikiInfo",
            'args': landmark.pointerId
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  /// Checks if the landmark has Yelp info
  ///
  /// Requests all the yelp info at once (page title/url, page summary, and list of pictures - only urls of the pictures) - returns true if request successfully made, false if something went wrong. [ProgressListener] will notifyComplete with [GemError.success] once all the results are received from the Yelp API.
  /// It will request the info in the language of the device, and will fallback to English if a page in the main language doesn't exist. If neither the main language nor the English version exist, [ProgressListener] will notifyComplete with [GemError.general], and the request will be canceled.
  ///
  /// **Parameters**
  ///
  /// * **IN** *landmark* [Landmark] for which the check will be done.
  ///
  /// **Returns**
  ///
  /// * True if the landmark has Yelp info, false otherwise
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  bool hasYelpInfo(Landmark landmark) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "hasYelpInfo",
            'args': landmark.pointerId
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      return throw (e.toString());
    }
  }

  static ExternalInfo getExternalInfo(Landmark landmark,
      {void Function(ExternalInfo? externalInfo)? onWikiDataAvailable,
      void Function(ExternalInfo? externalInfo)? onYelpDataAvailable}) {
    ExternalInfo pExternalInfo = ExternalInfo();

    if (onWikiDataAvailable != null) {
      bool hasExternalInfo = pExternalInfo.hasWikiInfo(landmark);
      if (hasExternalInfo) {
        EventDrivenProgressListener wikiListener =
            EventDrivenProgressListener();
        wikiListener.registerOnCompleteWithDataCallback((err, hint, json) {
          if (err == 0) {
            onWikiDataAvailable(pExternalInfo);
          }
        });
        pExternalInfo._requestWikiInfo(landmark, wikiListener);
        GemKitPlatform.instance
            .registerEventHandler(wikiListener.id, wikiListener);
      } else {
        onWikiDataAvailable(null);
      }
    }

    if (onYelpDataAvailable != null) {
      bool hasYelpInfo = pExternalInfo.hasYelpInfo(landmark);
      if (hasYelpInfo) {
        EventDrivenProgressListener yelpListener =
            EventDrivenProgressListener();
        yelpListener.registerOnCompleteWithDataCallback((err, hint, json) {
          if (err == 0) {
            onYelpDataAvailable(pExternalInfo);
          }
        });
        pExternalInfo._requestYelpInfo(landmark, yelpListener);
        GemKitPlatform.instance
            .registerEventHandler(yelpListener.id, yelpListener);
      } else {
        onYelpDataAvailable(null);
      }
    }
    return pExternalInfo;
  }

  /// Get info on one Wikipedia image directly, without notifier.
  ///
  /// **Parameters**
  ///
  /// * **IN** *index* Index of the image to get info on.
  /// * **IN** *listener* [ProgressListener] that gets notified of the request progress.
  ///
  /// **Returns**
  ///
  /// * The image description
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void _requestWikiImageInfo(int index, ProgressListener listener) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "requestWikiImageInfo",
            'args': {'index': index, 'listener': listener.id}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// **Parameters**
  ///
  /// * **IN** *landmark* [Landmark] for which the request will be made.
  /// * **IN** *listener* [ProgressListener] that gets notified of the request progress.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void _requestWikiInfo(Landmark landmark, ProgressListener listener) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "requestWikiInfo",
            'args': {'first': landmark.pointerId, 'second': listener.id}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// **Parameters**
  ///
  /// * **IN** *landmark* [Landmark] for which the request will be made.
  /// * **IN** *listener* [ProgressListener] that gets notified of the request progress.
  ///
  /// **Throws**
  ///
  /// * An exception if it fails.
  void _requestYelpInfo(Landmark landmark, ProgressListener listener) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          this,
          jsonEncode({
            'id': _pointerId,
            'class': "ExternalInfo",
            'method': "requestYelpInfo",
            'args': {'first': landmark.pointerId, 'second': listener.id}
          }));
    } catch (e) {
      rethrow;
    }
  }
}
