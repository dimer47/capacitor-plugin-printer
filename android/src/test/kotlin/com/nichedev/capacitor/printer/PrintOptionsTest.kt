package com.nichedev.capacitor.printer

import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class PrintOptionsTest {

    // =========================================================================
    // toMils — pure computation, no Android framework dependency
    // =========================================================================

    @Test
    fun toMils_null_returnsZero() {
        assertEquals(0, PrintOptions.toMils(null))
    }

    @Test
    fun toMils_emptyString_returnsZero() {
        assertEquals(0, PrintOptions.toMils(""))
    }

    @Test
    fun toMils_millimeters_converts() {
        // 10mm = 10 * 39.3701 ≈ 394 mils
        assertEquals(394, PrintOptions.toMils("10mm"))
    }

    @Test
    fun toMils_centimeters_converts() {
        // 1cm = 393.701 ≈ 394 mils
        assertEquals(394, PrintOptions.toMils("1cm"))
    }

    @Test
    fun toMils_inches_converts() {
        // 1in = 1000 mils
        assertEquals(1000, PrintOptions.toMils("1in"))
    }

    @Test
    fun toMils_halfInch_converts() {
        assertEquals(500, PrintOptions.toMils("0.5in"))
    }

    @Test
    fun toMils_points_converts() {
        // 72pt = 1 inch = 1000 mils
        assertEquals(1000, PrintOptions.toMils("72pt"))
    }

    @Test
    fun toMils_numericString_treatedAsPoints() {
        // 72 (no unit) = 1 inch = 1000 mils
        assertEquals(1000, PrintOptions.toMils("72"))
    }

    @Test
    fun toMils_number_treatedAsPoints() {
        assertEquals(1000, PrintOptions.toMils(72))
    }

    @Test
    fun toMils_doubleNumber_treatedAsPoints() {
        assertEquals(1000, PrintOptions.toMils(72.0))
    }

    @Test
    fun toMils_zero_returnsZero() {
        assertEquals(0, PrintOptions.toMils("0mm"))
        assertEquals(0, PrintOptions.toMils("0in"))
        assertEquals(0, PrintOptions.toMils("0cm"))
        assertEquals(0, PrintOptions.toMils("0pt"))
        assertEquals(0, PrintOptions.toMils(0))
    }

    @Test
    fun toMils_25_4mm_isOneInch() {
        assertEquals(1000, PrintOptions.toMils("25.4mm"))
    }

    @Test
    fun toMils_2_54cm_isOneInch() {
        assertEquals(1000, PrintOptions.toMils("2.54cm"))
    }

    @Test
    fun toMils_2inches_is2000() {
        assertEquals(2000, PrintOptions.toMils("2in"))
    }

    @Test
    fun toMils_10cm_converts() {
        // 10cm = 3937 mils
        assertEquals(3937, PrintOptions.toMils("10cm"))
    }

    @Test
    fun toMils_decimalMm_converts() {
        // 5.5mm = 5.5 * 39.3701 ≈ 217 mils
        assertEquals(217, PrintOptions.toMils("5.5mm"))
    }

    // =========================================================================
    // getJobName
    // =========================================================================

    @Test
    fun getJobName_withName_returnsName() {
        val spec = JSONObject().put("name", "My Job")
        assertEquals("My Job", PrintOptions(spec).getJobName())
    }

    @Test
    fun getJobName_emptyName_returnsDefault() {
        val spec = JSONObject().put("name", "")
        assertTrue(PrintOptions(spec).getJobName().startsWith("Printer Plugin Job"))
    }

    @Test
    fun getJobName_noName_returnsDefault() {
        assertTrue(PrintOptions(JSONObject()).getJobName().startsWith("Printer Plugin Job"))
    }

    @Test
    fun getJobName_default_containsTimestamp() {
        val name = PrintOptions(JSONObject()).getJobName()
        // "Printer Plugin Job #<timestamp>"
        assertTrue(name.contains("#"))
    }

    // =========================================================================
    // getPageCount
    // =========================================================================

    @Test
    fun getPageCount_withValue_returnsValue() {
        val spec = JSONObject().put("pageCount", 5)
        assertEquals(5, PrintOptions(spec).getPageCount())
    }

    @Test
    fun getPageCount_one_returnsOne() {
        val spec = JSONObject().put("pageCount", 1)
        assertEquals(1, PrintOptions(spec).getPageCount())
    }

    @Test
    fun getPageCount_default_returnsUnknown() {
        // PrintDocumentInfo.PAGE_COUNT_UNKNOWN = -1
        assertEquals(-1, PrintOptions(JSONObject()).getPageCount())
    }

    @Test
    fun getPageCount_zero_returnsUnknown() {
        val spec = JSONObject().put("pageCount", 0)
        assertEquals(-1, PrintOptions(spec).getPageCount())
    }

    @Test
    fun getPageCount_negative_returnsUnknown() {
        val spec = JSONObject().put("pageCount", -3)
        assertEquals(-1, PrintOptions(spec).getPageCount())
    }

    @Test
    fun getPageCount_large_returnsValue() {
        val spec = JSONObject().put("pageCount", 999)
        assertEquals(999, PrintOptions(spec).getPageCount())
    }

    // =========================================================================
    // toMils — edge cases and additional units
    // =========================================================================

    @Test
    fun toMils_largeValue_mm() {
        // 1000mm = 1000 * 39.3701 ≈ 39370 mils
        assertEquals(39370, PrintOptions.toMils("1000mm"))
    }

    @Test
    fun toMils_fractionalCm() {
        // 0.5cm = 0.5 * 393.701 ≈ 197 mils
        assertEquals(197, PrintOptions.toMils("0.5cm"))
    }

    @Test
    fun toMils_36pt_isHalfInch() {
        // 36pt = 0.5in = 500 mils
        assertEquals(500, PrintOptions.toMils("36pt"))
    }

    @Test
    fun toMils_144pt_is2Inches() {
        // 144pt = 2in = 2000 mils
        assertEquals(2000, PrintOptions.toMils("144pt"))
    }

    @Test
    fun toMils_invalidString_returnsZero() {
        assertEquals(0, PrintOptions.toMils("abc"))
    }

    @Test
    fun toMils_negativeValue_mm() {
        // Negative: -10mm = -394 mils
        assertEquals(-394, PrintOptions.toMils("-10mm"))
    }

    @Test
    fun toMils_negativeValue_in() {
        assertEquals(-1000, PrintOptions.toMils("-1in"))
    }

    @Test
    fun toMils_floatNumber_treatedAsPoints() {
        // 36.0 points = 0.5 inch = 500 mils
        assertEquals(500, PrintOptions.toMils(36.0))
    }

    @Test
    fun toMils_intNumber_treatedAsPoints() {
        // 36 points = 0.5 inch = 500 mils
        assertEquals(500, PrintOptions.toMils(36))
    }

    // =========================================================================
    // getJobName — additional cases
    // =========================================================================

    @Test
    fun getJobName_withSpaces_preservesSpaces() {
        val spec = JSONObject().put("name", "  My Job  ")
        assertEquals("  My Job  ", PrintOptions(spec).getJobName())
    }

    @Test
    fun getJobName_withSpecialChars_preserves() {
        val spec = JSONObject().put("name", "Job #42 / Report (v2)")
        assertEquals("Job #42 / Report (v2)", PrintOptions(spec).getJobName())
    }

    @Test
    fun getJobName_multipleCallsDefault_differentTimestamps() {
        val name1 = PrintOptions(JSONObject()).getJobName()
        Thread.sleep(2)
        val name2 = PrintOptions(JSONObject()).getJobName()
        // Each call uses System.currentTimeMillis(), so they should differ
        assertTrue(name1.startsWith("Printer Plugin Job #"))
        assertTrue(name2.startsWith("Printer Plugin Job #"))
    }
}
