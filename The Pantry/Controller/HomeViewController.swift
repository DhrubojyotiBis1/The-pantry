//
//  HomeViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 11/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import SVProgressHUD
import SafariServices

class HomeViewController: UIViewController {
    //@IBOutlet weak var adsCollectionView: UICollectionView!
    //@IBOutlet var conteverView: [UIView]!
    
    @IBOutlet weak var widthConstrainViewCartView: NSLayoutConstraint!
    @IBOutlet weak var horizontalcentralViewCartView: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstrain: NSLayoutConstraint!
    @IBOutlet weak var catagoriesStackViewTrailingConstant: NSLayoutConstraint!
    @IBOutlet var catagoryButtons: [UIButton]!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var trailingConstrain: NSLayoutConstraint!
    @IBOutlet weak var viewBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var viewLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var backgroundView:UIView!
    @IBOutlet weak var recomendedForYouTabelView:UITableView!
    @IBOutlet weak var viewCartView:UIView!
    @IBOutlet weak var bottomCostrainTableView:NSLayoutConstraint!
    //@IBOutlet weak var dynamicHeadingLabel:UILabel!
    //@IBOutlet weak var viewCartView:UIView!
    @IBOutlet weak var numberOfItemInCartLabel:UILabel!
    @IBOutlet weak var totalPricelabel:UILabel!
    /*var StringsForHeadting = ["Get our best deals!","Sale coming soon!","Deal of the day!","Aj Kya Banaoge?"]*/
    var showingHeadingAtIndex = 0
    var numberOfItemInCart = 0
    var totalPrice = Double()
    var transection = slideMenuAnimation()
    var itemInCart = [selectedProduct]()
    var products = [product]()
    var bannerImages = [UIImage?]()
    var stringUrlForSelectedPage:String?
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
    
    @IBAction func menuButtonTapped(_ sender:UIButton){
        
        self.changeContrain(isMenuShown: true)
        
        //show the slide menu
        guard let menu = storyboard?.instantiateViewController(identifier: "menuVC") as? MenuViewController else{return}
        
        menu.modalPresentationStyle = .overCurrentContext
        menu.transitioningDelegate = self
        
        menu.delegate = self
        
        present(menu, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.productListVC{
            let destination = segue.destination as! ProductListViewController
            destination.availableProducts = self.products
            destination.delegate = self
        }else if segue.identifier == segueId.yourCartVC{
            let destination = segue.destination as! YourCartViewController
            destination.delegate = self
        }else if segue.identifier == segueId.threeDotPopVCId{
            let destiination = segue.destination as! PopUpViewController
            destiination.delegate = self
        }
    }
    

}

extension HomeViewController : UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transection.isPresenting = true
        return self.transection
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transection.isPresenting = false
        return self.transection
    }
}

extension HomeViewController{
    //All private function extention
    private func setup(){
        
       /* _ = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)*/
        
        //confinding to dataSource and deligate
        //self.adsCollectionView.dataSource = self
        //self.adsCollectionView.delegate = self
        self.recomendedForYouTabelView.delegate = self
        self.recomendedForYouTabelView.dataSource = self
        
        //setting the card view for the top view
        self.topView.layer.masksToBounds = false
        self.topView.layer.shadowColor = UIColor.gray.cgColor
        self.topView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.topView.layer.shadowOpacity = 0.4
        
        //setting the card view for the contenor view
        /*for i in 0..<self.conteverView.count{
            self.conteverView[i].layer.masksToBounds = false
            self.conteverView[i].layer.cornerRadius = 2
            self.conteverView[i].layer.shadowColor = UIColor.gray.cgColor
            self.conteverView[i].layer.shadowOffset = CGSize(width: 0, height: 2)
            self.conteverView[i].layer.shadowOpacity = 0.4
        }*/
        
        for i in 0..<self.catagoryButtons.count{
           self.catagoryButtons[i].layer.cornerRadius = 40
        }
        
        self.setupForViewCartView()
    }
    
    /*@objc private func runTimedCode(){
        dynamicHeadingLabel.fadeTransition(1)
        self.dynamicHeadingLabel.text = self.StringsForHeadting[self.showingHeadingAtIndex]
        showingHeadingAtIndex += 1
        if showingHeadingAtIndex == StringsForHeadting.count{
            self.showingHeadingAtIndex = 0
        }
    }*/
    
    @objc func onTap(){
        print("Yes")
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
            if self.bottomCostrainTableView.constant != 10{
                self.bottomCostrainTableView.constant -= self.viewCartView.bounds.height
            }
        }else{
             self.viewCartView.isHidden = false
             self.bottomCostrainTableView.constant += self.viewCartView.bounds.height
        }
        for i in 0..<self.itemInCart.count{
            self.numberOfItemInCart += self.itemInCart[i].quantity
            self.totalPrice += Double(itemInCart[i].product!.sellingPrice)! * Double(itemInCart[i].quantity)
        }
        self.numberOfItemInCartLabel.text! = "\(numberOfItemInCart)"+"Item"
        self.totalPricelabel.text = "₹"+"\(self.totalPrice)"
        self.widthConstrainViewCartView.constant = self.view.bounds.width
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.viewCartView.addGestureRecognizer(tapGesture)
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
    
    private func clearCart(){
        self.itemInCart.removeAll()
        save().saveCartDetais(withDetails: self.itemInCart)
        self.setupForViewCartView()
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
                    for i in 0..<productList.count{
                        print(i,productList[i])
                    }
                    self.products = productList
                    self.performSegue(withIdentifier: segueId.productListVC, sender: nil)
                }else{
                //show the error that happend with a popup
                    print("error in getting product details")
                }
            }
    }
}


extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recomendedForYouTabelView.dequeueReusableCell(withIdentifier: "recomendedProductTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell.addButton.tag = indexPath.row
        cell.subtractButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    
}


//For the ads collection View
/*extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerImages.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.adsCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier.adsCellID, for: indexPath) as! HomeCollectionViewCell
        if bannerImages[indexPath.section] != nil{
            cell.adsImageView.image = self.bannerImages[indexPath.section]!
        }
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
}*/

extension HomeViewController{
    private func changeContrain(isMenuShown:Bool){
        
        if isMenuShown {
            self.mainView.layer.cornerRadius = 20
            self.mainView.layer.masksToBounds = false
            self.mainView.layer.shadowColor = UIColor.gray.cgColor
            self.mainView.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.mainView.layer.shadowOpacity = 0.6
            self.mainView.layer.shadowRadius = 15
            self.viewCartView.roundCorners(corners: .bottomLeft, radius: 20)

            
            self.backgroundView.backgroundColor = UIColor(red: 120/255, green: 202/255, blue: 40/255, alpha: 0.9)
            self.viewBottomConstrain.constant = self.viewBottomConstrain.constant + self.view.bounds.width*0.06
            
            self.viewTopConstrain.constant = self.viewTopConstrain.constant + self.view.bounds.width*0.06
            
            self.viewLeadingConstrain.constant = self.viewTopConstrain.constant + self.view.bounds.width*0.6
            
            self.trailingConstrain.constant -= self.view.bounds.width*0.6
            self.horizontalcentralViewCartView.constant = self.view.bounds.width*0.032
            
            if self.view.bounds.width < 380{
                self.catagoriesStackViewTrailingConstant.constant += self.view.bounds.width*0.025
                self.stackViewTrailingConstrain.constant -= 50
            }
            
        }else{
            
            self.mainView.layer.cornerRadius = 0
            self.mainView.layer.masksToBounds = true
            self.mainView.layer.shadowColor = UIColor.white.cgColor
            self.mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.mainView.layer.shadowOpacity = 0
            self.mainView.layer.shadowRadius = 0
            self.viewCartView.roundCorners(corners: .bottomLeft, radius: 0)
            
            self.backgroundView.backgroundColor = UIColor.systemBackground
            
            self.viewBottomConstrain.constant = 0
            
            self.viewTopConstrain.constant = 8
            
            self.viewLeadingConstrain.constant = 0
            self.horizontalcentralViewCartView.constant = 0
            
            self.trailingConstrain.constant = 0
            if self.view.bounds.width < 380{
                self.catagoriesStackViewTrailingConstant.constant = 8
                self.stackViewTrailingConstrain.constant = 8
            }

        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("The animation is complete!")
        }
    }
    
    private func showWebView(){
        //convert the string into url
        if let selectedStringURlForWebPage = self.stringUrlForSelectedPage{
            if let selectedUrlForWebPage = URL(string: selectedStringURlForWebPage){
                self.showWebPage(withUrl: selectedUrlForWebPage)
            }else{
                //failed to conver it string to url
                print("failed to conver it string to url")
            }
        }else{
            //failed to get the urlString
            print("failed to get the urlString")
        }
    }
    
    private func getTheUrl(fromButtonTag buttonTage:Int){
        if(buttonTage == 1){
            self.stringUrlForSelectedPage = webPageURL.privacyPolicy
        }else if(buttonTage == 2){
            self.stringUrlForSelectedPage = webPageURL.FAQ
        }else{
            self.stringUrlForSelectedPage = webPageURL.aboutUs
        }
    }
    
    private func showWebPage(withUrl url:URL){
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true) {
            print("Presented Safari VC")
        }
    }
}

extension HomeViewController:YourCartViewControllerProtocol,ProductListViewControllerProtocol{
    func didComeFromProductListViewController(value: Bool) {
        self.bottomCostrainTableView.constant = 10
        self.setupForViewCartView()
    }
    
    func didComeFromYourCart(value: Bool) {
        self.bottomCostrainTableView.constant = 10
        self.setupForViewCartView()
    }
}

extension HomeViewController:HomeTableViewCellProtocol{
    func addButtonPressed(tag: Int) {
        print(tag)
    }
    
    func subButtonPressed(tag: Int) {
        print(tag)
    }
    
    
}

extension HomeViewController:popUpPopUpViewControllerDelegate,MenuViewControllerProtocol{
    func selectedMenu(option: Int?) {
        if let selectedOption = option{
            switch selectedOption {
            case 0:
                //go to Profile VC
                performSegue(withIdentifier: segueId.profileVCId, sender: nil)
                break
            case 1:
                performSegue(withIdentifier: segueId.transactionVCId, sender: nil)
                break
                
            case 2:
                
                break
                
            case 3:
                self.stringUrlForSelectedPage = webPageURL.privacyPolicy
                self.showWebView()
                break
            case 4:
                self.stringUrlForSelectedPage = webPageURL.FAQ
                self.showWebView()
                break
            case 5:
                self.stringUrlForSelectedPage = webPageURL.aboutUs
                self.showWebView()
                break
            default:
                break
            }
        }
    }
    func didMenuDismis(withOption option: Int?) {
        self.changeContrain(isMenuShown: false)
    }
    
    func popUpButtonTaped(withTag tag: Int) {
        switch tag {
        case 1:
            //clear cart
            //remove all data and save
            self.clearCart()
            break
        case 2:
            //go to Profile VC
            performSegue(withIdentifier: segueId.profileVCId, sender: nil)
            break
        default:
            break
        }
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
