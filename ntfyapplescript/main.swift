//
//  main.swift
//  ntfyapplescript
//
//  Created by Jacob on 6/27/25.
//

import Foundation

// Check for script path arg
guard CommandLine.arguments.count > 1 else {
    print("Usage: ntfy-applescript <path-to-applescript>")
    exit(1)
}

let scriptPath = CommandLine.arguments[1]

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
curlProcess.arguments = ["-d", message, "ntfy.sh/ntfyapplescript"]
curlProcess.launch()
curlProcess.waitUntilExit()
