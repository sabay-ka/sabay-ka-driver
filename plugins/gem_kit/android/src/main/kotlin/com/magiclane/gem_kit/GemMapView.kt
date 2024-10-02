package com.magiclane.gem_kit

import android.app.Activity
import android.app.Application
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import android.opengl.GLES20
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.view.WindowManager
import com.magiclane.sdk.core.DataBuffer
import com.magiclane.sdk.core.GemError
import com.magiclane.sdk.core.GemSdk
import com.magiclane.sdk.core.GemSurfaceView
import com.magiclane.sdk.flutter.FlutterChannel
import com.magiclane.sdk.flutter.FlutterMethodListener
import com.magiclane.sdk.util.SdkCall
import com.magiclane.sdk.util.Util
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.concurrent.CountDownLatch

class EventCustom(val eventName: String, val arguments: String, var valid: Boolean)

class GemMapView(
    private val gemKitPlugin: GemKitPlugin,
    viewId: Int,
    context: Context
) : PlatformView, Application.ActivityLifecycleCallbacks {
    var eventQueue = mutableListOf<EventCustom>()
    var lockEvent = Any()
    var isPosting = false
    private val gemSurfaceView: GemSurfaceView
    private lateinit var methodChannel: MethodChannel
    private val appContext: Context
    private var activity: Activity? = null

    init {
        gemSurfaceView = GemSurfaceView(
            context = context,
            autoReleaseOnDetachedFromWindow = false,
            postLambdasOnMain = false
        )
        gemSurfaceView.visibilityChangeListener = object : GemSurfaceView.VisibilityChangeListener {
            override fun onVisibilityChanged(isVisible: Boolean) {
                // Handle visibility change
                if (gemSurfaceView.isShown) {
                    if (gemSurfaceView.mapView != null)
                        gemSurfaceView.onResume()
                } else {
                    if (gemSurfaceView.mapView != null) {
                        gemSurfaceView.onPause()
                    }
                }
                if (isVisible)
                    gemSurfaceView.visibility = View.VISIBLE
                else
                    gemSurfaceView.visibility = View.INVISIBLE
            }
        }
        appContext = context.applicationContext
        val aContext = appContext as Application
        aContext.registerActivityLifecycleCallbacks(this)
        registerCallsFromFlutter(viewId.toLong())
    }

    override fun getView(): View = gemSurfaceView

    override fun dispose() {
        releaseMapView()
        val aContext = appContext as Application
        aContext.unregisterActivityLifecycleCallbacks(this)
    }

    private fun registerMapView(result: MethodChannel.Result) {
        if (gemSurfaceView.mapView == null) {
            var hasBeenNotified = false
            gemSurfaceView.onDefaultMapViewCreated = {
                FlutterChannel.registerMapView(
                    gemSurfaceView.mapView!!,
                    DataBuffer(),
                    FlutterMethodListener.create(
                        onNotifyComplete = { err, retDetails, _ ->
                            SdkCall.execute {
                                val arguments = retDetails.bytes?.let { returnedDetails -> String(returnedDetails) } ?: ""
                                if (err == GemError.NoError && arguments.isNotEmpty()) {
                                    if (!hasBeenNotified) {
                                        result.success(arguments)
                                        hasBeenNotified = true
                                    }
                                } else {
                                    result.error(err.toString(), GemError.getMessage(err), null)
                                }
                            }
                        },
                        onNotifyEvent = { eventName, eventDetails, _ ->
                            if (eventName.isNotEmpty()) {
                                val arguments = eventDetails.bytes?.let { String(it) } ?: ""
                                if (!isPosting) {
                                    isPosting = true
                                    synchronized(lockEvent) {
                                        eventQueue.add(EventCustom(eventName, arguments, true))
                                    }
                                    Util.postOnMainDelayed({
                                        val jsonArray = JSONArray()
                                        synchronized(lockEvent) {
                                            for (eventCustom in eventQueue) {
                                                if (eventCustom != null) {
                                                    val jsonObject = JSONObject()
                                                    jsonObject.put("eventName", eventCustom.eventName)
                                                    jsonObject.put("arguments", eventCustom.arguments)
                                                    jsonArray.put(jsonObject)
                                                    eventCustom.valid = false
                                                }
                                            }
                                            eventQueue.removeIf { eventCustom -> !eventCustom.valid }
                                        }
                                        val jsonArrayAsString = jsonArray.toString()
                                        methodChannel.invokeMethod("notifyEvents", jsonArrayAsString)
                                        isPosting = false
                                    })
                                } else {
                                    synchronized(lockEvent) {
                                        eventQueue.add(EventCustom(eventName, arguments, true))
                                    }
                                }
                            }
                        }
                    )
                )
            }
        } else {
            FlutterChannel.registerMapView(
                gemSurfaceView.mapView!!,
                DataBuffer(),
                FlutterMethodListener.create(
                    onNotifyComplete = { err, retDetails, _ ->
                        SdkCall.execute {
                            val arguments = retDetails.bytes?.let { returnedDetails -> String(returnedDetails) } ?: ""
                            if (err == GemError.NoError && arguments.isNotEmpty()) {
                                result.success(arguments)
                            } else {
                                result.error(err.toString(), GemError.getMessage(err), null)
                            }
                        }
                    },
                    onNotifyEvent = { eventName, eventDetails, _ ->
                        if (eventName.isNotEmpty()) {
                            val arguments = eventDetails.bytes?.let { String(it) } ?: ""
                            if (!isPosting) {
                                isPosting = true
                                synchronized(lockEvent) {
                                    eventQueue.add(EventCustom(eventName, arguments, true))
                                }
                                Util.postOnMainDelayed({
                                    val jsonArray = JSONArray()
                                    synchronized(lockEvent) {
                                        for (eventCustom in eventQueue) {
                                            if (eventCustom != null) {
                                                val jsonObject = JSONObject()
                                                jsonObject.put("eventName", eventCustom.eventName)
                                                jsonObject.put("arguments", eventCustom.arguments)
                                                jsonArray.put(jsonObject)
                                                eventCustom.valid = false
                                            }
                                        }
                                        eventQueue.removeIf { eventCustom -> !eventCustom.valid }
                                    }
                                    val jsonArrayAsString = jsonArray.toString()
                                    methodChannel.invokeMethod("notifyEvents", jsonArrayAsString)
                                    isPosting = false
                                })
                            } else {
                                synchronized(lockEvent) {
                                    eventQueue.add(EventCustom(eventName, arguments, true))
                                }
                            }
                        }
                    }
                )
            )
        }
    }

    private fun releaseMapView() {
        if(gemSurfaceView!=null&&gemSurfaceView.mapView != null)
        {
        SdkCall.execute {
            FlutterChannel.unregisterMapView(gemSurfaceView.mapView!!, FlutterMethodListener.create())
            gemSurfaceView.release()
        }
        }
    }

    private fun captureScreenshotSync(): ByteArray? {
        var screenshotByteArray: ByteArray? = null

        // Create a latch to synchronize the completion of OpenGL operations
        val latch = CountDownLatch(1)

        // Queue a Runnable to execute on the GLThread
        gemSurfaceView.queueEvent(Runnable {
            try {
                // Ensure OpenGL operations are performed on the GLSurfaceView's rendering thread
                val width = gemSurfaceView.width
                val height = gemSurfaceView.height
                val buffer = ByteBuffer.allocateDirect(width * height * 4)
                buffer.order(ByteOrder.nativeOrder())

                // Read pixels from the framebuffer
                GLES20.glReadPixels(0, 0, width, height, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, buffer)

                // Create bitmap from pixel data
                val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                buffer.rewind()
                bitmap.copyPixelsFromBuffer(buffer)

                // Flip the bitmap vertically
                val flippedBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                for (y in 0 until height) {
                    for (x in 0 until width) {
                        flippedBitmap.setPixel(x, height - y - 1, bitmap.getPixel(x, y))
                    }
                }

                // Convert flipped bitmap to byte array (PNG format)
                val outputStream = ByteArrayOutputStream()
                flippedBitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                screenshotByteArray = outputStream.toByteArray()

                // Clean up resources
                bitmap.recycle()
                flippedBitmap.recycle()
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                // Release the latch to signal completion
                latch.countDown()
            }
        })

        try {
            // Wait for OpenGL operations to complete
            latch.await()
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }

        // Return the captured screenshot byte array (or null if capturing failed)
        return screenshotByteArray
    }

    private fun registerCallsFromFlutter(mapId: Long) {
        val name = "plugins.flutter.dev/gem_maps_$mapId"
        methodChannel = MethodChannel(
            gemKitPlugin.flutterPluginBinding.binaryMessenger,
            name
        )

        methodChannel.setMethodCallHandler { call, result ->
            if (!GemSdk.isInitialized()) {
                result.error(
                    GemError.EngineNotInitialized.toString(),
                    GemError.getMessage(GemError.EngineNotInitialized), null
                )
            }

            if (call.method == "waitForViewId") {
                SdkCall.execute { registerMapView(result) }
            } else if (call.method == "captureScreenshot") {
                val screenshot = captureScreenshotSync()
                if (screenshot != null) {
                    result.success(screenshot)
                } else {
                    result.error("UNAVAILABLE", "Screenshot not available.", null)
                }
            } else if (call.arguments != null) {
                val flutterMethodListener = FlutterMethodListener.create(
                    onNotifyComplete = { err, retDetails, _ ->
                        if (err == GemError.NoError) {
                            val returnedResult = retDetails.bytes?.let { String(it) } ?: ""
                            result.success(returnedResult)
                        } else {
                            result.error(err.toString(), GemError.getMessage(err), null)
                        }
                    },

                    onNotifyEvent = { eventName, eventDetails, _ ->
                        if (eventName.isNotEmpty()) {
                            val arguments = eventDetails.bytes?.let { String(it) } ?: ""
                            if (!isPosting) {
                                isPosting = true
                                synchronized(lockEvent) {
                                    eventQueue.add(EventCustom(eventName, arguments, true))
                                }
                                Util.postOnMainDelayed({
                                    val jsonArray = JSONArray()
                                    synchronized(lockEvent) {
                                        for (eventCustom in eventQueue) {
                                            if (eventCustom != null) {
                                                val jsonObject = JSONObject()
                                                jsonObject.put("eventName", eventCustom.eventName)
                                                jsonObject.put("arguments", eventCustom.arguments)
                                                jsonArray.put(jsonObject)
                                                eventCustom.valid = false
                                            }
                                        }
                                        eventQueue.removeIf { eventCustom -> !eventCustom.valid }
                                    }
                                    val jsonArrayAsString = jsonArray.toString()
                                    methodChannel.invokeMethod("notifyEvents", jsonArrayAsString)
                                    isPosting = false
                                })
                            } else {
                                synchronized(lockEvent) {
                                    eventQueue.add(EventCustom(eventName, arguments, true))
                                }
                            }
                        }
                    },

                    onNotifyException = { _, _ ->
                        return@create GemError.NotSupported.toLong()
                    }
                )

                SdkCall.execute {
                    val args = DataBuffer((call.arguments as String).toByteArray())

                    val ret = FlutterChannel.parseMethod(call.method, args, flutterMethodListener)
                    if (ret != GemError.NoError) {
                        if (ret == GemError.NotSupported) {
                            result.notImplemented()
                        } else {
                            result.error(ret.toString(), GemError.getMessage(ret), null)
                        }
                    }
                }
            }
        }
    }

    override fun onActivityPaused(activity: Activity) {
        if (gemSurfaceView.mapView != null) {
            gemSurfaceView.onPause()
        }
    }

    override fun onActivityResumed(activity: Activity) {
        this.activity = activity
        if (gemSurfaceView.mapView != null && gemSurfaceView.isShown) {
            gemSurfaceView.onResume()
        }
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        // Called when the activity is created or re-created
    }

    override fun onActivityStarted(activity: Activity) {
        // Called when the activity is started
        }

    override fun onActivityStopped(activity: Activity) {
        // Called when the activity is stopped
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}

    override fun onActivityDestroyed(activity: Activity) {
        if (this.activity == activity) {
            this.activity = null
        }
    }
}
