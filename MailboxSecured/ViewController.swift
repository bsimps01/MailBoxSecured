//
//  ViewController.swift
//  MailboxSecured
//
//  Created by Benjamin Simpson on 1/30/21.
//

import UIKit
import AWSAuthUI
import AWSAuthCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showSignIn()
    }
    
    func showSignIn(){
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController.presentViewController(with: self.navigationController!, configuration: nil, completionHandler: { (provider: AWSSignInProvider, error:Error?) in
                    if error != nil {
                        print("Error occurred: \(String(describing: error))")
                    } else {
                        print("Logged in with provider: \(provider.identityProviderName) with Token: \(provider.token())")
                        self.view.window?.rootViewController = HomeViewController()
                    }
                    
                })
        }
    }


}

