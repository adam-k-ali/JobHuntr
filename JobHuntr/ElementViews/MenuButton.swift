//
//  MenuButton.swift
//  JobHuntr
//
//  Created by Adam Ali on 05/03/2023.
//

import SwiftUI

struct MenuButton: View {
    var iconName: String
    var title: String
    var onClick: () -> Void
    
    
    var body: some View {
        Button(action: onClick, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.gray)
                HStack {
                    Image(systemName: iconName)
                    Text(title)
                        .font(.body)
                }
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(iconName: "person.crop.circle.fill", title: "Your Profile", onClick: {})
    }
}
