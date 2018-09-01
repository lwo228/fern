//
//  ViewController.swift
//  BarnsleyFern
//
//  Created by Konrad on 01/09/2018.
//  Copyright © 2018 Konrad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate lazy var headerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.white
        view.addSubview(self.optionsButton)
        return view
    }()
    fileprivate lazy var optionsButton: UIButton = {
        let button: UIButton = UIButton()
        button.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.setTitle("Options", for: UIControlState.normal)
        button.addTarget(self, action: #selector(optionsClick(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    fileprivate lazy var fernImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
    
    // MARK: Options
    fileprivate lazy var optionsView: UIView = {
        let view: UIView = UIView()
        view.isHidden = self.isOptionsHidden
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.addSubview(self.transformsView)
        return view
    }()
    fileprivate lazy var transformsView: UIView = {
        let view: UIView = UIView()
        view.addSubview(self.transformTitleView)
        view.addSubview(self.transformSliderView)
        return view
    }()
    fileprivate lazy var transformTitleView: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Transforms:"
        label.sizeToFit()
        return label
    }()
    fileprivate lazy var transformSliderView: UISlider = {
        let slider: UISlider = UISlider()
        slider.minimumValue = 100
        slider.maximumValue = 1_000_000
        slider.value = 100_000
        slider.addTarget(self, action: #selector(transformChangeEnd(_:)), for: [.valueChanged])
        return slider
    }()
    
    fileprivate var isOptionsHidden: Bool = true
    fileprivate var generationDelayTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.fernImageView)
        self.view.addSubview(self.optionsView)
        self.updateFrames()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.updateFrames(size: size)
    }
    
    @objc func optionsClick(_ sender: UIButton) {
        if self.isOptionsHidden {
            self.showOptions()
        } else {
            self.hideOptions()
        }
    }
    
    @objc func transformChangeEnd(_ sender: UISlider) {
        self.generationDelayTimer?.invalidate()
        self.generationDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                                         repeats: false,
                                                         block: { [weak self] _ in
                                                            self?.generateFern()
        })
    }
    
    // update frames
    fileprivate func updateFrames(size: CGSize? = nil) {
        let size: CGSize = size ?? self.view.bounds.size
        
        // header
        self.headerView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: size.width,
                                       height: 64)
        
        // options
        self.optionsButton.sizeToFit()
        self.optionsButton.frame.origin = CGPoint(
            x: self.headerView.frame.width - self.optionsButton.frame.width,
            y: 20
        )
        
        self.optionsView.frame = CGRect(x: 0,
                                        y: 64,
                                        width: size.width,
                                        height: self.optionsView.frame.height)
        
        // transforms
        self.transformsView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: size.width,
                                           height: 44)
        self.transformTitleView.frame = CGRect(x: 8,
                                               y: 0,
                                               width: self.transformTitleView.frame.width,
                                               height: self.transformsView.frame.height)
        self.transformSliderView.frame = CGRect(x: self.transformTitleView.frame.width + 16,
                                                y: 0,
                                                width: self.transformsView.frame.width - self.transformTitleView.frame.width - 16,
                                                height: self.transformsView.frame.height)
        
        // image
        self.fernImageView.frame = CGRect(x: 0,
                                          y: 144,
                                          width: size.width,
                                          height: size.height - 244)
        
        // generate fern
        self.generateFern()
    }
    
    // generate fern
    fileprivate func generateFern() {
        let transforms: Int = Int(self.transformSliderView.value)
        let image: UIImage? = FernFactory.generate(size: self.fernImageView.frame.size,
                                                   transforms: transforms,
                                                   scale: 3)
        self.fernImageView.image = image
    }
}

// MARK: - Options
extension ViewController {
    
    // show options
    func showOptions() {
        self.isOptionsHidden = false
        self.optionsView.isHidden = false
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.optionsView.frame.size = CGSize(width: self.optionsView.frame.width,
                                                             height: 44)
        })
    }
    
    // hide options
    func hideOptions() {
        self.isOptionsHidden = true
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.optionsView.frame.size = CGSize(width: self.optionsView.frame.width,
                                                             height: 0)
        }, completion: { _ in
            self.optionsView.isHidden = self.isOptionsHidden
        })
    }
}
