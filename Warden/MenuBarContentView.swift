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
        HostMonitor(ip: "192.168.1.1", name: "router"),
        HostMonitor(ip: "192.168.1.2", name: "test"),
        HostMonitor(ip: "192.168.1.3", name: "offline"),
    ]

    var body: some View {
        VStack {
            ForEach(hosts) { host in MenuItem(host: host) }

            Divider()

            if hosts.first(where: { $0.up == true }) != nil {
                Menu("Power Off") {
                    ForEach(hosts) { host in
                        if host.up {
                            Button(action: {
                                print("power off \(host.name)")
                            }, label: { Text(host.name) })
                        }
                    }
                }
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q", modifiers: .command)
        }
    }
}

#Preview {
    MenuBarContentView()
}
