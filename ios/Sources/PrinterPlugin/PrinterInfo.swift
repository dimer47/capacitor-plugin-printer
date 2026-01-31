import Foundation
import UIKit

/// Converts settings dictionary to UIPrintInfo.
class PrinterInfo {

    static func printInfo(with spec: [String: Any]) -> UIPrintInfo {
        let info = UIPrintInfo(dictionary: nil)
        let duplex = spec["duplex"] as? String
        let jobName = spec["name"] as? String
        let copies = max((spec["copies"] as? Int) ?? 1, 1)

        // Orientation
        if let orientation = spec["orientation"] as? String {
            switch orientation {
            case "landscape":
                info.orientation = .landscape
            case "portrait":
                info.orientation = .portrait
            default:
                break
            }
        }

        // Output type
        let monochrome = spec["monochrome"] as? Bool ?? false
        let photo = spec["photo"] as? Bool ?? false

        if monochrome {
            info.outputType = photo ? .photoGrayscale : .grayscale
        } else if photo {
            info.outputType = .photo
        }

        // Duplex
        if let duplex = duplex {
            switch duplex {
            case "long":
                info.duplex = .longEdge
            case "short":
                info.duplex = .shortEdge
            case "none":
                info.duplex = .none
            default:
                break
            }
        }

        // Copies (using private API via KVC, same as original plugin)
        if copies > 1 {
            info.setValue(NSNumber(value: copies), forKey: "_copies")
        }

        // Job name
        if let jobName = jobName, !jobName.isEmpty {
            info.jobName = jobName
        }

        return info
    }
}
