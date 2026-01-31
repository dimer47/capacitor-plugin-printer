import Foundation
import UIKit

/// Configures the shared UIPrintInteractionController with given settings.
class PrinterControllerHelper {

    static func sharedController(with settings: [String: Any]) -> UIPrintInteractionController {
        let ctrl = UIPrintInteractionController.shared

        // Reset previous state to avoid stale data from prior print jobs
        ctrl.printPageRenderer = nil
        ctrl.printFormatter = nil
        ctrl.printingItem = nil
        ctrl.printingItems = nil

        ctrl.printInfo = PrinterInfo.printInfo(with: settings)

        // Default to showing paper selection so users can pick A4, A5, Letter, etc.
        ctrl.showsPaperSelectionForLoadedPapers = true
        ctrl.showsNumberOfCopies = true

        if let ui = settings["ui"] as? [String: Any] {
            if let hide = ui["hideNumberOfCopies"] as? Bool, hide {
                ctrl.showsNumberOfCopies = false
            }
            if let hide = ui["hidePaperFormat"] as? Bool, hide {
                ctrl.showsPaperSelectionForLoadedPapers = false
            }
        }

        return ctrl
    }
}
