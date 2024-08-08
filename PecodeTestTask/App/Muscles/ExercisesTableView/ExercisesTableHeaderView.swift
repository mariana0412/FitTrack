//
//  ExercisesTableHeaderView.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.08.2024.
//

import UIKit

class ExercisesTableHeaderView: UITableViewHeaderFooterView {
    
    enum Constants {
        static let reuseIdentifier = String(describing: self)
        
        enum Layout {
            static let underlineHeight: CGFloat = 1
            static let underlineTop: CGFloat = 12
            static let headerViewBottom: CGFloat = 16
        }
    }
    
    private let label = UILabel()
    private let countLabel = UILabel()
    private let underlineView = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        let font = Fonts.helveticaNeue18 ?? UIFont.systemFont(ofSize: 18, weight: .regular)
        setupLabel(label, textColor: .primaryWhite, font: font)
        setupLabel(countLabel, textColor: .primaryWhite, font: font)
        setupUnderlineView(underlineView, backgroundColor: .primaryWhite)

        addSubviews([label, countLabel, underlineView])
        
        setConstraints()
    }
    
    func configure(with title: String, count: Int) {
        label.text = title
        countLabel.text = count > 0 ? "\(count)" : nil
    }
    
    private func setupLabel(_ label: UILabel, textColor: UIColor, font: UIFont) {
        label.textColor = textColor
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUnderlineView(_ view: UIView, backgroundColor: UIColor) {
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            underlineView.heightAnchor.constraint(equalToConstant: Constants.Layout.underlineHeight),
            underlineView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underlineView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constants.Layout.underlineTop),
            contentView.bottomAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: Constants.Layout.headerViewBottom)
        ])
    }
    
}
