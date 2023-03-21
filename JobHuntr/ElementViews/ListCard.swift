//
//  ListCard.swift
//  JobHuntr
//
//  Created by Adam Ali on 21/03/2023.
//

import SwiftUI

struct ListCard<Content>: View where Content: View {
    let content: () -> Content
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(AppColors.secondary)
            content()
                .padding()
        }
    }
}

struct ListCard_Previews: PreviewProvider {
    static var previews: some View {
        ListCard() {
            Text("Hello, World!")
        }
    }
}
