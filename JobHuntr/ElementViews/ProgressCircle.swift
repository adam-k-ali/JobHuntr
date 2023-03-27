//
//  ProgressCircle.swift
//  JobHuntr
//
//  Created by Adam Ali on 19/03/2023.
//

import SwiftUI

struct ProgressCircle: View {
    @State var rotation: Angle = .degrees(0)
    
    var body: some View {
        Circle()
            .trim(from: 0.3, to: 1)
            .stroke(
                LinearGradient(
                    colors: [
                        .red,
                        .accentColor
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 5, lineCap: .round)
            )
            .rotationEffect(rotation)
            .shadow(radius: 3.0, x: 0, y: 3)
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        self.rotation = .degrees(360)
                    }
                }
            }
            
    }
}

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircle()
    }
}
