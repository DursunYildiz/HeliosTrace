//
//  Bundle+HeliosTrace.swift
//  HeliosTrace
//
//  Created by Antigravity on 30.01.2026.
//

import Foundation

extension Bundle {
    static var module: Bundle {
        return Bundle(for: HeliosTrace.self)
    }
}
