//
//  ProgressCircle.swift
//  JobHuntr
//
//  Created by Adam Ali on 19/03/2023.
//

import SwiftUI

struct ProgressCircle: View {
    @State var isRotating: Bool = false
    
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
            .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
            .shadow(radius: 3.0, x: 0, y: 3)
            .animation(.linear(duration: 2.0).repeatForever(autoreverses: false))
            .onAppear {
                isRotating = true
            }
            
    }
}

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircle()
    }
}
