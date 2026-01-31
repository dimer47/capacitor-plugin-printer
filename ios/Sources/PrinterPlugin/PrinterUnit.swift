import Foundation

/// Converts various unit values (in, mm, cm, pt, numbers) to iOS points.
class PrinterUnit {

    /// Converts any unit value to points.
    /// Supports: numbers, "Xpt", "Xin", "Xmm", "Xcm", or numeric strings.
    static func convert(_ unit: Any?) -> Double {
        guard let unit = unit, !(unit is NSNull) else {
            return 0
        }

        if let number = unit as? NSNumber {
            return number.doubleValue
        }

        if let number = unit as? Int {
            return Double(number)
        }

        if let number = unit as? Double {
            return number
        }

        guard let str = unit as? String, !str.isEmpty else {
            return 0
        }

        if str.hasSuffix("pt") {
            let value = String(str.dropLast(2))
            return Double(value) ?? 0
        } else if str.hasSuffix("in") {
            let value = String(str.dropLast(2))
            return (Double(value) ?? 0) * 72.0
        } else if str.hasSuffix("mm") {
            let value = String(str.dropLast(2))
            return (Double(value) ?? 0) * 72.0 / 25.4
        } else if str.hasSuffix("cm") {
            let value = String(str.dropLast(2))
            return (Double(value) ?? 0) * 72.0 / 2.54
        }

        return Double(str) ?? 0
    }
}
