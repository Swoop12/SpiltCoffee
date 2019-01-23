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
    
    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleLoginSignUp()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func toggleLoginSignUp(){
        if loginSegmentedControl.selectedSegmentIndex == 0{
            profileImageContainerView.isHidden = true
            nameTextField.isHidden = true
            confirmPasswordTextField.isHidden = true
        }else {
            profileImageContainerView.isHidden = false
            nameTextField.isHidden = false
            confirmPasswordTextField.isHidden = false
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
        if let userInfo = self.unwrapTextFields(emailTextField, passwordTextField){
            print(userInfo[0])
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
    }
    
    func presentMainAppInterface(){
        DispatchQueue.main.async {
            let spiltTabBarController = SpiltTabBarController()
            self.present(spiltTabBarController, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginToggled(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.toggleLoginSignUp()
        }
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
            destinationVC?.delegate = self
        }
    }
}

extension WelcomeViewController: PhotoSelectorViewControllerDeleate {
    
    func photoSelected(_ photo: UIImage) {
        self.photo = photo
    }
}
