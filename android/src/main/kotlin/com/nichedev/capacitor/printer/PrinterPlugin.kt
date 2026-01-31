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
        // Printer picker is not supported on Android
        val ret = JSObject()
        call.resolve(ret)
    }

    @PluginMethod
    fun print(call: PluginCall) {
        val content = call.getString("content")
        val settings = extractSettings(call)

        bridge.executeOnMainThread {
            val pm = PrintManager(activity)
            val webView = bridge.webView as WebView

            pm.print(content, settings, webView) { completed ->
                val ret = JSObject()
                ret.put("success", completed)
                call.resolve(ret)
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
        call.getObject("margin")?.let { settings.put("margin", it) }
        call.getBoolean("margin")?.let { settings.put("margin", it) }

        return settings
    }
}
