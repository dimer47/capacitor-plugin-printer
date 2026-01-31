import Foundation
import UIKit

/// Handles font styling and attributes from settings dictionary.
class PrinterFont {

    private let settings: [String: Any]

    init(dictionary: [String: Any]?) {
        self.settings = dictionary ?? [:]
    }

    var attributes: [NSAttributedString.Key: Any] {
        let style = NSMutableParagraphStyle()
        style.alignment = self.alignment

        return [
            .font: self.font,
            .paragraphStyle: style,
            .foregroundColor: self.color,
        ]
    }

    var font: UIFont {
        var size = (settings["size"] as? NSNumber)?.doubleValue ?? 0

        if size <= 0 {
            size = Double(UIFont.smallSystemFontSize)
        }

        var uiFont: UIFont
        if let fontName = settings["name"] as? String,
            let namedFont = UIFont(name: fontName, size: size)
        {
            uiFont = namedFont
        } else {
            uiFont = UIFont.systemFont(ofSize: size)
        }

        var traits: UIFontDescriptor.SymbolicTraits = []

        if settings["bold"] as? Bool == true {
            traits.insert(.traitBold)
        }
        if settings["italic"] as? Bool == true {
            traits.insert(.traitItalic)
        }

        if !traits.isEmpty,
            let descriptor = uiFont.fontDescriptor.withSymbolicTraits(traits)
        {
            uiFont = UIFont(descriptor: descriptor, size: size)
        }

        return uiFont
    }

    var color: UIColor {
        guard let hex = settings["color"] as? String, !hex.isEmpty else {
            return .darkText
        }

        return PrinterFont.color(fromHex: hex) ?? .darkText
    }

    var alignment: NSTextAlignment {
        guard let align = settings["align"] as? String else {
            return .natural
        }

        switch align {
        case "left": return .left
        case "right": return .right
        case "center": return .center
        case "justified": return .justified
        default: return .natural
        }
    }

    // MARK: - Private

    private static func color(fromHex hex: String) -> UIColor? {
        var cleanHex = hex
        if cleanHex.hasPrefix("#") {
            cleanHex = String(cleanHex.dropFirst())
        }

        var rgb: UInt64 = 0
        let scanner = Scanner(string: cleanHex)
        scanner.scanHexInt64(&rgb)

        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
