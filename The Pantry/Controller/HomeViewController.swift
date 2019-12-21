//
//  HomeViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 11/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController {
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet var conteverView: [UIView]!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var viewCartView:UIView!
    @IBOutlet weak var numberOfItemInCartLabel:UILabel!
    @IBOutlet weak var totalPricelabel:UILabel!
    var numberOfItemInCart = 0
    var totalPrice = Double()
    
    var itemInCart = [selectedProduct]()
    var products = [product]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    @IBAction func catagoryButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        let productCatagory = self.getProductCatagory(fromTag: sender.tag)
        self.getProdctListDetails(withProductCatagory: productCatagory)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.productListVC{
            let destination = segue.destination as! ProductListViewController
            destination.availableProducts = self.products
            destination.delegate = self
        }else if segue.identifier == segueId.yourCartVC{
            let destination = segue.destination as! YourCartViewController
            destination.delegate = self
        }
    }
    

}

extension HomeViewController{
    //All private function extention
    private func setup(){
        
        //confinding to dataSource and deligate
        self.adsCollectionView.dataSource = self
        self.adsCollectionView.delegate = self
        
        //setting the card view for the top view
        self.topView.layer.masksToBounds = false
        self.topView.layer.shadowColor = UIColor.gray.cgColor
        self.topView.layer.shadowOffset = CGSize(width: 0, height: 4.5)
        self.topView.layer.shadowOpacity = 0.4
        
        //setting the card view for the contenor view
        for i in 0..<self.conteverView.count{
            self.conteverView[i].layer.masksToBounds = false
            self.conteverView[i].layer.cornerRadius = 2
            self.conteverView[i].layer.shadowColor = UIColor.gray.cgColor
            self.conteverView[i].layer.shadowOffset = CGSize(width: 0, height: 2)
            self.conteverView[i].layer.shadowOpacity = 0.4
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.viewCartView.addGestureRecognizer(tapGesture)
        self.setupForViewCartView()
    }
    
    @objc func onTap(){
        performSegue(withIdentifier: segueId.yourCartVC, sender: nil)
    }
    
    private func setupForViewCartView(){
        
        if let selectedProduct = save().getCartDetails(){
            self.itemInCart = selectedProduct
        }
        
        self.numberOfItemInCart = 0
        self.totalPrice = 0
        if(self.itemInCart.count == 0){
            self.viewCartView.isHidden = true
        }else{
             self.viewCartView.isHidden = false
        }
        for i in 0..<self.itemInCart.count{
            self.numberOfItemInCart += self.itemInCart[i].quantity
            self.totalPrice += Double(itemInCart[i].product!.sellingPrice)! * Double(itemInCart[i].quantity)
        }
        self.numberOfItemInCartLabel.text! = "\(numberOfItemInCart)"+"Item"
        self.totalPricelabel.text = "₹"+"\(self.totalPrice)"
    }
    
    private func getProductCatagory(fromTag tag:Int)->String{
        //returns the catagory of the product which the user want to buy
        if(tag == 1){
            return productCatagory.veg
        }else if(tag == 2){
            return productCatagory.nonVeg
        }else if(tag == 3){
            return productCatagory.readyToEat
        }else{
            return productCatagory.merchandise
        }
    }
    
}

//MARK:- Networking stuff
extension HomeViewController{
    private func getProdctListDetails(withProductCatagory productCatagory:String){
            //got the cart details hence can add move the user to product list VC
            Networking().getListOfProducts(forCatagory: productCatagory){isSucess,productList  in
                SVProgressHUD.dismiss()
                if(isSucess){
                    //got the product list details
                    //move the user to the next VC
                    self.products = productList
                    self.performSegue(withIdentifier: segueId.productListVC, sender: nil)
                }else{
                //show the error that happend with a popup
                    print("error in getting product details")
                }
            }
    }
}


//For the ads collection View
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.adsCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier.adsCellID, for: indexPath) as! HomeCollectionViewCell
        cell.adsImageView.image = UIImage(named: "ads")
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.adsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offSet = targetContentOffset.pointee
        let index = (offSet.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundIndex = round(index)
        
        offSet = CGPoint(x: roundIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offSet
        
        
    }
}

extension HomeViewController:YourCartViewControllerProtocol,ProductListViewControllerProtocol{
    func didComeFromProductListViewController(value: Bool) {
        self.setupForViewCartView()
    }
    
    func didComeFromYourCart(value: Bool) {
        self.setupForViewCartView()
    }
}

extension HomeViewController:popUpPopUpViewControllerDelegate{
    func popUpButtonTaped(withTag tag: Int) {
        
    }
}
