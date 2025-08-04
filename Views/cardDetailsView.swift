//
//  fidelityCardDetails.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 23/07/2025.
//

import SwiftUI
import SwiftData

enum CodeType {
    case qrcode, pincode
}

/// Create a Button withe a Label
struct LabelButton: View {
    var text: String
    var systemImage: String
    var color: Color
    
    var body: some View {
        Label(text, systemImage: systemImage)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
            .padding()
            .background(color)
            .clipShape(.rect(cornerRadius: 15))
    }
}


/// View that create the button which will open the modal for  PINCODE or  QRCode generation
struct collectStamp: View {
    var card: FidelityCard
    var fromHistoric: Bool = false
     
    @StateObject var user = UserModel()
    
    @State var showSheetPIN: Bool = false
    @State var showSheetQR: Bool = false
    
    @State var settingsDetent = PresentationDetent.medium
    
    @Environment(NetworkMonitor.self) private var networkMonitor: NetworkMonitor

    var body: some View {
        Group {
            if networkMonitor.isConnected && user.isConnected {
                HStack {
                    Button {
                        showSheetPIN = true
                    } label: {
                        LabelButton(text: "Generate a\nPINCODE", systemImage: "numbers.rectangle.fill", color: isDisabled() ? .gray : .greenEmeraude)
                    }
                    .sheet(isPresented: $showSheetPIN) {
                        generateCodeView(type: .pincode, card: card, fromHistoric: fromHistoric)
                            .presentationDetents(
                                [.medium, .large],
                                selection: $settingsDetent
                            )
                    }
                    
                    Button {
                        showSheetQR = true
                    } label: {
                        LabelButton(text: "Generate a QR Code", systemImage: "qrcode", color: isDisabled() ? .gray : .blueRoyal)
                    }
                    .sheet(isPresented: $showSheetQR) {
                        generateCodeView(type: .qrcode, card: card, fromHistoric: fromHistoric)
                            .presentationDetents(
                                [.medium, .large],
                                selection: $settingsDetent
                            )
                    }
                }
                .disabled(isDisabled())
                .padding()
            } else if networkMonitor.isConnected && (!user.isRegistered || !user.isConnected) {
                    NavigationLink(destination: Login()){
                        mainButton(text: user.isRegistered && !user.isConnected ? "Login" : "Register")
                    }
            } else {
                    mainButton(text: "Please check your connection and try again.", textColor: .red, color: .white)
                        .padding()
            }
        }
    }
    
    /// Check if card is in a particular state or the view is displayed from the Historic workflow
    /// - Returns: True if any condition is met
    func isDisabled() -> Bool {
        (card.status == "cardCompleted" &&  !fromHistoric) || card.status == "cardRedeemed" || !networkMonitor.isConnected
    }
}

/// View that create the card displayed on top of the screen with the stamps
struct fidelityCard: View {
    var fromHistoric: Bool
    var card: FidelityCard
    
    private let colorArray = ColorArray()
    
