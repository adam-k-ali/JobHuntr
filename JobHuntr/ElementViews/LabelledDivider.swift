//
//  OrDivider.swift
//  JobHuntr
//
//  Created by Adam Ali on 29/03/2023.
//

import SwiftUI

struct LabelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color
    
    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }
    
    var body: some View {
        HStack {
            line
            Text(label)
                .foregroundColor(color)
            line
        }
    }
    
    var line: some View {
        VStack {
            Divider()
                .background(color)
                
        }
        .padding(horizontalPadding)
    }
}

struct LabelledDivider_Previews: PreviewProvider {
    static var previews: some View {
        LabelledDivider(label: "Or")
        
    }
}
