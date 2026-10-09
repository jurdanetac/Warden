//
//  HostMonitor.swift
//  Warden
//
//  Created by Juan on 9/10/26.
//

import Foundation

func executeProcess(_ binary: String, _ arguments: [String]) -> String {
    let process = Process()
    let pipe = Pipe()
    
    process.standardOutput = pipe
    process.standardError = pipe
    process.launchPath = binary
    process.arguments = arguments
    
    try! process.run()
    let data = try! pipe.fileHandleForReading.readToEnd()
    let output = String(data: data!, encoding: .utf8) ?? ""
    
    return output
}


class HostMonitor {
    let ip: String
    let name: String
    
    init(ip: String, name: String) {
        self.ip = ip
        self.name = name
    }
    
    func ping() {
        let result = executeProcess("/sbin/ping", ["-c 3", ip])
        print(result)
    }
    
    // func wakeOnLAN() {}
}
