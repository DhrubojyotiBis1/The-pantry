//
//  ProductDescriptionViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol ProductDescriptionProtocol {
    func didProductDescriptionViewControllerDismiss(productInCart : [String:UIImage?])
}

class ProductDescriptionViewController: UIViewController {
    
    @IBOutlet weak var collectionViewHightConstrain: NSLayoutConstraint!
    @IBOutlet weak var productDescescriptionTableView:UITableView!
    @IBOutlet weak var productDescriptionCollectionView:UICollectionView!
    @IBOutlet weak var pageController:UIPageControl!
    @IBOutlet weak var productNameLabel:UILabel!
    @IBOutlet weak var productPriceLabel:UILabel!
    @IBOutlet weak var numberOfQuantityAddedLabel:UILabel!
    @IBOutlet var productQuantityChangeButton:[UIButton]!
    @IBOutlet weak var initialProductQuantityChangeButton:UIButton!
    @IBOutlet weak var viewCartView:UIView!
    @IBOutlet weak var numberOfItemInCartLabel:UILabel!
    @IBOutlet weak var totalPricelabel:UILabel!
    @IBOutlet weak var navigationBar:UIView!
    
    var productInCart = [selectedProduct]()
    var productForDescription = product()
    var isProductQuantityChangeButtonVisible = false
    var numberOfItemInCart = 0
    var totalPrice:Double = 0
    var delegate:ProductDescriptionProtocol?
    var productImages = [String:UIImage?]()
    var productImageInCart = [String:UIImage?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
        print(self.productForDescription.imageURL.count)
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        self.delegate?.didProductDescriptionViewControllerDismiss(productInCart: self.productImageInCart)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewTransactionHistoryButtonPressed(_ sender:UIButton){
        performSegue(withIdentifier: segueId.transactionVCId, sender: nil)
    }
    
    @IBAction func productQuantityChangeButtonPressed(_ sender:UIButton){
        var isAdded = true

        for i in 0..<self.productInCart.count{
            if self.productInCart[i].product.productId == self.productForDescription.productId{
                if sender.tag == 1{
                    //add
                    productInCart[i].quantity += 1
                    totalPrice += Double(productInCart[i].product.sellingPrice)!
                    self.numberOfItemInCart += 1
                }else{
                    //sub
                    productInCart[i].quantity -= 1
                    totalPrice -= Double(productInCart[i].product.sellingPrice)!
                    self.numberOfItemInCart -= 1
                }
                
                if productInCart[i].quantity == 0{
                    isAdded = false
                    let url = "http://gourmetatthepantry.com/public/storage/" + productInCart[i].product.imageURL[0]
                    self.productImageInCart.removeValue(forKey: url)
                    self.productInCart.remove(at: i)
                }else{
                    self.numberOfQuantityAddedLabel.text = "\(self.productInCart[i].quantity)"
                }
            }
        }
        
        self.numberOfItemInCartLabel.text = "\(self.numberOfItemInCart)" + "Item"
        self.totalPricelabel.text = "₹" + "\(self.totalPrice)"
        
        if !isAdded {
            if self.numberOfItemInCart == 0{
                self.viewCartView.isHidden = true
            }
            self.isProductQuantityChangeButtonVisible = false
            self.showProductQuantityChangeControllers(withOption: isProductQuantityChangeButtonVisible)
        }else{
            self.isProductQuantityChangeButtonVisible = true
            self.showProductQuantityChangeControllers(withOption: isProductQuantityChangeButtonVisible)
        }
        
        save().saveCartDetais(withDetails: self.productInCart)
        
    }
    
    @IBAction func initialProductQuantityChangeButtonPressed(_ sender:UIButton){
        
        
        let quantity = 1
        let newProduct = selectedProduct(product: self.productForDescription, quantity: quantity)
        self.productInCart.append(newProduct)
        self.isProductQuantityChangeButtonVisible = true
        self.numberOfQuantityAddedLabel.text = "\(quantity)"
        
        let url = "http://gourmetatthepantry.com/public/storage/" + newProduct.product.imageURL[0]
        self.productImageInCart[url] = self.productImages[url]
        self.numberOfItemInCart += 1
        self.totalPrice += Double(self.productForDescription.sellingPrice)!
        
        self.numberOfItemInCartLabel.text = "\(self.numberOfItemInCart)" + "Item"
         self.totalPricelabel.text = "₹" + "\(self.totalPrice)"
        
        if(self.totalPrice > 0){
            self.viewCartView.isHidden = false
        }
        
        self.showProductQuantityChangeControllers(withOption: isProductQuantityChangeButtonVisible)
        save().saveCartDetais(withDetails: self.productInCart)
    }
    
    @IBAction func threeDotButtonPressed(_ sender:UIButton){
        performSegue(withIdentifier: segueId.threeDotPopVCId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.yourCartVC{
            let destination = segue.destination as! YourCartViewController
            destination.isCommingformDescriptionVC = true
            destination.productInCartImages = self.productImageInCart
            destination.delegate = self
        }else if segue.identifier == segueId.transactionVCId{
            SVProgressHUD.show()
        }else if segue.identifier == segueId.threeDotPopVCId{
            let destination = segue.destination as! PopUpViewController
            destination.delegate = self
        }
    }
    

}

//table view protocolls of the product ProductDescriptionViewController
extension ProductDescriptionViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.productDescescriptionTableView.dequeueReusableCell(withIdentifier: cellIdentifier.productDescrptionCellID, for: indexPath) as! ProductDescriptionTableViewCell
        
        //store the description in the cell lable
        cell.productDescription.text = productForDescription.productDescription
        
        return cell
    }
    
    
}


