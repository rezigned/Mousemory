//
//  Screens.swift
//  Mousemory
//
//  Created by @rezigned on 12/9/2564 BE.
//

import Foundation
import AppKit

extension NSScreen {
    static var previous: NSScreen?

    // Returns active display id
    static func activeIdentifier() -> String {
        return String(format: "%@", main?.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! CVarArg)
    }
}
