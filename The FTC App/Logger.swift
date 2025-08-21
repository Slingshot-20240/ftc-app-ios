//
//  Logger.swift
//  The FTC App
//
//  Created by Jining Liu on 8/21/25.
//

import Foundation

struct Logger {
    static var count = 0
    
    static func info(_ message: String) {
        print("[FTC APP] [INFO]: \(message)")
    }
    
    static func debug(_ message: String) {
        print("[FTC APP] [DEBUG]: \(message)")
    }
    
    static func warning(_ message: String) {
        print("[FTC APP] [WARNING]: \(message)")
    }
    
    static func error(_ message: String) {
        print("[FTC APP] [ERROR]: \(message)")
    }
    
    static func count(_ start: Int? = nil) {
        if let start {
            Self.count = start
        }
        
        print("[FTC APP] [COUNT]: \(Self.count)")
    }
}
