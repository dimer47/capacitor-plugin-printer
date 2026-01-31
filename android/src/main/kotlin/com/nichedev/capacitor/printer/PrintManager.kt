package com.nichedev.capacitor.printer

import android.app.Activity
import android.content.Context
import android.print.PrintAttributes
import android.print.PrintDocumentAdapter
import android.print.PrintJob
import android.print.PrintJobInfo
import android.webkit.CookieManager
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.print.PrintHelper
import org.json.JSONArray
import org.json.JSONObject

class PrintManager(private val context: Context) {

    private var view: WebView? = null

    fun canPrintItem(item: String?): Boolean {
        var supported = PrintHelper.systemSupportsPrint()

        if (item != null && item.isNotEmpty()) {
            supported = PrintContent.getContentType(item, context) != PrintContent.ContentType.UNSUPPORTED
        }

        return supported
    }

    companion object {
        fun getPrintableTypes(): JSONArray {
            return JSONArray().apply {
                put("com.adobe.pdf")
                put("com.microsoft.bmp")
                put("public.jpeg")
                put("public.jpeg-2000")
                put("public.png")
                put("public.heif")
                put("com.compuserve.gif")
                put("com.microsoft.ico")
            }
        }
    }

    fun print(
        content: String?,
        settings: JSONObject,
        webView: WebView,
        callback: (Boolean) -> Unit,
        forcedMimeType: String? = null
    ) {
        when (PrintContent.getContentType(content, context, forcedMimeType)) {
            PrintContent.ContentType.IMAGE -> {
                if (content == null) { callback(false); return }
                printImage(content, settings, callback)
            }
            PrintContent.ContentType.PDF -> {
                if (content == null) { callback(false); return }
                printPdf(content, settings, callback)
            }
            PrintContent.ContentType.HTML -> {
                if (content.isNullOrEmpty()) {
                    printWebView(webView, settings, callback)
                } else {
                    printHtml(content, settings, callback)
                }
            }
            PrintContent.ContentType.UNSUPPORTED,
            PrintContent.ContentType.PLAIN -> printText(content, settings, callback)
        }
    }

    private fun printHtml(content: String, settings: JSONObject, callback: (Boolean) -> Unit) {
        printContent(content, "text/html", settings, callback)
    }

    private fun printText(content: String?, settings: JSONObject, callback: (Boolean) -> Unit) {
        printContent(content ?: "", "text/plain", settings, callback)
    }

    private fun printContent(
        content: String,
        mimeType: String,
        settings: JSONObject,
        callback: (Boolean) -> Unit
    ) {
        val activity = context as? Activity ?: run {
            callback(false)
            return
        }

        activity.runOnUiThread {
            val webView = createWebView(settings)
            view = webView

            webView.webViewClient = object : WebViewClient() {
                override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean = false

                override fun onPageFinished(wv: WebView, url: String) {
                    val currentView = this@PrintManager.view ?: run {
                        callback(false)
                        return
                    }
                    printWebView(currentView, settings) { result ->
                        this@PrintManager.view?.destroy()
                        this@PrintManager.view = null
                        callback(result)
                    }
                }
            }

            webView.loadDataWithBaseURL(
                "file:///android_asset/public/",
                content,
                mimeType,
                "UTF-8",
                null
            )
        }
    }

    private fun printWebView(view: WebView, settings: JSONObject, callback: (Boolean) -> Unit) {
        val options = PrintOptions(settings)
        val jobName = options.getJobName()

        val activity = context as? Activity ?: run {
            callback(false)
            return
        }

        activity.runOnUiThread {
            val adapter: PrintDocumentAdapter = view.createPrintDocumentAdapter(jobName)
            val proxy = PrintProxy(adapter) {
                callback(isPrintJobCompleted(jobName))
            }
            printAdapter(proxy, options)
        }
    }

    private fun printPdf(path: String, settings: JSONObject, callback: (Boolean) -> Unit) {
        val stream = PrintContent.open(path, context) ?: run {
            callback(false)
            return
        }

        val options = PrintOptions(settings)
        val jobName = options.getJobName()
        val pageCount = options.getPageCount()
        val adapter = PrintAdapter(jobName, pageCount, stream) {
            callback(isPrintJobCompleted(jobName))
        }

        printAdapter(adapter, options)
    }

    private fun printAdapter(adapter: PrintDocumentAdapter, options: PrintOptions) {
        val jobName = options.getJobName()
        val attrs = options.toPrintAttributes()
        getPrintService().print(jobName, adapter, attrs)
    }

    private fun printImage(path: String, settings: JSONObject, callback: (Boolean) -> Unit) {
        val bitmap = PrintContent.decode(path, context) ?: run {
            callback(false)
            return
        }

        val options = PrintOptions(settings)
        val printer = PrintHelper(context)
        val jobName = options.getJobName()

        options.decoratePrintHelper(printer)

        printer.printBitmap(jobName, bitmap) {
            callback(isPrintJobCompleted(jobName))
        }
    }

    private fun createWebView(settings: JSONObject): WebView {
        val jsEnabled = settings.optBoolean("javascript", false)
        val webView = WebView(context)
        val spec = webView.settings
        val font = settings.optJSONObject("font")

        spec.setSupportZoom(true)
        spec.useWideViewPort = true
        spec.javaScriptEnabled = jsEnabled

        if (font != null && font.has("size")) {
            spec.defaultFixedFontSize = font.optInt("size", 16)
        }

        spec.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
        CookieManager.getInstance().setAcceptThirdPartyCookies(webView, true)

        return webView
    }

    private fun findPrintJobByName(jobName: String): PrintJob? {
        for (job in getPrintService().printJobs) {
            if (job.info.label == jobName) {
                return job
            }
        }
        return null
    }

    private fun isPrintJobCompleted(jobName: String): Boolean {
        val job = findPrintJobByName(jobName) ?: return true
        return job.info.state != PrintJobInfo.STATE_FAILED &&
               job.info.state != PrintJobInfo.STATE_CANCELED
    }

    private fun getPrintService(): android.print.PrintManager {
        return context.getSystemService(Context.PRINT_SERVICE) as? android.print.PrintManager
            ?: throw IllegalStateException("Print service not available")
    }
}
