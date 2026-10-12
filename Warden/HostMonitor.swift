//
//  HostMonitor.swift
//  Warden
//
//  Created by Juan on 9/10/26.
//

import Foundation

class HostMonitor: Identifiable {
    let ipAddress: String

    var macAddress: String?
    let name: String?

    var up: Bool = false
    var isMonitoring: Bool = false

    private var monitoringTask: Task<Void, Error>?

    init(at ip: String, alias name: String) {
        ipAddress = ip
        self.name = name
    }

    deinit {
        monitoringTask?.cancel()
    }

    func wake() {
//        guard let mac else { return false }
//        Task {
//            try! await executeProcess("/opt/homebrew/bin/wakeonlan", [mac])
//        }
//        return true
        print("wakeonlan \(ipAddress)")
    }

    func startMonitoring() {
        stopMonitoring()
        isMonitoring = true

        monitoringTask = Task {
            while !Task.isCancelled {
                ping()
                try await Task.sleep(for: .seconds(5))
            }

            isMonitoring = false
        }
    }

    func stopMonitoring() {
        monitoringTask?.cancel()
        monitoringTask = nil
        isMonitoring = false
    }

    private func ping() {
//        do {
//            let status = try await executeProcess("/sbin/ping", ["-c", "3", id])
//            up = (status == 0)
//        } catch {
//            up = false
//        }
        print("ping \(ipAddress)")
    }

    private nonisolated func executeProcess(_ binary: String, _ arguments: [String]) async throws -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: binary)
        process.arguments = arguments

        return try await withCheckedThrowingContinuation { continuation in
            do {
                try process.run()
                process.terminationHandler = { proc in
                    continuation.resume(returning: proc.terminationStatus)
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
