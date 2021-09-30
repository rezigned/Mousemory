//
//  Color.swift
//  Mousemory
//
//  Created by @rezigned on 18/9/2564 BE.
//

import Foundation
import SwiftUI

extension Color: RawRepresentable {
    // colorspace|components
    public init?(rawValue: String) {
        let parts = rawValue.split(separator: "|")
        let space = Color.extractColorSpace(String(parts[0]))
        let comps = parts[1...].map { Double($0)! }

        self = Color(space, red: comps[0], green: comps[1], blue: comps[2], opacity: comps[3])
    }

    // colorspace|components
    public var rawValue: String {
        let color = NSColor(self)
        let v = [
            color.redComponent,
            color.greenComponent,
            color.blueComponent,
            color.alphaComponent
        ]
        .map{ String(format: "%.6f", $0) }
        .joined(separator: "|")

        return "\(color.colorSpace)|\(v)"
    }

    private static func extractColorSpace(_ space: String) -> RGBColorSpace {
        switch space {
        case _ where space.contains("P3"):
            return .displayP3
        default:
            return .sRGB
        }
    }
}
