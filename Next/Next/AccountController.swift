//
//  AccountController.swift
//  UpMeme
//
//  Created by jason smellz on 6/30/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI

class AccountController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FUIAuthDelegate {
    
    var authViewController: UIViewController!

    var account: Account!
    var dataLoaded = false
    var uploadImage: UIImage!
    var activityView: UIActivityIndicatorView!
    var userID: String!
    var username: String?
    var transferViewController: TransferViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(LeaderCell.self, forCellReuseIdentifier: "accountCell")

        var user = Auth.auth().currentUser;
        if user != nil {
            username = user?.displayName
            userID = user?.uid
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        transferViewController = storyboard.instantiateViewController(withIdentifier: "transferViewController") as! TransferViewController
                
        // remove extra empyt cells
        tableView.tableFooterView = UIView()

        
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        self.view.addSubview(activityView)

        tableView.rowHeight = 490
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initialDownload()
        
    }
    
    func initialDownload() {
        let db = Firestore.firestore()
        
        
        let docRef = db.collection("accounts").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.account = Account.init(
                    username: document.data()?["username"] as! String,
                    totalEarnings: document.data()?["totalEarnings"] as! Int)
                var count = 0
                guard let memesData = document.data()?["memes"] as? NSDictionary else { return }
                for meme in memesData {
                    if let m = meme.value as? NSDictionary {
                        var memeObject = Meme.init(
                            username: m["username"] as! String,
                            votes: m["votes"] as! Int,
                            timestamp: m["timestamp"] as! Timestamp,
                            url: meme.key as! String,
                            earnings: (m["earnings"] as! NSNumber).description)
                        self.account.memes.append(memeObject)
                        self.downloadImage(memeObject.url, count)
                        
                    }
                    print(self.account)
                    count += 1
                }
                self.dataLoaded = true
                self.tableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func downloadImage(_ filename: String, _ row: Int)  {
        
        
        var imageReference: StorageReference {
            return Storage.storage().reference() // .child("images")
        }
        
        let downloadImageRef = imageReference.child(filename + ".jpg")
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            print("ROW", row, self.account.memes)
            if let data = data {
                var image = UIImage(data: data)!
                self.account.memes[row].image = image
                self.tableView.reloadRows(at: [IndexPath(row: row + 1, section: 0)], with: .fade)
                //                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! LeaderBoardCell
                //                cell.imgView.image = image
                //                self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade )
            }
            print(error ?? "NO ERROR")
        }
        
        // this was causing a crash
        //        downloadtask.resume()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard dataLoaded else {return 1}
        return account.memes.count + 1

        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:  do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountHeaderCell", for: indexPath)

            return cell
            
        }
            
//        case 0:  do {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AccountHeaderCell
////            cell.textLabel?.text = "Your total earnings are 0 BTC"
////            cell.backgroundColor = .darkGray
//            cell.winningsButton.addTarget(self, action: #selector(winningsButtonAction), for: .touchUpInside)
//            cell.uploadButton.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
//            cell.uploadButton.setTitle("+ Upload", for: .normal)
//
//            guard dataLoaded else {return cell}
////            cell.textLabel?.text = "Your total earnings are \(account.totalEarnings) BTC"
//            cell.winningsButton.setTitle("Your total earnings are \(account.totalEarnings) BTC", for: .normal)
//            return cell
//
//        }
//        case 1:  do {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = "Upload"
//            cell.backgroundColor = .darkGray
//            return cell
//
//            }
//        case 2:  do {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = "Logout"
//            cell.backgroundColor = .red
//            return cell
//            
//            }
            
        
        default:  do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") as! LeaderCell

//            let cell = tableView.dequeueReusableCell(withIdentifier: "accountMemeCell", for: indexPath) as! AccountMemeCell
                let row = indexPath.row - 1
            cell.earningsLabel.text = "$" + String(self.account.memes[row].earnings)
            cell.votesLabel.text = "Votes: " + String(self.account.memes[row].votes)
            cell.dateLabel.text = String(self.account.memes[row].timestamp)
                
            if self.account.memes[row].image != nil {
                cell.mainImageView.image = self.account.memes[row].image
            }
            return cell

            }
            

        }   
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 100

