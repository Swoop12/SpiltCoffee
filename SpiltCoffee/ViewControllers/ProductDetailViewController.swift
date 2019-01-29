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
  @IBOutlet weak var nameTextField: UITextView!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var priceTextField: UITextField!
  @IBOutlet weak var originStackView: UIStackView!
  @IBOutlet weak var originTextField: UITextField!
  @IBOutlet weak var roastStackView: UIStackView!
  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var priceStackView: UIStackView!
  @IBOutlet var pickerView: UIPickerView!
  @IBOutlet weak var productTypeCollectionView: UICollectionView!
  @IBOutlet weak var roastTypeCollectionView: UICollectionView!
  @IBOutlet weak var addPhotosButton: UIButton!
  
  //MARK: - Properties
  var photoPagerViewController: PhotoPagerViewController?
  var photoCollectionViewDataSource: DataViewGenericDataSource<UIImage>!
  var pickerViewData: [String]?
  var productType: ProductType?
  var roastType: RoastType?
  
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
      photoPagerViewController?.photos = photos
    }
  }
  
  //MARK: - View LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    productTypeCollectionView.register(UINib(nibName: "IconCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "iconPhotoCell")
    roastTypeCollectionView.register(UINib(nibName: "IconCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "iconPhotoCell")
    setDelegates()
    setDataSources()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    selectRoastTypeIcons()
    selectProductTypeIcons()
  }
  
  //MARK: - Functions
  func setDelegates(){
    priceTextField.delegate = self
    originTextField.delegate = self
    descriptionTextView.delegate = self
    pickerView.delegate = self
    productTypeCollectionView.delegate = self
    roastTypeCollectionView.delegate = self
  }
  
  func setDataSources(){
    pickerView.dataSource = self
    productTypeCollectionView.dataSource = self
    roastTypeCollectionView.dataSource = self
//    photoCollectionViewDataSource = DataViewGenericDataSource(dataView: photosCollectionView, dataType: .photo, data: self.photos)
  }
  
  func updateViews(){
    if let product = product {
      nameTextField.text = product.name
      descriptionTextView.text = product.description
      priceTextField.text = "\(product.price)"
      purchaseButton.setTitle("$\(product.price)", for: .normal)
      self.photos = product.photos
      if let bean = product as? CoffeeBean{
        customizeView(for: bean)
      }
    }
    lockPermissionGuards()
  }
  
  func customizeView(for bean: CoffeeBean?){
    UIView.animate(withDuration: 0.3) {
      self.originStackView.isHidden = false
      self.roastTypeCollectionView.isHidden = false
      self.roastStackView.isHidden = false
      if let bean = bean{
        self.heartButton.isHidden = false
        let heartImage = self.isFavorite ? #imageLiteral(resourceName: "HeartIcon") : #imageLiteral(resourceName: "HollowHeartIcon")
        self.heartButton.setImage(heartImage, for: .normal)
        self.originTextField.text = bean.origin?.name ?? "?"
      }
    }
  }
  
  func hideCoffeeBeanAttributes(){
    UIView.animate(withDuration: 0.3) {
      self.originStackView.isHidden = true
      self.roastTypeCollectionView.isHidden = true
      self.roastStackView.isHidden = true
      self.heartButton.isHidden = true
    }
  }
  
  fileprivate func setViewForEditing() {
    view.allowTextEditting()
    priceStackView.isHidden = false
    purchaseButton.isHidden = true
    heartButton.isHidden = true
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProduct))
    self.title = product != nil ? "Edit Product" : "Add Product"
  }
  
  fileprivate func setViewForReading() {
    view.lockTextEditing()
    heartButton.isHidden = false
    purchaseButton.isHidden = false
    priceStackView.isHidden = true
    self.navigationItem.rightBarButtonItem = nil
  }
  
  func lockPermissionGuards(){
    if UserController.shared.currentUser?.uuid == product?.roasterAbridgedDictionary?["uuid"] as? String || product == nil{
      setViewForEditing()
    }else{
      setViewForReading()
    }
  }
  
  func selectProductTypeIcons(){
    guard let product = product,
      let row = ProductType.allCases.index(of: product.productType) else { return }
    let indexPath = IndexPath(row: row, section: 0)
    setSelectedItem(for: productTypeCollectionView, at: indexPath)
  }
  
  func selectRoastTypeIcons(){
    guard let beans = product as? CoffeeBean,
      let row = RoastType.allCases.index(of: beans.roastType) else { return }
    let indexPath = IndexPath(row: row, section: 0)
    setSelectedItem(for: roastTypeCollectionView, at: indexPath)
  }
  
  func saveProduct(){
    guard let name = nameTextField.text, !name.isEmpty,
      let description = descriptionTextView.text, !description.isEmpty,
      let priceText = priceTextField.text, !priceText.isEmpty, let price = Double(priceText),
      let roaster = UserController.shared.currentUser as? Roaster,
      let productType = productType else {
        self.presentSimpleAlertWith(title: "Whoops looks like we're missing some info", body: "Please make sure you have filled in all the necessary fields")
        return
    }
    var origin: Origin?
    if let originString = originTextField.text, !originString.isEmpty{
      origin = Origin(name: originString)
    }
    if let bean = product as? CoffeeBean{
      guard let roastType = roastType else {
        self.presentSimpleAlertWith(title: "Please select a roast type for this bean", body: nil)
        return
      }
      ProductController.shared.update(bean: bean, name: name, price: price, description: description, photos: photos, roastType: roastType, origin: origin, completion: nil)
    }else if let product = product{
      ProductController.shared.update(product: product, name: name, price: price, description: description, photos: photos, productType: productType, completion: nil)
    }else{
      ProductController.shared.createProduct(name: name, price: price, description: description, photos: photos, roaster: roaster, productType: productType, completion: nil)
    }
    self.navigationController?.popViewController(animated: true)
  }
  
  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    self.photoPagerViewController = segue.destination as? PhotoPagerViewController
  }
  
  //MARK: - IBActions
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
  
  @IBAction func addPhotoButtonTapped(_ sender: Any) {
    self.presentImagePickerWith(alertTitle: "Add an image", message: nil)
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
    photos.append(photo)
  }
}

