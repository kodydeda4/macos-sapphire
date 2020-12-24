//
//  Logger.swift
//  MarriottSwiftUI
//
//  Created by Klajd Deda on 7/1/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import SwiftUI

extension Thread {
    static var threadNumbers = [String: String]()
    private static let queue = DispatchQueue(label: "Thread", attributes: .concurrent)

    // return short int from pointer to Thread
    private static func threadNumber(thread: Thread) -> String {
        let threadID = String(format: "%p", thread)
        var threadNumber: String?

        Thread.queue.sync {
            threadNumber = Thread.threadNumbers[threadID]
        }

        if threadNumber == nil {
            threadNumber = String(format: "%04d", Thread.threadNumbers.count + 1)

            Thread.queue.async(flags: .barrier) {
                Thread.threadNumbers[threadID] = threadNumber
            }
        }
        return threadNumber!
    }

    public var threadName: String {
        if isMainThread {
            return "main"
        } else {
            return Thread.threadNumber(thread: self)
        }
    }

    static var dateFormatter: DateFormatter = {
        var rv = DateFormatter()

        rv.locale = Locale.init(identifier: "en_US_POSIX")
        // rv.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        // just give us the short time stamp to the millisecond
        rv.dateFormat = "HH:mm:ss.SSS"
        return rv
    }()

    static var logHeader: String {
        return "\(dateFormatter.string(from: Date())) [TH: \(Thread.current.threadName)]"
    }

    static func logHeader(file: String = "", function: String = "", line: Int = -1) -> String {
        guard !file.isEmpty, line > 0 else { return logHeader }

        let fileName: String = {
            let app = Bundle.main.executableURL?.lastPathComponent ?? "Unknown"
            if let index = file.range(of: app)?.upperBound {
                return ".." + String(file[index..<file.endIndex])
            }
            return file
        }()

        return "\(logHeader) \(fileName):\(line) \(function)() "
    }
}

func iddlog(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) -> Void {
    let output = items.map { "\($0)" }.joined(separator: "")
    print(Thread.logHeader(file: file, function: function, line: line), "\(output)")
}

extension View {
    // https://stackoverflow.com/questions/56517813/how-to-print-to-xcode-console-in-swiftui
    func debugPrint(_ value: Any) -> some View {
        print(value)
        return self
    }
}
