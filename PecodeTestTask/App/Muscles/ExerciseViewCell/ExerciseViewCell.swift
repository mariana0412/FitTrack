//
//  ExerciseViewCell.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 06.08.2024.
//

import UIKit

class ExerciseViewCell: UITableViewCell {
    
    private enum Constants {
        enum Layout {
            static let contentViewCornerRadius: CGFloat = 8
            static let contentViewBorderWidth: CGFloat = 1
            static let contentViewBorderColor = UIColor.primaryWhite.cgColor
            static let contentViewBorderWidthSelected: CGFloat = 2
            static let contentViewBorderColorSelected = UIColor.primaryYellow.cgColor
            static let attributesFont = UIFont(name: "Nunito-Light", size: 14)
            static let buttonFont = UIFont(name: "Nunito-Light", size: 16)
            static let attributesNumberOfLines = 0
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attributesLabel: UILabel!
    @IBOutlet weak var moreAboutButton: CustomButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var checkmark: CustomCheckmark!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        checkmark.setSelected(selected)
        setBorderStyle(isSelected: selected)
    }
    
    func configure(with exercise: Exercise, buttonText: String) {
        nameLabel.text = exercise.name
        attributesLabel.text = exercise.attributes
        icon.image = UIImage(named: exercise.imageIcon)
        moreAboutButton.buttonTitle = buttonText
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = Constants.Layout.contentViewCornerRadius
        setBorderStyle(isSelected: false)
        
        nameLabel.font = Fonts.sairaRegular18
        nameLabel.textColor = .primaryWhite
        
        attributesLabel.font = Constants.Layout.attributesFont
        attributesLabel.textColor = .primaryYellow
        attributesLabel.numberOfLines = Constants.Layout.attributesNumberOfLines
        
        moreAboutButton.setupButtonFont(font: Constants.Layout.buttonFont, color: .primaryYellow)
    }
    
    private func setBorderStyle(isSelected: Bool) {
        contentView.layer.borderWidth = isSelected ? Constants.Layout.contentViewBorderWidthSelected : Constants.Layout.contentViewBorderWidth
        contentView.layer.borderColor = isSelected ? Constants.Layout.contentViewBorderColorSelected : Constants.Layout.contentViewBorderColor
    }
    
}
