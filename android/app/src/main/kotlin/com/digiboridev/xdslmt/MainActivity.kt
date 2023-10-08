package com.digiboridev.xdslmt
import android.os.PowerManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val ch = "sys_wakelock"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val wakeLock: PowerManager.WakeLock =
                (getSystemService(POWER_SERVICE) as PowerManager).run {
                    newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "sys_wakelock::Wakelock")
                }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ch).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "startWakeLock"){
                result.success("start");
                wakeLock.acquire();
            } else if (call.method == "stopWakeLock"){
                result.success("stop");
                wakeLock.release();
            }
        }
    }
}