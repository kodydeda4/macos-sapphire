//
//  AppleScript.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import Foundation
import Combine

enum NSUserAppleScriptTaskError: Error, Equatable {
    case execute
}

extension NSUserAppleScriptTask {
    
    /// Writes command to ~/ApplicationScripts/`AppName`/Applescript.osa file & executes it
    func execute(_ command: String) -> AnyPublisher<Result<Bool, NSUserAppleScriptTaskError>, Never> {
        let rv = PassthroughSubject<Result<Bool, NSUserAppleScriptTaskError>, Never>()
        let command = "do shell script \"\(command)\" with administrator privileges"

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
            try NSUserAppleScriptTask(url: url).execute(completionHandler: { error in
                guard error != nil
                else {
                    rv.send(.success(true))
                    return
                }
                rv.send(.failure(.execute))
            })
        }
        catch {
            rv.send(.failure(.execute))
        }
        
        return rv.eraseToAnyPublisher()
    }
}

