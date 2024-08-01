//
//  ChartViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 01.08.2024.
//

import UIKit

final class ChartViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let barWidth: CGFloat = 58.0
            static let spacing: CGFloat = 12.0
            static let maxBarHeightRatio: CGFloat = 0.8
            static let baseLineHeight: CGFloat = 0.5
            static let dashedLineWidth: CGFloat = 0.5
            static let dashedLinePattern: [NSNumber] = [3, 3]
            static let baseLineYPositionOffset: CGFloat = 40.0
            static let valueLabelVerticalOffset: CGFloat = 4.0
            static let dateLabelVerticalOffset: CGFloat = 4.0
            static let changeLabelVerticalOffset: CGFloat = 6.0
            static let changeLabelSize = CGSize(width: 56, height: 25)
            static let changeLabelCornerRadius: CGFloat = 13.0
        }
    }
    
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
    
    override func setBackgroundImage(named imageName: String) {}
    
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
        let maxBarHeight = chartHeight * Constants.Layout.maxBarHeightRatio
        let baseLineYPosition = chartHeight - Constants.Layout.baseLineYPositionOffset
        
        let baselineLayer = createBaseLine(width: chartWidth,
                                           yPosition: baseLineYPosition)
        chartView.layer.addSublayer(baselineLayer)
        
        for (index, value) in data.valueArray.enumerated() {
            guard let value = value else { continue }

            let barHeight = maxBarHeight * CGFloat(value) / CGFloat(maxValue)
            let xPosition = Constants.Layout.spacing + CGFloat(index) * (Constants.Layout.barWidth + Constants.Layout.spacing)
            let yPosition = baseLineYPosition - barHeight

            let barLayer = createBarLayer(xPosition: xPosition, 
                                          yPosition: yPosition,
                                          height: barHeight)
            chartView.layer.addSublayer(barLayer)
            
            let valueLabel = createValueLabel(value: value, 
                                              unit: data.optionName.metricValue,
                                              xPosition: xPosition,
                                              yPosition: yPosition)
            chartView.addSubview(valueLabel)
            
            let dateLabel = createDateLabel(date: data.dateArray[index], 
                                            xPosition: xPosition,
                                            yPosition: baseLineYPosition)
            chartView.addSubview(dateLabel)

            if index == 0 {
                let dashedLineLayer = createDashedLine(width: chartWidth,
                                                       yPosition: yPosition)
                chartView.layer.addSublayer(dashedLineLayer)
                
                continue
            }
            
            let previousValue = data.valueArray[index - 1] ?? 0
            let changeValue = value - previousValue
            let changeLabel = createChangeLabel(changeValue: changeValue, 
                                                unit: data.optionName.metricValue,
                                                xPosition: xPosition,
                                                yPosition: yPosition,
                                                valueLabelMinY: valueLabel.frame.minY)
            chartView.addSubview(changeLabel)
        }
    }
    
    private func createBaseLine(width: CGFloat, yPosition: CGFloat) -> CALayer {
        let baseLineLayer = CALayer()
        
        baseLineLayer.frame = CGRect(x: 0, y: yPosition, width: width, height: Constants.Layout.baseLineHeight)
        baseLineLayer.backgroundColor = UIColor.primaryWhite.cgColor
        
        return baseLineLayer
    }
    
    private func createBarLayer(xPosition: CGFloat, yPosition: CGFloat, height: CGFloat) -> CALayer {
        let barLayer = CALayer()
        
        barLayer.frame = CGRect(x: xPosition, y: yPosition, width: Constants.Layout.barWidth, height: height)
        barLayer.backgroundColor = UIColor.primaryYellow.cgColor
        barLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        barLayer.cornerRadius = Constants.Layout.barWidth / 4
        
        return barLayer
    }
    
    private func createValueLabel(value: Double, unit: String, xPosition: CGFloat, yPosition: CGFloat) -> UILabel {
        let valueLabel = UILabel()
        
        valueLabel.text = String(format: "%.0f \(unit)", value)
        valueLabel.textColor = .primaryWhite
        valueLabel.font = Fonts.sairaRegular16
        valueLabel.sizeToFit()
        valueLabel.center = CGPoint(x: xPosition + Constants.Layout.barWidth / 2, 
                                    y: yPosition - valueLabel.bounds.height / 2 - Constants.Layout.valueLabelVerticalOffset)
        
        return valueLabel
    }
    
    private func createDateLabel(date: Int, xPosition: CGFloat, yPosition: CGFloat) -> UILabel{
        let dateLabel = UILabel()
        
        dateLabel.text = DateUtils.formatDate(from: date, format: "dd.MM")
        dateLabel.textColor = .primaryWhite
        dateLabel.font = Fonts.sairaRegular16
        dateLabel.sizeToFit()
        dateLabel.center = CGPoint(x: xPosition + Constants.Layout.barWidth / 2, 
                                   y: yPosition + Constants.Layout.baseLineHeight + dateLabel.bounds.height / 2 + Constants.Layout.dateLabelVerticalOffset)
        
        return dateLabel
    }
    
    private func createChangeLabel(changeValue: Double, unit: String, xPosition: CGFloat, yPosition: CGFloat, valueLabelMinY: CGFloat) -> UILabel {
        let changeLabel = UILabel()
        
        changeLabel.text = String(format: "%+.0f \(unit)", changeValue)
        changeLabel.textColor = changeValue > 0 ? .lightRed : .lightGreen
        changeLabel.font = UIFont(name: "Gilroy-SemiBold", size: 14)
        changeLabel.backgroundColor = changeLabel.textColor
        changeLabel.textColor = .primaryWhite
        changeLabel.textAlignment = .center
        changeLabel.sizeToFit()
        changeLabel.frame.size = Constants.Layout.changeLabelSize
        changeLabel.center = CGPoint(x: xPosition + Constants.Layout.barWidth / 2, 
                                     y: valueLabelMinY - changeLabel.bounds.height / 2 - Constants.Layout.changeLabelVerticalOffset)
        changeLabel.layer.cornerRadius = Constants.Layout.changeLabelCornerRadius
        changeLabel.layer.masksToBounds = true
        
        return changeLabel
    }

    private func createDashedLine(width: CGFloat, yPosition: CGFloat) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.primaryWhite.cgColor
        shapeLayer.lineWidth = Constants.Layout.dashedLineWidth
        shapeLayer.lineDashPattern = Constants.Layout.dashedLinePattern
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: yPosition), CGPoint(x: width, y: yPosition)])
        shapeLayer.path = path
        
        return shapeLayer
    }

}
