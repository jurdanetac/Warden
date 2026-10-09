//
//  MenuBarContentView.swift
//  Warden
//
//  Created by Juan on 9/10/26.
//

import SwiftUI

struct MenuBarContentView: View {
    var body: some View {
        let devices = [
            HostMonitor(ip: "127.0.0.1", name: "localhost"),
            HostMonitor(ip: "192.168.1.1", name: "router"),
            HostMonitor(ip: "192.168.1.2", name: "server"),
        ]

        VStack {
            ForEach(devices.indices, id: \.self) { index in
                let device = devices[index]

                Button(action: {
                    device.ping()
                }, label: {
                    Text(device.name)
                })
            }

            Divider()

            Button(action: {
                NSApplication.shared.terminate(nil)
            }, label: {
                Text("Quit")
            })
        }
    }
}

#Preview {
    MenuBarContentView()
}
