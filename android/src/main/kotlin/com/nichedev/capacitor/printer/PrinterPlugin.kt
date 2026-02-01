package com.nichedev.capacitor.printer

import android.webkit.WebView
import com.getcapacitor.JSArray
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "Printer")
class PrinterPlugin : Plugin() {

    @PluginMethod
    fun canPrintItem(call: PluginCall) {
        val uri = call.getString("uri")

        activity.let { ctx ->
            val pm = PrintManager(ctx)
            val available = pm.canPrintItem(uri)

            val ret = JSObject()
            ret.put("available", available)
            call.resolve(ret)
        }
    }

    @PluginMethod
    fun getPrintableTypes(call: PluginCall) {
        val types = PrintManager.getPrintableTypes()
        val ret = JSObject()
        val jsArray = JSArray()
        for (i in 0 until types.length()) {
            jsArray.put(types.getString(i))
        }
        ret.put("types", jsArray)
        call.resolve(ret)
    }

    @PluginMethod
    fun pick(call: PluginCall) {
        call.reject("Printer picker is not supported on Android")
    }

    @PluginMethod
    fun print(call: PluginCall) {
        try {
            val content = call.getString("content")
            val settings = extractSettings(call)

            val currentActivity = activity
            if (currentActivity == null) {
                call.reject("Activity not available")
                return
            }

            bridge.executeOnMainThread {
                try {
                    val pm = PrintManager(currentActivity)
                    val webView = bridge.webView as? WebView
                    if (webView == null) {
                        call.reject("WebView not available")
                        return@executeOnMainThread
                    }

                    pm.print(content, settings, webView, callback = { completed ->
                        val ret = JSObject()
                        ret.put("success", completed)
                        call.resolve(ret)
                    })
                } catch (e: Exception) {
                    call.reject("Print failed: ${e.message}", e)
                }
            }
        } catch (e: Exception) {
            call.reject("Print failed: ${e.message}", e)
        }
    }

    @PluginMethod
    fun printHtml(call: PluginCall) {
        val html = call.getString("html")
        if (html == null) {
            call.reject("The 'html' parameter is required")
            return
        }
        val currentActivity = activity
        if (currentActivity == null) {
            call.reject("Activity not available")
            return
        }
        val settings = extractSettings(call)

        bridge.executeOnMainThread {
            try {
                val pm = PrintManager(currentActivity)
                val webView = bridge.webView as? WebView
                if (webView == null) {
                    call.reject("WebView not available")
                    return@executeOnMainThread
                }
                pm.print(html, settings, webView, callback = { completed ->
                    val ret = JSObject()
                    ret.put("success", completed)
                    call.resolve(ret)
                })
            } catch (e: Exception) {
                call.reject("Print failed: ${e.message}", e)
            }
        }
    }

    @PluginMethod
    fun printPdf(call: PluginCall) {
        val path = call.getString("path")
        if (path == null) {
            call.reject("The 'path' parameter is required")
            return
        }
        val currentActivity = activity
        if (currentActivity == null) {
            call.reject("Activity not available")
            return
        }
        val settings = extractSettings(call)

        bridge.executeOnMainThread {
            try {
                val pm = PrintManager(currentActivity)
                val webView = bridge.webView as? WebView
                if (webView == null) {
                    call.reject("WebView not available")
                    return@executeOnMainThread
                }
                pm.print(path, settings, webView, callback = { completed ->
                    val ret = JSObject()
                    ret.put("success", completed)
                    call.resolve(ret)
                })
            } catch (e: Exception) {
                call.reject("Print failed: ${e.message}", e)
            }
        }
    }

    @PluginMethod
    fun printBase64(call: PluginCall) {
        val data = call.getString("data")
        if (data == null) {
            call.reject("The 'data' parameter is required")
            return
        }
        val mimeType = call.getString("mimeType")
        if (mimeType == null) {
            call.reject("The 'mimeType' parameter is required")
            return
        }
        val currentActivity = activity
        if (currentActivity == null) {
            call.reject("Activity not available")
            return
        }
        val content = "base64:$data"
        val settings = extractSettings(call)

        bridge.executeOnMainThread {
            try {
                val pm = PrintManager(currentActivity)
                val webView = bridge.webView as? WebView
                if (webView == null) {
                    call.reject("WebView not available")
                    return@executeOnMainThread
                }
                pm.print(content, settings, webView, callback = { completed ->
                    val ret = JSObject()
                    ret.put("success", completed)
                    call.resolve(ret)
                }, forcedMimeType = mimeType)
            } catch (e: Exception) {
                call.reject("Print failed: ${e.message}", e)
            }
        }
    }

    @PluginMethod
    fun printFile(call: PluginCall) {
        val path = call.getString("path")
        if (path == null) {
            call.reject("The 'path' parameter is required")
            return
        }
        val currentActivity = activity
        if (currentActivity == null) {
            call.reject("Activity not available")
            return
        }
        val mimeType = call.getString("mimeType")
        val settings = extractSettings(call)

        bridge.executeOnMainThread {
            try {
                val pm = PrintManager(currentActivity)
                val webView = bridge.webView as? WebView
                if (webView == null) {
                    call.reject("WebView not available")
                    return@executeOnMainThread
                }
                pm.print(path, settings, webView, callback = { completed ->
                    val ret = JSObject()
                    ret.put("success", completed)
                    call.resolve(ret)
                }, forcedMimeType = mimeType)
            } catch (e: Exception) {
                call.reject("Print failed: ${e.message}", e)
            }
        }
    }

    @PluginMethod
    fun printWebView(call: PluginCall) {
        val currentActivity = activity
        if (currentActivity == null) {
            call.reject("Activity not available")
            return
        }
        val settings = extractSettings(call)

        bridge.executeOnMainThread {
            try {
                val pm = PrintManager(currentActivity)
                val webView = bridge.webView as? WebView
                if (webView == null) {
                    call.reject("WebView not available")
                    return@executeOnMainThread
                }
                pm.print(null, settings, webView, callback = { completed ->
                    val ret = JSObject()
                    ret.put("success", completed)
                    call.resolve(ret)
                })
            } catch (e: Exception) {
                call.reject("Print failed: ${e.message}", e)
            }
        }
    }

    private fun extractSettings(call: PluginCall): JSObject {
        val settings = JSObject()

        call.getString("name")?.let { settings.put("name", it) }
        call.getString("orientation")?.let { settings.put("orientation", it) }
        call.getString("duplex")?.let { settings.put("duplex", it) }
        call.getBoolean("monochrome")?.let { settings.put("monochrome", it) }
        call.getBoolean("photo")?.let { settings.put("photo", it) }
        call.getInt("copies")?.let { settings.put("copies", it) }
        call.getInt("pageCount")?.let { settings.put("pageCount", it) }
        call.getBoolean("autoFit")?.let { settings.put("autoFit", it) }
        call.getBoolean("javascript")?.let { settings.put("javascript", it) }

        call.getObject("font")?.let { settings.put("font", it) }
        call.getObject("paper")?.let { settings.put("paper", it) }
        val margin = call.data.opt("margin")
        if (margin != null) { settings.put("margin", margin) }

        return settings
    }
}
