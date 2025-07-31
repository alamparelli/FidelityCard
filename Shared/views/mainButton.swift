//
//  mainButton.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 30/07/2025.
//

import SwiftUI

/// Personalized button that draw a Button interface but without the Button, shoudl be used with Button or NavigationLink
struct mainButton: View {
    var text : String
    var textColor: Color = .white
    var color : Color = .blueRoyal
    
    var body: some View {
        Text(text)
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(color)
            .clipShape(.rect(cornerRadius: 15))
            .padding(.horizontal, 64)
    }
}

#Preview {
    mainButton(text: "Hello")
}
