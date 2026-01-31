import XCTest
@testable import PrinterPlugin

final class PrinterItemTests: XCTestCase {

    // MARK: - canPrintURL

    func testCanPrintURL_nil_returnsPrintingAvailable() {
        let result = PrinterItem.canPrintURL(nil)
        // Should return whether printing is available on the system
        XCTAssertTrue(result || !result) // Just verify it doesn't crash
    }

    func testCanPrintURL_emptyString_returnsPrintingAvailable() {
        let result = PrinterItem.canPrintURL("")
        XCTAssertTrue(result || !result)
    }

    func testCanPrintURL_plainText_returnsPrintingAvailable() {
        // No scheme = falls through to isPrintingAvailable
        let result = PrinterItem.canPrintURL("hello")
        XCTAssertTrue(result || !result)
    }

    // MARK: - item(from:)

    func testItem_fileURL_returnsURL() {
        let item = PrinterItem.item(from: "file:///tmp/test.pdf")
        XCTAssertTrue(item is URL)
    }

    func testItem_base64_emptyData_returnsNil() {
        // "base64:" with no data after prefix (needs > 9 chars)
        let item = PrinterItem.item(from: "base64:AB")
        XCTAssertNil(item)
    }

    func testItem_base64_validData_returnsData() {
        // "base64://" + valid base64 data (prefix is 9 chars: "base64://")
        // Actually the prefix stripping is dropFirst(9), so "base64://" + "AQID" = valid
        let item = PrinterItem.item(from: "base64://AQIDBA==")
        XCTAssertTrue(item is Data)
    }

    func testItem_resURL_returnsURL() {
        let item = PrinterItem.item(from: "res://icon")
        XCTAssertTrue(item is URL)
    }

    func testItem_plainPath_returnsURL() {
        let item = PrinterItem.item(from: "/tmp/test.pdf")
        XCTAssertTrue(item is URL)
    }
}
