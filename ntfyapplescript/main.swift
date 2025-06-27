//
//  main.swift
//  ntfyapplescript
//
//  Created by Jacob on 6/27/25.
//

import Foundation

// Check for script path and topic args
guard CommandLine.arguments.count > 2 else {
    print("Usage: ntfy-applescript <path-to-applescript> <ntfy-topic>")
    exit(1)
}

let scriptPath = CommandLine.arguments[1]
let topic = CommandLine.arguments[2]

// Run the AppleScript
let process = Process()
process.launchPath = "/usr/bin/osascript"
process.arguments = [scriptPath]

let pipe = Pipe()
process.standardOutput = pipe
process.standardError = pipe

process.launch()
process.waitUntilExit()

let data = pipe.fileHandleForReading.readDataToEndOfFile()
if let output = String(data: data, encoding: .utf8) {
    print(output)
}

// Send notification via ntfy.sh & extract path
let scriptName = URL(fileURLWithPath: scriptPath).lastPathComponent
let message = "Run of \(scriptName) successful 😀"
let curlProcess = Process()
curlProcess.launchPath = "/usr/bin/curl"
curlProcess.arguments = ["-d", message, "ntfy.sh/\(topic)"]
curlProcess.launch()
curlProcess.waitUntilExit()
