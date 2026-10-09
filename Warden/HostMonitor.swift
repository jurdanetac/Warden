//
//  HostMonitor.swift
//  Warden
//
//  Created by Juan on 9/10/26.
//

import Foundation

@Observable
class HostMonitor: Identifiable {
    let id: String
    let name: String
    var up: Bool = false
    // var mac: String? = nil

    init(ip: String, name: String) {
        id = ip
        self.name = name
    }

    func wake() {
        print("woke")
        up = true
    }

    private func ping() {
        if _executeProcess("/sbin/ping", ["-c", "3", id]) == 0 {
            up = true
        }
        up = false
    }

    private func _executeProcess(_ binary: String, _ arguments: [String]) -> Int32 {
        let process = Process()
        let pipe = Pipe()

        process.standardOutput = pipe
        process.standardError = pipe
        process.executableURL = URL(fileURLWithPath: binary)
        process.arguments = arguments

        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus
        } catch {
            print("Failed to run ping: \(error)")
            return -1
        }
    }
}