//        case 2:  return 50
        default: do {
                var currentImage: UIImage!
                if account.memes[indexPath.row - 1].image != nil {
                    currentImage = account.memes[indexPath.row - 1].image
                    let imageRatio = currentImage.getImageRatio()
                    return tableView.frame.width / imageRatio + 50
                } else {
                    return 50
                }
            
            }

        }
    }
    
    @objc func winningsButtonAction() {
        print("WINNNING")
        
        present(transferViewController, animated: true, completion: nil)
        
    }
    
    @objc func uploadButtonAction() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            print("Button capture")
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerController.SourceType.photoLibrary;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            uploadImage = image

            dismiss(animated: true, completion: upload)
        }
    }
    
    
    func upload() {
        print("HERE")
        activityView.startAnimating()
        view.isUserInteractionEnabled = false
        var imageReference: StorageReference {
            return Storage.storage().reference() //.child("images")
        }
    
        guard let imageData = uploadImage.jpegData(compressionQuality:1) else { return }
        
        let filename = UUID().uuidString
        let uploadImageRef = imageReference.child(filename + ".jpg")
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
            self.activityView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.updateDB(filename)
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        uploadTask.resume()
    }
    
    func updateDB(_ imageId: String) {
        
        let db = Firestore.firestore()

        // Create an initial document to update.
        let accountRef = db.collection("accounts").document(userID)
        
        let docData: [String: Any] = [
            "uid": userID,
            "username": username,
            "timestamp": Timestamp(date: Date()),
            "votes": 0,
            "earnings": 0,
        ]

        // Atomically add a new region to the "regions" array field.
        accountRef.updateData([
            "memes.\(imageId)": docData
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("ACCOUNT MEME Document successfully updated")
                self.initialDownload()
                self.memeDB(imageId)
            }
        }
        

    }
    
    func memeDB(_ imageId: String) {
        
        let db = Firestore.firestore()

        // Create an initial document to update.
        let memesRef = db.collection("memes").document(imageId)
        
        let memeData: [String: Any] = [
            "uid": userID,
            "username": username,
            "timestamp": Timestamp(date: Date()),
            "votes": 1,
            "earnings": 0,
            ]
        print("HERE WE GO AGAIN")
        // Atomically add a new region to the "regions" array field.
        memesRef.setData(memeData) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("MEME Document successfully updated")
            }
        }
    }
    
}

class AccountMemeCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}

struct Meme {
    var username: String!
    var votes: Int!
    var timestamp: String!
    var seconds: Int!
    var url: String!
    var earnings: String!
    var image: UIImage?
    
    init(username: String, votes: Int, timestamp: Timestamp, url: String, earnings: String) {
        self.username = username
        self.votes = votes
        self.timestamp =  timestamp.dateToElapsedTime()
        self.seconds = Int(timestamp.seconds)
        print("DATE", self.timestamp)
        self.url = url
        self.earnings = earnings
    }
    
//    func dateToElapsedTime(_ timestamp: Timestamp) -> String {
//        let seconds = Timestamp().seconds - timestamp.seconds
//        print("SECONDS", seconds)
//        if seconds < 60 {
//            return String(seconds) + " secs"
//        } else if seconds < 3600 {
//            var unit = " mins"
//            if seconds >= 60*2 {
//                unit = " mins"
//            }
//            return String(seconds / 60) + unit
//        } else if seconds < 86400 {
//            var unit = " hr"
//            if seconds >= 3600*2 {
//                unit = " hrs"
//            }
//            return String(seconds / 60 / 60) + unit
//        } else if seconds < 2592000 {
//            var unit = " day"
//            if seconds >= 86400*2 {
//                unit = " days"
//            }
//            return String(seconds / 60 / 60 / 24) + unit
//        } else {
//            var unit = " month"
//            if seconds >= 2592000*2 {
//                unit = " months"
//            }
//            return String(seconds / 60 / 60 / 24 / 30) + unit
//        }
    
//        return timestamp.dateValue().toString(withFormat: "dd-MMM-yyyy")
//    }
    
}

class AccountHeaderCell:  UITableViewCell {
    
    @IBOutlet weak var accountImageView: RoundedImageView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var earningsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var uploadButton: RoundedButton!
    @IBOutlet weak var yourContentButton: RoundedButton!
    @IBOutlet weak var starredContentButton: RoundedButton!
    
}

struct Account {
    
    var username: String!
    var memes: [Meme] = []
    var totalEarnings: Int = 0
    
    init(username: String, totalEarnings: Int) {
        self.username = username
        self.totalEarnings = totalEarnings
    }
    
}

extension Date {
    
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format
        
        return formatter.string(from: yourDate!)
    }
}

extension Timestamp {
    
    func dateToElapsedTime() -> String {
        let seconds = Timestamp().seconds - self.seconds
        print("SECONDS", seconds, Timestamp().seconds , self.seconds)
        if seconds < 60 {
            return String(seconds) + " secs"
        } else if seconds < 3600 {
            var unit = " mins"
            if seconds >= 60*2 {
                unit = " mins"
            }
            return String(seconds / 60) + unit
        } else if seconds < 86400 {
            var unit = " hr"
            if seconds >= 3600*2 {
                unit = " hrs"
            }
            return String(seconds / 60 / 60) + unit
        } else if seconds < 2592000 {
            var unit = " day"
            if seconds >= 86400*2 {
                unit = " days"
            }
            return String(seconds / 60 / 60 / 24) + unit
        } else {
            var unit = " month"
            if seconds >= 2592000*2 {
                unit = " months"
            }
            return String(seconds / 60 / 60 / 24 / 30) + unit
        }
    }
        
}
