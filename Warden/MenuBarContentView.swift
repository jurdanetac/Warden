//
//  MenuBarContentView.swift
//  Warden
//
//  Created by Juan on 9/10/26.
//

import SwiftUI

struct MenuBarContentView: View {
    @State var hosts = [
        HostMonitor(at: "127.0.0.1", alias: "localhost"),
    ]

    var body: some View {
        VStack {
            ForEach(hosts) { host in MenuItem(host: host) }

            Divider()

//            if hosts.first(where: { $0.up == true }) != nil {
//                Menu("Power Off") {
//                    ForEach(hosts) { host in
//                        if host.up {
//                            Button(action: {
//                                print("power off \(host.ipA)")
//                            }, label: { Text(host.name) })
//                        }
//                    }
//                }
//            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q", modifiers: .command)
        }
    }
}

#Preview {
    MenuBarContentView()
}
