//
//  UIImagePickerController+Extensions.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 21.07.2024.
//

import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            setSelectedImage(selectedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !imageWasChanged {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return true }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            updateSaveButtonState(newName: updatedText)
        }
        return true
    }
}
