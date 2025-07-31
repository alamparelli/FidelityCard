//
//  Wallet.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 22/07/2025.
//

import SwiftUI
import SwiftData
import Foundation

/// View which create the addFidelityCard button in the Main page
struct addFidelityCard: View {
    @State private var showNetworkNotAvailable: Bool = false
    @Environment(NetworkMonitor.self) private var networkMonitor: NetworkMonitor
    
    var body: some View {
        Group {
            if networkMonitor.isConnected {
                NavigationLink(destination: addCardViews()){
                    mainButton(text: "Add a Fidelity Card")
                }
            } else {
                Button {
                    showNetworkNotAvailable = true
                } label: {
                    mainButton(text: "Add a Fidelity Card", color: .blueRoyal)
                        .alert(isPresented: $showNetworkNotAvailable){
                            Alert(title: Text("Not Connected"), message: Text("You are not connected to the Network! Please check your connection and try again"), dismissButton: .default(Text("Ok")))
                        }
                }
            }
        }
    }
}

/// Main View of the Wallet Page
struct cardWalletView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(NetworkMonitor.self) private var networkMonitor: NetworkMonitor
    
    @Query var fidelityCards: [FidelityCard]
    
    @Query(filter: #Predicate<FidelityCard> { $0.status == "active" })
    var activeFidelityCards: [FidelityCard]
    
    @StateObject private var user = UserModel()
    @State private var showNetworkNotAvailable: Bool = false
    
    @State var showLogin: Bool = false
    
    private let colorArray = ColorArray()

    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        NavigationStack {
            if activeFidelityCards.isEmpty {
                VStack {
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding()
                    
                    Spacer()
                    Spacer()
                    
                    Text("There area not yet any fidelity card.")
                        .tint(.primary.opacity(0.5))
                    
                    Spacer()
                    
                    addFidelityCard()
                    
                    Spacer()
                }
                .navigationTitle("Wallet")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Settings(showLogin: showLogin)) {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                }
            } else {
                VStack {
                    HStack {
                        Text("Welcome Back")
                            .font(.title)
                        Spacer()
                        Image(systemName: "globe" )
                            .foregroundStyle(networkMonitor.isConnected ? .greenEmeraude : .red)
                        Image(systemName: user.isConnected ? "person.fill" : "person.slash.fill")
                            .foregroundStyle(user.isConnected ? .greenEmeraude : .red)
                    }.padding()

                    ScrollView {
                        LazyVGrid(columns: columns, content: {
                            ForEach(fidelityCards) { fidelityCard in
                                if fidelityCard.status == "active" {
                                    NavigationLink(
                                        destination: cardDetailsView(cardID: fidelityCard.id, card: fidelityCard)) {
                                            VStack{
                                                HStack {
                                                    Text("\(fidelityCard.name)")
                                                        .foregroundColor(.white)
                                                        .lineLimit(1)
                                                        .truncationMode(.tail)
                                                        .fontWeight(.semibold)
                                                    Spacer()
                                                }.padding(4)
                                                Spacer()
                                                VStack {
                                                    HStack {
                                                        Spacer()
                                                        Text("Added: ")
                                                            .font(.caption)
                                                            .foregroundStyle(.white)
                                                        Text(fidelityCard.createdDate, format: .dateTime.day().month().year())
                                                            .font(.caption)
                                                            .foregroundStyle(.white)
                                                    }
                                                    HStack {
                                                        Spacer()
                                                        Text("\(fidelityCard.id)")
                                                            .font(.caption)
                                                            .foregroundStyle(.white)
                                                    }
                                                }.padding(4)
                                            }
                                            .frame(height:127)
                                            .background(LinearGradient(colors: colorArray.getArrayFidelityCard(card: fidelityCard), startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .clipShape(.rect(cornerRadius: 10))
                                            .shadow(radius: 6, x: 0, y: 4)
                                        }
                                }
                            }
                        })
                        .padding()
                    }
                    
                    addFidelityCard()
                    
                }
                .navigationTitle("Wallet")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Settings(showLogin: showLogin)) {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    cardWalletView()
        .modelContainer(for: [FidelityCard.self], inMemory: true)
        .environmentObject(NetworkMonitor())
}
