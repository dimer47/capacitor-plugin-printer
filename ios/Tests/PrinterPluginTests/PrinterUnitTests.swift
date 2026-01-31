import XCTest
@testable import PrinterPlugin

final class PrinterUnitTests: XCTestCase {

    // MARK: - Nil / NSNull / empty

    func testConvert_nil_returnsZero() {
        XCTAssertEqual(PrinterUnit.convert(nil), 0)
    }

    func testConvert_nsNull_returnsZero() {
        XCTAssertEqual(PrinterUnit.convert(NSNull()), 0)
    }

    func testConvert_emptyString_returnsZero() {
        XCTAssertEqual(PrinterUnit.convert(""), 0)
    }

    // MARK: - Numbers

    func testConvert_nsNumber_returnsSameValue() {
        XCTAssertEqual(PrinterUnit.convert(NSNumber(value: 42)), 42)
    }

    func testConvert_intValue_returnsSameValue() {
        XCTAssertEqual(PrinterUnit.convert(72 as Int), 72)
    }

    func testConvert_doubleValue_returnsSameValue() {
        XCTAssertEqual(PrinterUnit.convert(36.5 as Double), 36.5)
    }

    // MARK: - Points

    func testConvert_points_returnsSameValue() {
        XCTAssertEqual(PrinterUnit.convert("72pt"), 72)
    }

    func testConvert_pointsDecimal_works() {
        XCTAssertEqual(PrinterUnit.convert("36.5pt"), 36.5)
    }

    // MARK: - Inches

    func testConvert_oneInch_converts() {
        XCTAssertEqual(PrinterUnit.convert("1in"), 72.0)
    }

    func testConvert_twoInches_convertsToPoints() {
        XCTAssertEqual(PrinterUnit.convert("2in"), 144.0)
    }

    func testConvert_halfInch_convertsToPoints() {
        XCTAssertEqual(PrinterUnit.convert("0.5in"), 36.0)
    }

    // MARK: - Millimeters

    func testConvert_10mm_convertsToPoints() {
        let result = PrinterUnit.convert("10mm")
        XCTAssertEqual(result, 10.0 * 72.0 / 25.4, accuracy: 0.01)
    }

    func testConvert_25_4mm_isOneInch() {
        let result = PrinterUnit.convert("25.4mm")
        XCTAssertEqual(result, 72.0, accuracy: 0.01)
    }

    // MARK: - Centimeters

    func testConvert_1cm_convertsToPoints() {
        let result = PrinterUnit.convert("1cm")
        XCTAssertEqual(result, 72.0 / 2.54, accuracy: 0.01)
    }

    func testConvert_2_54cm_isOneInch() {
        let result = PrinterUnit.convert("2.54cm")
        XCTAssertEqual(result, 72.0, accuracy: 0.01)
    }

    // MARK: - Numeric string (no unit = points)

    func testConvert_numericString_treatedAsPoints() {
        XCTAssertEqual(PrinterUnit.convert("100"), 100)
    }

    // MARK: - Zero values

    func testConvert_zeroValues_returnZero() {
        XCTAssertEqual(PrinterUnit.convert("0pt"), 0)
        XCTAssertEqual(PrinterUnit.convert("0in"), 0)
        XCTAssertEqual(PrinterUnit.convert("0mm"), 0)
        XCTAssertEqual(PrinterUnit.convert("0cm"), 0)
    }

    // MARK: - Invalid

    func testConvert_invalidString_returnsZero() {
        XCTAssertEqual(PrinterUnit.convert("abc"), 0)
    }

    func testConvert_invalidUnitString_returnsZero() {
        XCTAssertEqual(PrinterUnit.convert("10foo"), 0)
    }
}
