package com.example.nutriplan

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nutriplan.app/intent"
    private var pendingFilePath: String? = null
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialIntent" -> {
                    result.success(pendingFilePath)
                    pendingFilePath = null
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        when (intent?.action) {
            Intent.ACTION_VIEW -> {
                intent.data?.let { uri ->
                    handleFileUri(uri)
                }
            }
            Intent.ACTION_SEND -> {
                if (intent.type?.startsWith("application/") == true || 
                    intent.type == "*/*") {
                    intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)?.let { uri ->
                        handleFileUri(uri)
                    }
                }
            }
        }
    }

    private fun handleFileUri(uri: Uri) {
        try {
            val fileName = getFileName(uri)
            if (fileName?.endsWith(".nutriplan") == true) {
                val filePath = copyUriToTempFile(uri, fileName)
                if (filePath != null) {
                    if (methodChannel != null) {
                        methodChannel?.invokeMethod("onFileReceived", filePath)
                    } else {
                        pendingFilePath = filePath
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun getFileName(uri: Uri): String? {
        return when (uri.scheme) {
            "content" -> {
                val cursor = contentResolver.query(uri, null, null, null, null)
                cursor?.use {
                    if (it.moveToFirst()) {
                        val nameIndex = it.getColumnIndex("_display_name")
                        if (nameIndex >= 0) {
                            return it.getString(nameIndex)
                        }
                    }
                }
                uri.lastPathSegment
            }
            "file" -> File(uri.path ?: "").name
            else -> null
        }
    }

    private fun copyUriToTempFile(uri: Uri, fileName: String): String? {
        return try {
            val inputStream: InputStream? = contentResolver.openInputStream(uri)
            val tempFile = File(cacheDir, fileName)
            val outputStream = FileOutputStream(tempFile)
            
            inputStream?.use { input ->
                outputStream.use { output ->
                    input.copyTo(output)
                }
            }
            
            tempFile.absolutePath
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}