//collection view protocolls of the product ProductDescriptionViewController
extension ProductDescriptionViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productForDescription.imageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.productDescriptionCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier.productDescriptionCollectionViewCellID, for: indexPath) as! ProductDesctiptionCollectionViewCell
        
        cell.activityIndicator.startAnimating()
        
        //if there is image in the uiimage array for the index path then show that
        //else download image using the url from the array of the product details class and store it in a different [uiimage]
        //stop the activity indicator
        
        let url = "http://gourmetatthepantry.com/public/storage/" + self.productForDescription.imageURL[indexPath.section]
        
        if productImages[url] != nil{
            cell.activityIndicator.stopAnimating()
            cell.productImage.image = productImages[url]!
        }else{
            Networking().downloadImageForProduct(withURL: url) { (image) in
                DispatchQueue.main.async {
                    if let cellToUpdate = self.productDescriptionCollectionView.cellForItem(at: indexPath) as? ProductDesctiptionCollectionViewCell{
                        cellToUpdate.productImage.image = image
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                    }
                }
            }
        }
        
        cell.hightConstrain.constant = self.productDescriptionCollectionView.bounds.height
        cell.widthContrain.constant = self.productDescriptionCollectionView.bounds.width
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //function showing one image at a time
        let layout = self.productDescriptionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offSet = targetContentOffset.pointee
        let index = (offSet.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundIndex = round(index)
        
        offSet = CGPoint(x: roundIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offSet
        
    }
}

//function to size the cell of the collection view also to make it in the center of the collection view
extension ProductDescriptionViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = productDescriptionCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageController.currentPage = Int(pageNumber)
    }
}


