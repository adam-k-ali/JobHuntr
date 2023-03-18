//
//  CircleCameraView.swift
//  JobHuntr
//
//  Created by Adam Ali on 10/03/2023.
//

import SwiftUI

struct CircleCameraView: View {
    var body: some View {
        Color.gray.opacity(0.5)
            .cutout(Circle().scale(0.5))
    }
}

extension View {
    func cutout<S: Shape>(_ shape: S) -> some View {
        self.clipShape(StackedShape(bottom: Rectangle(), top: shape), style: FillStyle(eoFill: true))
    }
}

struct StackedShape<Bottom: Shape, Top: Shape>: Shape {
    var bottom: Bottom // The shape at the bottom of the stack
    var top: Top // The shape at the top of the stack
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addPath(bottom.path(in: rect))
            path.addPath(top.path(in: rect))
        }
    }
}

struct CircleCameraView_Previews: PreviewProvider {
    static var previews: some View {
        CircleCameraView()
    }
}
