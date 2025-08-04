//
//  generateCodeView.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 28/07/2025.
//

import SwiftUI
import Foundation
import CoreImage.CIFilterBuiltins
import SwiftData

/// View that Generate the Modal with the PINCODE and QRCODE 
struct generateCodeView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var historic: [Historic]
    
    // only for conformity with Protocol, not used in this code. // TODO - To improve
    @State internal var showSuccesReward: Bool = false
    
    var type : CodeType
    var card: FidelityCard
    var fromHistoric: Bool
    
    private let manageCard = ManageCard()
    
    @State var pinCode = Int.random(in: 1...999999)
    @State var generatedUIImage: UIImage = UIImage()
    
    @State var timerValidity = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var code: String {
        switch type {
            case .qrcode:
                return "QR CODE"
            case .pincode:
                return "PINCODE"
        }
    }
    
    var generatedUrlString: String {
        var securityToken: String = "" // 8 digits
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for _ in 1...8 {
            securityToken.append(String(characters.randomElement() ?? "0"))
        }
        
        var qrCodeText = "https://api.localcard.com/validate/"
        if !fromHistoric {
            qrCodeText = "https://api.localcard.com/rewards/"
        }
        qrCodeText += card.id // ID de la carte
        qrCodeText += "-"
        qrCodeText += timeStamp // TimeStamp Unix
        qrCodeText += "-"
        qrCodeText += securityToken //SecurityToken
        
        return qrCodeText
    }
    
    var body: some View {
        VStack {
            if fromHistoric {
                Text("Collect your reward")
                    .font(.title2)
                    .padding()
            }
            if timerValidity == 0 {
                Text("\(code) Expired")
                    .font(.largeTitle)
            } else {
                if type == .pincode {
                    Text(String(format: "%06d", pinCode))
                        .font(.system(size: 50))
                        .fontWeight(.semibold)
                        .frame(minWidth: 300)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                } else {
                    Image(uiImage: generatedUIImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            VStack {
                Text("Expires in")
                    .font(.headline)
                HStack(spacing: 0) {
                    Text(String(format: "%01d", timerValidity / 60))
                        .foregroundColor(.greenEmeraude)
                    Text(":")
                        .foregroundColor(.primary)
                    Text(String(format: "%02d", timerValidity % 60))
                        .foregroundColor(.blueRoyal)
                }
                .font(.largeTitle)
                .fontWeight(.semibold)
            }.padding()
            Button {
                switch type {
                case .qrcode:
                    generatedUIImage = generateQRCode()
                case .pincode:
                    generatePinCode()
                }
                
                timerValidity = 300
            } label: {
                LabelButton(text: "Generate a new \(code)", systemImage: type == .qrcode ? "qrcode" : "numbers.rectangle.fill", color: .blueRoyal)
            }.alert(isPresented: $showSuccesReward) {
                Alert(title: Text("Reward Granted"), message: Text("Your card has been accepted! Enjoy your reward"), dismissButton: Alert.Button.default(Text("OK")) {
                    dismiss()
                })
            }
            
            //Debug Button
            Button {
                // This emaulate that store have stamped the fidelity card
                if !fromHistoric {
                    card.stampCollected += 5
                    
                    let log = Historic(storeId: card.storeId, dateActivity: Date.now, activity_type: "stampCollected", amount_stamps: 5, card_id: card.id)
                    modelContext.insert(log)
                    
                    if card.stampCollected >= card.stamps_required {
                        let stampsToReport = card.stampCollected - card.stamps_required
                        card.stampCollected = card.stamps_required
                        card.completedDate = Date.now
                        card.status = "cardCompleted"
                        
                        let log = Historic(storeId: card.storeId, dateActivity: Date.now, activity_type: "cardCompleted", card_id: card.id)
                        modelContext.insert(log)
                                            
                        manageCard.addNewCard(card: card, modelContext: modelContext, stampsToReport: stampsToReport)
                    }
                    
                    dismiss()
                } else {
                    card.status = "cardRedeemed"
                    showSuccesReward = true
                    
                }
            } label: {
                Label("Debug Options", systemImage: "gearshape.fill")
            }
        }
        .padding()
        .onAppear {
            generatedUIImage = generateQRCode()
        }.onReceive(timer) { time in
            if timerValidity > 0 {
                timerValidity -= 1
            }
        }
    }
    
    /// Generate the QRCode Image
    /// - Returns: an Image of the QRCode
    func generateQRCode() -> UIImage {
        filter.message = Data(generatedUrlString.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    /// Generate a PINCODE
    func generatePinCode() {
        pinCode = Int.random(in: 1...999999)
        timerValidity = 300
        // In real world code, i'll call a method on on Client Backend Server that will provide the code.
        // Server shoudl be authority to generate a newCode
    }
}


