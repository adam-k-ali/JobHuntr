//
//  CategoryCapsuleView.swift
//  JobHuntr
//
//  Created by Adam Ali on 05/03/2023.
//

import SwiftUI

struct CategoryCapsuleView: View {
    var title: String
    var color: Color
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(color)
                .frame(width: 128, height: 32)
            Text(title)
                .font(.body)
        }
    }
}

struct CategoryCapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCapsuleView(title: "Applied", color: ApplicationStage.applied.color)
    }
}
