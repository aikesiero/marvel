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
    case networkError = "[🔴]"
    case networkRequest = "[🔵]"
    case networkResponse = "[🟢]"
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

    class func networkRequest( request: URLRequest) {
        if isLoggingEnabled {
            let url = request.url ?? URL(string: "")
            let urlString = url?.absoluteURL.description

            let bodyString = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
            let method = request.httpMethod ?? ""
            let headers = request.allHTTPHeaderFields ?? [:]

            print("\nLOG \(Date().toString()) \(LogEvent.networkRequest.rawValue) -> Request with:\n\tURL: " +
                    "\(urlString ?? "")\n\tMethod: \(method)\n\tHeaders: \(headers )\n\tBody:\(bodyString)\n")
        }
    }

    class func networkError( _ object: Any,
                             filename: String = #file,
                             line: Int = #line,
                             funcName: String = #function) {
        if isLoggingEnabled {
            print("\nLOG \(Date().toString()) \(LogEvent.networkError.rawValue)" +
                    "[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }

    class func networkResponse( response: HTTPURLResponse, data: Data?, httpCodes: HTTPCodes) {
        if isLoggingEnabled {
            let url = response.url ?? URL(string: "")
            let urlString = url?.absoluteURL.description
            let headers = response.allHeaderFields
            let status = response.statusCode
            let stringResponse = String(decoding: data ?? Data(), as: UTF8.self)

            var logEvent = LogEvent.networkResponse.rawValue

            if !httpCodes.contains(response.statusCode) {
                logEvent = LogEvent.error.rawValue
            }

            print("\nLOG \(Date().toString()) \(logEvent) -> Response with:\n\tURL: \(urlString ?? "")" +
                    "\n\tStatusCode: \(status)\n\tHeaders: \(headers)\n\tResponse: \(stringResponse)\n")
        }
    }

    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
