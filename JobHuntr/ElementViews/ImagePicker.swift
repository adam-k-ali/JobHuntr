//
//  ImagePicker.swift
//  JobHuntr
//
//  Created by Adam Ali on 07/03/2023.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
//    @Binding var image: Image?
    @Binding var uiImage: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        if picker.sourceType == .camera {
            print("Setting up overlay")
            let cameraView = CircleCameraView()
            let hostingController = UIHostingController(rootView: cameraView)
            
            picker.cameraOverlayView = hostingController.view
            picker.cameraDevice = .front
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                parent.image = Image(uiImage: image)
                parent.uiImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
