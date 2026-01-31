import Foundation
import UIKit

/// Handles paper size selection for print jobs.
class PrinterPaper {

    let size: CGSize
    let length: CGFloat

    init(dictionary spec: [String: Any]?) {
        let spec = spec ?? [:]
        self.size = CGSize(
            width: CGFloat(PrinterUnit.convert(spec["width"])),
            height: CGFloat(PrinterUnit.convert(spec["height"]))
        )
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
