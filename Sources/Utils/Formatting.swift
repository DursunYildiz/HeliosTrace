//
//  Formatting.swift
//  HeliosTrace
//
//  Restored pretty-print helpers for previews and runtime.
//

import Foundation

public func prettyPrintedString(from object: Any) -> String {
    if JSONSerialization.isValidJSONObject(object),
       let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
       let pretty = String(data: data, encoding: .utf8)
    {
        return pretty
    }
    if let array = object as? [Any] {
        if array.isEmpty { return "[]" }
        return array.map { "- \(prettyPrintedString(from: $0))" }.joined(separator: "\n")
    }
    if let dict = object as? [String: Any] {
        if dict.isEmpty { return "{}" }
        let lines = dict.keys.sorted().map { key in
            let value = dict[key] ?? "nil"
            return "\(key): \(prettyPrintedString(from: value))"
        }
        return lines.joined(separator: "\n")
    }
    if let anyKeyDict = object as? [AnyHashable: Any] {
        if anyKeyDict.isEmpty { return "{}" }
        let mapped = Dictionary(uniqueKeysWithValues: anyKeyDict.map { (String(describing: $0.key), $0.value) })
        return prettyPrintedString(from: mapped)
    }
    return String(describing: object)
}

public extension Data {
    func dataToPrettyPrintString() -> String? {
        if let obj = try? JSONSerialization.jsonObject(with: self, options: []),
           let data = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted]),
           let pretty = String(data: data, encoding: .utf8)
        {
            return pretty
        }
        return String(data: self, encoding: .utf8)
    }
}
