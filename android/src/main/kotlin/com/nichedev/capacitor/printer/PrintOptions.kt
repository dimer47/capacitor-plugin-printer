package com.nichedev.capacitor.printer

import android.print.PrintAttributes
import android.print.PrintDocumentInfo
import androidx.print.PrintHelper
import org.json.JSONObject
import kotlin.math.roundToInt

class PrintOptions(private val spec: JSONObject) {

    companion object {
        /** Named paper sizes mapped to PrintAttributes.MediaSize constants. */
        private val NAMED_SIZES: Map<String, PrintAttributes.MediaSize> = mapOf(
            // ISO A series
            "A0" to PrintAttributes.MediaSize.ISO_A0,
            "A1" to PrintAttributes.MediaSize.ISO_A1,
            "A2" to PrintAttributes.MediaSize.ISO_A2,
            "A3" to PrintAttributes.MediaSize.ISO_A3,
            "A4" to PrintAttributes.MediaSize.ISO_A4,
            "A5" to PrintAttributes.MediaSize.ISO_A5,
            "A6" to PrintAttributes.MediaSize.ISO_A6,
            "A7" to PrintAttributes.MediaSize.ISO_A7,
            "A8" to PrintAttributes.MediaSize.ISO_A8,
            "A9" to PrintAttributes.MediaSize.ISO_A9,
            "A10" to PrintAttributes.MediaSize.ISO_A10,
            // ISO B series
            "B0" to PrintAttributes.MediaSize.ISO_B0,
            "B1" to PrintAttributes.MediaSize.ISO_B1,
            "B2" to PrintAttributes.MediaSize.ISO_B2,
            "B3" to PrintAttributes.MediaSize.ISO_B3,
            "B4" to PrintAttributes.MediaSize.ISO_B4,
            "B5" to PrintAttributes.MediaSize.ISO_B5,
            "B6" to PrintAttributes.MediaSize.ISO_B6,
            "B7" to PrintAttributes.MediaSize.ISO_B7,
            "B8" to PrintAttributes.MediaSize.ISO_B8,
            "B9" to PrintAttributes.MediaSize.ISO_B9,
            "B10" to PrintAttributes.MediaSize.ISO_B10,
            // ISO C series
            "C0" to PrintAttributes.MediaSize.ISO_C0,
            "C1" to PrintAttributes.MediaSize.ISO_C1,
            "C2" to PrintAttributes.MediaSize.ISO_C2,
            "C3" to PrintAttributes.MediaSize.ISO_C3,
            "C4" to PrintAttributes.MediaSize.ISO_C4,
            "C5" to PrintAttributes.MediaSize.ISO_C5,
            "C6" to PrintAttributes.MediaSize.ISO_C6,
            "C7" to PrintAttributes.MediaSize.ISO_C7,
            "C8" to PrintAttributes.MediaSize.ISO_C8,
            "C9" to PrintAttributes.MediaSize.ISO_C9,
            "C10" to PrintAttributes.MediaSize.ISO_C10,
            // North America
            "LETTER" to PrintAttributes.MediaSize.NA_LETTER,
            "LEGAL" to PrintAttributes.MediaSize.NA_LEGAL,
            "TABLOID" to PrintAttributes.MediaSize.NA_TABLOID,
            "LEDGER" to PrintAttributes.MediaSize.NA_LEDGER,
            "JUNIOR_LEGAL" to PrintAttributes.MediaSize.NA_JUNIOR_LEGAL,
            "GOVT_LETTER" to PrintAttributes.MediaSize.NA_GOVT_LETTER,
            "INDEX_3X5" to PrintAttributes.MediaSize.NA_INDEX_3X5,
            "INDEX_4X6" to PrintAttributes.MediaSize.NA_INDEX_4X6,
            "4X6" to PrintAttributes.MediaSize.NA_INDEX_4X6,
            "INDEX_5X8" to PrintAttributes.MediaSize.NA_INDEX_5X8,
            "MONARCH" to PrintAttributes.MediaSize.NA_MONARCH,
            "QUARTO" to PrintAttributes.MediaSize.NA_QUARTO,
            "FOOLSCAP" to PrintAttributes.MediaSize.NA_FOOLSCAP,
            // JIS
            "JIS_B0" to PrintAttributes.MediaSize.JIS_B0,
            "JIS_B1" to PrintAttributes.MediaSize.JIS_B1,
            "JIS_B2" to PrintAttributes.MediaSize.JIS_B2,
            "JIS_B3" to PrintAttributes.MediaSize.JIS_B3,
            "JIS_B4" to PrintAttributes.MediaSize.JIS_B4,
            "JIS_B5" to PrintAttributes.MediaSize.JIS_B5,
            "JIS_B6" to PrintAttributes.MediaSize.JIS_B6,
            "JIS_B7" to PrintAttributes.MediaSize.JIS_B7,
            "JIS_B8" to PrintAttributes.MediaSize.JIS_B8,
            "JIS_B9" to PrintAttributes.MediaSize.JIS_B9,
            "JIS_B10" to PrintAttributes.MediaSize.JIS_B10,
            "JIS_EXEC" to PrintAttributes.MediaSize.JIS_EXEC,
            // Japanese
            "JPN_CHOU2" to PrintAttributes.MediaSize.JPN_CHOU2,
            "JPN_CHOU3" to PrintAttributes.MediaSize.JPN_CHOU3,
            "JPN_CHOU4" to PrintAttributes.MediaSize.JPN_CHOU4,
            "JPN_HAGAKI" to PrintAttributes.MediaSize.JPN_HAGAKI,
            "JPN_OUFUKU" to PrintAttributes.MediaSize.JPN_OUFUKU,
            "JPN_KAHU" to PrintAttributes.MediaSize.JPN_KAHU,
            "JPN_KAKU2" to PrintAttributes.MediaSize.JPN_KAKU2,
            "JPN_YOU4" to PrintAttributes.MediaSize.JPN_YOU4,
            // Chinese
            "ROC_8K" to PrintAttributes.MediaSize.ROC_8K,
            "ROC_16K" to PrintAttributes.MediaSize.ROC_16K,
            "PRC_1" to PrintAttributes.MediaSize.PRC_1,
            "PRC_2" to PrintAttributes.MediaSize.PRC_2,
            "PRC_3" to PrintAttributes.MediaSize.PRC_3,
            "PRC_4" to PrintAttributes.MediaSize.PRC_4,
            "PRC_5" to PrintAttributes.MediaSize.PRC_5,
            "PRC_6" to PrintAttributes.MediaSize.PRC_6,
            "PRC_7" to PrintAttributes.MediaSize.PRC_7,
            "PRC_8" to PrintAttributes.MediaSize.PRC_8,
            "PRC_9" to PrintAttributes.MediaSize.PRC_9,
            "PRC_10" to PrintAttributes.MediaSize.PRC_10,
            "PRC_16K" to PrintAttributes.MediaSize.PRC_16K,
            "OM_PA_KAI" to PrintAttributes.MediaSize.OM_PA_KAI,
            "OM_DAI_PA_KAI" to PrintAttributes.MediaSize.OM_DAI_PA_KAI,
            "OM_JUURO_KU_KAI" to PrintAttributes.MediaSize.OM_JUURO_KU_KAI,
        )

        /** Convert a unit string (e.g., '10mm', '1in', '2cm') to mils (thousandths of inch). */
        fun toMils(value: Any?): Int {
            if (value == null) return 0
            if (value is Number) return (value.toDouble() * 1000.0 / 72.0).roundToInt()

            val str = value.toString()
            if (str.isEmpty()) return 0

            return when {
                str.endsWith("mm") -> {
                    val v = str.dropLast(2).toDoubleOrNull() ?: 0.0
                    (v * 39.3701).roundToInt()
                }
                str.endsWith("cm") -> {
                    val v = str.dropLast(2).toDoubleOrNull() ?: 0.0
                    (v * 393.701).roundToInt()
                }
                str.endsWith("in") -> {
                    val v = str.dropLast(2).toDoubleOrNull() ?: 0.0
                    (v * 1000.0).roundToInt()
                }
                str.endsWith("pt") -> {
                    val v = str.dropLast(2).toDoubleOrNull() ?: 0.0
                    (v * 1000.0 / 72.0).roundToInt()
                }
                else -> {
                    val v = str.toDoubleOrNull() ?: 0.0
                    (v * 1000.0 / 72.0).roundToInt()
                }
            }
        }
    }

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
        val paper = spec.optJSONObject("paper")
        val orientation = spec.optString("orientation", "")

