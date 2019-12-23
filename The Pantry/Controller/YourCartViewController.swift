//
//  YourCartViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

protocol YourCartViewControllerProtocol {
    func didComeFromYourCart(value : Bool)
}

class YourCartViewController:UIViewController{
    
    @IBOutlet weak var yourCartTableView:UITableView!
    @IBOutlet weak var checkOutButton:UIButton!

    
    var selectedProducts = [selectedProduct]()
    var totalPrice = Double()
    var numberOfItemAdded = Int()
    var delegate:YourCartViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didComeFromYourCart(value: true)
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    
        self.delegate?.didComeFromYourCart(value: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkOutButtonPressed(){
        //go to the payment page use the payment gatway

        self.performSegue(withIdentifier: segueId.checkOutVCId, sender: nil)
    }
    

}

//Extention for table view
extension YourCartViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.yourCartTableView.dequeueReusableCell(withIdentifier: cellIdentifier.yourCartCellID, for: indexPath) as! YourCartTableViewCell
        //setting the tag of each button equal to row
        cell.removeButton.tag = indexPath.row
        
        //Product added to cart details
        var sellingPrice = ""
        var numberOfProduct = 0
        
        sellingPrice = self.selectedProducts[indexPath.row].product.sellingPrice
        numberOfProduct = self.selectedProducts[indexPath.row].quantity
        
        
        cell.productName.text = self.selectedProducts[indexPath.row].product.name
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
        
        self.selectedProducts.remove(at: row)
        self.totalPrice = 0
        save().saveCartDetais(withDetails: self.selectedProducts)
        self.changeUiIfNeeded()
        self.yourCartTableView.reloadData()
    }
}



extension YourCartViewController{
    //All private functions
    
    private func setUp(){
        self.yourCartTableView.dataSource = self
        self.yourCartTableView.delegate = self
        self.changeUiIfNeeded()
    }
    
    private func changeUiIfNeeded(){
        if let selectedProduct = save().getCartDetails(){
            self.selectedProducts = selectedProduct
        }
        self.getTotalPriceAndNumberofItemInCart()
        
        self.checkOutButton.setTitle("CHECKOUT(₹\(self.totalPrice))", for: UIControl.State.normal)
    }
    
    /*private func getSelectedProduct()->[selectedProduct]{
        var selectedProducts = [selectedProduct]()
        for (key,quantity) in self.iteamAddedInCart {
            if(quantity != 0){
                var productDetals = selectedProduct()
                //productDetals.product = self.products[key]
                productDetals.quantity = quantity
                selectedProducts.append(productDetals)
            }
        }
        
        return selectedProducts
    }*/
    
    private func getTotalPriceAndNumberofItemInCart(){
        for i in 0..<self.selectedProducts.count{
            self.totalPrice += Double(self.selectedProducts[i].quantity) *  Double(self.selectedProducts[i].product.sellingPrice)!
            self.numberOfItemAdded += self.selectedProducts[i].quantity
        }
    }
}

extension YourCartViewController:CheckOutViewControllerProtcol{
    func didPaymentCmplete(withsStatus status: Bool) {
        
    }
}
