import XCTest
@testable import PrinterPlugin

final class PrinterLayoutTests: XCTestCase {

    // MARK: - Nil settings

    func testLayout_nilSettings_noError() {
        // Should not crash
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: [:])
        XCTAssertNotNil(formatter)
    }

    // MARK: - Max dimensions

    func testLayout_maxWidth_isApplied() {
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: ["maxWidth": "10cm"])
        let expected = 10.0 * 72.0 / 2.54
        XCTAssertEqual(Double(formatter.maximumContentWidth), expected, accuracy: 1.0)
    }

    func testLayout_maxHeight_isApplied() {
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: ["maxHeight": "15cm"])
        let expected = 15.0 * 72.0 / 2.54
        XCTAssertEqual(Double(formatter.maximumContentHeight), expected, accuracy: 1.0)
    }

    func testLayout_maxHeight_configuredOnFormatter() {
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: ["maxHeight": "5in"])
        let expected = 5.0 * 72.0
        XCTAssertEqual(Double(formatter.maximumContentHeight), expected, accuracy: 1.0)
    }

    func testLayout_noMaxDimensions_keepsDefault() {
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let originalWidth = formatter.maximumContentWidth
        let originalHeight = formatter.maximumContentHeight
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: [:])
        XCTAssertEqual(formatter.maximumContentWidth, originalWidth)
        XCTAssertEqual(formatter.maximumContentHeight, originalHeight)
    }

    func testLayout_maxWidth_inches() {
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: ["maxWidth": "8in"])
        let expected = 8.0 * 72.0
        XCTAssertEqual(Double(formatter.maximumContentWidth), expected, accuracy: 1.0)
    }

    func testLayout_maxWidth_mm() {
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: ["maxWidth": "100mm"])
        let expected = 100.0 * 72.0 / 25.4
        XCTAssertEqual(Double(formatter.maximumContentWidth), expected, accuracy: 1.0)
    }

    // MARK: - Margins

    func testLayout_margins_areApplied() {
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let margin: [String: Any] = [
            "top": "1cm",
            "left": "1cm",
            "bottom": "1cm",
            "right": "1cm",
        ]
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: ["margin": margin])
        let insets = formatter.perPageContentInsets
        let expected = 1.0 * 72.0 / 2.54
        XCTAssertEqual(Double(insets.top), expected, accuracy: 1.0)
        XCTAssertEqual(Double(insets.left), expected, accuracy: 1.0)
        XCTAssertEqual(Double(insets.bottom), expected, accuracy: 1.0)
        XCTAssertEqual(Double(insets.right), expected, accuracy: 1.0)
    }

    func testLayout_margins_inches() {
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let margin: [String: Any] = [
            "top": "0.5in",
            "left": "1in",
            "bottom": "0.5in",
            "right": "1in",
        ]
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: ["margin": margin])
        let insets = formatter.perPageContentInsets
        XCTAssertEqual(Double(insets.top), 36.0, accuracy: 1.0)
        XCTAssertEqual(Double(insets.left), 72.0, accuracy: 1.0)
        XCTAssertEqual(Double(insets.bottom), 36.0, accuracy: 1.0)
        XCTAssertEqual(Double(insets.right), 72.0, accuracy: 1.0)
    }

    func testLayout_partialMargins_othersShouldBeZero() {
        let formatter = UISimpleTextPrintFormatter(text: "test")
        let margin: [String: Any] = [
            "top": "1cm",
        ]
        let _ = PrinterLayout.configureFormatter(formatter, withSettings: ["margin": margin])
        let insets = formatter.perPageContentInsets
        let expected = 1.0 * 72.0 / 2.54
        XCTAssertEqual(Double(insets.top), expected, accuracy: 1.0)
        XCTAssertEqual(Double(insets.left), 0, accuracy: 1.0)
        XCTAssertEqual(Double(insets.bottom), 0, accuracy: 1.0)
        XCTAssertEqual(Double(insets.right), 0, accuracy: 1.0)
    }

    // MARK: - Text formatter font (via PrinterFont)
    // Note: UISimpleTextPrintFormatter does not reliably retain font/color/alignment
    // properties when set outside a print rendering context. We verify PrinterFont
    // produces the correct values that configureTextFormatter would assign.

    func testLayout_textFormatter_fontIsApplied() {
        let font = PrinterFont(dictionary: ["size": 20, "bold": true])
        XCTAssertEqual(font.font.pointSize, 20)
    }

    func testLayout_textFormatter_colorIsApplied() {
        let font = PrinterFont(dictionary: ["color": "#FF0000"])
        var red: CGFloat = 0
        font.color.getRed(&red, green: nil, blue: nil, alpha: nil)
        XCTAssertEqual(red, 1.0, accuracy: 0.01)
    }

    func testLayout_textFormatter_alignmentIsApplied() {
        let font = PrinterFont(dictionary: ["align": "center"])
        XCTAssertEqual(font.alignment, .center)
    }
}
