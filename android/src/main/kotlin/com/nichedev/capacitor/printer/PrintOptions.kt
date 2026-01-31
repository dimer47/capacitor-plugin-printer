package com.nichedev.capacitor.printer

import android.print.PrintAttributes
import android.print.PrintDocumentInfo
import androidx.print.PrintHelper
import org.json.JSONObject

class PrintOptions(private val spec: JSONObject) {

    fun getJobName(): String {
        val jobName = spec.optString("name", "")
        return if (jobName.isEmpty()) {
            "Printer Plugin Job #${System.currentTimeMillis()}"
        } else {
            jobName
        }
    }

    fun getPageCount(): Int {
        val count = spec.optInt("pageCount", PrintDocumentInfo.PAGE_COUNT_UNKNOWN)
        return if (count <= 0) PrintDocumentInfo.PAGE_COUNT_UNKNOWN else count
    }

    fun toPrintAttributes(): PrintAttributes {
        val builder = PrintAttributes.Builder()
        val margin = spec.opt("margin")

        when (spec.optString("orientation")) {
            "landscape" -> builder.setMediaSize(PrintAttributes.MediaSize.UNKNOWN_LANDSCAPE)
            "portrait" -> builder.setMediaSize(PrintAttributes.MediaSize.UNKNOWN_PORTRAIT)
        }

        if (spec.has("monochrome")) {
            if (spec.optBoolean("monochrome")) {
                builder.setColorMode(PrintAttributes.COLOR_MODE_MONOCHROME)
            } else {
                builder.setColorMode(PrintAttributes.COLOR_MODE_COLOR)
            }
        }

        if (margin is Boolean && !margin) {
            builder.setMinMargins(PrintAttributes.Margins.NO_MARGINS)
        }

        when (spec.optString("duplex")) {
            "long" -> builder.setDuplexMode(PrintAttributes.DUPLEX_MODE_LONG_EDGE)
            "short" -> builder.setDuplexMode(PrintAttributes.DUPLEX_MODE_SHORT_EDGE)
            "none" -> builder.setDuplexMode(PrintAttributes.DUPLEX_MODE_NONE)
        }

        return builder.build()
    }

    fun decoratePrintHelper(printer: PrintHelper) {
        when (spec.optString("orientation")) {
            "landscape" -> printer.orientation = PrintHelper.ORIENTATION_LANDSCAPE
            "portrait" -> printer.orientation = PrintHelper.ORIENTATION_PORTRAIT
        }

        if (spec.has("monochrome")) {
            if (spec.optBoolean("monochrome")) {
                printer.colorMode = PrintHelper.COLOR_MODE_MONOCHROME
            } else {
                printer.colorMode = PrintHelper.COLOR_MODE_COLOR
            }
        }

        if (spec.optBoolean("autoFit", true)) {
            printer.scaleMode = PrintHelper.SCALE_MODE_FIT
        } else {
            printer.scaleMode = PrintHelper.SCALE_MODE_FILL
        }
    }
}
