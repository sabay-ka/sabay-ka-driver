// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

/// Image handler class
///
/// {@category Core}
class ImageHandler {
  /// Decodes image data represented as a [Uint8List] into a [ui.Image] asynchronously.
  ///
  /// **Parameters**
  ///
  /// * **IN** *data* A [Uint8List] representing the raw image data to be decoded.
  /// * **IN** *width* Optional parameter specifying the desired width of the resulting image. Default value is 100.
  /// * **IN** *height* Optional parameter specifying the desired height of the resulting image. Default value is 100.
  ///
  /// **Returns**
  ///
  /// * A [Future] that completes with the decoded [ui.Image] object, or `null` if decoding fails.
  ///
  /// The decoding process is asynchronous, so the returned [Future] will complete when the image decoding is finished.
  static Future<ui.Image?> decodeImageData(Uint8List data,
      {int width = 100, int height = 100}) async {
    final completer = Completer<ui.Image?>();

    ui.decodeImageFromPixels(data, width, height, ui.PixelFormat.rgba8888,
        (ui.Image img) async {
      completer.complete(img);
    });

    return completer.future;
  }
}
