//
//  StatCardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 05/03/2023.
//

import SwiftUI

struct StatCardView<Content>: View where Content: View {
    var title: String
    @Binding var value: Int
    
    let icon: () -> Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .frame(width: 150, height: 64)
                .foregroundColor(AppColors.secondary)
                .shadow(radius: 2.0, x: 1, y: 2)
            HStack(spacing: 16) {
                icon()
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
        StatCardView(title: "Applications", value: .constant(14)) {
            Image(systemName: "tray.full.fill")
        }
    }
}
