//
//  PrimaryButtonStyle.swift
//  JobHuntr
//
//  Created by Adam Ali on 19/03/2023.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 300)
            .background(Color.accentColor)
            .foregroundColor(Color.white)
            .cornerRadius(8)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 300)
            .background(Color(uiColor: .systemGray))
            .foregroundColor(Color.white)
            .cornerRadius(8)
    }
    
}
