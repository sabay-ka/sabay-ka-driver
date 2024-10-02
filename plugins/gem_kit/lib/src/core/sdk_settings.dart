// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

// ignore_for_file: avoid_print, inference_failure_on_collection_literal

import 'dart:ui';

import 'package:gem_kit/core.dart';
import 'package:gem_kit/src/contentstore/content_types.dart';
import 'package:gem_kit/src/core/event_driven_progress_listener.dart';
import 'package:gem_kit/src/gem_kit_platform_interface.dart';

import 'dart:convert';
import 'dart:typed_data';

/// Represents the size and format of an image
///
/// {@category Core}
class SizeAndFormat {
  /// The size of the image
  final Size size;

  /// The format of the image
  final ImageFileFormat format;

  SizeAndFormat({required this.size, required this.format});

  @override
  bool operator ==(covariant SizeAndFormat other) {
    if (identical(this, other)) return true;

    return other.size == size && other.format == format;
  }

  @override
  int get hashCode => size.hashCode ^ format.hashCode;
}

/// Network access customization.
///
/// {@category Core}
class NetworkProvider extends EventDrivenProgressListener {
  NetworkProvider.init(dynamic id) {
    this.id = id;
  }

  factory NetworkProvider() => NetworkProvider._create();

  static NetworkProvider _create() {
    final resultString =
        GemKitPlatform.instance.callCreateObject(jsonEncode({'class': "CNetworkProvider", 'args': {}}));
    final decodedVal = jsonDecode(resultString!);
    return NetworkProvider.init(decodedVal['result']);
  }

  @override
  void notifyCustom(dynamic json) {
    String eventSubtype = json['event_subtype'];

    switch (eventSubtype) {
      case 'onConnectFinished':
        {}
        break;
      case 'onNetworkFailed':
        {}
        break;
      case 'onMobileCountryCodeChanged':
        {}
        break;
    }
  }
}

/// Unit system
///
/// {@category Core}
enum UnitSystem {
  /// Metric
  metric,

  /// Imperial UK - miles and yards
  imperialUK,

  /// Imperial US - feet and inches
  imperialUS,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Core}
extension UnitSystemExtension on UnitSystem {
  int get id {
    switch (this) {
      case UnitSystem.metric:
        return 0;
      case UnitSystem.imperialUK:
        return 1;
      case UnitSystem.imperialUS:
        return 2;
    }
  }

