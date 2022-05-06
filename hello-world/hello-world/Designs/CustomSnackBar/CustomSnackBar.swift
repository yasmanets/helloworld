//
//  CustomSnack.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 6/5/22.
//

import Foundation
import UIKit

class CustomSnackBar: UIView {
    @IBOutlet weak var view:            UIView!
    @IBOutlet weak var textLabel:       UILabel!
    @IBOutlet weak var button:          UIButton!
    @IBOutlet weak var closeImageView:  UIImageView!
    
    @IBOutlet weak var trailingLabelConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomLabelConstraint:   NSLayoutConstraint?
    @IBOutlet var viewHeightConstraint:         NSLayoutConstraint?
    
    private var originPoint:    CGPoint?
    
    private weak var leftMarginConstraint    : NSLayoutConstraint? = nil
    private weak var rightMarginConstraint   : NSLayoutConstraint? = nil
    private weak var bottomMarginConstraint  : NSLayoutConstraint? = nil
    private weak var minHeightConstraint     : NSLayoutConstraint? = nil
    private weak var centerXConstraint       : NSLayoutConstraint? = nil
    
    private var type:           SnackbarTypes       = .text
    private var duration:       SnackbarDurarion    = .middle
    private var timer:          Timer?              = Timer()
    
    static var defaultFrame:    CGRect  = CGRect(x:0, y: 0, width: 320, height: 44)
    static var minHeight:       CGFloat = 44
    static var BACKGROUND_TAG:  Int     = 100
    
    private var buttonAction:   ((_ snackbar:CustomSnackBar) -> Void)? = nil
    private var isLocked:       Bool    = false
    private var isDisplayed:    Bool    = false
    
    public var closeAction:     ((_ snackbar: CustomSnackBar) -> Void)? = nil
    
    /**
     Snackbar types:
     - `full`:          Displays the snackbar with icon, close button, text and bottom button.
     - `withoutButton`: Displays the snackbar without the bottom button.
     - `textAndClose`:  Displays the snackbar with text and close button.
     - `textAndButton`: Displays the snackbar with text and bottom button.
     - `text`:          Displays the snackbar with text only.
     */
    enum SnackbarTypes: Int {
        case full           = 1
        case withoutButton  = 3
        case textAndClose   = 4
        case textAndButton  = 6
        case text           = 7
    }
    
    /**
     Snackbar duration types and it is represented in seconds.
     */
    public enum SnackbarDurarion: Int {
        case short      = 1
        case middle     = 3
        case long       = 5
        case forever    = 2147483647
    }
    
    private var leftMargin: CGFloat = 4 {
        didSet {
            leftMarginConstraint?.constant = leftMargin
            superview?.layoutIfNeeded()
        }
    }
    
    private var rightMargin: CGFloat = 4 {
        didSet {
            leftMarginConstraint?.constant = rightMargin
            superview?.layoutIfNeeded()
        }
    }
    
    private var bottomMargin: CGFloat = 4 {
        didSet {
            leftMarginConstraint?.constant = bottomMargin
            superview?.layoutIfNeeded()
        }
    }
    
