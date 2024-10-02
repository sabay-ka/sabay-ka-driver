/*
 * Copyright (C) 2019-2024, Magic Lane B.V.
 * All rights reserved.
 *
 * This software is confidential and proprietary information of Magic Lane
 * ("Confidential Information"). You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms of the
 * license agreement you entered into with Magic Lane.
 */

package com.magiclane.gem_kit

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.app.Application
import android.app.Activity
import android.os.Bundle
import com.magiclane.sdk.util.SdkCall
import com.magiclane.sdk.core.GemSdk
import com.magiclane.sdk.core.ApiCallLogger
import com.magiclane.sdk.core.SdkSettings
import com.magiclane.sdk.core.ProgressListener
/** GemKitPlugin */
class GemKitPlugin: FlutterPlugin, MethodCallHandler, Application.ActivityLifecycleCallbacks {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  lateinit var flutterPluginBinding: FlutterPluginBinding
  
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.flutter.dev/gem_maps")
    channel.setMethodCallHandler(this)
      if (!GemSdk.isInitialized())
      {
        SdkSettings.setAllowAutoMapUpdate(false)
                val sdkInitProgress = ProgressListener.create(
                onCompleted = { _, _ -> GemSdk.notifyEngineInit()
                },
            )
     SdkCall.execute {
     GemSdk.initialize( context = flutterPluginBinding.applicationContext,activity = flutterPluginBinding.applicationContext as? Activity,              
                     listener = sdkInitProgress)
     }
                       
      }
    flutterPluginBinding
        .platformViewRegistry
        .registerViewFactory("plugins.flutter.dev/gem_maps", GemMapViewFactory(this))
   
   val appContext = flutterPluginBinding.applicationContext as Application
   appContext.registerActivityLifecycleCallbacks(this)
  }


  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
     val appContext = binding.applicationContext as Application
     appContext.unregisterActivityLifecycleCallbacks(this)
  }

  override fun onActivityPaused(activity: Activity) {
        SdkCall.execute {
            if (GemSdk.isInitialized())
                GemSdk.notifyBackgroundEvent(GemSdk.EBackgroundEvent.EnterBackground)
        }
    }

    override fun onActivityResumed(activity: Activity) {
        SdkCall.execute {
            if (GemSdk.isInitialized())
                GemSdk.notifyBackgroundEvent(GemSdk.EBackgroundEvent.LeaveBackground)
        }
    }
     override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
       if (!GemSdk.isInitialized())
       {
        
        val sdkInitProgress = ProgressListener.create(
                onCompleted = { _, _ -> GemSdk.notifyEngineInit()
                },
            )
       SdkCall.execute {
      GemSdk.initialize( context = activity.applicationContext, activity = activity.applicationContext as? Activity,
                        listener = sdkInitProgress)
       }
       }
    
        // Called when the activity is created or re-created
    }
     override fun onActivityStarted(activity: Activity) {
        // Called when the activity is started
    }
     override fun onActivityStopped(activity: Activity) {
        // Called when the activity is stopped
    }
    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
    }

    override fun onActivityDestroyed(activity: Activity)
    {

    }

}
