//
//  OptionTableViewCell.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 24.07.2024.
//

import UIKit

class OptionCell: UITableViewCell {

    @IBOutlet weak var checkmark: CustomCheckmark!
    @IBOutlet weak var name: UILabel!
    
    weak var delegate: OptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupActions()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configure(with option: OptionDataName, isSelected: Bool) {
        name.text = option.rawValue
        name.font = Fonts.sairaRegular18
        name.textColor = .primaryWhite
        
        checkmark.setSelected(isSelected)
    }
    
    private func setupActions() {
        checkmark.didToggleSelection = { [weak self] in
            guard let self = self else { return }
            self.delegate?.didTapCheckmark(in: self)
        }
    }
    
}
