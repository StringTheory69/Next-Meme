//
//  SignInVC.swift
//  Seven
//
//  Created by jason smellz on 11/20/18.
//  Copyright © 2018 777 LLC. All rights reserved.
//

import UIKit
import FirebaseUI

class SignInController: UIViewController, FUIAuthDelegate {
    
    var authViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth()]
        
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.providers = providers
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI!.delegate = self
        authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
    
}
