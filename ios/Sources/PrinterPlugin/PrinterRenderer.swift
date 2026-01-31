import Foundation
import UIKit

/// Custom page renderer supporting headers, footers, and page count control.
class PrinterRenderer: UIPrintPageRenderer {

    private let settings: [String: Any]

    init(dictionary spec: [String: Any], formatter: UIPrintFormatter) {
        self.settings = spec

        super.init()

        let _ = PrinterLayout.configureFormatter(formatter, withSettings: spec)
        self.addPrintFormatter(formatter, startingAtPageAt: 0)

        if let header = spec["header"] as? [String: Any] {
            self.headerHeight = CGFloat(PrinterUnit.convert(header["height"]))
        }

        if let footer = spec["footer"] as? [String: Any] {
            self.footerHeight = CGFloat(PrinterUnit.convert(footer["height"]))
        }
    }

    override var numberOfPages: Int {
        let num = super.numberOfPages
        let maxPages = settings["pageCount"]

        if let maxPagesInt = maxPages as? Int {
            if maxPagesInt < 0 {
                return max(1, num + maxPagesInt)
            }
            return maxPagesInt > 0 ? max(1, min(num, maxPagesInt)) : num
        }

        return num
    }

    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
        if let header = settings["header"] as? [String: Any] {
            drawLabels(from: header, forPageAt: pageIndex, in: headerRect)
        }
    }

    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
        if let footer = settings["footer"] as? [String: Any] {
            drawLabels(from: footer, forPageAt: pageIndex, in: footerRect)
        }
    }

    // MARK: - Private

    private func drawLabels(from spec: [String: Any], forPageAt index: Int, in rect: CGRect) {
        var labels: [[String: Any]]?

        if let label = spec["label"] as? [String: Any] {
            labels = [label]
        } else if let specLabels = spec["labels"] as? [[String: Any]] {
            labels = specLabels
        } else if let text = spec["text"] as? String, !text.isEmpty {
            labels = [["text": text]]
        }

        guard let labelsList = labels else { return }

        for label in labelsList {
            drawLabel(from: label, forPageAt: index, in: rect)
        }
    }

    private func drawLabel(from spec: [String: Any], forPageAt index: Int, in rect: CGRect) {
        var label = spec["text"] as? String
        let showIndex = spec["showPageIndex"] as? Bool ?? false

        if showIndex {
            let format: String
            if let existingLabel = label, !existingLabel.isEmpty {
                format = existingLabel
            } else {
                format = "%ld"
            }
            label = String(format: format, index + 1)
        }

        guard let labelText = label, !labelText.isEmpty else { return }

        let font = PrinterFont(dictionary: spec["font"] as? [String: Any])
        let attributes = font.attributes

        let hasPosition =
            spec["top"] != nil || spec["left"] != nil || spec["right"] != nil || spec["bottom"] != nil

        if hasPosition {
            let point = pointFromPosition(spec, forLabel: labelText, withAttributes: attributes, in: rect)
            labelText.draw(at: point, withAttributes: attributes)
        } else {
            labelText.draw(in: rect, withAttributes: attributes)
        }
    }

    private func pointFromPosition(
        _ spec: [String: Any],
        forLabel label: String,
        withAttributes attributes: [NSAttributedString.Key: Any],
        in rect: CGRect
    ) -> CGPoint {
        let top = spec["top"]
        let left = spec["left"]
        let right = spec["right"]
        let bottom = spec["bottom"]

        var x = rect.origin.x
        var y = rect.origin.y

        var size: CGSize = .zero
        if bottom != nil || right != nil {
            size = label.size(withAttributes: attributes)
        }

        if let top = top {
            y = rect.origin.y + CGFloat(PrinterUnit.convert(top))
        } else if let bottom = bottom {
            y = rect.origin.y + rect.size.height - size.height - CGFloat(PrinterUnit.convert(bottom))
        }

        if let left = left {
            x = rect.origin.x + CGFloat(PrinterUnit.convert(left))
        } else if let right = right {
            x = rect.origin.x + rect.size.width - size.width - CGFloat(PrinterUnit.convert(right))
        }

        return CGPoint(x: x, y: y)
    }
}
