//
//  ProductDescriptionViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 13/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class ProductDescriptionViewController: UIViewController {
    
    @IBOutlet weak var productDescescriptionTableView:UITableView!
    @IBOutlet weak var productDescriptionCollectionView:UICollectionView!
    @IBOutlet weak var pageController:UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
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
        
        return cell
    }
    
    
}


//collection view protocolls of the product ProductDescriptionViewController
extension ProductDescriptionViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.productDescriptionCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier.productDescriptionCollectionViewCellID, for: indexPath) as! ProductDesctiptionCollectionViewCell
        
        cell.activityIndicator.startAnimating()
        
        //if there is image in the uiimage array for the index path then show that
        //else download image using the url from the array of the product details class and store it in a different [uiimage]
        //stop the activity indicator
        
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
        
        //setting the initial value of page controller 
        self.pageController.numberOfPages = 3
        self.pageController.currentPage = 0
    }
}
