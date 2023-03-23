//
//  ProgressionView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import SwiftUI

struct ProgressionView: View {
    var applicationStage: ApplicationStage
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(AppColors.primary)
                .frame(height: 128)
            let currentStage = enumerateStage(applicationStage)
            HStack {
                VStack(alignment: .leading) {
                    Circle()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal)
                        .foregroundColor(
                            currentStage >= enumerateStage(.applied) ? ApplicationStage.applied.color : Color(uiColor: .systemGray3))
                    Text("Applied")
                }
                VStack {
                    Circle()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal)
                        .foregroundColor(currentStage >= enumerateStage(.preInterview) ? ApplicationStage.preInterview.color : Color(uiColor: .systemGray3))
                    Text("Pre-Interview")
                }
                VStack {
                    Circle()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal)
                        .foregroundColor(currentStage >= enumerateStage(.interviewing) ? ApplicationStage.interviewing.color : Color(uiColor: .systemGray3))
                    Text("Interview")
                }
                
                VStack {
                    Circle()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal)
                        .foregroundColor(currentStage >= enumerateStage(.offer) ? applicationStage.color : Color(uiColor: .systemGray3)
                        )
                    Text("Offer")
                }
            }
        }
//        .padding()

    }
    
    func enumerateStage(_ applicationStage: ApplicationStage) -> Int {
        switch applicationStage {
        case .applied:
            return 0
        case .preInterview:
            return 1
        case .interviewing:
            return 2
        case .offer:
            return 3
        case .rejection:
            return 4
        case .accepted:
            return 5
        }
    }
}

struct ProgressionView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressionView(applicationStage: .accepted)
    }
}
