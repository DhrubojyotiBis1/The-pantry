//
//  ContactUsViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 11/02/20.
//  Copyright © 2020 coded. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var navigationView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callUsButtonPressed(_ sender:UIButton){
        print("Call")
        let phoneNumber = 08080913452
        guard let url  = URL(string: "tel://\(phoneNumber)") else{return}
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    @IBAction func emailUsBUttonPressed(_ sender:UIButton){
        print("Email")
        guard MFMailComposeViewController.canSendMail() else{return}
        
        
        let mailId = "info@gourmetatthepantry.com"
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([mailId])
        
        self.present(composer, animated: true) {
            print("Mail view controller presented")
        }
    }
    
    @IBAction func whatsappUsButtonPressed(_ sender:UIButton){
        
        let urlWhats = "https://api.whatsapp.com/send?phone=+918080913452&abid=12354&text=Hi,The_Pantry"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                } else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
}

extension ContactUsViewController:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error{
            //show error
            controller.dismiss(animated: true) {
                print("Mail view controller dismised")
            }
            return
        }
        
        switch result {
        case .cancelled:
            print("canceled")
            break
        case .failed:
            print("Failed")
            break
        case .sent:
            print("Sent")
            break
        case .saved:
            print("saved")
            break
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
        
    }
}


extension ContactUsViewController{
    
    private func setup(){
        //makeing the card view for the view
        self.navigationView.layer.masksToBounds = false
        self.navigationView.layer.shadowColor = UIColor.gray.cgColor
        self.navigationView.layer.shadowOpacity = 0.4
        self.navigationView.layer.shadowOffset = CGSize(width: 0, height: 4.5)
    }
}
