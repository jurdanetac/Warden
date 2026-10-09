//
//  MenuBarContentView.swift
//  Warden
//
//  Created by Juan on 9/10/26.
//

import SwiftUI

struct MenuBarContentView: View {
    @State var hosts = [
        HostMonitor(ip: "127.0.0.1", name: "localhost"),
        // HostMonitor(ip: "192.168.1.1", name: "router"),
    ]

    var body: some View {
        VStack {
            ForEach(hosts) { host in MenuItem(host: host) }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q", modifiers: .command)
        }
    }
}

#Preview {
    MenuBarContentView()
}
