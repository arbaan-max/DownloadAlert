package com.example.download_tow

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.media.MediaScannerConnection
import android.net.Uri
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "media_scanner"

    override fun configureFlutterEngine(@NonNull flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "scanFile") {
                val path = call.argument<String>("path")
                path?.let {
                    MediaScannerConnection.scanFile(
                        this,
                        arrayOf(it),
                        null,
                        MediaScannerConnection.OnScanCompletedListener { path, uri ->
                            result.success("Scanned $path")
                        }
                    )
                }
            }
        }
    }
}
