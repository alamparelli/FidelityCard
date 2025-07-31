//
//  Login.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 22/07/2025.
//

import SwiftUI

/// Main View for the Login Page
struct Login: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @StateObject var user = UserModel()
    
    @State var email: String = "exemple@email.com"
    @State var password: String = "password"
    @State var name: String?
    @State var isLogged: Bool = false
    @State var badInput: Bool = false
    
    @Environment(NetworkMonitor.self) private var networkMonitor: NetworkMonitor

    var body: some View {
        VStack {
            Spacer()
            
            Image("logo")
                .resizable()
                .frame(width: 200, height: 200)
                .padding()
            
            Spacer()
            
            VStack (alignment: .center){
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .disableAutocorrection(true)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                TextField("Password", text: $password)
                    .textContentType(.password)
                    .disableAutocorrection(true)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .alert(isPresented: $isLogged){
                Alert(title: Text("Login Successful"), message: Text("Hi \(name ?? "there"). You can go back to the Main Menu"), dismissButton: .default(Text("Ok")) {
                    dismiss()
                })
            }
            .padding(.horizontal)
            
            Spacer()
            
            if networkMonitor.isConnected {
                Button(action: login){
                    mainButton(text: "Login")
                }
            } else {
                mainButton(text: "Not Connected", color: .red)
                    .disabled(true)
            }
                
            Button("Forgot your password?", action: login)
                .frame(maxWidth: .infinity)
                .padding()
                .buttonStyle(.borderless)
                .tint(.blueRoyal)
            Spacer()
            Spacer()
        }
        .padding(.horizontal)
        .alert("Wrong Input", isPresented: $badInput){}
    }
    
    /// Set virtually the user as connected and registered
    func login(){
        user.isConnected = true
        user.isRegistered = true
        isLogged = true
    }
    
}

#Preview {
    Login()
}
