//
//  PosePracticeResultViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import Combine
import CombineCocoa
import UIKit

final class PosePracticeResultViewController: UIViewController {
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 28)
        label.textAlignment = .left
        label.textColor = .mainWhite
        label.text = "your_result_txt".localized()
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 72)
        label.textAlignment = .center
        label.textColor = .mainWhite
        label.text = "96/100" // TEST
        label.attributedText = arrangeScoreText(text: label.text ?? "")
        
        return label
    }()
    
    private lazy var scoreDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 24)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .mainWhite
        label.text = "Congratulations!\nYou passed the CPR posture test." // TEST
        return label
    }()
    
    private let compressRateResultView: EvaluationResultView = {
        let view = EvaluationResultView()
        view.setImage(imgName: "ruler")
        view.setResultImageView(isSuccess: false)
        view.setTitle(title: "Compression Rate")
        view.setResultLabelText(as: "0.5 per 1 time")
        view.setDescriptionLabelText(as: "It’s too fast. Little bit Slower")
        return view
    }()
    
    private let pressDepthResultView: EvaluationResultView = {
        let view = EvaluationResultView()
        view.setImage(imgName: "ruler")
        view.setResultImageView(isSuccess: true)
        view.setTitle(title: "Press Depth")
        view.setResultLabelText(as: "Slightly shallow")
        view.setDescriptionLabelText(as: "Press little deeper")
        return view
    }()
    
    private let armAngleResultView: EvaluationResultView = {
        let view = EvaluationResultView()
        view.setImage(imgName: "ruler")
        view.setResultImageView(isSuccess: true)
        view.setTitle(title: "Arm Angle")
        view.setResultLabelText(as: "Adequate")
        view.setDescriptionLabelText(as: "Nice Angle!")
        return view
    }()
    
    private let finalResultView = ScoreResultView()
    
    private let quitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainWhite
        button.layer.cornerRadius = 24
        button.titleLabel?.font = UIFont(weight: .bold, size: 20)
        button.setTitleColor(.mainBlack, for: .normal)
        button.setTitle("quit".localized(), for: .normal)
        return button
    }()
    
    private let viewModel: EducationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var score: Int = 0
    
    init(viewModel: EducationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpConstraints()
        setUpStyle()
        bind(viewModel: viewModel)
        setUpText()
        
        setUpOrientation(as: .landscape) // TEST CODE
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let make = Constraints.shared
        
        let scoreStackView = UIStackView()
        scoreStackView.axis  = NSLayoutConstraint.Axis.horizontal
        scoreStackView.distribution  = UIStackView.Distribution.equalSpacing
        scoreStackView.alignment = UIStackView.Alignment.center
        scoreStackView.spacing   = 100
        
        let resultStackView = UIStackView()
        resultStackView.axis = NSLayoutConstraint.Axis.horizontal
        resultStackView.distribution = UIStackView.Distribution.equalSpacing
        resultStackView.alignment = UIStackView.Alignment.center
        resultStackView.spacing = 110
        
        [
            resultLabel,
            scoreStackView,
            resultStackView,
            quitButton
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: make.space16),
            resultLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            resultLabel.widthAnchor.constraint(equalToConstant: 200),
            resultLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            scoreStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            scoreStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            scoreStackView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: make.space8),
            scoreStackView.heightAnchor.constraint(equalToConstant: 108)
        ])
        
        NSLayoutConstraint.activate([
            resultStackView.leadingAnchor.constraint(equalTo: scoreStackView.leadingAnchor),
            resultStackView.trailingAnchor.constraint(equalTo: scoreStackView.trailingAnchor),
            resultStackView.topAnchor.constraint(equalTo: scoreStackView.bottomAnchor, constant: make.space8),
            resultStackView.heightAnchor.constraint(equalToConstant: 128)
        ])
        
        [
            scoreLabel,
            scoreDescriptionLabel
        ].forEach({
            scoreStackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 92),
            scoreLabel.widthAnchor.constraint(equalToConstant: 158),
            scoreLabel.heightAnchor.constraint(equalToConstant: 108)
        ])
        
        NSLayoutConstraint.activate([
            scoreDescriptionLabel.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 100),
            scoreDescriptionLabel.widthAnchor.constraint(equalToConstant: 396),
            scoreDescriptionLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        let evaluationResultViewArr = [
            armAngleResultView,
            compressRateResultView,
            pressDepthResultView
        ]
        
        evaluationResultViewArr.forEach({
            resultStackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 196).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 196).isActive = true
        })
        
        NSLayoutConstraint.activate([
            armAngleResultView.leadingAnchor.constraint(equalTo: resultStackView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            compressRateResultView.centerXAnchor.constraint(equalTo: resultStackView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pressDepthResultView.trailingAnchor.constraint(equalTo: resultStackView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            quitButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            quitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quitButton.widthAnchor.constraint(equalToConstant: 206),
            quitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setUpStyle() {
        view.backgroundColor = .mainRed
    }
    
    private func bind(viewModel: EducationViewModel) {
        quitButton.tapPublisher.sink { [weak self] _ in
            self?.setUpOrientation(as: .portrait)
            Task {
                _ = try await viewModel.savePosturePracticeResult(score: self?.score ?? 0)
                let rootVC = TabBarViewController(0)
                await self?.view.window?.setRootViewController(rootVC)
            }
        }.store(in: &cancellables)
    }

    private func setUpText() {
        let result = viewModel.judgePostureResult()
        compressRateResultView.setResultLabelText(as: result.compResult.rawValue)
        compressRateResultView.setDescriptionLabelText(as: result.compResult.description)
        armAngleResultView.setResultLabelText(as: result.angleResult.rawValue)
        armAngleResultView.setDescriptionLabelText(as: result.angleResult.description)
        pressDepthResultView.setResultLabelText(as: result.pressDepth.rawValue)
        pressDepthResultView.setDescriptionLabelText(as: result.pressDepth.description)
        score = result.compResult.score + result.angleResult.score + result.pressDepth.score + 1
        finalResultView.setUpScore(score: score)
    }
    
    private func arrangeScoreText(text: String) -> NSAttributedString {
        var range: Int = 0
        let attributedString = NSMutableAttributedString(string: text)
        if let rangeS = text.range(of: "/") {
            range = text.distance(from: text.startIndex, to: rangeS.lowerBound)
        }
        
        let realScoreAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont(weight: .bold, size: 72) ?? UIFont(),
            .foregroundColor : UIColor.mainWhite
        ]
        
        let defaultScoreAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont(weight: .bold, size: 32) ?? UIFont(),
            .foregroundColor : UIColor.mainLightRed
        ]
        
        attributedString.addAttributes(realScoreAttributes, range: NSRange(location: 0, length: range))
        attributedString.addAttributes(defaultScoreAttributes, range: NSRange(location: range, length: attributedString.length - range))
        
        return attributedString
    }
}
