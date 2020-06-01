//
//  LaunchCopyViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/25/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class LaunchCopyViewController: UIViewController {
    
    var firstLoad: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user{
            print("User on googles server is \(user.displayName) \(user)")
            print("Looking for user with ID \(user.uid)")
            UserController.shared.fetchFullUser(id: user.uid) { (enthusiast) in
                guard let enthusiast = enthusiast else {
                    try? Auth.auth().signOut()
                    self.presentSignInVC()
                    return
                }
                UserController.shared.currentUser = enthusiast
                self.presentMainInterface()
            }
        }else {
            self.presentSignInVC()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !firstLoad{
            presentSignInVC()
        }
        firstLoad = false
    }
    
    func presentSignInVC(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toSignUp", sender: self)
        }
    }
    
    func presentMainInterface(){
        let spiltTabBarController = SpiltTabBarController()
        UIApplication.shared.keyWindow?.rootViewController = spiltTabBarController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
