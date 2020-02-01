//
//  LoginViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 10/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    
    var itemInCart = [selectedProduct]()
    var numberOfProductInCart:Int?
    var bannerImages = [UIImage?]()
    var productInCartImages = [String:UIImage?]()
    var recomendedProduct = [product]()
    var process = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        self.neworking()
    }
 
    @IBAction func dontHaveAccountButtonPressed(_ sender : UIButton){
        self.performSegue(withIdentifier: segueId.enterMobileNumberVcId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == segueId.HomeVCId){
            //send the images to the home VC
            let destination = segue.destination as! HomeViewController
            destination.bannerImages = self.bannerImages
            destination.recomendedProducts = self.recomendedProduct
            destination.productInCartImage = self.productInCartImages
        }
    }
    
}

//MARK:- Networking stuff
extension LoginViewController{
    private func neworking() {
        Networking().CheckforLogin(withEmail: self.email.text!, andPassword: self.password.text!, comingfromLoginVC: true){success,token,bannerImages  in
            if(success){
                //save the credential for auto login
                print("Login done")
                self.bannerImages = bannerImages
                //Going to the HomeViewController
                self.getCartDetails {
                    SVProgressHUD.dismiss()
                    if self.itemInCart.count != 0{
                        save().saveCartDetais(withDetails: self.itemInCart)
                    }
                    self.performSegue(withIdentifier: segueId.HomeVCId, sender: nil)
                }
            }else{
                //show alar for the faliur of login
                print("login failed \(token)")
            }
        }
    }
}

extension LoginViewController{
    private func setup(){
        //make the corner of the register button round
        self.registerButton.layer.cornerRadius = 10
        
        //adding tap gesture to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.loginView.addGestureRecognizer(tapGesture)
        self.makeCardView(forButton: self.registerButton)
    }
    
    @objc private func onTap(){
        self.email.endEditing(true)
        self.password.endEditing(true)
    }
    
    private func makeCardView(forButton button:UIButton){
        //setting the card view for the top view
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4.5)
        button.layer.shadowOpacity = 0.4
        button.layer.cornerRadius = 10
    }
    
    private func getCartDetails(completion:@escaping()->()){
        var isReadyToPerformSegue = false
        self.getRecommendedProduct {
            if isReadyToPerformSegue {
                print("yep")
                completion()
            }else{
                print("yepp")
                isReadyToPerformSegue = true
            }
        }
        let userCredential = save().getCredentials()
        if let token = userCredential[saveCredential.token]{
            Networking().getUserCartDetails(withUserToken: token) { (result,productsInCart)  in
                if(productsInCart != nil){
                    self.numberOfProductInCart = productsInCart!.count
                    for i in 0..<productsInCart!.count{
                        let productId = productsInCart![i].productID
                        let quantity = productsInCart![i].quantity
                        Networking().getProductDetails(fromProductId: productId) { (result, products) in
                            if(result){
                                let cartItem = selectedProduct(product: products, quantity: quantity)
                                self.itemInCart.append(cartItem)
                                let url  = "http://gourmetatthepantry.com/public/storage/"+cartItem.product.imageURL[0]
                                self.downloadImageForProductInCart(withUrl: url) {
                                    if self.numberOfProductInCart == self.itemInCart.count{
                                        if isReadyToPerformSegue{
                                            print("ye")
                                            completion()
                                        }else{
                                            print("yeppp")
                                            isReadyToPerformSegue = true
                                        }
                                    }
                                }
                            }else{
                                print("look in Login VC")
                            }
                        }
                    }
                    if productsInCart!.count == 0{
                        completion()
                    }
                }else{
                    save().removeItemAddedToCart()
                    self.numberOfProductInCart = nil
                    completion()
                }
            }
        }
    }
    
    private func getRecommendedProduct(completion:@escaping ()->()){
        let catagory = "recommended-for-you"
        Networking().getListOfProducts(forCatagory: catagory) { (result, recomendedProducts) in
            self.recomendedProduct = recomendedProducts
            if(result){
                SVProgressHUD.dismiss()
                completion()
            }else{
                //internet problem
            }
        }
    }
    
    private func downloadImageForProductInCart(withUrl url:String,completion:@escaping ()->()){
        Networking().downloadImageForProduct(withURL: url) { (cartProductImages) in
            self.productInCartImages[url] = cartProductImages
            completion()
        }
    }
}
