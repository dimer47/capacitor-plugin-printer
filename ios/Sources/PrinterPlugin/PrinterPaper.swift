import Foundation
import UIKit

/// Handles paper size selection for print jobs.
/// Supports both named sizes (A4, A5, Letter, etc.) and custom width/height.
class PrinterPaper {

    let size: CGSize
    let length: CGFloat

    /// Common paper sizes in points (72 points = 1 inch).
    private static let namedSizes: [String: CGSize] = [
        // ISO A series
        "A0": CGSize(width: 2383.94, height: 3370.39),
        "A1": CGSize(width: 1683.78, height: 2383.94),
        "A2": CGSize(width: 1190.55, height: 1683.78),
        "A3": CGSize(width: 841.89, height: 1190.55),
        "A4": CGSize(width: 595.28, height: 841.89),
        "A5": CGSize(width: 419.53, height: 595.28),
        "A6": CGSize(width: 297.64, height: 419.53),
        "A7": CGSize(width: 209.76, height: 297.64),
        "A8": CGSize(width: 147.40, height: 209.76),
        "A9": CGSize(width: 104.88, height: 147.40),
        "A10": CGSize(width: 73.70, height: 104.88),
        // ISO B series
        "B0": CGSize(width: 2834.65, height: 4008.19),
        "B1": CGSize(width: 2004.09, height: 2834.65),
        "B2": CGSize(width: 1417.32, height: 2004.09),
        "B3": CGSize(width: 1000.63, height: 1417.32),
        "B4": CGSize(width: 708.66, height: 1000.63),
        "B5": CGSize(width: 498.90, height: 708.66),
        "B6": CGSize(width: 354.33, height: 498.90),
        // North America
        "LETTER": CGSize(width: 612, height: 792),
        "LEGAL": CGSize(width: 612, height: 1008),
        "TABLOID": CGSize(width: 792, height: 1224),
        "LEDGER": CGSize(width: 1224, height: 792),
        "JUNIOR_LEGAL": CGSize(width: 576, height: 360),
        "GOVT_LETTER": CGSize(width: 576, height: 756),
        // Photo sizes
        "4X6": CGSize(width: 288, height: 432),
        "5X7": CGSize(width: 360, height: 504),
        "8X10": CGSize(width: 576, height: 720),
        // JIS
        "JIS_B4": CGSize(width: 728.50, height: 1031.81),
        "JIS_B5": CGSize(width: 515.91, height: 728.50),
    ]

    init(dictionary spec: [String: Any]?) {
        let spec = spec ?? [:]
        let name = (spec["name"] as? String)?.uppercased() ?? ""

        if !name.isEmpty, let namedSize = PrinterPaper.namedSizes[name] {
            self.size = namedSize
        } else {
            self.size = CGSize(
                width: CGFloat(PrinterUnit.convert(spec["width"])),
                height: CGFloat(PrinterUnit.convert(spec["height"]))
            )
        }
        self.length = CGFloat(PrinterUnit.convert(spec["length"]))
    }

    /// Finds the best matching paper from available paper list.
    func bestPaper(from list: [UIPrintPaper]) -> UIPrintPaper? {
        if size.height > 0 || size.width > 0 {
            return UIPrintPaper.bestPaper(forPageSize: size, withPapersFrom: list)
        }
        return nil
    }
}
