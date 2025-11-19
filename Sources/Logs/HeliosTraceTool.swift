//
//  HeliosTraceTool.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import UIKit

/// Swift eşdeğeri HeliosTraceTool
enum HeliosTraceTool {
    // MARK: - Log with String

    static func log(_ string: String, color: UIColor = .white) {
        finalLog(string, type: .none, color: color)
    }

    // MARK: - Log with JSON Data

    @discardableResult
    static func log(jsonData data: Data?, color: UIColor = .white) -> String {
        guard let data = data else { return "NULL" }
        let string = getPrettyJsonString(from: data) ?? "NULL"
        return finalLog(string, type: .json, color: color)
    }

    // MARK: - Pretty JSON

    static func getPrettyJsonString(from jsonString: String) -> String? {
        getPrettyJsonString(from: jsonString.data(using: .utf8))
    }

    static func getPrettyJsonString(from data: Data?) -> String? {
        guard let data = data else { return nil }

        // 1️⃣ JSON biçimlendirme
        if let object = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8)
        {
            return prettyString
        }

        // 2️⃣ UTF-8 fallback
        return String(data: data, encoding: .utf8)
    }

    // MARK: - Internal Logging

    @discardableResult
    private static func finalLog(_ string: String, type: HeliosTraceToolType, color: UIColor) -> String {
        OCLogHelper.shared.handleLog(file: "XXX",
                                     function: "XXX",
                                     line: 1,
                                     message: string,
                                     color: color,
                                     type: type)
        return string
    }
}
