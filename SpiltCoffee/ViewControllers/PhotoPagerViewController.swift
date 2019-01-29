//
//  PhotoPagerViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/27/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class PhotoPagerViewController: UIPageViewController {
  
  //MARK: - Properties
  var photos: [UIImage] = []{
    didSet{
      guard !photos.isEmpty else { return }
      setViewControllers([self.generateViewController(for: photos[0])], direction: .forward, animated: true, completion: nil)
    }
  }
  var selectedIndex = 0
  
  //MARK: - Computed Properties
  var previousIndex: Int{
      return selectedIndex == 0 ? photos.count - 1 : selectedIndex - 1
  }
  
  var nextIndex: Int{
    return selectedIndex == photos.count - 1 ? 0 : selectedIndex + 1
  }
  
  //MARK: - View Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}

extension PhotoPagerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let photo = photos[nextIndex]
    return generateViewController(for: photo)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let photo = photos[previousIndex]
    return generateViewController(for: photo)
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return photos.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return selectedIndex
  }
}

extension PhotoPagerViewController{
  func generateViewController(for image: UIImage) -> UIViewController{
    let viewController = UIStoryboard(name: "PhotoPager", bundle: .main).instantiateViewController(withIdentifier: "photoVC") as! PhotoViewController
    viewController.setPhoto(image)
    return viewController
  }
  
}
