//
//  ListCard.swift
//  JobHuntr
//
//  Created by Adam Ali on 21/03/2023.
//

import SwiftUI

struct ListCard<Content>: View where Content: View {
    var isChangeable: Bool = false
    var onDelete: () -> Void = {}
    var onEdit: () -> Void = {}
    let content: () -> Content
    
    var body: some View {
        if isChangeable {
            root
                .contextMenu {
                    menu
                }
        } else {
            root
        }
    }
    
    var root: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(AppColors.secondary)
            content()
                .padding()
        }
    }
    
    var menu: some View {
        Group {
//            Button(action: onEdit, label: {
//                Image(systemName: "pencil")
//                Text("Edit")
//            })
            Button(action: onDelete, label: {
                Image(systemName: "trash")
                Text("Delete")
            })
        }
    }
}

struct ListCard_Previews: PreviewProvider {
    static var previews: some View {
        ListCard() {
            Text("Hello, World!")
        }
    }
}
