import XCTest
@testable import PrinterPlugin

final class PrinterPaperTests: XCTestCase {

    // MARK: - Named sizes

    func testPaper_A4_hasCorrectSize() {
        let paper = PrinterPaper(dictionary: ["name": "A4"])
        XCTAssertEqual(paper.size.width, 595.28, accuracy: 0.01)
        XCTAssertEqual(paper.size.height, 841.89, accuracy: 0.01)
    }

    func testPaper_a4_caseInsensitive() {
        let paper = PrinterPaper(dictionary: ["name": "a4"])
        XCTAssertEqual(paper.size.width, 595.28, accuracy: 0.01)
    }

    func testPaper_Letter_hasCorrectSize() {
        let paper = PrinterPaper(dictionary: ["name": "LETTER"])
        XCTAssertEqual(paper.size.width, 612, accuracy: 0.01)
        XCTAssertEqual(paper.size.height, 792, accuracy: 0.01)
    }

    func testPaper_A5_hasCorrectSize() {
        let paper = PrinterPaper(dictionary: ["name": "A5"])
        XCTAssertEqual(paper.size.width, 419.53, accuracy: 0.01)
        XCTAssertEqual(paper.size.height, 595.28, accuracy: 0.01)
    }

    func testPaper_Legal_hasCorrectSize() {
        let paper = PrinterPaper(dictionary: ["name": "LEGAL"])
        XCTAssertEqual(paper.size.width, 612, accuracy: 0.01)
        XCTAssertEqual(paper.size.height, 1008, accuracy: 0.01)
    }

    // MARK: - Custom size

    func testPaper_customWidthHeight_inPoints() {
        let paper = PrinterPaper(dictionary: ["width": 200, "height": 300])
        XCTAssertEqual(paper.size.width, 200, accuracy: 0.01)
        XCTAssertEqual(paper.size.height, 300, accuracy: 0.01)
    }

    func testPaper_customWidthHeight_withUnits() {
        // 210mm × 297mm = A4 in points
        let paper = PrinterPaper(dictionary: ["width": "210mm", "height": "297mm"])
        XCTAssertEqual(paper.size.width, 595.28, accuracy: 1.0)
        XCTAssertEqual(paper.size.height, 841.89, accuracy: 1.0)
    }

    // MARK: - Named takes precedence

    func testPaper_namedTakesPrecedenceOverWidthHeight() {
        let paper = PrinterPaper(dictionary: ["name": "A4", "width": 100, "height": 100])
        XCTAssertEqual(paper.size.width, 595.28, accuracy: 0.01)
    }

    // MARK: - Nil / empty

    func testPaper_nilDictionary_zeroSize() {
        let paper = PrinterPaper(dictionary: nil)
        XCTAssertEqual(paper.size.width, 0)
        XCTAssertEqual(paper.size.height, 0)
    }

    func testPaper_emptyDictionary_zeroSize() {
        let paper = PrinterPaper(dictionary: [:])
        XCTAssertEqual(paper.size.width, 0)
        XCTAssertEqual(paper.size.height, 0)
    }

    func testPaper_unknownName_fallsBackToWidthHeight() {
        let paper = PrinterPaper(dictionary: ["name": "UNKNOWN", "width": 100, "height": 200])
        XCTAssertEqual(paper.size.width, 100, accuracy: 0.01)
        XCTAssertEqual(paper.size.height, 200, accuracy: 0.01)
    }

    // MARK: - Cut length

    func testPaper_length_converts() {
        let paper = PrinterPaper(dictionary: ["length": "5cm"])
        XCTAssertGreaterThan(paper.length, 0)
        XCTAssertEqual(Double(paper.length), 5.0 * 72.0 / 2.54, accuracy: 0.01)
    }

    func testPaper_noLength_isZero() {
        let paper = PrinterPaper(dictionary: ["name": "A4"])
        XCTAssertEqual(paper.length, 0)
    }
}
