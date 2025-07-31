
//
//  Settings.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 31/07/2025.
//

import SwiftUI

/// Settings View
struct Settings: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var user = UserModel()
    
    @State var showLogin: Bool
    @State private var showDeleteAccount: Bool = false
    
    var body: some View {
        Form {
            Section ("About me"){
                TextField("Name", text: $user.name)
            }
            Section ("Connection") {
                if user.isConnected {
                    Button("Logout") {
                        user.isConnected = false
                    }
                } else {
                    NavigationLink(destination: Login()) {
                        Text("Login")
                    }
                }
            }
            Section ("Account"){
                Button  {
                    showDeleteAccount = true
                } label: {
                    Text("Delete my Account")
                        .foregroundStyle(.red)
                }
            }
        }
        .alert(isPresented: $showDeleteAccount){
            Alert(title: Text("Delete my Account"),
                  message: Text("Your account will be deleted on this phone. Are you sure?"),
                  primaryButton: .destructive(Text("Delete")) {
                    user.isConnected = false
                    user.isRegistered = false
                    user.name = ""
                },
                  secondaryButton: .cancel())
        }
    }
}
