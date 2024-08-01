//
//  ChartViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 01.08.2024.
//

import UIKit

final class ChartViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    
    var viewModel: ChartViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> ChartViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.chart, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.chartViewController) as! ChartViewController
    }
    
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let _ = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationItemTitle ?? "",
            backAction: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToProgress()
    }
    
    private func setupUI() {
        titleLabel.textColor = .primaryWhite
        titleLabel.font = Fonts.sairaRegular24
        
        subtitleLabel.textColor = .secondaryGray
        subtitleLabel.font = Fonts.sairaMedium16
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.titleText
        subtitleLabel.attributedText = getSubtitleText()
    }
    
    private func getSubtitleText() -> NSAttributedString {
        let subtitleText = viewModel?.subtitleText ?? ""
        let initialDate = viewModel?.initialDate ?? ""
        
        let subtitle = "\(subtitleText) \(initialDate)"
        let attributedString = NSMutableAttributedString(string: subtitle)
        
        let boldText = initialDate
        let range = (subtitle as NSString).range(of: boldText)
        if let customFont = Fonts.sairaMedium18 {
            attributedString.addAttribute(.font, value: customFont, range: range)
        } else {
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: range)
        }
        
        return attributedString
    }
    
    
}
