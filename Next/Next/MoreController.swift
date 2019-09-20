//
//  MoreController.swift
//  UpMeme
//
//  Created by jason smellz on 7/30/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MoreController: UIViewController, FUIAuthDelegate {
    
    var authViewController: UIViewController!

    @IBAction func moreButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let alert = UIAlertController(title: "Age Restriction", message: "Are you over the age of 17?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    // if user is not signed in then open Firebase Auth UI
                    if Auth.auth().currentUser == nil {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
