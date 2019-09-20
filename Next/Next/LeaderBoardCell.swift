//
//  LeaderBoardCell.swift
//  UpMeme
//
//  Created by jason smellz on 7/31/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

class LeaderCell: UITableViewCell {
    
    var dateLabel: UILabel!
    var votesLabel: UILabel!
    var earningsLabel: UILabel!
//    var dateLabel: UILabel!
    var jackpotView: UIView!
    
    var mainImageView : UIImageView  = {
        var imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var imageViewHeight = NSLayoutConstraint()
    var imageRatioWidth = CGFloat()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        var darkGray = UIColor.init(red: 18/288, green: 18/288, blue: 18/288, alpha: 1)

        backgroundColor = .clear
        jackpotView = UIView()
        dateLabel = UILabel()
        votesLabel = UILabel()
        earningsLabel = UILabel()
//        dateLabel = UILabel()
        
        jackpotView.backgroundColor = UIColor.init(red: 150/255, green: 0, blue: 75/255, alpha: 1)
        dateLabel.textColor = .white
        votesLabel.textColor = .white
        earningsLabel.textColor = .white
        earningsLabel.textAlignment = .center
//        dateLabel.textColor = .white
        
        dateLabel.font = UIFont(name: "Helvetica", size: 15)
        votesLabel.font = UIFont(name: "Helvetica", size: 15)
        earningsLabel.font = UIFont(name: "Helvetica-Neue", size: 25)
//        dateLabel.font = UIFont(name: "Helvetica", size: 15)
        
        dateLabel.textAlignment = .left
        
        addSubview(dateLabel)
//        addSubview(votesLabel)
//        addSubview(dateLabel)
        addSubview(mainImageView)
        addSubview(jackpotView)
        addSubview(earningsLabel)

        jackpotView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        votesLabel.translatesAutoresizingMaskIntoConstraints = false
        earningsLabel.translatesAutoresizingMaskIntoConstraints = false
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        mainImageView.translatesAutoresizingMaskIntoConstraints = false

        constraints()
        
    }
    
    func constraints() {
        
        //  usernameLabel
        
        dateLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        // imgView
        
        mainImageView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        // votes
        
//        votesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        votesLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        votesLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
//        votesLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        // earnings
//
        earningsLabel.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor).isActive = true
        earningsLabel.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor).isActive = true
//        earningsLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
//        earningsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        // date
//
//        dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
////        dateLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        dateLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
//        dateLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
        jackpotView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor).isActive = true
        jackpotView.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor).isActive = true
        jackpotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        jackpotView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        constraints()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 20
        
        jackpotView.clipsToBounds = true
        jackpotView.layer.cornerRadius = 25
    }
    
}


class AccountCell: UITableViewCell {
    
//    var usernameLabel: UILabel!
    var votesLabel: UILabel!
    var earningsLabel: UILabel!
    var dateLabel: UILabel!
    
    var mainImageView : UIImageView  = {
        var imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.clipsToBounds = true
        return imageView
    }()
    
    var imageViewHeight = NSLayoutConstraint()
    var imageRatioWidth = CGFloat()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        var darkGray = UIColor.init(red: 18/288, green: 18/288, blue: 18/288, alpha: 1)
        
        backgroundColor = darkGray
        
//        usernameLabel = UILabel()
        votesLabel = UILabel()
        earningsLabel = UILabel()
        dateLabel = UILabel()
        
//        usernameLabel.textColor = .white
        votesLabel.textColor = .white
        earningsLabel.textColor = .white
        dateLabel.textColor = .white
        
//        usernameLabel.font = UIFont(name: "Helvetica", size: 15)
        votesLabel.font = UIFont(name: "Helvetica", size: 15)
        earningsLabel.font = UIFont(name: "Helvetica", size: 15)
        dateLabel.font = UIFont(name: "Helvetica", size: 15)
        
        dateLabel.textAlignment = .right
        
//        addSubview(usernameLabel)
        addSubview(votesLabel)
        addSubview(earningsLabel)
        addSubview(dateLabel)
        addSubview(mainImageView)
        
//        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        votesLabel.translatesAutoresizingMaskIntoConstraints = false
        earningsLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints()
        
    }
    
    func constraints() {
        
        //  usernameLabel
        
//        usernameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        usernameLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
//        usernameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        usernameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        // imgView
        
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        
        // votes
        
        votesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        votesLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        votesLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        votesLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // earnings
        
        earningsLabel.leftAnchor.constraint(equalTo: votesLabel.rightAnchor).isActive = true
        earningsLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        earningsLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        earningsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // date
        
        dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        //        dateLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dateLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        constraints()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class WinnerCell: UICollectionViewCell {
    
        var usernameLabel: UILabel!
    var votesLabel: UILabel!
    var earningsLabel: UILabel!
    var dateLabel: UILabel!
    
    var mainImageView : UIImageView  = {
        var imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var imageViewHeight = NSLayoutConstraint()
    var imageRatioWidth = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
   
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        selectionStyle = .none
    
        var darkGray = UIColor.init(red: 18/288, green: 18/288, blue: 18/288, alpha: 1)
        
        backgroundColor = darkGray
        
        usernameLabel = UILabel()
        votesLabel = UILabel()
        earningsLabel = UILabel()
        dateLabel = UILabel()
        
        usernameLabel.textColor = .white
        votesLabel.textColor = .white
        earningsLabel.textColor = .white
        dateLabel.textColor = .white
        
        usernameLabel.font = UIFont(name: "Helvetica", size: 15)
        votesLabel.font = UIFont(name: "Helvetica", size: 15)
        earningsLabel.font = UIFont(name: "Helvetica", size: 15)
        dateLabel.font = UIFont(name: "Helvetica", size: 15)
        
        dateLabel.textAlignment = .right
        
        addSubview(usernameLabel)
        addSubview(votesLabel)
        addSubview(earningsLabel)
        addSubview(dateLabel)
        addSubview(mainImageView)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        votesLabel.translatesAutoresizingMaskIntoConstraints = false
        earningsLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints()
        
    }
    
    func constraints() {
        
        //  usernameLabel
        
        usernameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        // imgView
        
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        
        // votes
        
        votesLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        votesLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        votesLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        votesLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // earnings
        
        earningsLabel.leftAnchor.constraint(equalTo: votesLabel.rightAnchor).isActive = true
        earningsLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        earningsLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        earningsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // date
        
        dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        //        dateLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dateLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        constraints()
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
