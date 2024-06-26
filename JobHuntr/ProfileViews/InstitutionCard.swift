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
    
    var isLink: Bool = false
    
    var body: some View {
        HStack {
            ZStack {
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
            }
            .padding(.leading, 16)
            
            VStack(alignment: .leading) {
                Text(companyName)
                    .font(.headline)
                Text(title)
                    .font(.subheadline)
                Text(subheading)
                    .font(.caption)
            }
            .padding()
//            .padding()
            Spacer()
            if isLink {
                Image(systemName: "chevron.right")
                    .padding()
            }
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                Task {
                    if let company = await GlobalDataManager.fetchCompany(id: companyID) {
                        companyName = company.name
                    } else {
                        companyName = "Unknown Company"
                    }
                }
            } else {
                companyName = "Unknown Company"
            }
        }
    }
}

struct InstitutionCard_Previews: PreviewProvider {
    static var previews: some View {
        InstitutionCard(type: .education, companyID: "1", title: "MEng Computer Science")
    }
}
