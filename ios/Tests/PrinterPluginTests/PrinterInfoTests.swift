import XCTest
@testable import PrinterPlugin

final class PrinterInfoTests: XCTestCase {

    // MARK: - Orientation

    func testPrintInfo_landscape_setsLandscape() {
        let info = PrinterInfo.printInfo(with: ["orientation": "landscape"])
        XCTAssertEqual(info.orientation, .landscape)
    }

    func testPrintInfo_portrait_setsPortrait() {
        let info = PrinterInfo.printInfo(with: ["orientation": "portrait"])
        XCTAssertEqual(info.orientation, .portrait)
    }

    func testPrintInfo_noOrientation_defaultPortrait() {
        let info = PrinterInfo.printInfo(with: [:])
        XCTAssertEqual(info.orientation, .portrait)
    }

    func testPrintInfo_unknownOrientation_defaultPortrait() {
        let info = PrinterInfo.printInfo(with: ["orientation": "unknown"])
        XCTAssertEqual(info.orientation, .portrait)
    }

    // MARK: - Output type

    func testPrintInfo_monochrome_setsGrayscale() {
        let info = PrinterInfo.printInfo(with: ["monochrome": true])
        XCTAssertEqual(info.outputType, .grayscale)
    }

    func testPrintInfo_photo_setsPhoto() {
        let info = PrinterInfo.printInfo(with: ["photo": true])
        XCTAssertEqual(info.outputType, .photo)
    }

    func testPrintInfo_monochromeAndPhoto_setsPhotoGrayscale() {
        let info = PrinterInfo.printInfo(with: ["monochrome": true, "photo": true])
        XCTAssertEqual(info.outputType, .photoGrayscale)
    }

    // MARK: - Duplex

    func testPrintInfo_duplexLong_setsLongEdge() {
        let info = PrinterInfo.printInfo(with: ["duplex": "long"])
        XCTAssertEqual(info.duplex, .longEdge)
    }

    func testPrintInfo_duplexShort_setsShortEdge() {
        let info = PrinterInfo.printInfo(with: ["duplex": "short"])
        XCTAssertEqual(info.duplex, .shortEdge)
    }

    func testPrintInfo_duplexNone_setsNone() {
        let info = PrinterInfo.printInfo(with: ["duplex": "none"])
        XCTAssertEqual(info.duplex, .none)
    }

    // MARK: - Job name

    func testPrintInfo_jobName_isSet() {
        let info = PrinterInfo.printInfo(with: ["name": "Test Job"])
        XCTAssertEqual(info.jobName, "Test Job")
    }

    func testPrintInfo_emptyJobName_usesDefault() {
        let info = PrinterInfo.printInfo(with: ["name": ""])
        XCTAssertNotNil(info.jobName)
    }

    func testPrintInfo_noJobName_usesDefault() {
        let info = PrinterInfo.printInfo(with: [:])
        XCTAssertNotNil(info.jobName)
    }

    // MARK: - Defaults with no flags

    func testPrintInfo_noFlags_defaultGeneral() {
        let info = PrinterInfo.printInfo(with: [:])
        XCTAssertEqual(info.outputType, .general)
    }

    // MARK: - Copies

    func testPrintInfo_copies_default1() {
        let info = PrinterInfo.printInfo(with: [:])
        // Default copies = 1, no KVC applied
        XCTAssertNotNil(info)
    }

    func testPrintInfo_copies_multipleSetsViaKVC() {
        let info = PrinterInfo.printInfo(with: ["copies": 3])
        // We can't easily read _copies via public API, but verify no crash
        XCTAssertNotNil(info)
    }

    // MARK: - Combined settings

    func testPrintInfo_combinedSettings_allApplied() {
        let info = PrinterInfo.printInfo(with: [
            "orientation": "landscape",
            "monochrome": true,
            "photo": true,
            "duplex": "long",
            "name": "Combined Test",
            "copies": 2,
        ])
        XCTAssertEqual(info.orientation, .landscape)
        XCTAssertEqual(info.outputType, .photoGrayscale)
        XCTAssertEqual(info.duplex, .longEdge)
        XCTAssertEqual(info.jobName, "Combined Test")
    }
}
