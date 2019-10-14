//
//  CustomCell.swift
//  Painting-Master
//
//  Created by RTC-HN154 on 10/14/19.
//  Copyright © 2019 RTC-HN154. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    var imgView : UIImageView!
    let kCellWidth : CGFloat = 44
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        
        addSubViews()
    }
    
    
    func addSubViews() {
        if imgView == nil {
            imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: kCellWidth, height: kCellWidth))
            imgView.layer.borderColor = tintColor.cgColor
            contentView.addSubview(imgView)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imgView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
}
