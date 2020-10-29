//
//  Utils.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Foundation

class Log {
    private enum LogEvent: String {
        case i = "[ℹ️]" // info
        case d = "[💬]" // debug
        case w = "[⚠️]" // warning
        case e = "[‼️]" // error
    }
    
    private static var dateFormat = "yyyy-MM-dd hh:mm:ss"
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private static var logDate: String {
        return dateFormatter.string(from: Date())
    }
    
    private class func logInfo(file: String, function: String, line: Int) -> String {
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        return "[\(fileName)] \(funcName)(\(line)):"
    }
    
    class func i(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let info = logInfo(file: file, function: function, line: line)
        print("\(logDate) \(LogEvent.i.rawValue) \(info) \(msg)")
        #endif
    }
    
    class func d(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let info = logInfo(file: file, function: function, line: line)
        print("\(logDate) \(LogEvent.d.rawValue) \(info) \(msg)")
        #endif
    }
    
    class func w(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let info = logInfo(file: file, function: function, line: line)
        print("\(logDate) \(LogEvent.w.rawValue) \(info) \(msg)")
        #endif
    }
    
    class func e(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let info = logInfo(file: file, function: function, line: line)
        print("\(logDate) \(LogEvent.e.rawValue) \(info) \(msg)")
        #endif
    }
}

