//
//  MenuButton.swift
//  JobHuntr
//
//  Created by Adam Ali on 05/03/2023.
//

import SwiftUI

struct MenuButtonView: View {
    var iconName: String
    var title: String
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(AppColors.secondary)
                .frame(height: 64)
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(AppColors.fontColor)
                Text(title)
                    .font(.body)
                    .foregroundColor(AppColors.fontColor)
                Spacer()
            }
            .padding()
        }
        .padding(.vertical, 8)
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(iconName: "person.crop.circle.fill", title: "Your Profile")
    }
}
