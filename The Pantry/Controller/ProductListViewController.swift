//
//  ProductListViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    
    var availableProducts = [product]()
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var productListCollectionView:UICollectionView!
    @IBOutlet weak var viewCartView:UIView!
    @IBOutlet weak var numberOfItemAddedLabel:UILabel!
    @IBOutlet weak var totalPriceLabel:UILabel!
    
    var didSavingComplete = false
    var numberOfItemAdded:Int = 0
    var totalPrice:Double = 0
    var selectedProductAt = Int()
    var itemAddedToCart = [Int:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(availableProducts)
        // Do any additional setup after loading the view.
        self.setup()
        //if something is asready present in the cart the show the view cart option with correct values
        //else hide view cart option
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //update the surver about the changes in the cart
        //Networking().updateCartDetais(withToken: <#T##String#>, cartDetails: <#T##String#>, completion: <#T##(Bool) -> ()#>)
        
        if(!self.didSavingComplete){
            let selectedProducts = getSelectedProduct()
            save().saveCartDetais(withDetails: selectedProducts)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.threeDotPopVCId{
            let destination = segue.destination as! PopUpViewController
            destination.delegate = self
        }else if segue.identifier == segueId.productDescriptionVCId {
            let destination = segue.destination as! ProductDescriptionViewController
            destination.selectedProduct = availableProducts[self.selectedProductAt]
        }else if segue.identifier == segueId.yourCartVC{
            self.didSavingComplete = true
            let destination = segue.destination as! YourCartViewController
            destination.products = self.availableProducts
            destination.iteamAddedInCart = self.itemAddedToCart
            destination.totalPrice = self.totalPrice
            destination.delegate = self
        }
    }
    
    @IBAction func threeDotPopUpButtonTapped(_ sender:UIButton){
        self.performSegue(withIdentifier: segueId.threeDotPopVCId, sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
        
        //setting row and section no. to get which add button pressed later
        let row = 2*indexPath.section + indexPath.row
        if(itemAddedToCart[row] == nil){
            cell.productSubtractButton.isHidden = true
            cell.numOfItemSelected.text = "0"
        }else if (itemAddedToCart[row]! == 0){
             cell.productSubtractButton.isHidden = true
             cell.numOfItemSelected.text = "\(itemAddedToCart[row]!)"
        }else{
            cell.productSubtractButton.isHidden = false
            cell.numOfItemSelected.text = "\(itemAddedToCart[row]!)"
        }
        
        
        self.totalPriceLabel.text! = "₹"+"\(self.totalPrice)"
        self.numberOfItemAddedLabel.text! = "\(self.numberOfItemAdded)" + "Item"
        cell.section = indexPath.section
        cell.productAddButton.tag = indexPath.row
        cell.productSubtractButton.tag = indexPath.row
        cell.activityIndicator.startAnimating()
        
        if(totalPrice == 0.0){
            self.viewCartView.isHidden = true
        }else{
            self.viewCartView.isHidden = false
        }
        
        
        //if there is image in the uiimage array for the index path the show that
        //else download image using the url from the array of the product details class and store it in a different [uiimage]
        //stop the activity indicator
        
        
        //general information of the product
        if(row>=self.availableProducts.count){
            cell.isHidden = true
        }else{
            cell.productName.text = self.availableProducts[row].name
            cell.productPrice.text = self.availableProducts[row].sellingPrice
            self.makeCardView(fromViews: cell.cellView, isViewNavigationBar: false)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //go to the product description View cntroller
        //pass the general infornamtion of the product to next VC
        let row = 2*indexPath.section + indexPath.row
        self.selectedProductAt = row
        performSegue(withIdentifier: segueId.productDescriptionVCId, sender: nil)
    }
}


extension ProductListViewController:popUpPopUpViewControllerDelegate{
    func popUpButtonTaped(withTag tag: Int) {
        switch tag {
        case 0:
            //refresh
            self.productListCollectionView.reloadData()
            break
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
        let i = (2*tag[0] + tag[1])
        if(itemAddedToCart[i] == 0){
            self.itemAddedToCart[i] = 0
        }else{
            itemAddedToCart[i]! -= 1
        }
        self.totalPrice -= Double(self.availableProducts[i].sellingPrice)!
        self.numberOfItemAdded -= 1
        let indepath = IndexPath(row: tag[1], section: tag[0])
        self.productListCollectionView.reloadItems(at: [indepath])
    }
    
    func cellAddButton(haveTag tag: [Int]) {
        //function called when add button of the cell is taped
        //create a array of the product class
        //add the item to the array of product class
        let i = (2*tag[0] + tag[1])
        if(itemAddedToCart[i] == nil){
            self.itemAddedToCart[i] = 1
        }else{
            itemAddedToCart[i]! += 1
        }
        self.totalPrice += Double(self.availableProducts[i].sellingPrice)!
        self.numberOfItemAdded += 1
        let indepath = IndexPath(row: tag[1], section: tag[0])
        self.productListCollectionView.reloadItems(at: [indepath])
    }
    
}


extension ProductListViewController:YourCartViewControllerProtocol{
    
    func itemRemainingInCart(item: [Int : Int],totalPrice:Double,numberOfItemInCart:Int) {
        print("yes")
        self.itemAddedToCart = item
        self.totalPrice = totalPrice
        self.numberOfItemAdded = numberOfItemInCart
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
        
        
        self.viewCartView.isHidden = true
        
        //adding tap gesture to the view cart view
        self.addGestureRecognization()
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
        self.itemAddedToCart.removeAll()
        self.numberOfItemAdded = 0
        self.totalPrice = 0
        self.productListCollectionView.reloadData()
    }
    
    
    private func getSelectedProduct()->[selectedProduct]{
        var selectedProducts = [selectedProduct]()
        for (key,quantity) in self.itemAddedToCart {
            var productDetals = selectedProduct()
            productDetals.product = self.availableProducts[key]
            productDetals.quantity = quantity
            selectedProducts.append(productDetals)
        }
        
        return selectedProducts
        
    }
    
}
