import Foundation
import UIKit

/// Configures the shared UIPrintInteractionController with given settings.
class PrinterControllerHelper {

    static func sharedController(with settings: [String: Any]) -> UIPrintInteractionController {
        let ctrl = UIPrintInteractionController.shared

        ctrl.printInfo = PrinterInfo.printInfo(with: settings)

        if let ui = settings["ui"] as? [String: Any] {
            ctrl.showsNumberOfCopies = !(ui["hideNumberOfCopies"] as? Bool ?? false)
            ctrl.showsPaperSelectionForLoadedPapers = !(ui["hidePaperFormat"] as? Bool ?? false)
        }

        return ctrl
    }
}
