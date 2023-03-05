//
//  StatCardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 05/03/2023.
//

import SwiftUI

struct StatCardView: View {
    var iconName: String
    var title: String
    var value: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .frame(width: 150, height: 64)
                .foregroundColor(Color(uiColor: .systemGray5))
                .shadow(radius: 2.0, x: 1, y: 2)
            HStack {
                Image(systemName: iconName)
                VStack(alignment: .leading) {
                    Text("\(value)")
                        .font(.headline)
                    Text(title)
                        .font(.caption)
                }
            }
        }
        
    }
}

struct StatCardView_Previews: PreviewProvider {
    static var previews: some View {
        StatCardView(iconName: "tray.full.fill", title: "Applications", value: 14)
    }
}
