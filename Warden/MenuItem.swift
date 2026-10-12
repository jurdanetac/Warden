//
//  MenuItem.swift
//  Warden
//
//  Created by Juan on 9/10/26.
//

import SwiftUI

struct MenuItem: View {
    @State var host: HostMonitor

    var body: some View {
        if !host.up {
            Button(host.ipAddress, systemImage: "bolt.fill") {
                Task {
                    host.wake()
                }
            }
            .task {
                host.startMonitoring()
            }
            .help(host.ipAddress)
            .labelStyle(.titleAndIcon)
        } else {
            Text(host.ipAddress)
        }
    }
}
