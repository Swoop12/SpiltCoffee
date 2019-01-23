//
//  UIView+Extension.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import AVKit

//MARK: - Simple View Presentations

extension UIViewController: GenericDataSourceVCDelegate {
    
    func presentSimpleAlertWith(title: String, body: String?){
        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAreYouSureAlert(title: String, body: String?, completion: @escaping (UIAlertAction) -> ()){
        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Yes", style: .default, handler: completion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func prepareAndPerformSegue<T>(for dataType: DataType, with data: T?){
        
        var viewController: UIViewController!
        
        switch dataType {
        case .roaster:
            viewController = UIStoryboard(name: "RoasterProfile", bundle: .main).instantiateViewController(withIdentifier: "RoasterProfile")
            let vc = viewController as? RoasterProfileViewController
            vc?.roaster = data as? Roaster
        case .enthusiast:
            viewController = UIStoryboard(name: "UserProfile", bundle: .main).instantiateViewController(withIdentifier: "UserProfile")
            let vc = viewController as? BaseUserProfileViewController
        case .post:
            viewController = UIStoryboard(name: "RoasterProfile", bundle: .main).instantiateViewController(withIdentifier: "PostViewController")
            let vc = viewController as? PostDetailViewController
            vc?.post = data as? Post
        case .product, .coffeeBean:
            viewController = UIStoryboard(name: "RoasterProfile", bundle: .main).instantiateViewController(withIdentifier: "ProductDetailVC")
            let vc = viewController as? ProductDetailViewController
            vc?.product = data as? Product
        case .recepie:
            viewController = UIStoryboard(name: "Recepie", bundle: .main).instantiateInitialViewController()
            let vc = viewController as? RecepieDetailViewController
            vc?.recepie = data as? Recepie
        default:
            fatalError("Print You cliced on a cell I was not prepared for")
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func unwrapTextFields(_ textFields: UITextField...) -> [String]?{
        var textArray: [String] = []
        for textField in textFields{
            if let text = textField.text, !text.isEmpty{
                textArray.append(text)
            }else {
                return nil
            }
        }
        return textArray
    }
    
    func presentAVPlayerVC(with player: AVPlayer){
        let controller = AVPlayerViewController()
        controller.player = player
        self.present(controller, animated: true, completion: {
            player.play()
        })
    }
}

//MARK: - TextField and TextView Delegates
extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

//MARK: - ImagePicker Extension

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func presentImagePickerWith(alertTitle: String, message: String?){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alert: UIAlertController!
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .actionSheet)
        }else{
            alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
                UIImagePickerController.availableMediaTypes(for: .photoLibrary)
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
