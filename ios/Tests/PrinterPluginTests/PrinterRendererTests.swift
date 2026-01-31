import XCTest
@testable import PrinterPlugin

final class PrinterRendererTests: XCTestCase {

    // MARK: - Initialization

    func testInit_withHeaderFooter_setsHeights() {
        let settings: [String: Any] = [
            "header": ["height": "1cm"] as [String: Any],
            "footer": ["height": "0.5cm"] as [String: Any]
        ]

        let formatter = UISimpleTextPrintFormatter(text: "Test content")
        let renderer = PrinterRenderer(dictionary: settings, formatter: formatter)

        // 1cm ~ 28.35pt
        XCTAssertEqual(renderer.headerHeight, 28.346, accuracy: 0.5)
        // 0.5cm ~ 14.17pt
        XCTAssertEqual(renderer.footerHeight, 14.173, accuracy: 0.5)
    }

    func testInit_noHeaderFooter_zeroHeights() {
        let formatter = UISimpleTextPrintFormatter(text: "Test content")
        let renderer = PrinterRenderer(dictionary: [:], formatter: formatter)

        XCTAssertEqual(renderer.headerHeight, 0)
        XCTAssertEqual(renderer.footerHeight, 0)
    }

    // MARK: - Page count

    func testNumberOfPages_noPageCount_returnsActualPages() {
        let formatter = UISimpleTextPrintFormatter(text: "Short text")
        let renderer = PrinterRenderer(dictionary: [:], formatter: formatter)

        let pages = renderer.numberOfPages
        XCTAssertGreaterThanOrEqual(pages, 0)
    }

    // MARK: - Page range caching

    func testNumberOfPages_calledMultipleTimes_stableResult() {
        let formatter = UISimpleTextPrintFormatter(text: "Test")
        let renderer = PrinterRenderer(dictionary: [:], formatter: formatter)

        let first = renderer.numberOfPages
        let second = renderer.numberOfPages
        let third = renderer.numberOfPages

        XCTAssertEqual(first, second)
        XCTAssertEqual(second, third)
    }

    // MARK: - Page count limiting

    func testNumberOfPages_withPageCount_limitsPages() {
        let settings: [String: Any] = ["pageCount": 5]
        let formatter = UISimpleTextPrintFormatter(text: "Test")
        let renderer = PrinterRenderer(dictionary: settings, formatter: formatter)

        let pages = renderer.numberOfPages
        XCTAssertGreaterThanOrEqual(pages, 0)
        XCTAssertLessThanOrEqual(pages, 5)
    }

    // MARK: - Page range settings

    func testNumberOfPages_withPageRange_doesNotCrash() {
        let settings: [String: Any] = [
            "pageRange": ["start": 1, "end": 2] as [String: Any]
        ]
        let formatter = UISimpleTextPrintFormatter(text: "Test")
        let renderer = PrinterRenderer(dictionary: settings, formatter: formatter)

        let pages = renderer.numberOfPages
        XCTAssertGreaterThanOrEqual(pages, 0)
    }

    // MARK: - Formatter is attached

    func testInit_formatterIsAttached() {
        let formatter = UISimpleTextPrintFormatter(text: "Attached")
        let renderer = PrinterRenderer(dictionary: [:], formatter: formatter)

        XCTAssertEqual(renderer.printFormatters?.count, 1)
    }
}
