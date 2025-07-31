//
//  User.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 22/07/2025.
//

import Foundation
import SwiftData
import SwiftUI

extension Date {
    func adding(months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
}

/// Class created to manage the Historic Model / SwiftData
@Model
class Historic: Identifiable {
    var transactionId: UUID = UUID()
    var storeId: String // id of the Store
    var dateActivity: Date
    var activity_type: String
    var amount_stamps: Int?
    var card_id: String? // id of the Card
    
    init(storeId: String, dateActivity: Date, activity_type: String, amount_stamps: Int? = nil, card_id: String? = nil) {
        self.storeId = storeId
        self.dateActivity = dateActivity
        self.activity_type = activity_type
        self.amount_stamps = amount_stamps
        self.card_id = card_id
    }
}

/// Class created to store the FidelityCard Model / SwiftData
@Model
class FidelityCard: Identifiable{
    var id: String
    var storeId: String
    var activity_type : String
    var status: String
    var createdDate: Date
    var completedDate: Date?
    var template_id: String
    var name: String
    var primary_color: String
    var secondary_color: String
    var address: String
    var phone: String
    var logo_url: String
    var stamps_required: Int
    var reward_description: String
    var card_name: String
    var hours: String
    var personalized_message: String
    var stamp_value: Int = 5
    
    var stampCollected: Int = 0
    
    var validTo: Date {
        createdDate.adding(months: 12)
    }
    
    init(id: String,
         storeId: String,
         activity_type: String,
         status: String,
         template_id: String,
         name: String,
         primary_color: String,
         secondary_color: String,
         address: String,
         phone: String,
         logo_url: String,
         stamps_required: Int,
         reward_description: String,
         card_name: String,
         hours: String,
         personalized_message: String,
         createdDate: Date = .now,
         completedDate: Date? = nil,
         stampCollected: Int = 0
    ) {
        self.id = id
        self.storeId = storeId // ID of the store
        self.activity_type = activity_type
        self.status = status
        self.template_id = template_id
        self.name = name
        self.primary_color = primary_color
        self.secondary_color = secondary_color
        self.address = address
        self.phone = phone
        self.logo_url = logo_url
        self.stamps_required = stamps_required
        self.reward_description = reward_description
        self.card_name = card_name
        self.hours = hours
        self.personalized_message = personalized_message
        self.createdDate = createdDate
        self.completedDate = completedDate
        self.stampCollected = stampCollected
    }
}

extension FidelityCard {
    static func mockContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        var container: ModelContainer!
        do {
            container =  try ModelContainer(for: FidelityCard.self, configurations: config)
        } catch {
            print("\(error.localizedDescription)")
        }
        return container
    }
    
    static func mockFidelityCard(in context: ModelContext) -> FidelityCard {
        let card = FidelityCard(
            id: "CARDIDVWX234",
            storeId: "STOREIDWX234",
            activity_type: "Restaurant",
            status: "active",
            template_id: "template_pharmacie",
            name: "A la Belle Epoque",
            primary_color: "FFFFFF",
            secondary_color: "FFFFFF",
            address: "15 Place de la République, 59000 Lille",
            phone: "03 20 74 85 96",
            logo_url: "https://api.localcard.com/logos/pharmacie-central.png",
            stamps_required: 8,
            reward_description: "5€ de réduction sur votre prochain achat",
            card_name: "Carte Santé Central",
            hours: "Lun-Sam: 8h30-19h30",
            personalized_message: "Votre santé, notre priorité"
        )
        card.stampCollected = 3
        context.insert(card)
        return card
    }
}

/// AppStorage Class used to store user settings ( after being synced with the backend server ) / Backend Sync not implemented
class UserModel:ObservableObject {
    @AppStorage("user_id") var id: String = UUID().uuidString
    @AppStorage("user_name") var name: String = ""
    @AppStorage("user_email") var emailAddress: String = ""
    @AppStorage("user_connected") var isConnected: Bool = false
    @AppStorage("user_registered") var isRegistered: Bool = false
}
