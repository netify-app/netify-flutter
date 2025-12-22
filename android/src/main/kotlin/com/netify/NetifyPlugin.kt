package com.netify

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class NetifyPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.netify/platform")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getAppName" -> {
        try {
          val packageManager = context.packageManager
          val applicationInfo = context.applicationInfo
          val appName = packageManager.getApplicationLabel(applicationInfo).toString()
          result.success(appName)
        } catch (e: Exception) {
          result.success("Netify")
        }
      }
      "getTempDirectory" -> {
        result.success(context.cacheDir.absolutePath)
      }
      "getDocumentsDirectory" -> {
        result.success(context.filesDir.absolutePath)
      }
      "shareFile" -> {
        try {
          val path = call.argument<String>("path")
          val mimeType = call.argument<String>("mimeType") ?: "*/*"
          
          if (path != null) {
            val file = File(path)
            val uri = FileProvider.getUriForFile(
              context,
              "${context.packageName}.fileprovider",
              file
            )
            
            val intent = Intent(Intent.ACTION_SEND).apply {
              type = mimeType
              putExtra(Intent.EXTRA_STREAM, uri)
              addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
              addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            
            context.startActivity(Intent.createChooser(intent, "Share").apply {
              addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            })
            result.success(null)
          } else {
            result.error("INVALID_PATH", "File path is null", null)
          }
        } catch (e: Exception) {
          result.error("SHARE_ERROR", e.message, null)
        }
      }
      "shareText" -> {
        try {
          val text = call.argument<String>("text")
          
          if (text != null) {
            val intent = Intent(Intent.ACTION_SEND).apply {
              type = "text/plain"
              putExtra(Intent.EXTRA_TEXT, text)
              addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            
            context.startActivity(Intent.createChooser(intent, "Share").apply {
              addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            })
            result.success(null)
          } else {
            result.error("INVALID_TEXT", "Text is null", null)
          }
        } catch (e: Exception) {
          result.error("SHARE_ERROR", e.message, null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
