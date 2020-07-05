//
//  HRUILabel.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/7/4.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit

class HRUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.boldSystemFont(ofSize: 25)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
