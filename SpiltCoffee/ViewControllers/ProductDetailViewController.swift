//
//  AddProductViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController{
  
  //MARK: - IBOUTLETS
  @IBOutlet weak var purchaseButton: UIButton!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var priceTextField: UITextField!
  @IBOutlet weak var photosCollectionView: UICollectionView!
  @IBOutlet weak var originStackView: UIStackView!
  @IBOutlet weak var originTextField: UITextField!
  @IBOutlet weak var productTypeTextField: UITextField!
  @IBOutlet weak var roastTextField: UITextField!
  @IBOutlet weak var roastStackView: UIStackView!
  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var addPhotoButton: UIButton!
  @IBOutlet weak var priceStackView: UIStackView!
  @IBOutlet var pickerView: UIPickerView!
  
  //MARK: - Properties
  var photoCollectionViewDataSource: DataViewGenericDataSource<UIImage>!
  var pickerViewData: [String]?
  
  //MARK: - ComputedProperties
  var isFavorite: Bool{
    guard let currentUser = UserController.shared.currentUser, let bean = product as? CoffeeBean else { return false }
    return currentUser.favoriteBeanIDs.contains(bean.uuid)
  }
  
  var product: Product?{
    didSet{
      loadViewIfNeeded()
      updateViews()
    }
  }
  
  var photos: [UIImage] = []{
    didSet{
      photoCollectionViewDataSource.sourceOfTruth = photos
      photosCollectionView.reloadData()
    }
  }
  
  //MARK: - View LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setDelegates()
    setDataSources()
  }
  
  //MARK: - Functions
  func setDelegates(){
    priceTextField.delegate = self
    productTypeTextField.delegate = self
    originTextField.delegate = self
    roastTextField.delegate = self
    descriptionTextView.delegate = self
    pickerView.delegate = self
  }
  
  func setDataSources(){
    pickerView.dataSource = self
    photoCollectionViewDataSource = DataViewGenericDataSource(dataView: photosCollectionView, dataType: .photo, data: self.photos)
  }
  
  func updateViews(){
    lockPermissionGuards()
    if let product = product {
      nameTextField.text = product.name
      self.productTypeTextField.text = product.productType.rawValue
      descriptionTextView.text = product.description
      purchaseButton.isHidden = false
      priceTextField.text = "\(product.price)"
      purchaseButton.setTitle("$\(product.price)", for: .normal)
      self.photos = product.photos
      
      if let bean = product as? CoffeeBean{
        customizeViewFor(coffeeBean: true, bean: bean)
      }else {
        customizeViewFor(coffeeBean: false, bean: nil)
      }
    }else {
      purchaseButton.isHidden = true
      heartButton.isHidden = true
      priceTextField.text = "\(product?.price ?? 00.00)"
      priceTextField.isHidden = false
    }
  }
  
  func customizeViewFor(coffeeBean: Bool, bean: CoffeeBean?){
    switch coffeeBean{
    case true:
      originStackView.isHidden = false
      roastStackView.isHidden = false
      heartButton.isHidden = false
      
      let heartImage = isFavorite ? #imageLiteral(resourceName: "HeartIcon") : #imageLiteral(resourceName: "HollowHeartIcon")
      heartButton.setImage(heartImage, for: .normal)
      originTextField.text = bean?.origin?.name ?? "?"
      roastTextField.text = bean?.roastType.rawValue
      
    case false:
      originStackView.isHidden = true
      roastStackView.isHidden = true
      heartButton.isHidden = true
    }
  }
  
  func lockPermissionGuards(){
    if UserController.shared.currentUser?.uuid == product?.roasterAbridgedDictionary?["uuid"] as? String || product == nil{
      nameTextField.isHidden = false
      descriptionTextView.isEditable = true
      productTypeTextField.isUserInteractionEnabled = true
      originTextField.isUserInteractionEnabled = true
      roastTextField.isUserInteractionEnabled = true
      priceStackView.isHidden = false
      priceTextField.isUserInteractionEnabled = true
      heartButton.isHidden = true
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProduct))
      self.title = product != nil ? "Edit Product" : "Add Product"
      addPhotoButton.isHidden = false
    }else{
      nameTextField.isHidden = true
      descriptionTextView.isEditable = false
      heartButton.isHidden = false
      productTypeTextField.isUserInteractionEnabled = false
      originTextField.isUserInteractionEnabled = false
      roastTextField.isUserInteractionEnabled = false
      priceTextField.isUserInteractionEnabled = false
      self.title = product?.name
      self.navigationItem.rightBarButtonItem = nil
      addPhotoButton.isHidden = true
    }
  }
  
  func saveProduct(){
    guard let name = nameTextField.text, !name.isEmpty,
      let description = descriptionTextView.text, !description.isEmpty,
      let priceText = priceTextField.text, !priceText.isEmpty, let price = Double(priceText),
      let roaster = UserController.shared.currentUser as? Roaster,
      let productTypeText = productTypeTextField.text, let productType = ProductType(rawValue: productTypeText) else {
        self.presentSimpleAlertWith(title: "Whoops looks like we're missing some info", body: "Please make sure you have filled in all the necessary fields")
        return
    }
    var roast: RoastType?
    var origin: Origin?
    if let roastString = roastTextField.text, !roastString.isEmpty{
      roast = RoastType(rawValue: roastString)
    }
    if let originString = originTextField.text, !originString.isEmpty{
      origin = Origin(name: originString)
    }
    if let product = product{
      ProductController.shared.update(product: product, name: name, price: price, description: description, photos: photos, productType: productType, completion: nil)
    }else if let bean = product as? CoffeeBean{
      bean.origin = origin
      bean.roastType = roast ?? .medium
      ProductController.shared.update(bean: bean, name: name, price: price, description: description, photos: photos, roastType: roast ?? .medium, origin: origin, completion: nil)
    }else{
      ProductController.shared.createProduct(name: name, price: price, description: description, photos: photos, roaster: roaster, productType: productType, completion: nil)
    }
    self.navigationController?.popViewController(animated: true)
  }
  
  //MARK: - IBActions
  @IBAction func addPhotoButtonTapped(_ sender: Any) {
    self.presentImagePickerWith(alertTitle: "Select Images of Your Product", message: nil)
  }
  
  @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    guard let bean = product as? CoffeeBean else { return }
    if isFavorite{
      ProductController.shared.unfavoriteBean(bean)
      sender.setImage(#imageLiteral(resourceName: "HollowHeartIcon"), for: .normal)
    }else {
      ProductController.shared.favoriteBean(bean)
      sender.setImage(#imageLiteral(resourceName: "HeartIcon"), for: .normal)
    }
  }
  
  @IBAction func purchaseButtonTapped(_ sender: Any) {
    self.presentSimpleAlertWith(title: "Visit \(self.product?.roaster?.name ?? "the Roasters") Website to Purchase", body: "In app purchases coming soon (:")
  }
  
}

