//
//  Debug.swift
//  Mousemory
//
//  Created by @rezigned on 25/9/2564 BE.
//

import Foundation

func log(_ items: Any...) {
    #if DEBUG
    print(items.map { "\($0)" }.joined(separator: " "))
    #endif
}
