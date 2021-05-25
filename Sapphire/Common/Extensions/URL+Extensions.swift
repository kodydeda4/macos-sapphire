//
//  URL+Extensions.swift
//  Sapphire
//
//  Created by Kody Deda on 5/25/21.
//

import SwiftUI

extension URL {    
    static var ApplicationSupport: URL {
        let directory =
            FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]
        .appendingPathComponent("KSWIFTSapphire", isDirectory: true)

        if !FileManager.default.fileExists(atPath: directory.path) {
            do {
                try FileManager.default.createDirectory(
                    atPath: directory.path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return directory
    }
    
    
    static var ApplicationScripts: URL {
        try! FileManager.default.url(
            for: .applicationScriptsDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }
    
    //    static var SapphireDirectory: URL {
    //        try! FileManager.default.url(
    //            for: .applicationSupportDirectory,
    //            in: .userDomainMask,
    //            appropriateFor: nil,
    //            create: true
    //        )
    //        .appendingPathComponent("kswift.Sapphire")
    //    }
}
