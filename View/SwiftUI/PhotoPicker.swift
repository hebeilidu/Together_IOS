//
//  PhotoPicker.swift
//  Together
//
//  Created by lcx on 2021/11/29.
//

import SwiftUI
import Amplify

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var error: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                guard let imageData = image.jpegData(compressionQuality: 0.1),
                      let compressedImage = UIImage(data: imageData),
                      let imageKey = Amplify.Auth.getCurrentUser()?.username
                else {
                    DispatchQueue.main.async {
                        self.photoPicker.error = "Unable to change profile photo"
                    }
                    return
                }
                Amplify.Storage.uploadData(key: imageKey, data: imageData) {
                    result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.photoPicker.image = compressedImage
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.photoPicker.error = error.errorDescription
                        }
                    }
                }
            }
            picker.dismiss(animated: true)
        }
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker(image: .constant(UIImage(systemName: "person")), error: .constant(""))
    }
}
