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
        if let optionData = viewModel?.optionData {
            drawChart(with: optionData)
        }
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
        subtitleLabel.numberOfLines = 0
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
    
    private func drawChart(with data: OptionData) {
        guard let maxValue = data.valueArray.compactMap({ $0 }).max() else { return }

        let chartWidth = chartView.bounds.width
        let chartHeight = chartView.bounds.height
        let barWidth: CGFloat = 58.0
        let spacing: CGFloat = 12
        let maxBarHeight = chartHeight * 0.6
        let baseLineHeight: CGFloat = 0.5
        let baseLineYPosition = chartHeight - 40

        let baseLineLayer = CALayer()
        baseLineLayer.frame = CGRect(x: 0, y: baseLineYPosition, width: chartWidth, height: baseLineHeight)
        baseLineLayer.backgroundColor = UIColor.primaryWhite.cgColor
        chartView.layer.addSublayer(baseLineLayer)

        for (index, value) in data.valueArray.enumerated() {
            guard let value = value else { continue }

            let barHeight = maxBarHeight * CGFloat(value) / CGFloat(maxValue)
            let xPosition = spacing + CGFloat(index) * (barWidth + spacing)
            let yPosition = baseLineYPosition - barHeight

            let barLayer = CALayer()
            barLayer.frame = CGRect(x: xPosition, y: yPosition, width: barWidth, height: barHeight)
            barLayer.backgroundColor = UIColor.primaryYellow.cgColor
            barLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            barLayer.cornerRadius = barWidth / 4

            chartView.layer.addSublayer(barLayer)

            let valueLabel = UILabel()
            valueLabel.text = String(format: "%.0f \(data.optionName.metricValue)", value)
            valueLabel.textColor = .primaryWhite
            valueLabel.font = Fonts.sairaRegular16
            valueLabel.sizeToFit()
            valueLabel.center = CGPoint(x: xPosition + barWidth / 2, y: yPosition - valueLabel.bounds.height / 2 - 4)
            chartView.addSubview(valueLabel)

            let dateLabel = UILabel()
            dateLabel.text = formatDate(from: data.dateArray[index])
            dateLabel.textColor = .primaryWhite
            dateLabel.font = Fonts.sairaRegular16
            dateLabel.sizeToFit()
            dateLabel.center = CGPoint(x: xPosition + barWidth / 2, y: baseLineYPosition + baseLineHeight + dateLabel.bounds.height / 2 + 4)
            chartView.addSubview(dateLabel)

            if index > 0 {
                let previousValue = data.valueArray[index - 1] ?? 0
                let changeValue = value - previousValue

                let changeLabel = UILabel()
                changeLabel.text = String(format: "%+.0f \(data.optionName.metricValue)", changeValue)
                changeLabel.textColor = changeValue > 0 ? .lightRed : .lightGreen
                changeLabel.font = UIFont(name: "Gilroy-SemiBold", size: 14)
                changeLabel.backgroundColor = changeLabel.textColor
                changeLabel.textColor = .primaryWhite
                changeLabel.textAlignment = .center
                changeLabel.sizeToFit()
                changeLabel.frame.size = CGSize(width: 56, height: 25)
                changeLabel.center = CGPoint(x: xPosition + barWidth / 2, y: valueLabel.frame.minY - changeLabel.bounds.height / 2 - 6)
                changeLabel.layer.cornerRadius = 13
                changeLabel.layer.masksToBounds = true
                chartView.addSubview(changeLabel)
            }
        }
    }
    
    private func formatDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date)
    }

}
