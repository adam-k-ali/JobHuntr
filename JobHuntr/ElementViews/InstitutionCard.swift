//
//  InstitutionCard.swift
//  JobHuntr
//
//  Created by Adam Ali on 17/03/2023.
//

import SwiftUI

enum InstitutionType {
    case education
    case placeOfWork
}

struct InstitutionCard: View {
    
    /// The title of the institution
    var type: InstitutionType
    
    /// The name of the institution
    var companyID: String
    @State var companyName: String = ""
    
    /// The title of the role the user took on here. e.g. Course name or Job Title.
    var title: String
    
    var subheading: String = ""
    
    var body: some View {
        HStack {
            switch type {
            case .education:
                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .frame(width: 48.0, height: 48.0)
            case .placeOfWork:
                Image(systemName: "studentdesk")
                    .resizable()
                    .frame(width: 48.0, height: 48.0)
            }
            VStack(alignment: .leading) {
                Text(companyName)
                    .font(.headline)
                Text(title)
                    .font(.subheadline)
                Text(subheading)
                    .font(.caption)
            }
            .padding()
        }
        .onAppear {
            Task {
                if let company = await GlobalDataManager.fetchCompany(id: companyID) {
                    companyName = company.name
                } else {
                    companyName = "Unknown Company"
                }
            }
        }
    }
}

struct InstitutionCard_Previews: PreviewProvider {
    static var previews: some View {
        InstitutionCard(type: .education, companyID: "1", title: "MEng Computer Science")
    }
}
