//
//  ViewController.swift
//  The Pantry
//
//  Created by Dhrubojyoti on 09/12/19.
//  Copyright © 2019 coded. All rights reserved.
//

import UIKit
import DotsLoading

class ViewController: UIViewController {
    
    var destinationSegueId = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.decideDestinationSegueID()
        //doing the networking i.e downloading image if user is going to Home VC
        if self.destinationSegueId == segueId.HomeVCId{
            self.neworking()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //if user is going to the register VC
        if self.destinationSegueId == segueId.loginVCId{
            performSegue(withIdentifier: self.destinationSegueId, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == segueId.HomeVCId){
            //send the images to the Home VC
        }
    }
}

//MARK:- Networking stuff
extension ViewController{
    private func neworking() {
        let animator = createAnimatorDotView()
        self.addConstrain(toAnimator: animator)
        animator.show()
            Networking().downloadImage(havingUrls: nil) { (result) in
                if(result){
                    //Pass the image array to the home VC
                    print("Image download complete")
                }else{
                    //handel the error
                    print("Image download fails")
                }
                animator.stop()
                //going to home VC
                self.performSegue(withIdentifier: self.destinationSegueId, sender: nil)
            }
    }
}

//All private function expet netwoking stuff
extension ViewController{
    
    //decides which VC to go
    private func decideDestinationSegueID(){
        let savedCredentials = save().getCredentials()
        if(savedCredentials[saveCredential.token] != nil){
            //go to home VC
            self.destinationSegueId = segueId.HomeVCId
        }else{
            // go to Register VC
            self.destinationSegueId = segueId.loginVCId
        }
    }
    
    //Creating loading animation
    private func createAnimatorDotView()->DotsLoadingView{
        let dotColors = [UIColor.black, UIColor.black, UIColor.black, UIColor.white]
        let loadingView = DotsLoadingView(colors: dotColors)
        return loadingView
    }
    
    
    private func addConstrain(toAnimator animator:DotsLoadingView){
        //adding to the viewController View
        self.view.addSubview(animator)
        //Adding contrains
        animator.translatesAutoresizingMaskIntoConstraints = false
        animator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60).isActive = true
        animator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
}