//MARK: - UICollectionViewDataSource
extension ProductDetailViewController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == productTypeCollectionView{
      return ProductType.allCases.count
    }else{
      return RoastType.allCases.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconPhotoCell", for: indexPath) as! IconCollectionViewCell
    if collectionView == productTypeCollectionView{
      let productType = ProductType.allCases[indexPath.row]
      cell.iconImageView.image = productType.icon
      cell.iconLabel.text = productType.description
      if productType == product?.productType{
        setSelectedItem(for: collectionView, at: indexPath)
        //        setSelectedItem(for: collectionView, at: indexPath)
      }
    }else{
      let roastType = RoastType.allCases[indexPath.row]
      cell.iconImageView.image = roastType.icon
      cell.iconLabel.text = roastType.rawValue
      if let beans = product as? CoffeeBean, beans.roastType == roastType{
        //        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        setSelectedItem(for: collectionView, at: indexPath)
      }
    }
    return cell
  }
}

//MARK: - UICollectionViewDelegate
extension ProductDetailViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    setSelectedItem(for: collectionView, at: indexPath)
  }
  
  //Not A delegate method
  func setSelectedItem(for collectionView: UICollectionView, at indexPath: IndexPath){
    let cell = collectionView.cellForItem(at: indexPath) as? IconCollectionViewCell
    if collectionView == productTypeCollectionView{
      let productType = ProductType.allCases[indexPath.row]
      self.productType = productType
      if productType == .coffeeBean{
        customizeView(for: nil)
      }else{
        hideCoffeeBeanAttributes()
      }
    }else{
      let roastType = RoastType.allCases[indexPath.row]
      self.roastType = roastType
    }
    cell?.iconImageView.setImageColor(color: .mossGreen)
    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! IconCollectionViewCell
    cell.iconImageView.setImageColor(color: .black)
    if collectionView == productTypeCollectionView{
      self.productType = nil
    }else{
      self.roastType = nil
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == productTypeCollectionView{
      let width = (collectionView.frame.width - 17)/5
      return CGSize(width: width, height: width)
    }else {
      let height = (collectionView.frame.width - 12) / 3
      return CGSize(width: height, height: height)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }
}
