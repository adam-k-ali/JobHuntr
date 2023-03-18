//
//  CompanyCardView.swift
//  JobHuntr
//
//  Created by Adam Ali on 13/02/2023.
//

import SwiftUI

struct CompanyCardView: View {
    let company: Company
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(company.name)
                .font(.headline)
            Divider()
            if let website = URL(string: company.website) {
                if !company.website.isEmpty {
                    Link(destination: website) {
                        HStack {
                            Image(systemName: "globe")
                            Text(company.website)
                        }
                    }
                    Divider()
                }
            }
            if let phone = URL(string: "tel:\(company.phone)") {
                if !company.phone.isEmpty {
                    Link(destination: phone) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text(company.phone)
                        }
                    }
                    Divider()
                }
            }
            if let email = URL(string: "mailto:\(company.email)") {
                if !company.email.isEmpty {
                    Link(destination: email) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text(company.email)
                        }
                    }
                    Divider()
                }
            }
        }
        .padding()
    }
}

struct CompanyCardView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyCardView(company: Company.sampleCompany)
    }
}

extension Company {
    static let sampleCompany = Company(
        id: "1",
        name: "Acme Inc.",
        website: "https://acme.com",
        email: "info@acme.com",
        phone: "+1-555-123-4567"
    )
}
