//
//  HostMonitor.swift
//  Warden
//
//  Created by Juan on 9/10/26.
//

import Foundation

@Observable
@MainActor
class HostMonitor: Identifiable {
    let id: String
    var mac: String?
    let name: String
    var up: Bool = false
    var isMonitoring: Bool = false

    private var monitoringTask: Task<Void, Never>?

    init(ip: String, name: String) {
        id = ip
        self.name = name
    }

    isolated deinit {
        monitoringTask?.cancel()
    }

    func wake() -> Bool {
        guard let mac else { return false }
        Task {
            try! await executeProcess("/opt/homebrew/bin/wakeonlan", [mac])
        }
        return true
    }

    func startMonitoring() {
        guard monitoringTask == nil else { return }
        isMonitoring = true

        monitoringTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { break }

                await ping()

                do {
                    try await Task.sleep(for: .seconds(5))
                } catch {
                    break
                }
            }

            self?.isMonitoring = false
        }
    }

    func stopMonitoring() {
        monitoringTask?.cancel()
        monitoringTask = nil
        isMonitoring = false
    }

    private func ping() async {
        do {
            let status = try await executeProcess("/sbin/ping", ["-c", "3", id])
            up = (status == 0)
        } catch {
            up = false
        }
    }

    private nonisolated func executeProcess(_ binary: String, _ arguments: [String]) async throws -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: binary)
        process.arguments = arguments
        process.standardOutput = Pipe()
        process.standardError = Pipe()

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
