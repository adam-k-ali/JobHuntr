//
//  EditEducationView.swift
//  JobHuntr
//
//  Created by Adam Ali on 21/03/2023.
//

import SwiftUI
import Amplify

struct EditEducationView: View {
    @State var education: Education
    
    @State var institutionName: String = ""
    
    var body: some View {
        Form {
            TextField("Institution Name", text: $institutionName)
            
        }
    }
}

struct EditEducationView_Previews: PreviewProvider {
    static var previews: some View {
        EditEducationView(education: Education(userID: "", companyID: "", startDate: Temporal.Date.now(), endDate: Temporal.Date.now(), roleName: ""))
    }
}
