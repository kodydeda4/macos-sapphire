//
//  AppleScript.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import Foundation

struct AppleScript {

    // Writes argument to an Applescript file & executes it
    static func execute(_ command: String) -> Result<Bool, Error> {
        var url: URL {
            try! FileManager.default.url(
                for: .applicationScriptsDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            .appendingPathComponent("AppleScript")
            .appendingPathExtension(for: .osaScript)
        }
        
        do {
            try command.write(to: url, atomically: true, encoding: .utf8)
            try NSUserScriptTask(url: url).execute()
            return .success(true)
        }
        catch {
            return .failure(error)
        }
    }
}

