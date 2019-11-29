//
//  QuestionView.swift
//  Open Quizz
//
//  Created by Yohan W. Dunon on 24/11/2019.
//  Copyright © 2019 Yohan W. Dunon. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    enum Style {
        case Correct, Incorrect, Standard
    }
    
    var title = "" {
        didSet {
            label.text = title
        }
    }
    
    var style : Style = .Standard {
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle(_ style: Style) {
        switch style {
        case .Correct:
            backgroundColor = UIColor(red: 200.0/255.0, green: 236.0/255.0, blue: 160.0/255.0, alpha: 1)
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
        case .Incorrect:
            backgroundColor = UIColor(red: 243.0/255.0, green: 135.0/255.0, blue: 148.0/255.0, alpha: 1)
            icon.image = UIImage(named: "Icon Error")
            icon.isHidden = false
        case .Standard:
            backgroundColor = UIColor(red: 191.0/255.0, green: 196.0/255.0, blue: 201.0/255.0, alpha: 1)
            icon.isHidden = true
        }
    }

}
