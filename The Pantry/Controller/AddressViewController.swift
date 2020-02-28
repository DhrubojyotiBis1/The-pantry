//
//  AddressViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 18/01/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit
import Toast_Swift

class AddressViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var scrollViewBottomContrain: NSLayoutConstraint!
    @IBOutlet weak var addressViewHigntConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBarView:UIView!
    @IBOutlet weak var checkBoxButton:UIButton!
    @IBOutlet weak var checkBoxView:UIView!
    @IBOutlet weak var addBillingAddresslable:UILabel!
    @IBOutlet var addBillingAddressTextFields: [UITextField]!
    
    var allAdress = [String]()
    let addressViewHigntConstrainValue:CGFloat = 350
    let scrollViewBottomContrainValue:CGFloat = 30

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
    }
    
    @IBAction func checkBoxButtonPressed(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.addressViewHigntConstrain.constant += self.addressViewHigntConstrainValue
            self.scrollViewBottomContrain.constant -= self.scrollViewBottomContrainValue
            self.wantToShowBillingView(option: true)
        }else{
            self.addressViewHigntConstrain.constant -= self.addressViewHigntConstrainValue
            self.scrollViewBottomContrain.constant += self.scrollViewBottomContrainValue
            self.wantToShowBillingView(option: false)
        }
    }
    
    @IBAction func PayButtonPressed(_ sender:UIButton){
        self.allAdress.removeAll()
        if checkBoxButton.isSelected{
            for i in 0..<self.addBillingAddressTextFields.count{
                if(self.addBillingAddressTextFields[i].text == ""){
                    self.view.makeToast(massage.allFieldsRequired, duration: massage.duration, position: .top)
                    print(massage.allFieldsRequired)
                    return
                }
                allAdress.append(addBillingAddressTextFields[i].text!)
            }
        }else{
            for i in 0..<6{
                if(self.addBillingAddressTextFields[i].text == ""){
                    self.view.makeToast(massage.allFieldsRequired, duration: massage.duration, position: .top)
                    print(massage.allFieldsRequired)
                    return
                }
                allAdress.append(addBillingAddressTextFields[i].text!)
            }
        }
        
        performSegue(withIdentifier: segueId.checkOutVCId, sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.checkOutVCId{
            let destination = segue.destination as! CheckOutViewController
            destination.checkOutAddress = self.allAdress
        }
    }

}

extension AddressViewController{
    
    
    private func setUp(){
        
        //making the navigation bar view card view
        self.navigationBarView.layer.masksToBounds = false
        self.navigationBarView.layer.shadowColor = UIColor.gray.cgColor
        self.navigationBarView.layer.shadowOffset = CGSize(width: 0, height: 4.5)
        self.navigationBarView.layer.shadowOpacity = 0.4
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapCheckBoxView))
        self.checkBoxView.addGestureRecognizer(tapGesture)
        
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroundViewTap))
        self.backgroundView.addGestureRecognizer(backgroundTapGesture)
    }
    
    
    @objc private func onBackgroundViewTap(){
       for i in 0..<self.addBillingAddressTextFields.count {
            self.addBillingAddressTextFields[i].endEditing(true)
        }
    }
    
    @objc private func onTapCheckBoxView(){
        self.checkBoxButtonPressed(self.checkBoxButton)
    }
    
    private func wantToShowBillingView(option:Bool){
           
           self.addBillingAddresslable.isHidden = !option
           self.addBillingAddresslable.isEnabled = option
           
        for i in 6..<self.addBillingAddressTextFields.count {
               self.addBillingAddressTextFields[i].isHidden = !option
               self.addBillingAddressTextFields[i].isEnabled = option
           }
       }
}
