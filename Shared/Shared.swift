//
//  Shared.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 28/07/2025.
//

import SwiftUI
import SwiftData
import Network

/// Class that manage the retrieval and creation of the card in FidelityCard Model
final class ManageCard {
    /// Add a card into FidelityCard Model, called when adding a new Card or invoked by addNewCard
    /// - Parameters:
    ///   - card: card information retrieved by the FakeAPI
    ///   - modelContext: FidelityCard /SwiftData
    ///   - stampsToReport: the amount of stamp to reports (if mentioned)
    /// - Returns: CardName, Bool if card has been added, Bool if an active card is already in user data (oinly one active card at the time)
    func addCard(card: StoreCards, modelContext: ModelContext, stampsToReport: Int) -> (String, Bool, Bool) {
        var cardName = ""
        var showCardAdded = false
        var showCardExist = false
            
        var cardId = ""
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for _ in 1...12 {
            cardId.append(String(characters.randomElement() ?? "0"))
        }
        
        let newCard = FidelityCard(
            id: cardId,
            storeId: card.id,
            activity_type: card.activity_type,
            status: card.status,
            template_id: card.template_id,
            name: card.name,
            primary_color: card.primary_color,
            secondary_color: card.secondary_color,
            address: card.address,
            phone: card.phone,
            logo_url: card.logo_url,
            stamps_required: card.stamps_required,
            reward_description: card.reward_description,
            card_name: card.card_name,
            hours: card.hours,
            personalized_message: card.personalized_message,
            stampCollected: stampsToReport
        )
        
        let idCard = card.id
        let predicate = #Predicate<FidelityCard> { search in
            search.storeId == idCard && search.status == "active"
        }

        let descriptor = FetchDescriptor<FidelityCard>(predicate: predicate)
        
        do {
            let foundExistingCards = try modelContext.fetch(descriptor)
            cardName = card.name
            
            if foundExistingCards.isEmpty{
                modelContext.insert(newCard)
                showCardAdded = true
            } else {
                showCardExist = true
                showCardAdded = false
            }
        } catch {
            print("Error searching cards: \(error.localizedDescription)")
        }
        
        return (cardName, showCardAdded, showCardExist)
    }
    
    /// Add a card into FidelityCard Model, called once a fidelitycard is filled (after QRCode and PINCode has been validated)
    /// - Parameters:
    ///   - card: FidelityCard which has been completed
    ///   - modelContext: FidelityCard /SwiftData
    ///   - stampsToReport: the amount of stamp to reports in case the stamp redeeemed are higher that the amount of stamps remaining on cnewly completed card.
    func addNewCard(card: FidelityCard, modelContext: ModelContext, stampsToReport: Int) {
        let liste = availableStoreFidelityCards
        for i in 0..<liste.count {
            if liste[i].id == card.storeId {
                (_, _, _) = addCard(card: liste.first(where: { $0.id == card.storeId })!, modelContext: modelContext, stampsToReport: stampsToReport)
            }
        }
    }
    
    /// Retrieve a card in FidelityCard Model
    /// - Parameters:
    ///   - cardID: the id of the fidelitycard searched
    ///   - modelContext: FidelityCard /SwiftData
    /// - Returns: return the information of the FidelityCard found in Model
    func getCard(cardID: String, modelContext: ModelContext) throws -> FidelityCard {
        let descriptor = FetchDescriptor<FidelityCard>(
            predicate: #Predicate<FidelityCard> { $0.id == cardID}
        )

        var currentCardFirst: FidelityCard!
        
        do {
            let currentCard = try modelContext.fetch(descriptor)
            currentCardFirst = currentCard.first
        } catch {
            print("\(error.localizedDescription)")
        }
        return currentCardFirst
    }
}


/// Observable that help checking the Network Connection
@Observable
final class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}


// Merit to SO
// https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


/// Class which create an array of Colors passed to the Cards view generations. Match store colors (primary & secondary)
final class ColorArray : ObservableObject {
    /// Retrieve the colors in the FAKEAPI and return an array of these colors
    /// - Parameter card: Storecards definition based on FAKEAPI data
    /// - Returns: array of two colors
    func getArrayStoreCard(card : StoreCards) -> [Color] {
        return appendColor(Color(hex: card.primary_color),Color(hex: card.secondary_color))
    }
    
    /// Retrieve the colors in the FidelityCard model and return an array of these colors
    /// - Parameter card: FidelityCard in the FIdelityCard model
    /// - Returns: array of two colors
    func getArrayFidelityCard(card : FidelityCard) -> [Color] {
        return appendColor(Color(hex: card.primary_color),Color(hex: card.secondary_color))
    }
    
    /// Utility to add primary and secondary colors to an Array
    /// - Parameters:
    ///   - color1: based on definition in FakeAPI
    ///   - color2: based on definition in FakeAPI
    /// - Returns: array of two colors
    private func appendColor(_ color1 : Color, _ color2: Color) -> [Color] {
        var array : [Color] = []
        
        array.append(color1)
        array.append(color2)
        
        return array
    }
}

