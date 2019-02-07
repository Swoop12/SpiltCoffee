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
      
      let homeIcon = #imageLiteral(resourceName: "home").withRenderingMode(.alwaysTemplate)
      let profileIcon = #imageLiteral(resourceName: "barista").withRenderingMode(.alwaysTemplate)
      let shopIcon = #imageLiteral(resourceName: "shop").withRenderingMode(.alwaysTemplate)
      let brewIcon = #imageLiteral(resourceName: "brew").withRenderingMode(.alwaysTemplate)
      let discoverIcon = #imageLiteral(resourceName: "discover").withRenderingMode(.alwaysTemplate)
      
        home.tabBarItem = UITabBarItem(title: "Home", image: homeIcon, selectedImage: homeIcon)
        profile.tabBarItem = UITabBarItem(title: "Profile", image: profileIcon, selectedImage: profileIcon)
        shop.tabBarItem = UITabBarItem(title: "Shop", image: shopIcon, selectedImage: shopIcon)
        brew.tabBarItem = UITabBarItem(title: "Brew", image: brewIcon, selectedImage: brewIcon)
        discover.tabBarItem = UITabBarItem(title: "Discover", image: discoverIcon, selectedImage: discoverIcon)
        
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