//All private functions
extension ProductDescriptionViewController{
    private func setUp(){
        //setting the delegate and data source of the table and collection view to self
        productDescescriptionTableView.dataSource = self
        productDescescriptionTableView.delegate = self
        productDescriptionCollectionView.delegate = self
        productDescriptionCollectionView.dataSource = self
        
        //setting the card view for the top view
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.navigationBar.layer.shadowOpacity = 0.4
        
        //setting the initial value of page controller
        if self.productForDescription.imageURL.count <= 1{
            self.pageController.isHidden = true
            self.pageController.isEnabled = false
        }
        self.pageController.pageIndicatorTintColor = UIColor.green
        self.pageController.numberOfPages = self.productForDescription.imageURL.count
        self.pageController.currentPage = 0
        
        //setting ProductName and ProductPrice
        self.productNameLabel.text = self.productForDescription.name
        self.productPriceLabel.text = self.productForDescription.sellingPrice
        
        self.setupForViewCartView()
        
        self.setupForQuantityChange()
        
        if (self.view.bounds.height / 3) >  self.collectionViewHightConstrain.constant {
            self.collectionViewHightConstrain.constant = self.view.bounds.height / 3
        }
    }
    
    @objc private func onViewCartViewTapped(){
        performSegue(withIdentifier: segueId.yourCartVC, sender: nil)
    }
    
    private func setupForQuantityChange(){
        
        var numberOfQuantityAdded = 0
        
        for i in 0..<self.productInCart.count{
            if self.productForDescription.productId == self.productInCart[i].product.productId{
                numberOfQuantityAdded = Int(self.productInCart[i].quantity)
                self.numberOfQuantityAddedLabel.text =  "\(numberOfQuantityAdded)"
                self.isProductQuantityChangeButtonVisible = true
                self.showProductQuantityChangeControllers(withOption: isProductQuantityChangeButtonVisible)
            }
        }
        
        if numberOfQuantityAdded == 0{
            self.isProductQuantityChangeButtonVisible = false
            self.showProductQuantityChangeControllers(withOption: self.isProductQuantityChangeButtonVisible)
        }
        
    }
    
    private func setupForViewCartView(){
        
        //getting cart detalis
        if let cartDetails = save().getCartDetails(){
            self.productInCart = cartDetails
        }
        
        self.numberOfItemInCart = 0
        self.totalPrice = 0
        if(self.productInCart.count == 0){
            self.viewCartView.isHidden = true
        }else{
             self.viewCartView.isHidden = false
        }
        for i in 0..<self.productInCart.count{
            self.numberOfItemInCart += self.productInCart[i].quantity
            self.totalPrice += Double(productInCart[i].product!.sellingPrice)! * Double(productInCart[i].quantity)
        }
        self.numberOfItemInCartLabel.text! = "\(numberOfItemInCart)"+"Item"
        self.totalPricelabel.text = "₹"+"\(self.totalPrice)"
        
        //adding tap gesture to viewCart view
        let tapGestute = UITapGestureRecognizer(target: self, action: #selector(onViewCartViewTapped))
        self.viewCartView.addGestureRecognizer(tapGestute)
    }
    
    private func showProductQuantityChangeControllers(withOption option:Bool){
        
        self.initialProductQuantityChangeButton.isHidden = option
        self.initialProductQuantityChangeButton.isEnabled  = !option
        
        self.numberOfQuantityAddedLabel.isEnabled = option
        self.numberOfQuantityAddedLabel.isHidden = !option
        
        for i in 0..<self.productQuantityChangeButton.count{
            self.productQuantityChangeButton[i].isEnabled = option
            self.productQuantityChangeButton[i].isHidden = !option
        }
        
    }
    
    private func clearCartPressed(){
        self.productInCart.removeAll()
        save().saveCartDetais(withDetails: self.productInCart)
        self.setUp()
    }
    
}

extension ProductDescriptionViewController:YourCartViewControllerProtocol{
    func didComeFromYourCart(value: Bool) {
        self.setupForViewCartView()
        self.setupForQuantityChange()
    }
}

extension ProductDescriptionViewController:popUpPopUpViewControllerDelegate{
    func popUpButtonTaped(withTag tag: Int) {
        print("yes")
        switch tag {
        case 1:
            //clear cart
            self.clearCartPressed()
            break
        case 2:
            performSegue(withIdentifier: segueId.profileVCId, sender: nil)
        default:
            break
        }
    }
}
