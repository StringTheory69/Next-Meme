//
//  custom_view.swift
//  UpMeme
//
//  Created by jason smellz on 7/6/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

class CustomView : UIView {
    
    var label: UILabel!
    var imageView: UIImageView!
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        label.text = " iPhone 6s Plus"
        let url = "http://i.telegraph.co.uk/multimedia/archive/03058/iphone_6_3058505b.jpg"
        imageView.image = UIImage(data: NSData(contentsOf: URL(string: url)! as URL)! as Data)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    func addSubviews() {
        imageView = UIImageView()
        addSubview(imageView)
        label = UILabel()
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.borderWidth = 0.5
//        layer.cornerRadius = 5
        imageView.frame = CGRect(x: bounds.size.width/4, y: 0, width: bounds.size.width/4, height: bounds.size.height)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        label.frame = CGRect(x: bounds.size.width/2, y: 0, width: bounds.size.width/2, height: bounds.size.height)
//        label.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        label.textAlignment = .center
        label.textColor = .white
    }
    
    @IBInspectable var text: String? {
        didSet { label.text = text }
    }
    
    @IBInspectable var image: UIImage? {
        didSet { imageView.image = image }
    }
}

@IBDesignable
class RoundedImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
