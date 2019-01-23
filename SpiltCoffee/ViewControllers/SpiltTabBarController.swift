//
//  SpiltTabBarController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/15/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class SpiltTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let home = UIStoryboard(name: "Home", bundle: .main).instantiateInitialViewController(),
            let profile = UserController.shared.currentUser is Roaster ? UIStoryboard(name: "RoasterProfile", bundle: .main).instantiateInitialViewController() : UIStoryboard(name: "UserProfile", bundle: .main).instantiateInitialViewController(),
            let shop = UIStoryboard(name: "Shop", bundle: .main).instantiateInitialViewController(),
            let brew = UIStoryboard(name: "Brew", bundle: .main).instantiateInitialViewController(),
            let discover = UIStoryboard(name: "Discover", bundle: .main).instantiateInitialViewController() else {return}
        
        home.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "HomeIconSmall"), selectedImage: #imageLiteral(resourceName: "HomeIconSmall"))
        profile.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "ProfileIconSmall"), selectedImage: #imageLiteral(resourceName: "ProfileIconSmall"))
        shop.tabBarItem = UITabBarItem(title: "Shop", image: #imageLiteral(resourceName: "CartIconSmall"), selectedImage: #imageLiteral(resourceName: "CartIconSmall"))
        brew.tabBarItem = UITabBarItem(title: "Brew", image: #imageLiteral(resourceName: "CoffeeIconSmall"), selectedImage: #imageLiteral(resourceName: "CoffeeIconSmall"))
        discover.tabBarItem = UITabBarItem(title: "Discover", image: #imageLiteral(resourceName: "DiscoverIconSmall"), selectedImage: #imageLiteral(resourceName: "DiscoverIconSmall"))
        
        tabBar.tintColor = UIColor.mossGreen
        if let profileNav = profile as? UINavigationController{
            if let roasterProfile = profileNav.viewControllers.first as? RoasterProfileViewController{
                roasterProfile.roaster = UserController.shared.currentUser as? Roaster
            }else if let enthusiastProfile = profileNav.viewControllers.first as? BaseUserProfileViewController{
                enthusiastProfile.enthusiast = UserController.shared.currentUser
            }
        }
        self.viewControllers = [home, discover, shop, brew, profile]
        
        
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
