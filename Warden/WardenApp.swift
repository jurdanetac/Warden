//
//  WardenApp.swift
//  Warden
//
//  Created by Juan on 21/10/26.
//

import SwiftUI

@main
struct WardenApp: App {
    let name = "Warden"
    let icon = "point.3.filled.connected.trianglepath.dotted"

    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }

        MenuBarExtra(name, systemImage: icon) {
            MenuBarContentView()
        }.menuBarExtraStyle(.menu)
    }
}
