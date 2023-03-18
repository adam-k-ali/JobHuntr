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
//            RoundedRectangle(cornerRadius: 6)
//                .foregroundColor(.gray)
//                .frame(width: .infinity, height: 50)
            HStack {
                Image(systemName: iconName)
                Text(title)
                    .font(.body)
                Spacer()
            }.padding()
        }
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(iconName: "person.crop.circle.fill", title: "Your Profile")
    }
}
