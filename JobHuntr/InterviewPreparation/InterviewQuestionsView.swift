//
//  InterviewQuestionsView.swift
//  JobHuntr
//
//  Created by Adam Ali on 05/04/2023.
//

import SwiftUI

struct InterviewQuestionsView: View {
    var questions: [String] = [
        "Tell me about yourself.",
        "Why do you want to work here?"
    ]
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    Section(header:
                                Text("General Questions")
                        .font(.callout)
                        .padding(.leading)
                            , content: {
                        ForEach(questions, id: \.self) { question in
                            ListCard {
                                Text(question)
                            }
                        }
                    })
                }
            }
            .padding()
        }
    }
}

struct InterviewQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InterviewQuestionsView()
        }
    }
}
