package tech.stmr.engine_security

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class EngineSecurityPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "engine_security/gps_fake")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "checkMockLocationEnabled" -> {
        result.success(isMockLocationEnabled())
      }
      "getInstalledApps" -> {
        result.success(getInstalledAppPackages())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun isMockLocationEnabled(): Boolean {
    return try {
      val mockLocation = Settings.Secure.getString(
        context.contentResolver,
        Settings.Secure.ALLOW_MOCK_LOCATION
      )
      mockLocation == "1"
    } catch (e: Exception) {
      false
    }
  }

  private fun getInstalledAppPackages(): List<String> {
    return try {
      val packageManager = context.packageManager
      val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
      packages.filter { it.flags and ApplicationInfo.FLAG_SYSTEM == 0 }
        .map { it.packageName }
    } catch (e: Exception) {
      emptyList()
    }
  }
} 