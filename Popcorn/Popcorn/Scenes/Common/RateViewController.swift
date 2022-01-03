//
//  RateViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/19.
//

import UIKit
import RxSwift
import RxCocoa

class RateViewController: BaseViewController {
    var viewModel: RateViewModel!

    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var rateLb: UILabel!
    @IBOutlet var starIvs: [UIImageView]!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    
    var touchValue: Observable<Float>?
    
    convenience init(viewModel: RateViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        rateSlider.addGestureRecognizer(tapGestureRecognizer)
        
        touchValue = tapGestureRecognizer.rx.event
            .map { [weak self] gesture -> Float in
                guard let self = self else { return 0 }
                let pointTapped: CGPoint = gesture.location(in: self.rateSlider.superview)
                
                let positionOfSlider: CGPoint = self.rateSlider.frame.origin
                let widthOfSlider: CGFloat = self.rateSlider.frame.size.width
                let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(self.rateSlider.maximumValue) / widthOfSlider)
                
                self.rateSlider.setValue(Float(newValue), animated: true)
                return Float(newValue)
            }
        
        saveBtn.setTitle("saveRate".localized, for: .normal)
        deleteBtn.setTitle("removeRate".localized, for: .normal)
    }
    
    func bindViewModel() {
        let ready = self.rx.viewWillAppear.take(1).asObservable()
        let slideValue = rateSlider.rx.value.asObservable()
        let touchValue = touchValue ?? .empty()
        let rateValue = Observable.merge(slideValue, touchValue)
        let save = saveBtn.rx.tap.asObservable()
        let delete = deleteBtn.rx.tap.asObservable()
        let dismiss = dismissBtn.rx.tap.asObservable()
        
        let input = RateViewModel.Input(ready: ready,
                                        rateValue: rateValue,
                                        save: save,
                                        delete: delete,
                                        dismiss: dismiss)
        
        let output = viewModel.transform(input: input)
        
        output.rate
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] rate in
                guard let self = self else { return }
                
                self.rateLb.text = "\(rate)"
                self.rateSlider.setValue(Float(rate), animated: false)
            })
            .disposed(by: disposeBag)
        
        output.starImageNames
            .asDriverOnErrorJustComplete()
            .drive(onNext: { imgNames in
                for (index, iv) in self.starIvs.enumerated() {
                    guard let imgName = imgNames[safe: index] else {
                        return
                    }
                    
                    iv.image = UIImage(named: imgName)
                }
            })
            .disposed(by: disposeBag)
        
        output.saveEnable
            .asDriverOnErrorJustComplete()
            .drive(saveBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.deleteHidden
            .asDriverOnErrorJustComplete()
            .drive(deleteBtn.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}
