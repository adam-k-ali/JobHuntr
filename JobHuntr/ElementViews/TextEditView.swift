//
//  TextEditView.swift
//  JobHuntr
//
//  Created by Adam Ali on 28/03/2023.
//

import SwiftUI

struct TextEditView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            let bgColor = Color(uiColor: .systemGray6)
            let textColor = Color(uiColor: bgColor.contrastColor())
            let opacity = colorScheme == .light ? 0.2 : 0.3
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(bgColor)
            
            if colorScheme == .light {
                TextEditor(text: $text)
                    .colorMultiply(bgColor)
                    .font(.body)
                    .padding([.top, .bottom], 7)
                    .padding([.leading, .trailing], 12)
            } else {
                TextEditor(text: $text)
                    .font(.body)
                    .padding([.top, .bottom], 7)
                    .padding([.leading, .trailing], 12)
            }
                
            
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(textColor.opacity(opacity))
                    .padding()
            }
        }
    }
}

struct TextEditView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditView(placeholder: "Description", text: .constant(""))
    }
}
