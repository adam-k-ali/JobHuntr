//
//  LoadingView.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI

struct LoadingView: View {
    @Binding var progressValue: Float
    
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                .frame(width: 128, height: 128)
            ProgressBar(value: $progressValue)
                .frame(height: 20)
                .padding(20)
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(progressValue: .constant(0.25))
    }
}
