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
    /* var mac: String? = nil */
    var up: Bool = false
    var isMonitoring: Bool = false

    /// Holds a reference to the active background loop
    private var monitoringTask: Task<Void, Never>?

    init(ip: String, name: String) {
        id = ip
        self.name = name
        startMonitoring()
    }

    func wake() {
        print("woke")
        up = true
    }

    /// Starts pinging every 5 seconds until `stopMonitoring()` is called.
    func startMonitoring() {
        // Prevent duplicate tasks
        guard monitoringTask == nil else { return }
        isMonitoring = true
        print("monitoring started")

        monitoringTask = Task {
            while !Task.isCancelled {
                await ping()

                do {
                    // Suspends the task for 5 seconds without blocking any thread
                    try await Task.sleep(for: .seconds(5))
                } catch {
                    // Task was cancelled during sleep
                    break
                }
            }

            isMonitoring = false
            print("monitoring stopped")
        }
    }

    /// Stops the 5-second polling loop.
    func stopMonitoring() {
        monitoringTask?.cancel()
        monitoringTask = nil
        isMonitoring = false
    }

    private func ping() async {
        do {
            let status = try await executeProcess("/sbin/ping", ["-c", "3", id])
            up = (status == 0)
            print("ping sent successfully")
        } catch {
            print("Ping error: \(error)")
            up = false
        }
    }

    private func executeProcess(_ binary: String, _ arguments: [String]) async throws -> Int32 {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: binary)
        process.arguments = arguments
        // ignore output, we only care for the termination status for now
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
