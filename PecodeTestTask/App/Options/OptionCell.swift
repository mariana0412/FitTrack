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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with option: OptionDataName, isSelected: Bool) {
        name.text = option.rawValue
        checkmark.setSelected(isSelected)
    }
    
}
