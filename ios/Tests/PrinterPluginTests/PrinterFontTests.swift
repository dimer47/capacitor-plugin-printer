import XCTest
@testable import PrinterPlugin

final class PrinterFontTests: XCTestCase {

    // MARK: - Default values

    func testFont_nilDictionary_usesSystemFont() {
        let font = PrinterFont(dictionary: nil)
        XCTAssertNotNil(font.font)
    }

    func testFont_emptyDictionary_usesSystemFont() {
        let font = PrinterFont(dictionary: [:])
        XCTAssertNotNil(font.font)
    }

    func testFont_defaultColor_isDarkText() {
        let font = PrinterFont(dictionary: nil)
        XCTAssertEqual(font.color, .darkText)
    }

    func testFont_defaultAlignment_isNatural() {
        let font = PrinterFont(dictionary: nil)
        XCTAssertEqual(font.alignment, .natural)
    }

    // MARK: - Font size

    func testFont_customSize_isApplied() {
        let font = PrinterFont(dictionary: ["size": 24])
        XCTAssertEqual(font.font.pointSize, 24)
    }

    func testFont_zeroSize_usesSmallSystemFont() {
        let font = PrinterFont(dictionary: ["size": 0])
        XCTAssertEqual(font.font.pointSize, UIFont.smallSystemFontSize)
    }

    func testFont_negativeSize_usesSmallSystemFont() {
        let font = PrinterFont(dictionary: ["size": -5])
        XCTAssertEqual(font.font.pointSize, UIFont.smallSystemFontSize)
    }

    // MARK: - Bold / Italic

    func testFont_bold_hasBoldTrait() {
        let font = PrinterFont(dictionary: ["bold": true])
        let traits = font.font.fontDescriptor.symbolicTraits
        XCTAssertTrue(traits.contains(.traitBold))
    }

    func testFont_italic_hasItalicTrait() {
        let font = PrinterFont(dictionary: ["italic": true])
        let traits = font.font.fontDescriptor.symbolicTraits
        XCTAssertTrue(traits.contains(.traitItalic))
    }

    func testFont_boldAndItalic_hasBothTraits() {
        let font = PrinterFont(dictionary: ["bold": true, "italic": true])
        let traits = font.font.fontDescriptor.symbolicTraits
        XCTAssertTrue(traits.contains(.traitBold))
        XCTAssertTrue(traits.contains(.traitItalic))
    }

    func testFont_noBoldNoItalic_noTraits() {
        let font = PrinterFont(dictionary: ["bold": false, "italic": false])
        let traits = font.font.fontDescriptor.symbolicTraits
        XCTAssertFalse(traits.contains(.traitBold))
        XCTAssertFalse(traits.contains(.traitItalic))
    }

    // MARK: - Named font

    func testFont_namedFont_loadsIfAvailable() {
        // Courier is always available on iOS
        let font = PrinterFont(dictionary: ["name": "Courier", "size": 14])
        XCTAssertEqual(font.font.fontName, "Courier")
        XCTAssertEqual(font.font.pointSize, 14)
    }

    func testFont_unknownFontName_fallsBackToSystem() {
        let font = PrinterFont(dictionary: ["name": "NonExistentFont123", "size": 16])
        // Should fall back to system font
        XCTAssertEqual(font.font.pointSize, 16)
        XCTAssertNotEqual(font.font.fontName, "NonExistentFont123")
    }

    // MARK: - Color

    func testFont_nilColor_isDarkText() {
        let font = PrinterFont(dictionary: nil)
        XCTAssertEqual(font.color, .darkText)
    }

    func testFont_noColorKey_isDarkText() {
        let font = PrinterFont(dictionary: ["size": 12])
        XCTAssertEqual(font.color, .darkText)
    }

    func testFont_hexColor_red_isParsed() {
        let font = PrinterFont(dictionary: ["color": "#FF0000"])
        let color = font.color
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        XCTAssertEqual(red, 1.0, accuracy: 0.01)
        XCTAssertEqual(green, 0.0, accuracy: 0.01)
        XCTAssertEqual(blue, 0.0, accuracy: 0.01)
    }

    func testFont_hexColor_green_isParsed() {
        let font = PrinterFont(dictionary: ["color": "#00FF00"])
        let color = font.color
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        XCTAssertEqual(red, 0.0, accuracy: 0.01)
        XCTAssertEqual(green, 1.0, accuracy: 0.01)
    }

    func testFont_hexColor_blue_isParsed() {
        let font = PrinterFont(dictionary: ["color": "#0000FF"])
        let color = font.color
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        XCTAssertEqual(red, 0.0, accuracy: 0.01)
        XCTAssertEqual(blue, 1.0, accuracy: 0.01)
    }

    func testFont_hexColorWithoutHash_isParsed() {
        let font = PrinterFont(dictionary: ["color": "00FF00"])
        let color = font.color
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        XCTAssertEqual(red, 0.0, accuracy: 0.01)
        XCTAssertEqual(green, 1.0, accuracy: 0.01)
        XCTAssertEqual(blue, 0.0, accuracy: 0.01)
    }

    func testFont_emptyColor_isDarkText() {
        let font = PrinterFont(dictionary: ["color": ""])
        XCTAssertEqual(font.color, .darkText)
    }

    // MARK: - Alignment

    func testFont_alignLeft() {
        let font = PrinterFont(dictionary: ["align": "left"])
        XCTAssertEqual(font.alignment, .left)
    }

    func testFont_alignRight() {
        let font = PrinterFont(dictionary: ["align": "right"])
        XCTAssertEqual(font.alignment, .right)
    }

    func testFont_alignCenter() {
        let font = PrinterFont(dictionary: ["align": "center"])
        XCTAssertEqual(font.alignment, .center)
    }

    func testFont_alignJustified() {
        let font = PrinterFont(dictionary: ["align": "justified"])
        XCTAssertEqual(font.alignment, .justified)
    }

    func testFont_alignUnknown_isNatural() {
        let font = PrinterFont(dictionary: ["align": "unknown"])
        XCTAssertEqual(font.alignment, .natural)
    }

    // MARK: - Attributes

    func testFont_attributes_containsExpectedKeys() {
        let font = PrinterFont(dictionary: ["size": 16, "color": "#000000"])
        let attrs = font.attributes
        XCTAssertNotNil(attrs[.font])
        XCTAssertNotNil(attrs[.paragraphStyle])
        XCTAssertNotNil(attrs[.foregroundColor])
    }

    func testFont_attributes_paragraphStyleHasCorrectAlignment() {
        let font = PrinterFont(dictionary: ["align": "center"])
        let attrs = font.attributes
        let style = attrs[.paragraphStyle] as? NSParagraphStyle
        XCTAssertNotNil(style)
        XCTAssertEqual(style?.alignment, .center)
    }
}
