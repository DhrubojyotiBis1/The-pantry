//
//  ProductListViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

protocol  ProductListViewControllerProtocol{
    func didComeFromProductListViewController(value:Bool)
}

class ProductListViewController: UIViewController{
    
    var availableProducts = [product]()
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var productListCollectionView:UICollectionView!
    @IBOutlet weak var viewCartView:UIView!
    @IBOutlet weak var numberOfItemAddedLabel:UILabel!
    @IBOutlet weak var totalPriceLabel:UILabel!
    
    var delegate:ProductListViewControllerProtocol?
    var totalPrice = Double()
    var selectedProducts = [selectedProduct]()
    var numberOfItemAdded = Int()
    var isfirstTime = true
    var rowForSeceltedproductToSeeDescription = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setup()
        //if something is asready present in the cart the show the view cart option with correct values
        //else hide view cart option
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.threeDotPopVCId{
            let destination = segue.destination as! PopUpViewController
            destination.delegate = self
        }else if segue.identifier == segueId.productDescriptionVCId {
            let destination = segue.destination as! ProductDescriptionViewController
            destination.productForDescription = self.availableProducts[rowForSeceltedproductToSeeDescription]
            destination.delegate = self
        }else if segue.identifier == segueId.yourCartVC{
            let destination = segue.destination as! YourCartViewController
            destination.delegate = self

        }
    }
    
    @IBAction func threeDotPopUpButtonTapped(_ sender:UIButton){
        self.performSegue(withIdentifier: segueId.threeDotPopVCId, sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.delegate?.didComeFromProductListViewController(value: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewTransactionButtonPressed(_ sender:UIButton){
        performSegue(withIdentifier: segueId.transactionVCId, sender: nil)
    }

}

extension ProductListViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if((self.availableProducts.count%2)==0){
            //even
            return (self.availableProducts.count/2)
        }else{
            //odd
            let numberOfsection = (self.availableProducts.count/2) + 1
            return numberOfsection
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.productListCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier.productListCellID, for: indexPath) as! ProductListCollectionViewCell
        
        
        cell.delegate = self
        cell.activityIndicator.startAnimating()
        cell.productSubtractButton.isHidden = true
        cell.numOfItemSelected.text = "0"
        self.viewCartView.isHidden = true
        cell.productAddButton.tag = indexPath.row
        cell.productSubtractButton.tag = indexPath.row
        cell.section = indexPath.section
        cell.isHidden = false
        
        let row = 2*indexPath.section + indexPath.row
        
        
        //setting row and section no. to get which add button pressed later
        if(row >= 0 && row < availableProducts.count){
            if(self.selectedProducts.count > 0){
                for i in 0..<self.selectedProducts.count{
                    if(self.selectedProducts[i].product.productId ==  self.availableProducts[row].productId){
                        cell.numOfItemSelected.text = "\(self.selectedProducts[i].quantity)"
                        cell.productSubtractButton.isHidden = false
                    }
                    if(isfirstTime){
                        self.totalPrice += Double(self.selectedProducts[i].quantity) *  Double(self.selectedProducts[i].product.sellingPrice)!
                        self.numberOfItemAdded += self.selectedProducts[i].quantity
                    }
                }
            }
        }
        
        self.isfirstTime = false
        //if there is image in the uiimage array for the index path the show that
        //else download image using the url from the array of the product details class and store it in a different [uiimage]
        //stop the activity indicator
        
         self.numberOfItemAddedLabel.text = "\(self.numberOfItemAdded)" + "Item"
         self.totalPriceLabel.text = "₹" + "\(self.totalPrice)"
        
        if(self.totalPrice > 0){
            self.viewCartView.isHidden = false
        }
        
        //general information of the product
        if(row >= availableProducts.count){
            cell.isHidden = true
        }else{
            cell.productName.text = self.availableProducts[row].name
            cell.productPrice.text = self.availableProducts[row].sellingPrice
            self.makeCardView(fromViews: cell.cellView, isViewNavigationBar: false)
        }
        
        if let screenWidth = self.view.window?.bounds.width{
            cell.cellWidth.constant = screenWidth/2.4
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //go to the product description View cntroller
        //pass the general infornamtion of the product to next VC
        self.rowForSeceltedproductToSeeDescription = 2*indexPath.section + indexPath.row
        performSegue(withIdentifier: segueId.productDescriptionVCId, sender: nil)
    }
}


extension ProductListViewController:popUpPopUpViewControllerDelegate{
    func popUpButtonTaped(withTag tag: Int) {
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

//Deligate of productListCollectionView Cell
extension ProductListViewController:ProductListCollectionViewCellDelegate{
    func cellRemoveBUttonPressed(havingTag tag: [Int]) {
        
        self.isfirstTime = false
        let row = tag[0]
        let section = tag[1]
        let i = (2*row + section)
        let justSelectedProduct = availableProducts[i]
        for j in 0..<self.selectedProducts.count{
            if(selectedProducts[j].product.productId == justSelectedProduct.productId ){
                self.selectedProducts[j].quantity -= 1
                if(selectedProducts[j].quantity == 0){
                    self.selectedProducts.remove(at: j)
                    break
                }
            }
        }
        
        self.numberOfItemAdded -= 1
        if(totalPrice != 0){
            self.totalPrice -= Double(justSelectedProduct.sellingPrice)!
        }
        
        let indepath = IndexPath(row: section, section: row)
        self.productListCollectionView.reloadItems(at: [indepath])
        
        save().saveCartDetais(withDetails: self.selectedProducts)
        
    }
    
    func cellAddButton(haveTag tag: [Int]) {
        //function called when add button of the cell is taped
        //create a array of the product class
        //add the item to the array of product class
        
        self.isfirstTime = false
        let row = tag[0]
        let section = tag[1]
        
        let i = (2*row + section)
        var doneWithSelectedProduct = false
        let justSelectedProduct = availableProducts[i]
        for j in 0..<self.selectedProducts.count{
            if(selectedProducts[j].product.productId == justSelectedProduct.productId ){
                self.selectedProducts[j].quantity += 1
                doneWithSelectedProduct = true
            }
        }
        
        if(!doneWithSelectedProduct){
            let quantity = 1
            let justSelectedProduct = selectedProduct(product: justSelectedProduct, quantity: quantity)
            self.selectedProducts.append(justSelectedProduct)
        }
        
        self.numberOfItemAdded += 1
        self.totalPrice += Double(justSelectedProduct.sellingPrice)!
        
        let indepath = IndexPath(row: section, section: row)
        self.productListCollectionView.reloadItems(at: [indepath])
        
        save().saveCartDetais(withDetails: self.selectedProducts)
        
    }
}


extension ProductListViewController:YourCartViewControllerProtocol{
    func didComeFromYourCart(value: Bool) {
        self.getStarted()
        self.productListCollectionView.reloadData()
    }
}

extension ProductListViewController:ProductDescriptionProtocol{
    func didProductDescriptionViewControllerDismiss() {
        self.getStarted()
        self.productListCollectionView.reloadData()
    }
}

//All private functions
extension ProductListViewController{
    
    private func setup(){
        //confinding to delegate
        self.productListCollectionView.delegate = self
        self.productListCollectionView.dataSource = self
        
        //allowing selection of the collection view cell
        self.productListCollectionView.allowsSelection = true
        
        //making the navigation bar a card view
        self.makeCardView(fromViews: self.navigationBarView, isViewNavigationBar: true)
        
        self.getStarted()
                
        //adding tap gesture to the view cart view
        self.addGestureRecognization()

    }
    
    private func getStarted(){
        self.numberOfItemAdded = 0
        self.totalPrice = 0
        self.viewCartView.isHidden = true
        if let selectedProduct = save().getCartDetails(){
            self.selectedProducts = selectedProduct
        }
        
        self.isfirstTime = true

    }
    
    private func makeCardView(fromViews view:UIView,isViewNavigationBar :Bool){
        //makeing the card view for the view
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.4
        if(isViewNavigationBar){
            view.layer.shadowOffset = CGSize(width: 0, height: 4.5)
        }else{
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    
    private func addGestureRecognization(){
        //adding tap gesture to the view cart view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.viewCartView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap(){
        //go to the your cart View controller
        //pass the array of the product class to next VC
        performSegue(withIdentifier: segueId.yourCartVC, sender: nil)
    }
    
    private func clearCartPressed(){
        self.selectedProducts.removeAll()
        save().saveCartDetais(withDetails: self.selectedProducts)
        self.getStarted()
        self.productListCollectionView.reloadData()
    }
}
