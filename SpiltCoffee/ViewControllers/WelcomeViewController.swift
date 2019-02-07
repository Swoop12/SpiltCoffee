//
//  WelcomeViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/22/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
  @IBOutlet weak var photoSelectorContainerView: UIView!
  
  var photo: UIImage?
  
  var textFields: [UITextField]!
  override func viewDidLoad() {
    super.viewDidLoad()
    textFields = [nameTextField,
                  emailTextField,
                  passwordTextField,
                  confirmPasswordTextField]
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    toggleLoginSignUp()
    textFields.forEach{ $0.delegate = self }
  }
  
  func toggleLoginSignUp(){
    if loginSegmentedControl.selectedSegmentIndex == 0{
      UIView.animate(withDuration: 0.3, animations: {
        self.photoSelectorContainerView.alpha = 0
      }) { (_) in
        UIView.animate(withDuration: 0.3, animations: {
          self.nameTextField.isHidden = true
          self.confirmPasswordTextField.isHidden = true
          self.photoSelectorContainerView.isHidden = true
        })
      }
    }else {
      UIView.animate(withDuration: 0.3, animations: {
        self.photoSelectorContainerView.isHidden = false
        self.nameTextField.isHidden = false
        self.confirmPasswordTextField.isHidden = false
      }) { (_) in
        UIView.animate(withDuration: 0.3, animations: {
          self.photoSelectorContainerView.alpha = 1
        })
      }
    }
  }
  
  func signUpUser(){
    if let userInfo = self.unwrapTextFields(nameTextField, emailTextField, passwordTextField, confirmPasswordTextField), passwordTextField.text == confirmPasswordTextField.text{
      Auth.auth().createUser(withEmail: emailTextField.text!
      , password: passwordTextField.text!) { (authResult, error) in
        if let error = error {
          self.presentSimpleAlertWith(title: "Whoops", body:  error.localizedDescription)
          print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
          return
        }
        guard let authResult = authResult else {
          self.presentSimpleAlertWith(title: "Whoops", body: "Looks like something went wrong trying to create your account 💩")
          return
        }
        let id = authResult.user.uid
        let user = UserController.shared.createNewUser(name: userInfo[0], email: userInfo[1], profilePicture: self.photo, uuid: id,  completion: { (success) in
          if success{
            print("User Successfully Saved To Firestore")
            self.presentMainAppInterface()
            return
          } else{
            self.presentSimpleAlertWith(title: "Whoops", body: "Looks like something went wrong trying to create your account 💩")
            return
          }
        })
        UserController.shared.currentUser = user
      }
    }
  }
  
  func loginUser(){
    guard let userInfo = self.unwrapTextFields(emailTextField, passwordTextField) else {
      presentSimpleAlertWith(title: "Whoops", body: "Please make sure you have filled in an email and password.")
      return
    }
    Auth.auth().signIn(withEmail: userInfo[0], password: userInfo[1]) { (authResult, error) in
      if let error = error {
        print("💩  There was an error in \(#function) ; \(error)  ; \(error.localizedDescription)  💩")
        self.presentSimpleAlertWith(title: "Whoops", body: "Something went wrong logging you in.  Make sure your email and password are correct.")
        return
      }
      guard let authResult = authResult else { return }
      let id = authResult.user.uid
      UserController.shared.fetchFullUser(id: id, completion: { (user) in
        guard let user = user else {
          print("No user returned from Client Firebase libary")
          self.presentSimpleAlertWith(title: "Whoops", body: "Something went wrong logging you in.  Make sure your email and password are correct.")
          return
        }
        UserController.shared.currentUser = user
        self.presentMainAppInterface()
      })
    }
  }
  
  func presentMainAppInterface(){
    DispatchQueue.main.async {
      let spiltTabBarController = SpiltTabBarController()
      self.present(spiltTabBarController, animated: true, completion: nil)
    }
  }
  
  @IBAction func loginToggled(_ sender: Any) {
    self.toggleLoginSignUp()
  }
  
  @IBAction func startSpillingButtonTapped(_ sender: UIButton) {
    switch loginSegmentedControl.selectedSegmentIndex{
    case 0:
      loginUser()
    case 1:
      signUpUser()
    default: break
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "photoSelectorVC"{
      let destinationVC = segue.destination as? PhotoSelectorViewController
      destinationVC?.isEditingEnabled = true
      destinationVC?.delegate = self
    }
  }
}

//MARK: - TextFieldDelegate
extension WelcomeViewController {
  override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let currentFieldIndex = textFields.index(of: textField),
      currentFieldIndex + 1 < textFields.count else {
      textField.resignFirstResponder()
      return true
    }
    let nextField = textFields[currentFieldIndex + 1]
    nextField.becomeFirstResponder()
    return true
  }
}

extension WelcomeViewController: PhotoSelectorViewControllerDeleate {
  
  func photoSelected(_ photo: UIImage) {
    self.photo = photo
  }
}

extension WelcomeViewController {
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0 {
        UIView.animate(withDuration: 0.3){
          self.view.frame.origin.y -= keyboardSize.height/2
        }
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    DispatchQueue.main.async {
      self.shiftFrameBackDown()
    }
  }
  
  func shiftFrameBackDown(){
    UIView.animate(withDuration: 0.3){
      if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
      }
    }
  }
}