        // Resolve media size from paper option or orientation
        val mediaSize = resolveMediaSize(paper, orientation)
        if (mediaSize != null) {
            builder.setMediaSize(mediaSize)
        }

        // Color mode
        if (spec.has("monochrome")) {
            if (spec.optBoolean("monochrome")) {
                builder.setColorMode(PrintAttributes.COLOR_MODE_MONOCHROME)
            } else {
                builder.setColorMode(PrintAttributes.COLOR_MODE_COLOR)
            }
        }

        // Margins: false → NO_MARGINS, object → custom margins
        if (margin is Boolean && !margin) {
            builder.setMinMargins(PrintAttributes.Margins.NO_MARGINS)
        } else if (margin is JSONObject) {
            val left = toMils(margin.opt("left"))
            val top = toMils(margin.opt("top"))
            val right = toMils(margin.opt("right"))
            val bottom = toMils(margin.opt("bottom"))
            builder.setMinMargins(PrintAttributes.Margins(left, top, right, bottom))
        }

        // Duplex
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

    private fun resolveMediaSize(
        paper: JSONObject?,
        orientation: String
    ): PrintAttributes.MediaSize? {
        var mediaSize: PrintAttributes.MediaSize? = null

        if (paper != null) {
            val name = paper.optString("name", "").uppercase()

            if (name.isNotEmpty()) {
                mediaSize = NAMED_SIZES[name]
            }

            // Custom width/height in paper option (values with units → mils)
            if (mediaSize == null) {
                val widthMils = toMils(paper.opt("width"))
                val heightMils = toMils(paper.opt("height"))
                if (widthMils > 0 && heightMils > 0) {
                    mediaSize = PrintAttributes.MediaSize(
                        "custom_${widthMils}x${heightMils}",
                        "Custom ${widthMils}x${heightMils}",
                        widthMils,
                        heightMils
                    )
                }
            }
        }

        // Apply orientation: if landscape, swap to landscape variant
        if (mediaSize != null) {
            mediaSize = when (orientation) {
                "landscape" -> if (mediaSize.isPortrait) mediaSize.asLandscape() else mediaSize
                "portrait" -> if (!mediaSize.isPortrait) mediaSize.asPortrait() else mediaSize
                else -> mediaSize
            }
            return mediaSize
        }

        // Fallback: orientation only (no paper specified)
        return when (orientation) {
            "landscape" -> PrintAttributes.MediaSize.UNKNOWN_LANDSCAPE
            "portrait" -> PrintAttributes.MediaSize.UNKNOWN_PORTRAIT
            else -> null
        }
    }
}
