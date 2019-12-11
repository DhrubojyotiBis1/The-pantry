//
//  HomeViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 11/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet var conteverView: [UIView]!
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
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
    }
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.adsCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier.adsCellID, for: indexPath) as! HomeCollectionViewCell
        cell.adsImageView.image = UIImage(named: "Logo")
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