/// Exception thrown when GemKit is not initialized
///
/// Use [GemKit.initialize] to initialize the GemKit before calling SDK methods
///
/// {@category Core}
class GemKitUninitializedException implements Exception {
  static const message =
      'Native SDK not initialized! Please add the call \'await GemKit.initialize() \' in the main function, before calling \'runApp\'';

  @override
  String toString() => message;
}
