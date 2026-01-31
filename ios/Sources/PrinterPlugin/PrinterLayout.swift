import Foundation
import UIKit

/// Configures print formatter layout (margins, max dimensions, font).
class PrinterLayout {

    private var contentInsets: UIEdgeInsets = .zero
    private var maximumContentWidth: CGFloat = 0
    private var maximumContentHeight: CGFloat = 0

    init(dictionary spec: [String: Any]?) {
        guard let spec = spec else { return }

        if let margin = spec["margin"] as? [String: Any] {
            contentInsets = UIEdgeInsets(
                top: CGFloat(PrinterUnit.convert(margin["top"])),
                left: CGFloat(PrinterUnit.convert(margin["left"])),
                bottom: CGFloat(PrinterUnit.convert(margin["bottom"])),
                right: CGFloat(PrinterUnit.convert(margin["right"]))
            )
        }

        maximumContentWidth = CGFloat(PrinterUnit.convert(spec["maxWidth"]))
        maximumContentHeight = CGFloat(PrinterUnit.convert(spec["maxHeight"]))
    }

    /// Configures formatter with layout and optional font settings.
    static func configureFormatter(
        _ formatter: UIPrintFormatter, withSettings settings: [String: Any]
    ) -> UIPrintFormatter {
        let layout = PrinterLayout(dictionary: settings)
        layout.configureFormatter(formatter)

        if let textFormatter = formatter as? UISimpleTextPrintFormatter {
            layout.configureTextFormatter(textFormatter, withSettings: settings)
        }

        return formatter
    }

    func configureFormatter(_ formatter: UIPrintFormatter) {
        if maximumContentHeight > 0 {
            formatter.maximumContentHeight = maximumContentHeight
        }

        if maximumContentWidth > 0 {
            formatter.maximumContentWidth = maximumContentWidth
        }

        formatter.perPageContentInsets = contentInsets
    }

    func configureTextFormatter(
        _ formatter: UISimpleTextPrintFormatter, withSettings settings: [String: Any]
    ) {
        let font = PrinterFont(dictionary: settings["font"] as? [String: Any])
        formatter.font = font.font
        formatter.color = font.color
        formatter.textAlignment = font.alignment
    }
}
