//
//  PrizeView.swift
//  UpMeme
//
//  Created by jason smellz on 8/3/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

class PrizeView: UIView {
    
    var topLabel: UILabel!
    var bottomLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topLabel = UILabel()
        bottomLabel = UILabel()
        
        topLabel.font = UIFont(name: "Helvetica", size: 30)
        topLabel.textColor = .green
        topLabel.textAlignment = .center
        bottomLabel.font = UIFont(name: "Helvetica", size: 20)
        bottomLabel.textColor = .green
        bottomLabel.textAlignment = .center
        bottomLabel.text = "Daily Jackpot"
        
        addSubview(topLabel)
        addSubview(bottomLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        constraints()
    }
    
    func constraints() {
        
        topLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topLabel.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor, constant: -20).isActive = true
        
        bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        createParticles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        // set the shadow properties
        
    }
    
    func createParticles() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: 100, y: 100)
        particleEmitter.emitterShape = .circle
        particleEmitter.emitterSize = CGSize(width: frame.size.width, height: 10)
        
        let red = makeEmitterCell(0)
        let green = makeEmitterCell(1)
        let blue = makeEmitterCell(2)
//        makeEmitterCell(2)
//        makeEmitterCell(2)
        
        particleEmitter.emitterCells = [red, green, blue]
        
        layer.addSublayer(particleEmitter)
    }
    
    func makeEmitterCell(_ number: Int) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 0.1
        cell.lifetime = 100
        cell.lifetimeRange = 1
        cell.color = UIColor.white.cgColor
        cell.velocity = 10
        cell.velocityRange = 5
        cell.emissionLongitude = CGFloat.pi / CGFloat(number * 10)
        cell.emissionRange = 100
        cell.spin = 0.007
        cell.spinRange = 0.5
        cell.scaleRange = 0.1
        cell.scaleSpeed = -0.05
        let arrayOfImages = [#imageLiteral(resourceName: "thumbsUp").cgImage,#imageLiteral(resourceName: "noun_Money_2194384").cgImage,#imageLiteral(resourceName: "trophySmall").cgImage]
        cell.contents = arrayOfImages[number]
        return cell
    }

}
