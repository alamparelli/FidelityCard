//
//  fidelityCardHistoric.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 28/07/2025.
//

import SwiftUI
import SwiftData

/// View which define the text of stamps collected in Historic List
struct TextStamps: View {
    var stamps_amount: Int?
    
    var text: String {
        var str = "1 stamp collected"
        if stamps_amount ?? 0 > 1 {
            str = "\(stamps_amount ?? 0) stamps collected"
        }
        return str
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
        }
    }
}

/// View that create the Card displayed in Historic
struct CardViews: View {
    var historicItem: Historic
    var card: FidelityCard
    var status: String
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text(status == "cardCompleted" ? "Completed:" : "Redeemed: " )
                Text(historicItem.dateActivity, format: .dateTime.day().month().year().hour().minute())

            }
            HStack {
                Text("Validity:")
                Text(card.validTo, format: .dateTime.day().month().year().hour().minute())
            }
            Spacer()
            HStack {
                Text("\(historicItem.card_id ?? "")")
                NavigationLink("", destination: cardDetailsView(cardID: historicItem.card_id ?? "nil", fromHistoric: true, card: card))
                .opacity(0)
                Spacer()
                Image(systemName: status == "cardCompleted" ? "giftcard.fill" : "lock.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.greenEmeraude)
            }.disabled(status == "cardRedeemed") 
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxHeight:200)
        .background(LinearGradient(colors: ColorArray().getArrayFidelityCard(card: card), startPoint: .topLeading, endPoint: .bottomTrailing))
//        .background(LinearGradient(colors: [.blue, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))

        .clipShape(.rect(cornerRadius: 10))
        .shadow(radius: 6, x: 0, y: 4)
    }
}

/// Main view of Historic Page
struct cardHistoricView: View {
    var card: FidelityCard
    
    @Query var historic: [Historic]
    @State private var errorMessage: String?
    @Query var logs: [Historic]
    @Query var logOnlyCards: [Historic]
    
    @State private var segmentedList: Int = 0
    
    @Environment(\.modelContext) var modelContext
    
    let rowCard = ManageCard()
    
    init(card: FidelityCard) {
        self.card = card
        let cardIdToFilter = card.storeId
        
        _logs = Query(filter: #Predicate<Historic> { historicItem in
            historicItem.storeId == cardIdToFilter
        })
        
        _logOnlyCards = Query(filter: #Predicate<Historic> { historicItem in
            historicItem.storeId == cardIdToFilter && (historicItem.activity_type == "cardCompleted" || historicItem.activity_type == "cardRedeemed")
        })
    }
    
    var body: some View {
        NavigationStack {
            Picker("Color", selection: $segmentedList) {
                Text("All entries").tag(0)
                Text("Fidelity Cards").tag(1)
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            
            List {
                if segmentedList == 0 {
                    ForEach(logs.sorted(by: { $0.dateActivity > $1.dateActivity }), id: \.transactionId) {
                        historicItem in
                        let fetchCard = try! rowCard.getCard(cardID: historicItem.card_id ?? "", modelContext: modelContext )
                        let status = fetchCard.status
                        VStack (alignment: .leading){
                            if historicItem.activity_type == "cardCompleted" || historicItem.activity_type == "cardRedeemed" {
                                CardViews(historicItem: historicItem, card: card, status: status)
                            } else {
                                HStack {
                                    TextStamps(stamps_amount: historicItem.amount_stamps)
                                    Spacer()
                                    Text(historicItem.dateActivity, format: .dateTime.day().month().year().hour().minute())
                                }
                            }
                        }

                    }
                }
                else {
                    ForEach(logOnlyCards.sorted(by: { $0.dateActivity > $1.dateActivity }), id: \.transactionId) { historicItem in
                        let fetchCard = try! rowCard.getCard(cardID: historicItem.card_id ?? "", modelContext: modelContext )
                        let status = fetchCard.status
                        VStack (alignment: .leading){
                            if historicItem.activity_type == "cardCompleted" || historicItem.activity_type == "cardRedeemed"{
                                CardViews(historicItem: historicItem, card: card, status: status)
                            }
                        }
                    }
                }
            }
            .font(.subheadline)
            .listRowBackground(Color.clear)
            .listStyle(.plain)
            .navigationTitle("Historic")
        }
    }
}


#Preview {
    cardHistoricView(card: FidelityCard(id: "1234567890", storeId: "STU901VWX234", activity_type: "Restaurant", status: "active", template_id: "template_pharmacie", name: "A la Belle Epoque", primary_color: "FFFFFF", secondary_color: "FFFFFF", address: "15 Place de la République, 59000 Lille", phone: "03 20 74 85 96", logo_url: "https://api.localcard.com/logos/pharmacie-central.png", stamps_required: 8, reward_description: "5€ de réduction sur votre prochain achat", card_name: "Carte Santé Central", hours: "Lun-Sam: 8h30-19h30", personalized_message: "Votre santé, notre priorité"))
        .modelContainer(for: [FidelityCard.self, Historic.self], inMemory: true)
}

