//
//  PhotoViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 1/27/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class PhotoPagerViewContoller: UIViewController {
  
  //MARK: - IBOutlets
  @IBOutlet weak var photoPageControl: UIPageControl!
  @IBOutlet weak var photoCollectionView : UICollectionView!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var addPhotoButton: UIButton!
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var editingButtonsStackView: UIStackView!
  
  //MARK: - Properties
  var photoSources: [PhotoSource] = []
  var isEditingEnabled: Bool = false{
    didSet{
      loadViewIfNeeded()
      toggleEditingVisibility()
    }
  }
  
  var isEditting: Bool = false
  
  var photos: [UIImage] {
    return photoSources.compactMap({ $0.photo })
  }
  
  var buttons: [UIButton] {
    return [
      deleteButton,
      addPhotoButton,
      moreButton,
      previousButton,
      nextButton
    ]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updatePageControll()
    setUpPhotoCollectionView()
    self.view.addShadow()
    for button in buttons {
      button.addShadow()
    }
  }
  
  //MARK: - Methods
  func setUpPhotoCollectionView(){
    photoCollectionView.dataSource = self
    photoCollectionView.delegate = self
    photoCollectionView.isPagingEnabled = true
  }
  
  func toggleEditingVisibility() {
    editingButtonsStackView.isHidden = !isEditingEnabled
  }
  
  func updatePageControll(){
    photoPageControl.numberOfPages = photoSources.count
    let visibleIndexPaths = photoCollectionView.indexPathsForVisibleItems
    print("😱 \(visibleIndexPaths) ")
    guard let selected = visibleIndexPaths.last else { return }
    photoPageControl.currentPage = selected.row
  }
  
  func showEditInfo(){
    isEditting = true
    deleteButton.isHidden = false
    addPhotoButton.isHidden = false
    moreButton.setImage(#imageLiteral(resourceName: "collapseRightButton"), for: .normal)
  }
  
  func collapseEditInfo(){
    isEditting = false
    deleteButton.isHidden = true
    addPhotoButton.isHidden = true
    moreButton.setImage(#imageLiteral(resourceName: "menuButton"), for: .normal)
  }
  
  func add(_ photo: UIImage){
    let photoSource = PhotoSource(imageUrl: nil, photo: photo)
    photoSources.append(photoSource)
    photoCollectionView.reloadData()
    let indexPath = IndexPath(row: photoSources.count - 1, section: 0)
    photoCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    updatePageControll()
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let photo = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
    add(photo)
  }
  
  func removePhoto(){
    guard let visibleIndexPath = photoCollectionView.indexPathsForVisibleItems.first else { return }
    photoSources.remove(at: visibleIndexPath.row)
    photoCollectionView.deleteItems(at: [visibleIndexPath])
    updatePageControll()
  }
  
  public func setPager(for photos: [UIImage]) {
    let photoSources = photos.compactMap{ PhotoSource(imageUrl: nil, photo: $0)}
    self.photoSources = photoSources
    photoCollectionView.reloadData()
    updatePageControll()
  }
  
  public func setPagerFor(urls: [String]) {
    self.loadViewIfNeeded()
    let photoSources = urls.compactMap{ PhotoSource(imageUrl: $0, photo: nil)}
    self.photoSources = photoSources
    updatePageControll()
  }
  
  //MARK: - Actions
  @IBAction func previousButtonTapped(_ sender: Any) {
    guard let visibleIndexPath = photoCollectionView.indexPathsForVisibleItems.first,
      visibleIndexPath.row - 1 >= 0 else { return }
    let previousIndexPath = IndexPath(row: visibleIndexPath.row - 1, section: 0)
    photoCollectionView.selectItem(at: previousIndexPath, animated: true, scrollPosition: .centeredHorizontally)
  }
  
  @IBAction func nextButtonTapped(_ sender: Any) {
    guard let visibleIndexPath = photoCollectionView.indexPathsForVisibleItems.first,
      visibleIndexPath.row + 1 < photoSources.count else { return }
    let nextIndexPath = IndexPath(row: visibleIndexPath.row + 1, section: 0)
    photoCollectionView.selectItem(at: nextIndexPath, animated: true, scrollPosition: .centeredHorizontally)
  }
  
  @IBAction func moreButtonTapped(_ sender: Any) {
    UIView.animate(withDuration: 0.2) {
      self.isEditting ? self.collapseEditInfo() : self.showEditInfo()
    }
  }
  
  @IBAction func deleteButtonTapped(_ sender: Any) {
    presentAreYouSureAlert(title: "Are you sure you want to delete this photo?", body: nil) { (_) in
      self.removePhoto()
    }
  }
  
  @IBAction func addPhotoButtonTapped(_ sender: Any) {
    self.presentImagePickerWith(alertTitle: "Select A new Image", message: nil)
  }
}

extension PhotoPagerViewContoller: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photoSources.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoPagerCell
    let photoSource = photoSources[indexPath.row]
    cell.delegate = self
    cell.photoImageView.photoSource = photoSource
    return cell
  }
}

extension PhotoPagerViewContoller: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return self.view.frame.size
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

extension PhotoPagerViewContoller: UICollectionViewDelegate {
//  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//    updatePageControll()
//  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    photoPageControl.currentPage = indexPath.row
  }
}

extension PhotoPagerViewContoller: PhotoPagerCellDelegate{
  
  func photoRetrieved(photo: UIImage, urlString: String) {
    let photoSource = PhotoSource.init(imageUrl: urlString, photo: photo)
    guard let index = photoSources.index(of: photoSource) else { return }
    photoSources[index] = photoSource
  }
}
