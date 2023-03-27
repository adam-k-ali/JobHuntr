//
//  SecureInputView.swift
//  JobHuntr
//
//  Created by Adam Ali on 25/03/2023.
//

import SwiftUI

struct SecureInputView: View {
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
                        .accentColor(.gray)
                        .padding(.trailing)
                }
            }
//            .padding(.trailing, 32)
            
        }
    }
}

struct SecureInputView_Previews: PreviewProvider {
    static var previews: some View {
        SecureInputView("Password", text: .constant("Example"))
            .textFieldStyle(GradientTextFieldBackground(systemImageString: "key"))
    }
}