//MARK: - UIPickerView DataSource & Delegate
extension ProductDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.pickerViewData?.count ?? 0
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let title = self.pickerViewData?[row]
    return title
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 50
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard let firstResponder = self.view.firstResponder else {return}
    if let textField = firstResponder as? UITextField{
      textField.text = pickerViewData?[row]
    }
    firstResponder.resignFirstResponder()
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    configureKeyboard(for: textField)
  }
  
  func configureKeyboard(for textField: UITextField){
    switch textField {
    case priceTextField:
      textField.keyboardType = .decimalPad
    default:
      configurePickerView(textField: textField)
    }
  }
  
  
  func configurePickerView(textField: UITextField){
    switch textField {
    case originTextField:
      self.pickerViewData = Origin.countries.compactMap{ $0.name }
    case productTypeTextField:
      self.pickerViewData = ProductType.allCases.compactMap{ $0.rawValue }
    case roastTextField:
      self.pickerViewData = RoastType.allCases.compactMap{ $0.rawValue }
    default:
      print("Configured the picker view for the wrong type.")
      return
    }
    pickerView.reloadAllComponents()
    textField.inputView = pickerView
  }
}

//MARK: - ImagePickerDelegate
extension ProductDetailViewController{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let photo = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
    self.photos.append(photo)
  }
}
