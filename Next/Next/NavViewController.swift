//
//  NavViewController.swift
//  UpMeme
//
//  Created by jason smellz on 8/5/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase

class NavViewController: UINavigationController, FUIAuthDelegate {

    var authViewController: UIViewController!
    var moreController: MoreController!
    var time: String!
//    var navigationBar: UINavigationBar!
    var releaseDate: Date?
    var countdownTimer = Timer()
    var contest: Contest!
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        notificationCenter.addObserver(self, selector: #selector(updateTime), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        moreController = storyboard.instantiateViewController(withIdentifier: "moreController") as! MoreController
        openMoreController()
        
    }
    
    func startTimer(_ endTime: Date) {
        
        releaseDate = endTime
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        print("COUNT", diffDateComponents.hour?.description.count)
        
        var hour: String!
        
        if diffDateComponents.hour != nil {
            if diffDateComponents.hour!.description.count == 2 {
                hour = diffDateComponents.hour!.description
            } else {
                hour = "0" + diffDateComponents.hour!.description
            }
        } else {
            hour = "00"
        }
        
        var minute: String!
        
        if diffDateComponents.minute != nil {
            if diffDateComponents.minute!.description.count == 2 {
                minute = diffDateComponents.minute!.description
            } else {
                minute = "0" + diffDateComponents.minute!.description
            }
        } else {
            minute = "00"
        }
        
        var second: String!
        
        if diffDateComponents.second != nil {
            if diffDateComponents.second!.description.count == 2 {
                second = diffDateComponents.second!.description
            } else {
                second = "0" + diffDateComponents.second!.description
            }
        } else {
            second = "00"
        }
        
        let countdown = "\(String(hour)):\(String(minute)):\(String(second))"
        //
        //        // if contest is over get new contest details
        if countdown == "00:00:00" {
            getContest()
        }
        
        time = countdown
        
        let navigationItem = UINavigationItem(title: "\(String(contest.prize)) BTC WINNER in \(countdown)")
        
        let more = UIBarButtonItem(image: #imageLiteral(resourceName: "cog"), style: .plain, target: self, action: #selector(openMoreController))// UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(openMoreController))
        more.tintColor = .white
        navigationItem.rightBarButtonItem  = more
        navigationBar.setItems([navigationItem], animated: false)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        var darkGray = UIColor.init(red: 18/288, green: 18/288, blue: 18/288, alpha: 1)
        var topView = UIView()
//        navigationBar = UINavigationBar()
        
        self.view.addSubview(topView)
        self.view.addSubview(navigationBar)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        topView.backgroundColor = darkGray
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        navigationBar.barTintColor = .clear
        navigationBar.backgroundColor = darkGray
        navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!]
        
        getContest()
        
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
    
    @objc func openMoreController() {
        self.present(moreController, animated: true, completion: nil)
    }
    
    
    func getContest() {
        var contestsArray: [Contest] = []
        // get newest contest from db
        let db = Firestore.firestore()
        
        db.collection("contests").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let c = Contest.init(
                        endTime: document.data()["endTime"] as! Timestamp,
                        prize: document.data()["prize"] as! Int)
                    contestsArray.append(c)
                    
                }
                // sort winners greatest votes to least
                contestsArray.sort {
                    return $0.endTime.timeIntervalSince1970 > $1.endTime.timeIntervalSince1970
                }
                self.contest = contestsArray[0]
                self.startTimer(self.contest.endTime)
                
            }
        }
        
    }
    
}
