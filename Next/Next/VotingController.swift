//
//  VotingController.swift
//  UpMeme
//
//  Created by jason smellz on 6/30/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class VotingController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SwipeCardsDelegate {
    
    var networking = Networking()
    var memeId: String = ""
    var cell = CAEmitterCell()
    var particleEmitter: CAEmitterLayer!
    var prizeView: PrizeView!

//    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var swipeCardView: SwipeCardView?
    var imageReference: StorageReference {
        return Storage.storage().reference() //.child("images")
    }
    @IBAction func closeButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func uploadButton(_ sender: Any) {
//        uploadButtonAction()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var user = Auth.auth().currentUser;
//        if user != nil {
//            username = user?.displayName
//            userID = user?.uid
//        }
        
//        addPrizeView()
        makeEmitterCell()
        
        // setup activity indicator 
        activityIndicator.hidesWhenStopped = true
//        activityIndicator.startAnimating()
        activityIndicator.style = .whiteLarge
    }
    
//    func addPrizeView() {
//        prizeView = PrizeView(frame: CGRect(x: 10, y: self.view.bounds.height/4, width: self.view.bounds.width - 20, height: self.view.bounds.height/2))
//        view.addSubview(prizeView)
//        prizeView.topLabel.text = "0.001 BTC"
//        prizeView.backgroundColor = .red
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addSwipeCard()
//        createParticles()

        if swipeCardView?.dataSource == nil {
            self.swipeCardView?.dataSource = #imageLiteral(resourceName: "Next_placeholder")
        }
    }
    
    func addSwipeCard() {
        
//        if prizeView != nil {
//            prizeView?.removeFromSuperview()
//        }
        
        if swipeCardView != nil {
            swipeCardView?.removeFromSuperview()
        }
        
        swipeCardView = SwipeCardView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        view.insertSubview(swipeCardView!, belowSubview: activityIndicator)
        
        swipeCardView?.translatesAutoresizingMaskIntoConstraints = false
        swipeCardView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        swipeCardView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        swipeCardView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        swipeCardView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        swipeCardView?.delegate = self
        

    }
    
    func downloadImage(_ filename: String?, _ moreContentExists: Bool) {
        
        if moreContentExists {
            memeId = filename!
            let downloadImageRef = imageReference.child(filename! + ".jpg")
            
            let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
                if let data = data {
                    let image = UIImage(data: data)
//                    self.imageView.image = image
                    self.addSwipeCard()
                    self.swipeCardView?.dataSource = image
                }
                print(error ?? "NO ERROR")
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true

            }
            
            downloadtask.observe(.progress) { (snapshot) in
                print(snapshot.progress ?? "NO MORE PROGRESS")
            }
            // this was causing a crash
            //        downloadtask.resume()
        } else {
            // NO more content exists image
            self.addSwipeCard()
            self.swipeCardView?.dataSource =  #imageLiteral(resourceName: "tune_in_later")
            self.activityIndicator.stopAnimating()

        }
    }
    
    func swipeDidEnd(vote: Bool) {
        print("HELLO")
        
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        // if swipe reaches threshold download bundle

        if vote == true {

            print("TRUE")
            // go through queue
            networking.getMeme(memeId, true, downloadImage)
            animateParticles(true)
        } else {
            print("FALSE")
            // go through queue
            networking.getMeme(memeId, false, downloadImage)
            animateParticles(false)
        }
    }
    
//    @IBAction func upVoteButton(_ sender: Any) {
//        print("Up vote")
//        networking.getMeme(memeId, true, downloadImage)
//    }
//    @IBAction func downVoteButton(_ sender: Any) {
//        print("Down vote")
//        networking.getMeme(memeId, false, downloadImage)
//    }
//
//
    func animateParticles(_ up: Bool) {
        createParticles()

        if up == true {
            cell.contents = #imageLiteral(resourceName: "thumbsupsprite").cgImage
        } else {
            cell.contents = #imageLiteral(resourceName: "thumbsdownsprite").cgImage
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (success) in
            print("DESTRUCTION")
            self.destroyParticles()
        }

    }
    
    func makeEmitterCell() -> CAEmitterCell {
//        cell = CAEmitterCell()
        cell.birthRate = 5
        cell.lifetime = 1
        cell.lifetimeRange = 1
        cell.color = UIColor.white.cgColor
        cell.velocity = -200
        cell.velocityRange = 5
        cell.emissionLongitude = CGFloat.pi
        
        //        cell.emissionRange = CGFloat.pi / 10
        cell.spin = 0.007
        //        cell.spinRange = -0.007
//                cell.scaleRange = 0.1
        //        cell.scaleSpeed = -0.05
        cell.contents = #imageLiteral(resourceName: "noun_like_1555605").cgImage
        return cell
    }

    func createParticles() {
        
        particleEmitter = CAEmitterLayer()
        particleEmitter.emitterPosition = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width:  self.view.frame.size.width/2, height: 1)

//        let red = makeEmitterCell()

        particleEmitter.emitterCells = [cell]
//        particleEmitter.birthRate = 0
    
        self.view.layer.addSublayer(particleEmitter)
    }
    
    func destroyParticles() {
        particleEmitter.removeFromSuperlayer()
    }
    
}