    var body: some View {
        let columns = Int(card.stamps_required / 2)
        var stampCollectedFirstRow: Int {
            var number = 0
            if card.stampCollected >= card.stamps_required / 2 {
                number = card.stamps_required / 2
            } else {
                number = card.stampCollected
            }
            return number
        }
        var stampCollectedSecondRow: Int {
            var number = 0
            if card.stampCollected >= card.stamps_required / 2 {
                number = card.stampCollected - card.stamps_required / 2
            }
            return number
        }
        
        ZStack {
            Spacer()
            
            ZStack (alignment: .center){
                VStack{
                    Spacer()
                    HStack {
                        Text("\(card.stampCollected)\\\\\(card.stamps_required)")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(card.id)")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                }
            }
            .frame(maxHeight:200)
            .background(LinearGradient(colors: colorArray.getArrayFidelityCard(card: card), startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 6, x: 0, y: 4)
            
            ZStack {
                VStack {
                    HStack { // firstrow
                        ForEach(1...columns, id: \.self) { stamp in
                            if stamp <= stampCollectedFirstRow {
                                Image(systemName: "star.circle")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.white)
                            } else {
                                Image(systemName: "star.circle")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(8)
                    HStack { // second row
                        ForEach(1...columns, id: \.self) { stamp in
                            if stamp <= stampCollectedSecondRow {
                                Image(systemName: "star.circle")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.white)
                            } else {
                                Image(systemName: "star.circle")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(8)
                }
            }
            .padding()
            
            ZStack {
                if fromHistoric {
                    Text(card.status == "cardCompleted" ? "COMPLETED" : "REDEEMED")
                        .foregroundStyle(.greenEmeraude)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .rotationEffect(.degrees(-35))
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

/// Main View thet display the Details of a FidelityCard
struct cardDetailsView: View {
    let cardID: String
    var fromHistoric: Bool = false
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var card: FidelityCard
    @State private var haveCompletedCards: Bool = false
    @State private var showCardRemoved = false
    @State private var showCompletedCard = false
    @State private var backToWallet = false
    
    @StateObject var user = UserModel()
    
    let currentCard = ManageCard()
      
    var body: some View {
        NavigationStack {
            VStack {
                fidelityCard(fromHistoric: fromHistoric, card: card)
                
                if fromHistoric {
                    Text("\(card.status == "cardCompleted" ? "This card is completed.\n Generate a QRCode to claim the Rewards" : "This card is Redeemed.")")
                        .foregroundStyle(.greenEmeraude)
                        .font(.title3)
                        .fontWeight(.medium)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                // only show if more than 1 card completed
                if showCompletedCard && !fromHistoric {
                    NavigationLink(destination: cardHistoricView(card: card)) {
                        Text("1 Card completed")
                    }
                }
                
                if card.status == "cardCompleted" && !fromHistoric {
                    Text("The card is complete.\nA new one has been created")
                        .foregroundStyle(.greenEmeraude)
                        .font(.title2)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                
                VStack {
                    VStack (alignment: .center) {
                        Text("\(card.stamps_required) \(Image(systemName: "star.circle")) : \(card.reward_description)")
                            .lineLimit(1)
                            
                        Text("1 \(Image(systemName: "star.circle")) = \(card.stamp_value)€")
                        HStack {
                            Text("Valid to:")
                            Text(card.validTo, format: .dateTime.day().month().year())
                                .fontWeight(.semibold)
                        }
                        .padding()
                    }
                    

                    
                    Spacer()
                    
                    VStack (alignment: .center){
                        Text("\(card.name)")
                            .font(.title)
                            .lineLimit(1)
                        Text("\(card.address)")
                            .foregroundStyle(.secondary)
                        HStack {
                            Text("\(Image(systemName: "phone.fill"))")
                            Link("\(card.phone)", destination: URL(string: "tel:\(card.phone)")!)
                                .underline()
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Spacer()
                }
                .padding(32)
                .font(.subheadline)

                collectStamp(card: card, fromHistoric: fromHistoric)
                          
                Spacer()
                Spacer()
                
                if !fromHistoric && card.status != "cardCompleted" {
                    Button {
                        showCardRemoved = true
                    } label: {
                        Text("Remove the Store")
                            .foregroundStyle(Color.red)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                    .buttonStyle(.borderless)
                    .padding(.horizontal, 64)
                    .alert(isPresented: $showCardRemoved) {
                        Alert(
                            title: Text("This card will be removed from your Wallet"),
                            message: Text("This action cannot be undone."),
                            primaryButton: .destructive(Text("Remove")){
                                card.status = "cardRemoved"
                                dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                
                Spacer()
            }
            .onAppear {
                if fromHistoric {
                    card = try! currentCard.getCard(cardID: cardID, modelContext: modelContext)
                }
            }
            .navigationTitle("\(card.name)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: cardHistoricView(card: card)) {
                        Label("History", systemImage: "list.bullet")
                    }
                }
            }
        }
    }
}

