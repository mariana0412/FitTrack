//
//  OptionNameViewCell.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 02.08.2024.
//

import UIKit

class OptionNameViewCell: UITableViewCell {

    let optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .primaryWhite
        label.font = Fonts.helveticaNeue16
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = UIEdgeInsets.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = .clear
        contentView.addSubview(optionLabel)
        
        NSLayoutConstraint.activate([
            optionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: optionLabel.bottomAnchor, constant: 12)
        ])
        
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .primaryWhite
        self.contentView.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(with text: String) {
        optionLabel.text = text
    }
}

