//
//  UIButton+AlignText.swift
//  Agent
//
//  Created by 于劲 on 2017/11/15.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation

extension UIButton{
    @objc func setTitleAlign(position:UIViewContentMode){
        self.imageView?.contentMode = .center
        self.titleLabel?.contentMode = .center
        
        let title = self.currentTitle
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title?.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + (titleSize?.height)! + 10),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize?.width)!)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + (titleSize?.height)! + 10),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize?.width)!)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -((titleSize?.width)! * 2 + 10))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    @objc func setBorder(type:Int){
        let clr = UIColor(red: 0, green: 140/255, blue: 230/255, alpha: 1.0)
        self.layer.cornerRadius = 5
        switch type {
        case 0:
            self.backgroundColor = clr
            self.layer.borderWidth = 0
            self.titleLabel!.textColor = .white
        case 1:
            self.backgroundColor = .clear
            self.layer.borderWidth = 1
            self.layer.borderColor = clr.cgColor
            self.titleLabel!.textColor = clr
        default:
            break
        }
    }
}
