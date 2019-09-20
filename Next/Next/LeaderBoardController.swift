//
//  LeaderBoardController.swift
//  UpMeme
//
//  Created by jason smellz on 6/30/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit
import Firebase

class LeaderBoardController: UITableViewController {

//    var memes: [Meme] = []
    var contests: [Contest] = []
    var votingController: VotingController!
    var winnersController: WinnersViewController!
    var releaseDate: Date?
    var countdownTimer = Timer()
    var contest: Contest!
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(self, selector: #selector(updateTime), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        votingController = storyboard.instantiateViewController(withIdentifier: "votingController") as! VotingController
                
        self.tableView.register(LeaderCell.self, forCellReuseIdentifier: "leaderCell")
    
//        tableView.rowHeight = 490
//        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)

        let db = Firestore.firestore()
        
        
        db.collection("contests").getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
    
                for document in querySnapshot!.documents {
                    
                    var contestItem = Contest.init(
                        endTime: document.data()["endTime"] as! Timestamp,
                        prize: document.data()["prize"] as! Int
                    )
                    
//                    print("HERE",contestItem)
                    
                    if let winners = document.data()["winners"] as? NSDictionary {
                        
//                        print("WINNERS",winners)
                        for winner in winners {
                            //                        print("\(document.documentID) => \(document.data())")
                            if let win = winner.value as? NSDictionary {
                                let meme = Meme.init(
                                    username: win.value(forKey: "username") as! String,
                                    votes: win.value(forKey: "votes") as! Int,
                                    timestamp: win.value(forKey: "timestamp") as! Timestamp,
                                    url: winner.key as! String,
                                    earnings: (win.value(forKey: "earnings") as! NSNumber).description)
                                contestItem.winners.append(meme)
                            }
                            
                        }
                        
                        // order winners greatest to least votes
                        
                        contestItem.winners.sort {
                            return $0.votes > $1.votes
                        }
                        
                    }
                    
                    self.contests.append(contestItem)
                
                }
                
//                print("CONTESTS", self.contests)
                
                    // sort winners greatest votes to least
                    self.contests.sort {
                        return $0.seconds > $1.seconds
                    }
//
                    for (key, contest) in self.contests.enumerated() {
                        if contest.winners.count >= 1 {
                            self.downloadImage(contest.winners[0].url, key)
                        }
                        
                    }

                    self.tableView.reloadData()
            }
            
        }
        
//        db.collection("contests").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//
//
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    var meme = Meme.init(
//                        username: document.data()["username"] as! String,
//                        votes: document.data()["votes"] as! Int,
//                        timestamp: document.data()["timestamp"] as! Timestamp,
//                        url: document.documentID as! String,
//                        earnings: document.data()["earnings"] as! Int)
//                    self.memes.append(meme)
//
//                }
//
//                // sort winners greatest votes to least
//                self.memes.sort {
//                    return $0.seconds > $1.seconds
//                }
//
//                var count = 0
//
//                for (key, meme) in self.memes.enumerated() {
//                    print("KEY", count, key)
//                    self.downloadImage(meme.url, key)
//                    count += 1
//                }
//
//                self.tableView.reloadData()
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getContest()

    }
    
    func downloadImage(_ filename: String, _ row: Int)  {
        
        
        var imageReference: StorageReference {
            return Storage.storage().reference() // .child("images")
        }
        
        let downloadImageRef = imageReference.child(filename + ".jpg")
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in

            if let data = data {
                var image = UIImage(data: data)!
                self.contests[row].winners[0].image = image
                self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)

            }
            print(error ?? "NO ERROR")
        }

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contests.count //+ 1
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "jackpotCell") as! JackpotCell
            cell.amountLabel.text = String(contests[indexPath.row].prize) + " BTC"
//            cell.countdownLabel.text =
//            cell.jackpotView.backgroundColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.6)
//            let gesture = UITapGestureRecognizer(target: self, action: #selector(openVotingView))
//            cell.jackpotView.addGestureRecognizer(gesture)
            return cell
            }
        default: do {
            let row = indexPath.row - 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "leaderCell") as! LeaderCell
            //     let cell = tableView.dequeueReusableCell(withIdentifier: "leaderBoardCell", for: indexPath) as! LeaderBoardCell
            
            
            if contests[indexPath.row].winners[0].image != nil {
                cell.earningsLabel.text = String(contests[indexPath.row].prize) + " BTC"
//                cell.votesLabel.text = "votes " + String(memes[row].votes)
//                cell.dateLabel.text = String(memes[row].username)
                cell.dateLabel.text = String(contests[indexPath.row].endDate)
                cell.mainImageView.image = contests[indexPath.row].winners[0].image
//                let gesture = UITapGestureRecognizer(target: self, action: #selector(openWinnersView))
//                cell.addGestureRecognizer(gesture)
            }
            return cell
            }
        
        }
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: do {
            openVotingView()
            }
        default: do {
            openWinnersView(indexPath.row - 1)
            }
            
        }
    }
    
    @objc func openVotingView() {

        present(votingController, animated: true, completion: nil)

    }
    
    @objc func openWinnersView(_ contestNumber:Int) {
        print("WINNERS")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        winnersController = WinnersViewController.init(collectionViewLayout: flowLayout)
        winnersController.winners = contests[contestNumber].winners
        present(winnersController, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: return 200
            
        //        case 2:  return 50
        default: do {
            var currentImage: UIImage!
            let row = indexPath.row
            if contests[row].winners[0].image != nil {
                currentImage = contests[row].winners[0].image
                let imageRatio = currentImage.getImageRatio()
                return (tableView.frame.width - 50) / imageRatio + 60
            } else {
                return tableView.frame.width + 10
            }
            
            }
        
        }

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
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? JackpotCell {
            cell.amountLabel.text = String(contest.prize) + "BTC"
            cell.countdownLabel.text = String(countdown)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }

        
        print("\(String(contest.prize)) BTC WINNER in \(countdown)")
        
//        let navigationItem = UINavigationItem(title: "\(String(contest.prize)) BTC WINNER in \(countdown)")
        
//        let more = UIBarButtonItem(image: #imageLiteral(resourceName: "cog"), style: .plain, target: self, action: #selector(openMoreController))// UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(openMoreController))
//        more.tintColor = .white
//        navigationItem.rightBarButtonItem  = more
//        navigationBar.setItems([navigationItem], animated: false)
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

class LeaderBoardCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var voterLabel: CustomView!
    @IBOutlet weak var earnedLabel: CustomView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
}

class JackpotCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var jackpotView: RoundedView!
    
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}
