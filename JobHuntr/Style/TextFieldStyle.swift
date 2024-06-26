//
//  TextFieldStyle.swift
//  JobHuntr
//
//  Created by Adam Ali on 19/03/2023.
//

import SwiftUI

struct GradientTextFieldBackground: TextFieldStyle {
   let systemImageString: String

   func _body(configuration: TextField<Self._Label>) -> some View {
       ZStack {
           RoundedRectangle(cornerRadius: 8.0)
               .stroke(
                   LinearGradient(
                       colors: [
                           .red,
                           .blue
                       ],
                       startPoint: .leading,
                       endPoint: .trailing
                   )
               )
               .frame(height: 48)
           
           HStack {
               Image(systemName: systemImageString)
               // Reference the TextField here
               configuration
           }
           .padding(.leading)
           .foregroundColor(.gray)
       }
   }
}

struct FormTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            let bgColor = Color(uiColor: .systemGray6)
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(bgColor)
                .frame(height: 48)
//            RoundedRectangle(cornerRadius: 8.0)
//                .stroke(.black)
//                .frame(height: 48)
            
            
            let textColor = Color(uiColor: bgColor.contrastColor())
            HStack {
                // Reference the TextField here
                configuration
            }
            .padding(.leading)
            .foregroundColor(textColor)
        }
    }
}
