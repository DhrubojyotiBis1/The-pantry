//
//  YourCartViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

protocol YourCartViewControllerProtocol {
    func itemRemainingInCart(item : [Int:Int],totalPrice:Double,numberOfItemInCart:Int)
}

class YourCartViewController:UIViewController{
    
    @IBOutlet weak var yourCartTableView:UITableView!
    @IBOutlet weak var checkOutButton:UIButton!
    var iteamAddedInCart = [Int:Int]()
    var products = [product]()
    var numberOfItem = [Int]()
    var selectedProductAt = [Int]()
    var totalPrice = Double()
    var delegate:YourCartViewControllerProtocol?
    var selectedProducts = [selectedProduct]()
    var numberOfItemInCart = Int()
    var didSavingComplete = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.yourCartTableView.dataSource = self
        self.yourCartTableView.delegate = self
        for (key, value) in iteamAddedInCart{
            self.numberOfItem.append(value)
            self.selectedProductAt.append(key)
        }
        self.checkOutButton.setTitle("CHECKOUT(₹\(self.totalPrice))", for: UIControl.State.normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //update the server about the changes in the cart
        //Networking().updateCartDetais(withToken: <#T##String#>, cartDetails: <#T##String#>, completion: <#T##(Bool) -> ()#>)
        if(!didSavingComplete){
            if(self.selectedProducts.count > 0){
                save().saveCartDetais(withDetails: selectedProducts)
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        for (_ , value) in self.iteamAddedInCart{
            numberOfItemInCart += value
        }
        
        
        delegate?.itemRemainingInCart(item: self.iteamAddedInCart, totalPrice: self.totalPrice, numberOfItemInCart: numberOfItemInCart)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkOutButtonPressed(){
        //go to the payment page use the payment gatway
        self.selectedProducts = getSelectedProduct()
        self.performSegue(withIdentifier: segueId.checkOutVCId, sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.checkOutVCId {
            let destination = segue.destination as! CheckOutViewController
            destination.selectedProducts = self.selectedProducts
            self.didSavingComplete = true
        }
    }

}

//Extention for table view
extension YourCartViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.iteamAddedInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.yourCartTableView.dequeueReusableCell(withIdentifier: cellIdentifier.yourCartCellID, for: indexPath) as! YourCartTableViewCell
        //setting the tag of each button equal to row
        cell.removeButton.tag = indexPath.row
        
        //Product added to cart details
        
        let sellingPrice = self.products[self.selectedProductAt[indexPath.row]].sellingPrice
        let productName = self.products[self.selectedProductAt[indexPath.row]].name
        let numberOfProduct = self.numberOfItem[indexPath.row]
        cell.productName.text = productName
        cell.price.text = "₹\(sellingPrice)x\(numberOfProduct)"
        
        //setting the delegate to self
        cell.delegate = self
        
        return cell
    }
    
}

extension YourCartViewController:YourCartTableViewCellDelegate{
    func removedButtonClicked(atRow row: Int) {
        //function is called when remove button of a cell is pressed
        //remove the data from the array of th product class at row
        let removedDataKey = self.selectedProductAt[row]
        self.iteamAddedInCart.removeValue(forKey: removedDataKey)
        
        self.totalPrice -= (Double(self.products[selectedProductAt[row]].sellingPrice)!)*Double(numberOfItem[row])
        
        self.selectedProductAt.remove(at: row)
        self.numberOfItem.remove(at: row)
        //reload lable view
        self.yourCartTableView.reloadData()
        self.checkOutButton.setTitle("CHECKOUT(₹\(self.totalPrice))", for: UIControl.State.normal)
        if(totalPrice == 0){
            self.checkOutButton.isEnabled = false
        }
    }
}

extension YourCartViewController{
    func itemRemainingInCart(item : [Int:Int],totalPrice:Double,numberOfItemInCart:Int){}
}

extension YourCartViewController{
    //All private functions
    
    private func getSelectedProduct()->[selectedProduct]{
        var selectedProducts = [selectedProduct]()
        for (key,quantity) in self.iteamAddedInCart {
            var productDetals = selectedProduct()
            productDetals.product = self.products[key]
            productDetals.quantity = quantity
            print(quantity)
            selectedProducts.append(productDetals)
        }
        
        return selectedProducts
        
    }
}

extension YourCartViewController:CheckOutViewControllerProtcol{
    func didPaymentCmplete(withsStatus status: Bool) {
        if(status){
            self.iteamAddedInCart.removeAll()
            self.totalPrice = 0
            self.numberOfItemInCart = 0
        }else{
            
        }
    }
}
