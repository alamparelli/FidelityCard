//
//  fidelityAppApp.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 22/07/2025.
//

import SwiftUI
import SwiftData

/// FidelityCard for LocalCard Solutions
@main
struct fidelityAppApp: App {
    @State private var userModel = UserModel()
    @State private var networkMonitor = NetworkMonitor()


    var body: some Scene {
        WindowGroup {
            cardWalletView()
        }
        .modelContainer(for: [FidelityCard.self, Historic.self])
        .environment(networkMonitor)
    }
}
