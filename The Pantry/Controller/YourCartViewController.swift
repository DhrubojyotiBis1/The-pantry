//
//  YourCartViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class YourCartViewController: UIViewController {
    
    var numberOfRowsInTableView = 2
    @IBOutlet weak var yourCartTableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.yourCartTableView.dataSource = self
        self.yourCartTableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //update the server about the changes in the cart
        //Networking().updateCartDetais(withToken: <#T##String#>, cartDetails: <#T##String#>, completion: <#T##(Bool) -> ()#>)
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkOutButtonPressed(){
        //go to the payment page use the payment gatway
        performSegue(withIdentifier: "test", sender: nil)
        print("pay")
    }

}

//Extention for table view
extension YourCartViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.yourCartTableView.dequeueReusableCell(withIdentifier: cellIdentifier.yourCartCellID, for: indexPath) as! YourCartTableViewCell
        //setting the tag of each button equal to row
        cell.removeButton.tag = indexPath.row
        
        //Product added to cart details
        cell.productName.text = "Rice"
        cell.price.text = "₹200.0x1"
        
        //setting the delegate to self
        cell.delegate = self
        
        return cell
    }
    
}

extension YourCartViewController:YourCartTableViewCellDelegate{
    func removedButtonClicked(atRow row: Int) {
        //function is called when remove button of a cell is pressed
        //remove the data from the array of th product class at row
        numberOfRowsInTableView -= 1
        //reload lable view
        self.yourCartTableView.reloadData()
    }
}

extension YourCartTableViewCell{
    //All private functions
}

