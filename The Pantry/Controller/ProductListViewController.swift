//
//  ProductListViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    
    let numberOfSectionInCollectionView = 5
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var productListCollectionView:UICollectionView!
    @IBOutlet weak var viewCartView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //update the surver about the changes in the cart
        //Networking().updateCartDetais(withToken: <#T##String#>, cartDetails: <#T##String#>, completion: <#T##(Bool) -> ()#>)
    }
    

}

extension ProductListViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSectionInCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.productListCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier.productListCellID, for: indexPath) as! ProductListCollectionViewCell
        
        cell.delegate = self
        
        //set some image in the product image
        //cell.productImage
        
        //setting row and section no. to get which add button pressed later
        cell.section = indexPath.section
        cell.productAddButton.tag = indexPath.row
        
        //general information of the product
        cell.productName.text = "Rice"
        cell.productPrice.text = "₹200.0"
        self.makeCardView(fromViews: cell.cellView, isViewNavigationBar: false)
        
        return cell
        
    }
    
    
}

//Deligate of productListCollectionView Cell
extension ProductListViewController:ProductListCollectionViewCellDelegate{
    func cellAddButton(haveTag tag: [Int]) {
        //function called when add button of the cell is taped
        //create a product class
        //add the item to the array of product class
       print(tag)
        self.viewCartView.isHidden = false
    }
    
}

//All private functions
extension ProductListViewController{
    
    private func setup(){
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
        performSegue(withIdentifier: segueId.yourCartVC, sender: nil)
    }
}
