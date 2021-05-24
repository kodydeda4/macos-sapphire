//
//  AppleScript.swift
//  Sapphire
//
//  Created by Kody Deda on 5/19/21.
//

import Foundation
import Combine

enum AppleScriptError: Error, Equatable {
    case error(String)
    case withError
}

struct AppleScript {    
    let command: String

//    // Writes argument to an Applescript file & executes it
//    func execute() -> Result<Bool, Error> {
//        var url: URL {
//            try! FileManager.default.url(
//                for: .applicationScriptsDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//            )
//            .appendingPathComponent("AppleScript")
//            .appendingPathExtension(for: .osaScript)
//        }
//        
//        do {
//            try command.write(to: url, atomically: true, encoding: .utf8)
//            try NSUserAppleScriptTask(url: url).execute() // completion handler?
//            
//            return .success(true)
//        }
//        catch {
//            return .failure(error)
//        }
//    }
    
    func execute() -> AnyPublisher<Result<Bool, AppleScriptError>, Never> {
        let rv = PassthroughSubject<Result<Bool, AppleScriptError>, Never>()
        
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
                guard let error = error
                else {
                    rv.send(.success(true))
                    return
                }
                rv.send(.failure(AppleScriptError.error(error.localizedDescription)))
            })
        }
        catch {
            rv.send(.failure(AppleScriptError.error(error.localizedDescription)))
        }
        
        return rv.eraseToAnyPublisher()
    }

}

