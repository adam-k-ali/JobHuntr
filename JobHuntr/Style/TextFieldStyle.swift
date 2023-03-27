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
                   .colorScheme(.dark)
           }
           .padding(.leading)
           .foregroundColor(.gray)
       }
   }
}

struct FormTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(AppColors.primary)
                .frame(height: 48)
//            RoundedRectangle(cornerRadius: 8.0)
//                .stroke(.black)
//                .frame(height: 48)
            
            HStack {
                // Reference the TextField here
                configuration
                    .foregroundColor(AppColors.fontColor)
                
            }
            .padding(.leading)
            .foregroundColor(.gray)
        }
    }
}
