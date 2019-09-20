//
//  WinnersViewController.swift
//  UpMeme
//
//  Created by jason smellz on 8/6/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit
import Firebase

class WinnersViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //...
    
    let cellId = "cellId"
    var winners: [Meme] = []
    
    //...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        //...
    }
    
    func downloadImage(_ filename: String, _ imageNumber: Int)  {
        
        
        var imageReference: StorageReference {
            return Storage.storage().reference() // .child("images")
        }
        
        let downloadImageRef = imageReference.child(filename + ".jpg")
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            
            if let data = data {
                let image = UIImage(data: data)!
                self.winners[imageNumber].image = image
                self.collectionView.reloadItems(at: [IndexPath(row: imageNumber, section: 0)])
                
            }
            print(error ?? "NO ERROR")
        }
        
    }
    
    func setupCollectionView() {
//        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.scrollDirection = .horizontal
//            flowLayout.minimumLineSpacing = 0
//        }
        
        let closeButton = UIButton(frame: CGRect(x: 20, y: 30, width: 100, height: 50))
        closeButton.setTitle("close", for: .normal)
        closeButton.setTitleColor(.red, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(closeButton)
        
        collectionView?.backgroundColor = UIColor.white
        
        //        collectionView?.registerClass(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.register(WinnerCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView?.isPagingEnabled = true
        
        downloadAllImages(winners)
    }
    
    func downloadAllImages(_ memes: [Meme]) {
        
        for (key, meme) in memes.enumerated() {
            downloadImage(meme.url, key)
        }
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSearch() {
//        scrollToMenuIndex(menuIndex: 2)
    }
    
//    func scrollToMenuIndex(menuIndex: Int) {
//        let indexPath = NSIndexPath(item: menuIndex, section: 0)
//        collectionView?.scrollToItem(at: indexPath as IndexPath, at: .none, animated: true)
//    }
    
//    lazy var menuBar: MenuBar = {
//        let mb = MenuBar()
//        mb.homeController = self
//        return mb
//    }()
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
//
        let indexPath = IndexPath(item: index, section: 0)
        print("load this data at array item number", index)
//        menuBar.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return winners.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WinnerCell
        
        let colors: [UIColor] = [.blue, .green, UIColor.gray, .purple]
        cell.dateLabel.text = winners[indexPath.item].timestamp
        cell.earningsLabel.text = String(winners[indexPath.item].earnings)
//        cell.backgroundColor = colors[indexPath.item]
        
        if winners[indexPath.item].image != nil {
    
            cell.mainImageView.image = winners[indexPath.item].image

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
