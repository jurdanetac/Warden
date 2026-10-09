//
//  WardenApp.swift
//  Warden
//
//  Created by Juan on 9/10/26.
//

import SwiftUI

@main
struct WardenApp: App {
    var body: some Scene {
        let appName = "Warden"
        let menuBarIcon = "point.3.filled.connected.trianglepath.dotted"
        
        // Menu Bar Utility
        MenuBarExtra(appName, systemImage: menuBarIcon) {
            MenuBarContentView()
        }.menuBarExtraStyle(.menu)
        
        // Window UI
        // WindowGroup {
        //     ContentView()
        // }
    }
}
