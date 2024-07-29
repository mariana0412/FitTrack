//
//  OptionCollectionCell.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.07.2024.
//

import UIKit

class OptionCollectionCell: UICollectionViewCell {
    
    static let identifier = "OptionCollectionCell"
    
    private enum Constants {
        static let identifier = "OptionCollectionCell"
        
        enum Layout {
            static let containerCornerRadius: CGFloat = 10
            static let containerBorderWidth: CGFloat = 1
            static let containerBorderColor = UIColor.primaryWhite.cgColor
        }
        
        enum Font {
            static let optionNameFont = UIFont(name: "HelveticaNeue", size: 20)
            static let optionValueFont = UIFont(name: "HelveticaNeue-Bold", size: 30)
            static let optionMeasureFont = UIFont(name: "HelveticaNeue", size: 20)
            static let changedValueFont = UIFont(name: "Gilroy-SemiBold", size: 19)
        }
        enum Color {
            static let increaseColor = UIColor.lightRed
            static let decreaseColor = UIColor.lightGreen
        }
    }

    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var optionValue: UILabel!
    @IBOutlet weak var optionMeasure: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var changedValue: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func configure(with option: OptionData) {
        optionName.text = option.optionName.rawValue
        if let value = option.valueArray.last, let value {
            optionValue.text = "\(value)"
        }
        
        optionMeasure.text = option.optionName.metricValue
        
        if let change = option.changedValue {
            if change > 0 {
                changedValue.text = "+\(change)"
                circleView.backgroundColor = Constants.Color.increaseColor
            } else {
                changedValue.text = "\(change)"
                circleView.backgroundColor = Constants.Color.decreaseColor
            }
        } else {
            changedValue.text = ""
            circleView.backgroundColor = UIColor.clear
        }
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = Constants.Layout.containerCornerRadius
        containerView.layer.borderWidth = Constants.Layout.containerBorderWidth
        containerView.layer.borderColor = Constants.Layout.containerBorderColor
        containerView.layer.masksToBounds = true
        
        optionName.font = Constants.Font.optionNameFont
        optionName.textColor = .primaryWhite
        
        optionValue.font = Constants.Font.optionValueFont
        optionValue.textColor = .primaryYellow
        
        optionMeasure.font = Constants.Font.optionMeasureFont
        optionMeasure.textColor = .primaryWhite

        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.clipsToBounds = true
        
        changedValue.font = Constants.Font.changedValueFont
        changedValue.textColor = .primaryWhite
    }
}
