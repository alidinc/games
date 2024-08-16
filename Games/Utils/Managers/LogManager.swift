//
//  LogManager.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import Foundation

// MARK: - Logger
/// MARK: - Logger

/// Provides logging capabilities for debugging purposes.
public enum Logger {
    public static var mediatorLogs: [String] = []
    public static var jurisdictionLogs: [String] = []
    public static var loginLogs: [String] = []

    /// Capture mediator related logs.
    public static func logMediator(_ logs: [String]) {
        logs.forEach { log in
            /// Assuming this is a mediator event
            if log.contains("web:") || log.contains("app:") {
                mediatorLogs.append(log)
            }
        }
    }

    /// Capture jurisdiction related logs.
    public static func logJurisdiction(_ logs: [String]) {
        logs.forEach { log in
            /// Assuming this is a jurisdiction log
            if log.contains("Jurisdiction") {
                jurisdictionLogs.append(log)
            }
        }
    }

    /// Capture login related logs.
    public static func logLogin(_ logs: [String]) {
        logs.forEach { log in
            /// Assuming this is a login log
            if log.contains("Login:") {
                loginLogs.append(log)
            }
        }
    }
}

// MARK: - Log

/// Logs the specified items with the given log type.
///
/// - Parameters:
///   - items: Zero or more items to be logged.
///   - separator: A string to be used as a separator between the items. The default value is a space.
///   - terminator: A string to be used as a terminator after the logged items. The default value is a new line character.
///   - type: The log type indicating the severity or category of the log message.
///
/// - Note: The log message will be printed to the console only when the application runs in debug mode
///
/// - Example:
///   log("Error: 404", type: .error)
///   log("Warning: File not found", type: .warning)
public func log(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    type: LogType
) {
    /// Capture logs and print out statements only if debug mode is enabled, i.e: `Debug`, `QA` configurations.
//    if BuildConfigVariables.debugEnabled.boolValue {
//        /// Capture jurisdiction logs.
//        Logger.logJurisdiction(items.map { "\($0)" })
//        /// Capture mediator event logs.
//        Logger.logMediator(items.map { "\($0)" })
//        /// Capture login logs.
//        Logger.logLogin(items.map { "\($0)" })
//
//        let output = items.map { "\(type.emoji) \($0)" }.joined(separator: separator)
//        let timestamp = DateFormatter.localizedString(from: .now, dateStyle: .none, timeStyle: .medium)
//        Swift.print(timestamp, output, terminator: terminator)
//    }
}


// MARK: - LogType
/// Represents the type or severity level of a log message.
public enum LogType {
    /// Used to log critical errors or exceptions.
    case error
    /// Used to log non-critical issues or warnings that may not cause immediate problems but should be noted.
    case warning
    /// Used to log general information such as important milestones or events.
    case info
    /// Used for debugging purposes.
    case debug

    /// The emoji associated with the log type.
    var emoji: String {
        switch self {
        case .error:
            return "❌ Error:"
        case .warning:
            return "⚠️ Warning:"
        case .info:
            return "ℹ️ Info:"
        case .debug:
            return "🐞 Debug:"
        }
    }
}
