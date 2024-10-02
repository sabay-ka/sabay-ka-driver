// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import Flutter
import UIKit

public class SwiftGemKitPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let factory = GemViewFactory.init(withRegistrar: registrar)
        
        registrar.register(factory, withId:"plugins.flutter.dev/gem_maps")
    }
}