    private var topMargin: CGFloat = 4 {
        didSet {
            leftMarginConstraint?.constant = topMargin
            superview?.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Initializers
    static func createSnackbar(message: String) -> CustomSnackBar {
        let snackbar = Bundle.main.loadNibNamed("CustomSnackBar", owner: self, options: nil)?.first as! CustomSnackBar
        snackbar.initSnackbarProperties("", message, .text, .forever)
        snackbar.isLocked = true
        snackbar.setup()
        return snackbar
    }
    
    static func createSnackbar(message: String, type: SnackbarTypes, duration: SnackbarDurarion) -> CustomSnackBar {
        let snackbar = Bundle.main.loadNibNamed("CustomSnackBar", owner: self, options: nil)?.first as! CustomSnackBar
        snackbar.initSnackbarProperties("", message, type, duration)
        snackbar.setup()
        return snackbar
    }
    
    static func createSnackbar(buttonTitle: String, message: String, type: SnackbarTypes, duration: SnackbarDurarion, buttonAction: @escaping (_ snackbar: CustomSnackBar) -> Void) -> CustomSnackBar {
        let snackbar = Bundle.main.loadNibNamed("CustomSnackBar", owner: self, options: nil)?.first as! CustomSnackBar
        snackbar.initSnackbarProperties(buttonTitle, message, type, duration)
        snackbar.buttonAction = buttonAction
        snackbar.setup()
        return snackbar
    }
    
    private func initSnackbarProperties(_ buttonTitle: String, _ message: String, _ type: SnackbarTypes, _ duration: SnackbarDurarion) {
        self.textLabel.text = message
        self.type           = type
        self.duration       = duration
        self.button.setTitle(buttonTitle, for: .normal)
    }
    
    // MARK: - Configure view
    private func setup() {
        self.setupContainerView()
        self.setupTapGestureRecognizers()
        self.setupButton()
        self.setupSnackbarByType()
    }
    
    private func setupContainerView() {
        self.view.layer.cornerRadius    = 4.0
        self.view.backgroundColor       = .black
        self.view.alpha                 = 1
        self.view.clipsToBounds         = true
    }
    
    private func setupTapGestureRecognizers() {
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanSnackbar(_:))))
        self.closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSnackbar(_:))))
        self.closeImageView.isUserInteractionEnabled = true
    }
    
    private func setupButton() {
        self.button.layer.cornerRadius = 4
    }
    
    @objc func didTapSnackbar(_ sender: UITapGestureRecognizer) {
        if self.closeAction == nil {
            self.dismissAnimation(moveToY: self.view.frame.origin.y + 100)
        }
        else {
            closeAction?(self)
        }
        
    }
    
    @objc func didPanSnackbar(_ gesture: UIPanGestureRecognizer) {
        let velocity: CGPoint = gesture.velocity(in: self.view)
        // Down gesture.
        if (velocity.y > 0 && !isLocked) {
            self.dismissAnimation(moveToY: self.view.frame.origin.y + 100)
        }
    }
    
    @IBAction func didTabButton(_ sender: Any) {
        buttonAction?(self)
    }
    
    // MARK: - Manage Snackbar types
    private func setupSnackbarByType() {
        switch self.type {
        case .text:
            self.closeImageView.isHidden = true
            self.button.isHidden         = true
            
            self.hideButtonConstraints()
            self.updateViewHeight()
        
        case .textAndClose:
            self.button.isHidden         = true
            
            self.hideButtonConstraints()
            self.updateViewHeight()
            
        case .textAndButton:
            self.closeImageView.isHidden = false
            
            self.updateViewHeight()
            
        case .withoutButton:
            self.button.isHidden         = true
            
            self.hideButtonConstraints()
            self.updateViewHeight()
            
        case .full:
            self.updateFullViewConstraints()
        }
    }
    
    // MARK: - Snackbar types constraints
    private func updateFullViewConstraints() {
        self.viewHeightConstraint?.constant += self.textLabel.textSize().height - 25
    }
    
    private func updateViewHeight() {
        self.viewHeightConstraint?.constant     = CustomSnackBar.minHeight
        if self.textLabel.textSize().height > self.textLabel.bounds.size.height {
            self.viewHeightConstraint?.constant = CustomSnackBar.minHeight + self.textLabel.textSize().height - 5
        }
        self.viewHeightConstraint?.isActive     = true
    }
    
    private func hideButtonConstraints() {
        self.bottomLabelConstraint              = self.textLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12)
        self.bottomLabelConstraint?.isActive    = true
    }
    
    private func updateTextTrailingConstraints() {
        self.trailingLabelConstraint = self.textLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        self.trailingLabelConstraint?.isActive   = true
    }
        
    // MARK: - Show methods
    public func show() {
        if self.isDisplayed == true {
            return
        }
        self.isDisplayed = true
        // Create timer
        self.timer = Timer.scheduledTimer(timeInterval: (TimeInterval)(self.duration.rawValue), target: self, selector: #selector(dismissByDuration), userInfo: nil, repeats: false)

        RunLoop.main.add(self.timer!, forMode: .common)

        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        window.addSubview(self.view)
        
        self.leftMarginConstraint   = self.view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: self.leftMargin)
        self.rightMarginConstraint  = self.view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -self.rightMargin)
        self.bottomMarginConstraint = self.view.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -self.bottomMargin)
        self.centerXConstraint      = self.view.centerXAnchor.constraint(equalTo: window.centerXAnchor)

        self.leftMarginConstraint?.priority     = UILayoutPriority(999)
        self.rightMarginConstraint?.priority    = UILayoutPriority(999)
        self.bottomMarginConstraint?.priority   = UILayoutPriority(999)
        self.centerXConstraint?.priority        = UILayoutPriority(999)
        
        self.leftMarginConstraint?.isActive     = true
        self.rightMarginConstraint?.isActive    = true
        self.bottomMarginConstraint?.isActive   = true
        self.centerXConstraint?.isActive        = true
        self.viewHeightConstraint?.isActive     = true
        
        self.showAnimation()
    }
    
    public func showUp() {
        self.show()
        
        if let _ = UIApplication.getPresentedViewController() {
            if self.originPoint == nil {
                self.originPoint = self.frame.origin
            }
            var frame = self.frame
            frame.origin.y = self.originPoint!.y
        }
    }
    
    /**
     Function to displaying the snackbar by blocking the ViewController passed by parameter
     - Parameter viewController: UIViewController.
     - Returns: Void
     */
    public func showBlocked() {
        if self.isDisplayed == true {
            return
        }
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        let background = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height))
        background.backgroundColor = .lightGray
        background.alpha = 0.5
        background.isUserInteractionEnabled = true
        background.tag = CustomSnackBar.BACKGROUND_TAG
        
        window.addSubview(background)

        self.showUp()
    }
    
    public func dismiss() {
        self.dismissAnimation(moveToY: self.view.frame.origin.y + 100)
    }
    
    /**
     Function to dismissing the snackbar by unlocking the ViewController passed by parameter
     - Parameter viewController: UIViewController.
     - Returns: Void
     */
    public func dismissBlocked() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        if let viewWithTag = window.viewWithTag(CustomSnackBar.BACKGROUND_TAG) {
            viewWithTag.removeFromSuperview()
        }
        self.dismissAnimation(moveToY: self.view.frame.origin.y)
    }
    
    @objc func dismissByDuration() {
        DispatchQueue.main.async {
            () -> Void in
            self.dismissAnimation(moveToY: self.view.frame.origin.y)
        }
    }
    
    // MARK: - Animations
    fileprivate func showAnimation() {
        let currentFrame    = self.view.frame
        self.view.alpha     = 0.0
        self.view.frame     = CGRect(x: currentFrame.origin.x, y: self.view.frame.origin.y + 100, width: currentFrame.width, height: currentFrame.height)
        superview?.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .allowUserInteraction, animations: {
            self.view.frame = currentFrame
            self.view.alpha = 1.0
        }, completion: nil)
    }
    
    fileprivate func dismissAnimation(moveToY: CGFloat) {
        self.invalidDismissTimer()

        let currentFrame    = self.view.frame
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .allowUserInteraction, animations: {
            self.view.frame = CGRect(x: currentFrame.origin.x, y: moveToY, width: currentFrame.width, height: currentFrame.height)
            self.view.alpha = 0.0
            self.isDisplayed = false
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    /**
     Invalid the dismiss timer.
     */
    fileprivate func invalidDismissTimer() {
        timer?.invalidate()
        timer = nil
    }
}
