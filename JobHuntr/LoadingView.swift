//
//  LoadingView.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack {
                Spacer()
                Image(uiImage: UIImage(named: "AppLogo") ?? UIImage())
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .frame(width: 128, height: 128)
                Spacer()
                ProgressCircle()
                    .frame(width: 48.0, height: 48.0)
                    .padding(20)
                Spacer()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
