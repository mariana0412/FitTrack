//
//  ActivityLevelCell.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 24.07.2024.
//

import UIKit

class ActivityLevelCell: UITableViewCell {

    @IBOutlet weak var radioButton: CustomRadiobutton!
    @IBOutlet weak var name: UILabel!
    
    weak var delegate: ActivityLevelCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupActions()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configure(with option: DailyCaloriesRateActivity, isSelected: Bool) {
        name.text = option.rawValue
        name.font = Fonts.helveticaNeue16
        name.textColor = .primaryWhite
        name.numberOfLines = 0
        
        radioButton.setSelected(isSelected)
    }
    
    private func setupActions() {
        radioButton.didToggleSelection = { [weak self] in
            guard let self = self else { return }
            self.delegate?.didTapRadiobutton(in: self)
        }
    }
    
}
