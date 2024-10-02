// Copyright (C) 2019-2024, Magic Lane B.V.
// All rights reserved.
//
// This software is confidential and proprietary information of Magic Lane
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with Magic Lane.

import Foundation
import Flutter
import GEMKit

public class GemViewFactory: NSObject, FlutterPlatformViewFactory {
    
    var registrar: FlutterPluginRegistrar?
    
    public init(withRegistrar registrar: FlutterPluginRegistrar) {
        
        super.init()
        
        self.registrar = registrar
        
        self.prepareSDK()
    }
    
    // MARK: - GEMSdk
    
    func prepareSDK() {
        
        let token = ""
        
        let success = GEMSdk.shared().initCoreSdk(token)
        if success {
            GEMSdk.shared().activateDebugLogger()
            GEMSdk.shared().appDidBecomeActive()
        }
          NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
            
    }
    
    // MARK: - FlutterPlatformViewFactory
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        let gemMapController = GemMapController.init(withFrame: frame, viewIdentifier: viewId, arguments: args, registrar: self.registrar)
        
        return gemMapController
    }
 @objc func handleApplicationDidEnterBackground() {
        // Handle application entering background state
        // Send an event to Flutter using EventChannel or MethodChannel
        GEMSdk.shared().appDidEnterBackground()
    }
    @objc func handleApplicationWillEnterForeground() {
           // Handle application entering foreground state
           // Send an event to Flutter using EventChannel or MethodChannel
        GEMSdk.shared().appDidBecomeActive()
       }

}

