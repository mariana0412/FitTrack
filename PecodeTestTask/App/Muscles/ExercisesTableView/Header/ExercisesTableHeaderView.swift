//
//  ExercisesTableHeaderView.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.08.2024.
//

import UIKit

class ExercisesTableHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = String(describing: ExercisesTableHeaderView.self)
    
    private enum Constants {
        enum Layout {
            static let underlineHeight: CGFloat = 1
            static let underlineTop: CGFloat = 12
            static let headerViewBottom: CGFloat = 16
            static let chevronUpImage = UIImage(systemName: "chevron.up")
            static let chevronDownImage = UIImage(systemName: "chevron.down")
        }
    }
    
    private let label = UILabel()
    private let countLabel = UILabel()
    private let underlineView = UIView()
    private let arrowImageView = UIImageView()
        
    weak var delegate: ExercisesTableHeaderViewDelegate?
    var section: Int?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
        setupGesture()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        setupArrowImageView()
        
        let font = Fonts.helveticaNeue18 ?? UIFont.systemFont(ofSize: 18, weight: .regular)
        setupLabel(label, textColor: .primaryWhite, font: font)
        setupLabel(countLabel, textColor: .primaryWhite, font: font)
        
        setupUnderlineView(underlineView, backgroundColor: .primaryWhite)
        
        addSubviews([label, countLabel, underlineView, arrowImageView])
        
        setConstraints()
    }
    
    func configure(with title: String, count: Int, isExpanded: Bool) {
        label.text = title
        countLabel.text = count > 0 ? "\(count)" : nil
        arrowImageView.image = isExpanded ? Constants.Layout.chevronUpImage : Constants.Layout.chevronDownImage
    }
    
    private func setupArrowImageView() {
        arrowImageView.tintColor = .primaryYellow
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
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
            arrowImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            arrowImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            underlineView.heightAnchor.constraint(equalToConstant: Constants.Layout.underlineHeight),
            underlineView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underlineView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constants.Layout.underlineTop),
            contentView.bottomAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: Constants.Layout.headerViewBottom)
        ])
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        if let section = section {
            delegate?.toggleSection(section)
        }
    }
    
}
