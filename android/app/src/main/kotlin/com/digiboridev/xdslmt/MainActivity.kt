package com.digiboridev.xdslmt
import android.os.Bundle
import android.os.PowerManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler {
    private val _ch = "main"
    private val _pm:PowerManager by lazy { getSystemService(POWER_SERVICE) as PowerManager }
    private val _wl:PowerManager.WakeLock by lazy { _pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "sys_wakelock::Wakelock") }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        println("CREATE")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val method = call.method
        println("Method call: $method")
        if(method == "minimize"){
            this.moveTaskToBack(true)
            result.success("minimized")
        }
        if(method == "startWakeLock"){
            _wl.acquire(7*24*60*60*1000L /*7 days*/)
            result.success("started")
        }
        if(method == "stopWakeLock"){
            _wl.release()
            result.success("stopped")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, _ch).setMethodCallHandler(this)
    }
}