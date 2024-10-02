import 'package:gem_kit/src/gem_kit_platform_interface.dart';

/// GEM SDK global functions.
///
/// {@category Core}
class GemKit {
  /// Initialize GEM SDK.
  ///
  /// All GEM SDK objects must be used only after a successful call to this function
  ///
  /// **Parameters**
  ///
  /// * **IN** *appAuthorization* Application token that enables the SDK. Required for evaluation SDKs.
  /// The map will have a watermark and some features might not work as expected without this parameter.
  static Future<void> initialize({String? appAuthorization}) =>
      GemKitPlatform.instance.loadNative(appAuthorization: appAuthorization);

  /// Release GEM SDK. After this call all remained SDK objects cannot be used.
  static void release() {
    GemKitPlatform.disposeGemSdk();
  }
}
