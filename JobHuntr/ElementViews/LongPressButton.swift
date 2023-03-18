//
//  LongPressButton.swift
//  JobHuntr
//
//  Created by Adam Ali on 18/03/2023.
//

import SwiftUI

struct LongPressButton<Label>: View where Label: View {
    let action: () -> Void
    let label: () -> Label
    
    @GestureState private var isLongPressing = false
    
    var body: some View {
        let longPressGesture = LongPressGesture(minimumDuration: 1.0)
            .updating($isLongPressing) { value, state, _ in
                state = value
            }
            .onEnded { _ in
                self.action()
            }
        
        return Button(action: {}, label: label)
            .simultaneousGesture(longPressGesture)
            .buttonStyle(PlainButtonStyle())
    }
}

struct LongPressButton_Previews: PreviewProvider {
    static var previews: some View {
        LongPressButton(action: {}, label: {Text("Test Button")})
    }
}
