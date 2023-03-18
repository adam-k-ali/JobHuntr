//
//  SkillCardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 18/03/2023.
//

import SwiftUI

struct SkillCardView<Content: View>: View {
    @ViewBuilder var content: Content
    var onClick: () -> () = {}
    
    let idleColor: Color = Color(uiColor: .systemIndigo)
    
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .frame(height: 32)
                .foregroundColor(idleColor.opacity(opacity))
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        opacity = 0.7
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            opacity = 1.0
                        }
                    }
                }
            
            content
                .padding()
        }
    }
}

struct SkillCardView_Previews: PreviewProvider {
    static var previews: some View {
        SkillCardView(content: {Text("Hello, World!")})
    }
}
