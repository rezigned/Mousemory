//
//  About.swift
//  Mousemory
//
//  Created by @rezigned on 24/9/2564 BE.
//

import Foundation

struct About {
    struct Link {
        let id = UUID()
        let title: String
        let url: URL
    }

    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    let links = [
        Link(title: "@rezigned", url: URL(string: "https://twitter.com/rezigned")!),
        Link(title: "github", url: URL(string: "https://github.com/rezigned/Mousemory")!),
        Link(title: "Buy me a coffee", url: URL(string: "https://www.buymeacoffee.com/rezigned")!),
    ]
}
