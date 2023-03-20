//
//  JHListStyle.swift
//  JobHuntr
//
//  Created by Adam Ali on 19/03/2023.
//

import SwiftUI

struct JHListStyle: ListStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        InsetGroupedListStyle()
            .makeBody(configuration: configuration)
            .background(backgroundColor)
    }
}
