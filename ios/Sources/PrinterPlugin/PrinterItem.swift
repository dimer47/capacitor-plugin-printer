import Foundation
import UIKit

/// Handles converting URLs/paths into printable items (NSURL or NSData).
class PrinterItem {

    /// Returns the printing item referred by URL, either as URL or Data.
    static func item(from urlString: String) -> Any? {
        return PrinterItem().itemFromURL(urlString)
    }

    /// Returns whether the print framework can render the referenced file.
    static func canPrintURL(_ url: String?) -> Bool {
        guard let url = url, !(url as NSString).isEqual(to: NSNull().description), !url.isEmpty else {
            return UIPrintInteractionController.isPrintingAvailable
        }

        guard URL(string: url)?.scheme != nil else {
            return UIPrintInteractionController.isPrintingAvailable
        }

        let item = PrinterItem().itemFromURL(url)

        if let data = item as? Data {
            return UIPrintInteractionController.canPrint(data)
        } else if let fileURL = item as? URL {
            return UIPrintInteractionController.canPrint(fileURL)
        }

        return false
    }

    // MARK: - Private

    private func itemFromURL(_ path: String) -> Any? {
        if path.hasPrefix("file:///") {
            return urlForFile(path)
        } else if path.hasPrefix("res:") {
            return urlForResource(path)
        } else if path.hasPrefix("file://") {
            return urlForAsset(path)
        } else if path.hasPrefix("base64:") {
            return dataFromBase64(path)
        }

        let fm = FileManager.default
        if !fm.fileExists(atPath: path) {
            NSLog("[capacitor-plugin-printer] File not found: %@", path)
        }

        return URL(fileURLWithPath: path)
    }

    private func urlForFile(_ path: String) -> URL {
        let absPath = String(path.dropFirst(7))
        let fm = FileManager.default

        if !fm.fileExists(atPath: absPath) {
            NSLog("[capacitor-plugin-printer] File not found: %@", absPath)
        }

        return URL(fileURLWithPath: absPath)
    }

    private func urlForResource(_ path: String) -> URL {
        let fm = FileManager.default
        let bundlePath = Bundle.main.resourcePath ?? ""
        var adjustedPath = path

        if path == "res://icon" {
            if UIDevice.current.userInterfaceIdiom == .pad {
                adjustedPath = "res://AppIcon76x76@2x~ipad.png"
            } else {
                adjustedPath = "res://AppIcon60x60@2x.png"
            }
        }

        let absPath = bundlePath + adjustedPath.replacingOccurrences(of: "res:/", with: "")

        if !fm.fileExists(atPath: absPath) {
            NSLog("[capacitor-plugin-printer] File not found: %@", absPath)
        }

        return URL(fileURLWithPath: absPath)
    }

    private func urlForAsset(_ path: String) -> URL {
        let fm = FileManager.default
        let bundlePath = Bundle.main.bundlePath
        let absPath = bundlePath + "/public" + String(path.dropFirst(6))

        if !fm.fileExists(atPath: absPath) {
            NSLog("[capacitor-plugin-printer] File not found: %@", absPath)
        }

        return URL(fileURLWithPath: absPath)
    }

    private func dataFromBase64(_ url: String) -> Data? {
        guard url.count > 9 else { return nil }
        let base64String = String(url.dropFirst(9))
        return Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)
    }
}