  static UnitSystem fromId(int id) {
    switch (id) {
      case 0:
        return UnitSystem.metric;
      case 1:
        return UnitSystem.imperialUK;
      case 2:
        return UnitSystem.imperialUS;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// Available options for map language selection.
///
/// {@category Core}
enum MapLanguage {
  /// The map language is automatically selected based on the API language.
  automaticLanguage,

  /// The native language is used on map objects.
  nativeLanguage,
}

/// This class will not be documented.
/// @nodoc
///
/// {@category Core}
extension MapLanguageExtension on MapLanguage {
  int get id {
    switch (this) {
      case MapLanguage.automaticLanguage:
        return 0;
      case MapLanguage.nativeLanguage:
        return 1;
    }
  }

  static MapLanguage fromId(int id) {
    switch (id) {
      case 0:
        return MapLanguage.automaticLanguage;
      case 1:
        return MapLanguage.nativeLanguage;

      default:
        throw ArgumentError('Invalid id');
    }
  }
}

/// SDK settings class
///
/// {@category Core}
abstract class SdkSettings {
  /// Check if the connection is allowed or not.
  ///
  /// **Returns**
  ///
  /// * True if the connection is allowed, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static bool get allowConnection {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "getAllowConnection", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the given service type is allowed on the extra charged network.
  ///
  /// **Parameters**
  ///
  /// * **IN** *serviceType* The service type, [ServiceGroupType] object
  ///
  /// **Returns**
  ///
  /// * True if the service is allowed on the extra charged network, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static bool getAllowOffboardServiceOnExtraChargedNetwork(ServiceGroupType serviceType) {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "SdkSettings",
            'method': "getAllowOffboardServiceOnExtraChargedNetwork",
            'args': serviceType.id
          }));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the application authorization API token.
  ///
  ///  Return empty if no valid authorization API token is used.
  ///
  /// **Returns**
  ///
  /// * The token
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static String get appAuthorization {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "getAppAuthorization", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the image by its ID
  ///
  /// **Parameters**
  ///
  /// * **IN** *id* The image id
  /// * **IN** *size* [Size] of the image
  /// * **IN** *format* [ImageFileFormat] of the image.
  ///
  /// **Returns**
  ///
  /// * The image
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static Uint8List getImageById({required int id, Size? size, ImageFileFormat? format}) {
    try {
      return GemKitPlatform.instance.callGetImage(
          id, "SdkSettingsgetImageById", size?.width.toInt() ?? -1, size?.height.toInt() ?? -1, format?.id ?? -1,
          imageId: id);
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the SDK has initialized
  ///
  /// **Returns**
  ///
  /// * True if the SDK has been initialized, false otherwise
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static bool get isSDkInitialized {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "isSDKinitialized", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the API language.
  ///
  /// **Returns**
  ///
  /// * [Language] object
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static Language get language {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "getLanguage", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return Language.fromJson(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the API language list.
  ///
  /// **Returns**
  ///
  /// * The languages list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static List<Language> get languageList {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "getLanguageList", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      final categoriesJson = decodedVal['result'] as List<dynamic>;
      List<Language> categories = categoriesJson.map((categoryJson) => Language.fromJson(categoryJson)).toList();
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  static int get osInfo {
    try {
      final resultString = GemKitPlatform.instance
          .callObjectMethodffi(Object(), jsonEncode({'id': 0, 'class': "Platform", 'method': "getOSInfo", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the current setting for the map language selection.
  ///
  /// **Returns**
  ///
  /// * The map language selection method
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static MapLanguage get mapLanguage {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "getMapLanguage", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return MapLanguageExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Get maximum storage space/cache size to use for downloaded tiles in kilobytes (Kb).
  ///
  /// **Returns**
  ///
  /// * Size in Kb
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static int get tilesMaxSpace {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "getTilesMaxSpace", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get the unit system used by the SDK.
  ///
  /// **Returns**
  ///
  /// * The unit system
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static UnitSystem get unitSystem {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "getUnitSystem", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return UnitSystemExtension.fromId(decodedVal['result']);
    } catch (e) {
      rethrow;
    }
  }

  /// Allow/deny internet connection.
  ///
  /// **Parameters**
  ///
  /// * **IN** *allow* Allow/deny value, [bool] type
  /// * **IN** *listener* Offboard listener that will get notifications regarding connection changes.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static void setAllowConnection(bool allow,
      {bool canDoAutoUpdate = true,
      void Function(bool isConnected)? onConnectionStatusUpdatedCallback,
      void Function(ServiceGroupType serviceType, bool isConnected)? onConnectionStatusUpdated2Callback,
      void Function(bool isAvailable)? onTopicNotificationsStatusUpdatedCallback,
      void Function(Reason reason)? onWorldwideRoadMapSupportDisabledCallback,
      void Function(Status status)? onWorldwideRoadMapSupportStatusCallback,
      void Function()? onWorldwideRoadMapSupportEnabledCallback,
      void Function()? onResourcesReadyToDeployCallback,
      void Function(int size)? onOnlineCacheSizeChangeCallback,
      void Function()? onWorldwideRoadMapVersionUpdatedCallback,
      void Function(ContentType type, Status status)? onAvailableContentUpdateCallback,
      void Function()? onWorldwideRoadMapUnsupportedCapabilitiesCallback,
      void Function()? onApiTokenRejectedCallback,
      void Function()? onApiTokenUpdatedCallback,
      void Function(bool isLoggedIn)? onLoginStatusUpdatedCallback}) {
    try {
      final offBoardListener = OffBoardListener(canDoAutoUpdate);

      offBoardListener.registerOnConnectionStatusUpdated(onConnectionStatusUpdatedCallback);
      offBoardListener.registerOnConnectionStatusUpdated2(onConnectionStatusUpdated2Callback);
      offBoardListener.registerOnTopicNotificationsStatusUpdated(onTopicNotificationsStatusUpdatedCallback);
      offBoardListener.registerOnWorldwideRoadMapSupportDisabled(onWorldwideRoadMapSupportDisabledCallback);
      offBoardListener.registerOnWorldwideRoadMapSupportStatus(onWorldwideRoadMapSupportStatusCallback);
      offBoardListener.registerOnWorldwideRoadMapSupportEnabled(onWorldwideRoadMapSupportEnabledCallback);
      offBoardListener.registerOnResourcesReadyToDeploy(onResourcesReadyToDeployCallback);
      offBoardListener.registerOnOnlineCacheSizeChange(onOnlineCacheSizeChangeCallback);
      offBoardListener.registerOnWorldwideRoadMapVersionUpdated(onWorldwideRoadMapVersionUpdatedCallback);
      offBoardListener.registerOnAvailableContentUpdate(onAvailableContentUpdateCallback != null
          ? (type, status) => onAvailableContentUpdateCallback(ContentTypeExtension.fromId(type), status)
          : null);
      offBoardListener.registerOnApiTokenRejected(onApiTokenRejectedCallback);
      offBoardListener.registerOnApiTokenUpdated(onApiTokenUpdatedCallback);
      offBoardListener.registerOnLoginStatusUpdated(onLoginStatusUpdatedCallback);

      GemKitPlatform.instance.safecallObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "SdkSettings",
            'method': "setAllowConnection",
            'args': {'allow': allow, 'listener': offBoardListener.id}
          }));
      GemKitPlatform.instance.registerEventHandler(offBoardListener.id, offBoardListener);
    } catch (e) {
      rethrow;
    }
  }

  /// Allow the given service type on the extra charged network type. By default all are allowed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *serviceType* [ServiceGroupType] object containing the service type
  /// * **IN** *allow* Allow/deny value, [bool] type
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static void setAllowOffboardServiceOnExtraChargedNetwork(ServiceGroupType serviceType, bool allow) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "SdkSettings",
            'method': "setAllowOffboardServiceOnExtraChargedNetwork",
            'args': {'serviceType': serviceType.id, 'allow': allow}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Allow the given service type on the extra charged network type. By default all are allowed.
  ///
  /// **Parameters**
  ///
  /// * **IN** *token* The API token
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static set appAuthorization(String token) {
    if (isSDkInitialized) {
      try {
        GemKitPlatform.instance.callObjectMethodffi(
            Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "setAppAuthorization", 'args': token}));
      } catch (e) {
        rethrow;
      }
    } else {
      throw (GemKitUninitializedException());
    }
  }

  /// Set the API language.
  ///
  /// **Parameters**
  ///
  /// * **IN** *language* The selected language from the SDK list
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static set language(Language language) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "setLanguage", 'args': language}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the map language selection method.
  ///
  /// **Parameters**
  ///
  /// * **IN** *mapLanguage* [MapLanguage] type
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static set mapLanguage(MapLanguage mapLanguage) {
    try {
      GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "setMapLanguage", 'args': mapLanguage.id}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the network service provider.
  ///
  /// **Parameters**
  ///
  /// * **IN** *networkProvider* The network provider
  ///
  /// The network service provider interface enables the API client to customize the network access. If this is set then the SDK will use it for network access.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static set networkProvider(NetworkProvider networkProvider) {
    try {
      GemKitPlatform.instance.registerEventHandler(networkProvider.id, networkProvider);
      GemKitPlatform.instance.callObjectMethod(
          jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "setNetworkProvider", 'args': networkProvider.id}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set maximum cache size/storage space to use for downloaded tiles in kilobytes (Kb).
  ///
  /// **Parameters**
  ///
  /// * **IN** *maxSpace* Size in Kb. If maxSpace is 0 there are no restrictions for tiles space.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static set tilesMaxSpace(int maxSpace) {
    try {
      GemKitPlatform.instance.safecallObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "setTilesMaxSpace", 'args': maxSpace}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the unit system to be used by the SDK.
  ///
  /// This setting will affect the text of the route / navigation instructions and the voice instructions.
  ///
  /// **Parameters**
  ///
  /// * **IN** *unitSystem* The unit system to be used
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static set unitSystem(UnitSystem unitSystem) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "setUnitSystem", 'args': unitSystem.id}));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the current voice by specifying the path to the voice file.
  ///
  /// The voice can be chosen from a *VoiceList* provided by _getBestVoiceMatch()_ method.
  ///
  /// **Parameters**
  ///
  /// * **IN** *filePath* The voice file path. See _Voice.getFileName_ for details.
  /// * **IN** *lang* 	The desired voice language. Used only in the case of TTS voice for accurate match in the underlaying OS support.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static void setVoiceByPath(String filePath, Language lang) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "SdkSettings",
            'method': "setAllowOffboardServiceOnExtraChargedNetwork",
            'args': {'filePath': filePath, 'lang': lang}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Set the default width, height and format for the image used in automatically returned images.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static void setDefaultWidthHeightImageFormat(Size size, {ImageFileFormat format = ImageFileFormat.png}) {
    try {
      GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "DefaultWidthHeightImageFormat",
            'method': "set",
            'args': {'width': size.width, 'height': size.height, 'format': format.id}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Get the default width, height and format for the image used in automatically returned images.
  ///
  ///  **Throws**
  ///
  /// * An exception if it fails.
  static SizeAndFormat getDefaultWidthHeightImageFormat() {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "DefaultWidthHeightImageFormat", 'method': "get", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return SizeAndFormat(
          size: Size(decodedVal['width'].toDouble(), decodedVal['height'].toDouble()),
          format: ImageFileFormatExtension.fromId(decodedVal['format']));
    } catch (e) {
      rethrow;
    }
  }

  /// Verifies an app token.
  ///
  /// Validates the provided token and reports progress through the specified listener.
  ///
  /// **Parameters**
  /// * **IN** *token* The token to be verified. Must be a valid JWT token.
  /// * **IN** *callback* An operation progress listener that handles the validation process.
  ///
  /// **Error Codes**
  /// * *GemError.invalidInput* Triggered if the token format is invalid (e.g., not a JWT token).
  /// * *GemError.expired* Triggered if the token is expired.
  /// * *GemError.accessDenied* Triggered if the token is blacklisted (e.g., the token's `jti` or `aud` is blacklisted).
  /// * Other error codes may be related to the validation process and are not directly related to token validity.
  static void verifyAppAuthorization(String token, void Function(GemError err) callback) {
    try {
      final listener = EventDrivenProgressListener();
      GemKitPlatform.instance.registerEventHandler(listener.id, listener);
      listener.registerOnCompleteWithDataCallback((err, hint, json) {
        callback(GemErrorExtension.fromCode(err));
        GemKitPlatform.instance.unregisterEventHandler(listener.id);
      });
      GemKitPlatform.instance.callObjectMethodffi(
          Object(),
          jsonEncode({
            'id': 0,
            'class': "SdkSettings",
            'method': "verifyAppAuthorization",
            'args': {'token': token, 'listener': listener.id}
          }));
    } catch (e) {
      rethrow;
    }
  }

  /// Check if the current thread is the main thread.
  /// 
  /// **Returns**
  /// 
  /// * *true* if the current thread is the main thread
  /// * *false* if the current thread is not the main thread
  static bool get isCurrentThreadMainThread {
    try {
      final resultString = GemKitPlatform.instance.callObjectMethodffi(
          Object(), jsonEncode({'id': 0, 'class': "SdkSettings", 'method': "isCurrentThreadMainThread", 'args': {}}));
      final decodedVal = jsonDecode(resultString!);
      return decodedVal['result'];
    } catch (e) {
      rethrow;
    }
  }
}
