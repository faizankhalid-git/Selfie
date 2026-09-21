package com.company.posecoach

import android.Manifest
import android.content.pm.PackageManager
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.camera.core.CameraSelector
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private var pendingPermissionResult: MethodChannel.Result? = null
    private var frontFacing = true

    private val permissionLauncher = registerForActivityResult(ActivityResultContracts.RequestPermission()) { granted ->
        pendingPermissionResult?.success(if (granted) "granted" else "denied")
        pendingPermissionResult = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.platformViewsController.registry.registerViewFactory("posecoach/camera-preview", CameraPreviewFactory(this) { frontFacing })
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "posecoach/camera").setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "requestPermission" -> requestPermission(result)
                "permissionStatus" -> result.success(permissionStatus())
                "setLens" -> { frontFacing = call.argument<Boolean>("frontFacing") ?: true; result.success(null) }
                else -> result.notImplemented()
            }
        }
    }

    private fun requestPermission(result: MethodChannel.Result) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) result.success("granted")
        else { pendingPermissionResult = result; permissionLauncher.launch(Manifest.permission.CAMERA) }
    }

    private fun permissionStatus(): String = when {
        ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED -> "granted"
        !shouldShowRequestPermissionRationale(Manifest.permission.CAMERA) -> "unknown"
        else -> "denied"
    }
}

private class CameraPreviewFactory(private val activity: MainActivity, private val frontFacing: () -> Boolean) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: android.content.Context, viewId: Int, args: Any?): PlatformView = CameraPreview(activity, frontFacing)
}

private class CameraPreview(private val activity: MainActivity, private val frontFacing: () -> Boolean) : PlatformView {
    private val previewView = PreviewView(activity)
    private val executor = Executors.newSingleThreadExecutor()

    init { startCamera() }

    private fun startCamera() {
        val providerFuture = ProcessCameraProvider.getInstance(activity)
        providerFuture.addListener({
            val provider = providerFuture.get()
            val preview = androidx.camera.core.Preview.Builder().build().also { it.surfaceProvider = previewView.surfaceProvider }
            val selector = if (frontFacing()) CameraSelector.DEFAULT_FRONT_CAMERA else CameraSelector.DEFAULT_BACK_CAMERA
            provider.unbindAll()
            provider.bindToLifecycle(activity, selector, preview)
        }, ContextCompat.getMainExecutor(activity))
    }

    override fun getView(): android.view.View = previewView
    override fun dispose() { executor.shutdown(); ProcessCameraProvider.getInstance(activity).get().unbindAll() }
}
