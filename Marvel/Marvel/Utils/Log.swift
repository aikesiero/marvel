//
//  Log.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 24/11/21.
//

import Foundation

enum LogEvent: String {
    case error = "[❌]"
    case debug = "[ℹ️]"
}

func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

class Log {

    static var dateFormat = "yyyy-MM-dd hh:mm:ss"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }

    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    class func error( _ object: Any,
                      filename: String = #file,
                      line: Int = #line,
                      funcName: String = #function) {
        if isLoggingEnabled {
            print("LOG \(Date().toString()) \(LogEvent.error.rawValue)" +
                    "[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }

    class func debug( _ object: Any,
                      filename: String = #file,
                      line: Int = #line,
                      funcName: String = #function) {
        if isLoggingEnabled {
            print("LOG \(Date().toString()) \(LogEvent.debug.rawValue)" +
                    "[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }

    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
