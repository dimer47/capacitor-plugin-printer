import Foundation
import Capacitor
import UIKit

@objc(PrinterPlugin)
public class PrinterPlugin: CAPPlugin, CAPBridgedPlugin, UIPrintInteractionControllerDelegate {
    public let identifier = "PrinterPlugin"
    public let jsName = "Printer"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "print", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "printHtml", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "printPdf", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "printBase64", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "printFile", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "printWebView", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "canPrintItem", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getPrintableTypes", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "pick", returnType: CAPPluginReturnPromise),
    ]

    private var previousPrinter: UIPrinter?
    private var currentSettings: [String: Any] = [:]

    // MARK: - Plugin Methods

    @objc func canPrintItem(_ call: CAPPluginCall) {
        let uri = call.getString("uri")

        DispatchQueue.main.async {
            let available = PrinterItem.canPrintURL(uri)
            call.resolve(["available": available])
        }
    }

    @objc func getPrintableTypes(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let utis = UIPrintInteractionController.printableUTIs
            let typesArray = utis.map { $0 as String }
            call.resolve(["types": typesArray])
        }
    }

    @objc func pick(_ call: CAPPluginCall) {
        let uiOptions = call.getObject("ui") ?? [:]

        DispatchQueue.main.async {
            let controller = UIPrinterPickerController(initiallySelectedPrinter: nil)

            let handler: UIPrinterPickerController.CompletionHandler = { [weak self] pickerController, selected, error in
                guard let self = self else { return }

                if let printer = pickerController.selectedPrinter {
                    self.rememberPrinter(printer)
                    call.resolve(["url": printer.url.absoluteString])
                } else {
                    call.resolve([:])
                }
            }

            if UIDevice.current.userInterfaceIdiom == .pad {
                let rect = self.rectFromDictionary(uiOptions)
                if let webView = self.bridge?.webView {
                    controller.present(from: rect, in: webView, animated: true, completionHandler: handler)
                } else {
                    controller.present(animated: true, completionHandler: handler)
                }
            } else {
                controller.present(animated: true, completionHandler: handler)
            }
        }
    }

    @objc func print(_ call: CAPPluginCall) {
        let content = call.getString("content")
        let settings = self.extractSettings(from: call)

        DispatchQueue.global(qos: .userInitiated).async {
            self.printContent(content, withSettings: settings, call: call)
        }
    }

    @objc func printHtml(_ call: CAPPluginCall) {
        guard let html = call.getString("html") else {
            call.reject("The 'html' parameter is required")
            return
        }
        let settings = self.extractSettings(from: call)

        DispatchQueue.global(qos: .userInitiated).async {
            self.printContent(html, withSettings: settings, call: call)
        }
    }

    @objc func printPdf(_ call: CAPPluginCall) {
        guard let path = call.getString("path") else {
            call.reject("The 'path' parameter is required")
            return
        }
        let settings = self.extractSettings(from: call)

        DispatchQueue.global(qos: .userInitiated).async {
            self.printContent(path, withSettings: settings, call: call)
        }
    }

    @objc func printBase64(_ call: CAPPluginCall) {
        guard let data = call.getString("data") else {
            call.reject("The 'data' parameter is required")
            return
        }
        guard call.getString("mimeType") != nil else {
            call.reject("The 'mimeType' parameter is required")
            return
        }
        let content = "base64:" + data
        let settings = self.extractSettings(from: call)

        DispatchQueue.global(qos: .userInitiated).async {
            self.printContent(content, withSettings: settings, call: call)
        }
    }

    @objc func printFile(_ call: CAPPluginCall) {
        guard let path = call.getString("path") else {
            call.reject("The 'path' parameter is required")
            return
        }
        let settings = self.extractSettings(from: call)

        DispatchQueue.global(qos: .userInitiated).async {
            self.printContent(path, withSettings: settings, call: call)
        }
    }

    @objc func printWebView(_ call: CAPPluginCall) {
        let settings = self.extractSettings(from: call)

        DispatchQueue.global(qos: .userInitiated).async {
            self.printContent(nil, withSettings: settings, call: call)
        }
    }

    // MARK: - UIPrintInteractionControllerDelegate

    public func printInteractionController(
        _ printInteractionController: UIPrintInteractionController,
        choosePaper paperList: [UIPrintPaper]
    ) -> UIPrintPaper {
        if let paperSpec = currentSettings["paper"] as? [String: Any] {
            let paper = PrinterPaper(dictionary: paperSpec)
            if let bestPaper = paper.bestPaper(from: paperList) {
                return bestPaper
            }
        }
        return paperList.first ?? UIPrintPaper.bestPaper(forPageSize: CGSize(width: 612, height: 792), withPapersFrom: paperList)
    }

    public func printInteractionController(
        _ printInteractionController: UIPrintInteractionController,
        cutLengthFor paper: UIPrintPaper
    ) -> CGFloat {
        if let paperSpec = currentSettings["paper"] as? [String: Any] {
            let paperObj = PrinterPaper(dictionary: paperSpec)
            if paperObj.length > 0 {
                return paperObj.length
            }
        }
        return paper.paperSize.height
    }

    // MARK: - Core Printing

    private func printContent(_ content: String?, withSettings settings: [String: Any], call: CAPPluginCall) {
        var item: Any?
        var ctrl: UIPrintInteractionController!

        DispatchQueue.main.sync {
            ctrl = PrinterControllerHelper.sharedController(with: settings)
            ctrl.delegate = self
            self.currentSettings = settings
        }

        if content == nil || content?.isEmpty == true {
            DispatchQueue.main.sync {
                if let webView = self.bridge?.webView {
                    item = webView.viewPrintFormatter()
                }
            }
        } else if let content = content, content.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("<") {
            DispatchQueue.main.sync {
                item = UIMarkupTextPrintFormatter(markupText: content)
            }
        } else if let content = content, URL(string: content)?.scheme != nil {
            item = PrinterItem.item(from: content)
        } else if let content = content {
            DispatchQueue.main.sync {
                item = UISimpleTextPrintFormatter(text: content)
            }
        }

        self.useController(ctrl, toPrintItem: item, withSettings: settings, call: call)
    }

    private func useController(
        _ ctrl: UIPrintInteractionController,
        toPrintItem item: Any?,
        withSettings settings: [String: Any],
        call: CAPPluginCall
    ) {
        let printerURL = settings["printer"] as? String

        if let formatter = item as? UIPrintFormatter {
            ctrl.printPageRenderer = PrinterRenderer(dictionary: settings, formatter: formatter)
        } else {
            ctrl.printingItem = item
        }

        if let printerURL = printerURL, !printerURL.isEmpty {
            self.printToPrinter(ctrl, withSettings: settings, call: call)
        } else {
            self.presentController(ctrl, withSettings: settings, call: call)
        }
    }

    private func printToPrinter(
        _ ctrl: UIPrintInteractionController,
        withSettings settings: [String: Any],
        call: CAPPluginCall
    ) {
        let printerURLString = settings["printer"] as? String ?? ""
        guard let printer = self.printer(withURL: printerURLString) else {
            self.presentController(ctrl, withSettings: settings, call: call)
            return
        }

        DispatchQueue.main.async {
            ctrl.print(to: printer) { [weak self] _, completed, _ in
                self?.rememberPrinter(completed ? printer : nil)
                call.resolve(["success": completed])
            }
        }
    }

    private func presentController(
        _ ctrl: UIPrintInteractionController,
        withSettings settings: [String: Any],
        call: CAPPluginCall
    ) {
        let uiOptions = settings["ui"] as? [String: Any] ?? [:]
        let rect = self.rectFromDictionary(uiOptions)

        let handler: UIPrintInteractionController.CompletionHandler = { _, completed, _ in
            call.resolve(["success": completed])
        }

        DispatchQueue.main.async {
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let webView = self.bridge?.webView {
                    ctrl.present(from: rect, in: webView, animated: true, completionHandler: handler)
                } else {
                    ctrl.present(animated: true, completionHandler: handler)
                }
            } else {
                ctrl.present(animated: true, completionHandler: handler)
            }
        }
    }

    // MARK: - Helpers

    private func extractSettings(from call: CAPPluginCall) -> [String: Any] {
        var settings: [String: Any] = [:]

        if let name = call.getString("name") { settings["name"] = name }
        if let orientation = call.getString("orientation") { settings["orientation"] = orientation }
        if let duplex = call.getString("duplex") { settings["duplex"] = duplex }
        if let printer = call.getString("printer") { settings["printer"] = printer }
        if let maxWidth = call.getString("maxWidth") ?? (call.getInt("maxWidth").map { String($0) }) { settings["maxWidth"] = maxWidth }
        if let maxHeight = call.getString("maxHeight") ?? (call.getInt("maxHeight").map { String($0) }) { settings["maxHeight"] = maxHeight }

        settings["monochrome"] = call.getBool("monochrome") ?? false
        settings["photo"] = call.getBool("photo") ?? false
        settings["copies"] = call.getInt("copies") ?? 1

        if let pageCount = call.getInt("pageCount") { settings["pageCount"] = pageCount }

        if let margin = call.getObject("margin") {
            settings["margin"] = margin
        } else if let marginBool = call.getBool("margin") {
            if !marginBool {
                settings["margin"] = false
            }
        }

        if let font = call.getObject("font") { settings["font"] = font }
        if let header = call.getObject("header") { settings["header"] = header }
        if let footer = call.getObject("footer") { settings["footer"] = footer }
        if let paper = call.getObject("paper") { settings["paper"] = paper }
        if let ui = call.getObject("ui") { settings["ui"] = ui }

        return settings
    }

    private func rememberPrinter(_ printer: UIPrinter?) {
        previousPrinter = printer
        if let printer = printer {
            _ = UIPrinterPickerController(initiallySelectedPrinter: printer)
        }
    }

    private func printer(withURL urlString: String) -> UIPrinter? {
        if let prev = previousPrinter, prev.url.absoluteString == urlString {
            return prev
        }
        guard let url = URL(string: urlString) else { return nil }
        return UIPrinter(url: url)
    }

    private func rectFromDictionary(_ pos: [String: Any]) -> CGRect {
        let left = (pos["left"] as? NSNumber)?.doubleValue ?? 40.0
        let top = (pos["top"] as? NSNumber)?.doubleValue ?? 30.0
        let width = (pos["width"] as? NSNumber)?.doubleValue ?? 0.0
        let height = (pos["height"] as? NSNumber)?.doubleValue ?? 0.0

        return CGRect(x: left, y: top, width: width, height: height)
    }
}
