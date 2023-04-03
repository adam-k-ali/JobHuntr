//
//  EditableImage.swift
//  JobHuntr
//
//  Created by Adam Ali on 07/03/2023.
//

import SwiftUI

struct EditableImage: View {
    @State private var showPickSource = false
    @State private var showImagePicker = false
//    @State private var image: Image?
    @State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @EnvironmentObject var userManager: UserManager
    
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if image != nil {
//                image!
                Image(uiImage: image!)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: width ?? 64.0, height: height ?? 64.0)
            } else {
                if let profilePic = userManager.profile.profilePic {
                    Image(uiImage: profilePic)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width ?? 64.0, height: height ?? 64.0)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width ?? 64.0, height: height ?? 64.0)
                }
                
                    
            }
            
            Button(action: {
                self.showPickSource = true
            }, label: {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: (width ?? 64.0) / 3, height: (width ?? 64.0) / 3)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
            })
            .actionSheet(isPresented: $showPickSource) {
                ActionSheet(title: Text(""), buttons: [
                    .cancel(),
                    .default(Text("Take Photo"), action: {
                        showImagePicker = true
                        sourceType = .camera
                    }),
                    .default(Text("Choose Photo"), action: {
                        showImagePicker = true
                        sourceType = .photoLibrary
                    })
                ])
            }
            
        }
        .onDisappear {
            Task {
                if let image = image {
                    userManager.profile.profilePic = image
                    await userManager.profile.saveProfilePicture()
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(uiImage: $image, sourceType: $sourceType)
        }
    }
    
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct EditableImage_Previews: PreviewProvider {
    static var previews: some View {
        EditableImage(width: 64.0, height: 64.0)
            .environmentObject(UserManager())
    }
}
