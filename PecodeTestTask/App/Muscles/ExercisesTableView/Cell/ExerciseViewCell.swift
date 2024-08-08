//
//  ExerciseViewCell.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 06.08.2024.
//

import UIKit

class ExerciseViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ExerciseViewCell.self)
    
    private enum Constants {
        enum Layout {
            static let contentViewCornerRadius: CGFloat = 8
            static let contentViewBorderWidth: CGFloat = 1
            static let contentViewBorderColor = UIColor.primaryWhite.withAlphaComponent(0.4).cgColor
            static let contentViewBorderWidthSelected: CGFloat = 2
            static let contentViewBorderColorSelected = UIColor.primaryYellow.cgColor
            static let attributesFont = UIFont(name: "Nunito-Light", size: 14)
            static let buttonFont = UIFont(name: "Nunito-Light", size: 16)
            static let nameNumberOfLines = 2
            static let attributesNumberOfLines = 0
            static let spacing: CGFloat = 12
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attributesLabel: UILabel!
    @IBOutlet weak var moreAboutButton: CustomButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var checkmark: CustomCheckmark!
    
    weak var delegate: ExerciseViewCellDelegate?
    
    var cellIsSelected: Bool = false {
        didSet {
            setBorderStyle(isSelected: cellIsSelected)
            setCheckmark(isSelected: cellIsSelected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        setupGestures()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: Constants.Layout.spacing, right: 0))
    }
    
    func configure(with exercise: Exercise, buttonText: String, isSelected: Bool) {
        nameLabel.text = exercise.name
        attributesLabel.text = exercise.attributes
        icon.image = UIImage(named: exercise.imageIcon)
        moreAboutButton.buttonTitle = buttonText
        cellIsSelected = isSelected
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        
        contentView.layer.cornerRadius = Constants.Layout.contentViewCornerRadius
        setBorderStyle(isSelected: false)
        
        nameLabel.font = Fonts.sairaRegular18
        nameLabel.textColor = .primaryWhite
        nameLabel.numberOfLines = Constants.Layout.nameNumberOfLines
        
        attributesLabel.font = Constants.Layout.attributesFont
        attributesLabel.textColor = .primaryYellow
        attributesLabel.numberOfLines = Constants.Layout.attributesNumberOfLines
        
        moreAboutButton.setupButtonFont(font: Constants.Layout.buttonFont, color: .primaryYellow)
        
        setCheckmark(isSelected: false)
    }
    
    private func setBorderStyle(isSelected: Bool) {
        contentView.layer.borderWidth = isSelected ? Constants.Layout.contentViewBorderWidthSelected : Constants.Layout.contentViewBorderWidth
        contentView.layer.borderColor = isSelected ? Constants.Layout.contentViewBorderColorSelected : Constants.Layout.contentViewBorderColor
    }
    
    private func setCheckmark(isSelected: Bool) {
        checkmark.isHidden = !isSelected
        checkmark.setSelected(isSelected)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
        
        checkmark.didToggleSelection = { [weak self] in
            self?.handleTap()
        }
    }
    
    @objc private func handleTap() {
        delegate?.didTapCell(self)
    }
    
}
