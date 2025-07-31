//
//  addNewCardView.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 24/07/2025.
//

import SwiftUI
import SwiftData

/// Page that enable the possibility to add a FidelityCard
struct addCardViews: View {
     
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var fidelityCards: [FidelityCard]
    
    @State internal var cardName: String = ""
    @State internal var showCardExist: Bool = false
    @State internal var showCardAdded: Bool = false
    @State private var errorMessage: String? = ""
    @State private var searchText: String = ""
    @State private var searchBarActive: Bool = false
    
    var list = availableStoreFidelityCards
    
    private let manageCard = ManageCard()
    private let colorArray = ColorArray()
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]

        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, content: {
                        ForEach(list, id: \.id) { card in
                            Button {
                                (cardName, showCardAdded, showCardExist) = manageCard.addCard(card: card, modelContext: modelContext, stampsToReport: 0)
                            } label: {
                                VStack{
                                    HStack {
                                        Text("\(card.name)")
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .fontWeight(.semibold)
                                        Spacer()
                                    }.padding(4)
                                    .alert(isPresented: $showCardExist){
                                        Alert(title: Text("Duplicate Card"), message: Text("An active card already exists for :\n\(cardName)"), dismissButton: .default(Text("Ok")))
                                    }
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text("\(card.address)")
                                            .font(.caption)
                                            .foregroundStyle(.white)
                                            .lineLimit(2)
                                            .truncationMode(.tail)
                                            .multilineTextAlignment(.trailing)
                                    }.padding(4)
                                    .alert(isPresented: $showCardAdded){
                                        Alert(title: Text("Success"), message: Text("The fidelity card of :\n\(cardName)\nhas been successfully added."), dismissButton: .default(Text("Ok")){
                                            dismiss()
                                        })
                                    }
                                    
                                }
                                .frame(height:127)
                                .background(LinearGradient(colors: colorArray.getArrayStoreCard(card: card), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(radius: 6, x: 0, y: 4)
                            }
                }
                    }).padding()
                }
            }
            .navigationTitle("Choose your Store")
            .searchable(text: $searchText, isPresented: $searchBarActive, placement: .navigationBarDrawer(displayMode: .automatic))
        }
    }
}

#Preview {
    addCardViews()
        .modelContainer(for: [FidelityCard.self])
}
