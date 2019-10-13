//
//  ImageEditViewController.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 07.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import MessageUI

/// Edit Controller used to edit the selected mars rover image
class ImageEditViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var editScrollView: UIScrollView!
    @IBOutlet weak var editImageView: UIImageView!
    // Constraints
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let brandColor = UIColor(red: 0, green: 102/255, blue: 179/255, alpha: 1.0)
    private let postcardFont = UIFont(name: "Futura-Medium", size: 20.0)!
    
    var navigationBar: NavigationBar?
    var marsImage: MarsRoverImage!
    var postCardView: UIView!
    var colorPaletteView: UIStackView!
    var fillLayer = CAShapeLayer()
    var postCardTextField: UITextField!
    var postcardTextColor: UIColor = .white

    var minZoomScale: CGFloat {
        let viewSize = view.bounds.size
        let widthScale = viewSize.width / editImageView.bounds.width
        let heightScale = viewSize.height / editImageView.bounds.height
        return min(widthScale, heightScale)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        setupNavigationBar()
        addPostcardView()
        addPostcardMask(gutter: 32.0, topMargin: 44.0)
        editScrollView.delegate = self
        editImageView.image = marsImage.image
        editImageView.sizeToFit()
        editScrollView.contentSize = editImageView.bounds.size
        setZoomScale()
        updateConstraints(view.bounds.size)
        view.backgroundColor = .black
    }
    
    /// Set the Scrollview zoomscale
    func setZoomScale() {
        editScrollView.minimumZoomScale = 1.0
        editScrollView.zoomScale = 1.0
        editScrollView.maximumZoomScale = 2.0
    }
    
    /** Update constraints according to the zoom scale
     
     - Parameters:
        - size: The size used to set the constraints accordingly
     
     - Returns: Void
     */
    func updateConstraints(_ size: CGSize) {
        let verticalSize = size.height - editImageView.frame.height
        
        let yOffset = max(0, verticalSize / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width / editImageView.frame.width)/2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
    }
    
    /**
     Set up the Navigation bar
     */
    func setupNavigationBar() {
        navigationBar = NavigationBar(for: self.view, title: "Crop", leftButton: .close, rightButton: .next, leftButtonAction: #selector(closeEdit), rightButtonAction: #selector(cropImage))
        navigationBar?.load()
    }
    
    /// @objc method to crop the image, set the user selected text and email the image using MessageUI
    @objc func addTextAndSend() {
        // Text modification - Start
        guard let image = editImageView.image, let text = postCardTextField.text else { return }
        let renderer = UIGraphicsImageRenderer(size: postCardView.frame.size)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let finalPostcardImage = renderer.image { ctx in
            
            let textAttributes = [
                NSAttributedString.Key.font: postcardFont,
                NSAttributedString.Key.backgroundColor: UIColor.black.withAlphaComponent(0.4),
                NSAttributedString.Key.foregroundColor: postcardTextColor,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: textAttributes)
            
            image.draw(in: CGRect(origin: CGPoint.zero, size: postCardView.frame.size))
            
            
            let center = CGPoint(x: (postCardView.frame.size.width - postCardTextField.frame.width) / 2.0, y: (postCardView.frame.size.height - postCardTextField.frame.height) / 2.0)
            
            attributedString.draw(at: center)
        }
        // Text modification - End
        
        sendPostCard(finalPostcardImage)
    }
    
    /// @objc method used to reset a crop when user navigates back a step
    @objc func resetCrop() {
        editImageView.image = marsImage.image
        addPostcardMask(gutter: 32.0, topMargin: 44.0)
        addPostcardView()
        postCardTextField.removeFromSuperview()
        colorPaletteView.removeFromSuperview()
        navigationBar?.navItem.title = "Crop"
        navigationBar?.navItem.leftBarButtonItem = NavBarButton.close.button(action: #selector(closeEdit))
        navigationBar?.navItem.rightBarButtonItem = NavBarButton.next.button(action: #selector(cropImage))
        setZoomScale()
        updateConstraints(view.bounds.size)
    }
    
    /// @objc method to crop image
    @objc func cropImage() {
        
        guard let currentImage = editImageView.image else { return }
        
        // Start - Cropping
        
        let imageViewScale = max(currentImage.size.width / editImageView.frame.width, currentImage.size.height / editImageView.frame.height)
        
        let cropRect = CGRect(x: postCardView.frame.origin.x - editImageView.getRealImageRect().origin.x, y: postCardView.frame.origin.y - editImageView.getRealImageRect().origin.y, width: postCardView.frame.width, height: postCardView.frame.height)
        
        let cropArea = CGRect(x: cropRect.origin.x * imageViewScale, y: cropRect.origin.y * imageViewScale, width: cropRect.size.width * imageViewScale, height: cropRect.size.height * imageViewScale)
        
        guard let croppedImageReference = editImageView.image?.cgImage?.cropping(to: cropArea) else { return }
        
        let croppedImage = UIImage(cgImage: croppedImageReference)
        
        // End - Cropping
        
        editImageView.image = croppedImage
        navigationBar?.navItem.title = "Add Text"
        navigationBar?.navItem.leftBarButtonItem = NavBarButton.backStep.button(action: #selector(resetCrop))
        navigationBar?.navItem.rightBarButtonItem = NavBarButton.send.button(action: #selector(addTextAndSend))
        
        editScrollView.zoomScale = 1.0
        updateConstraints(view.bounds.size)
        
        postCardView.removeFromSuperview()
        fillLayer.removeFromSuperlayer()
        
        addPostCardTextfield()
        addColorPalette()
    }
    
    /// @objc to dismiss the editing view and return to the image viewer
    @objc func closeEdit() {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Method used to add a mask to indicate which portion of the screen will be used to crop the image
     
     - Parameters:
        - gutter: The gutter used to create the mask
        - topMargin: The margin to the top used to start the mask
     
     - Returns: Void
     */
    func addPostcardMask(gutter: CGFloat, topMargin: CGFloat) {
        fillLayer.removeFromSuperlayer()
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let layerRect = CGRect(x: 0, y: topMargin, width: screenWidth, height: screenHeight - topMargin)
        
        let postcard = CGRect(x: (screenWidth - (screenWidth - gutter)) / 2.0, y: (( screenHeight - ((screenWidth - gutter) / 1.41)) / 2.0), width: (screenWidth - gutter), height: (screenWidth - gutter) / 1.41)
        let bgPath = UIBezierPath(rect: layerRect)
        let postCardPath = UIBezierPath(rect: postcard)
        
        bgPath.usesEvenOddFillRule = true
        bgPath.append(postCardPath)
        
        fillLayer.path = bgPath.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = brandColor.cgColor
        fillLayer.opacity = 0.3
        
        view.layer.addSublayer(fillLayer)
    }
    
    /// Creates a clear rectangle inside the postcard mask
    func addPostcardView() {
        postCardView = UIView()
        postCardView.isUserInteractionEnabled = false
        postCardView.backgroundColor = .clear
        postCardView.layer.borderWidth = 2.0
        postCardView.layer.borderColor = UIColor.white.cgColor
        editScrollView.addSubview(postCardView)
        // Constraints
        postCardView.translatesAutoresizingMaskIntoConstraints = false
        postCardView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32.0).isActive = true
        postCardView.heightAnchor.constraint(equalTo: postCardView.widthAnchor, multiplier: 1 / 1.41).isActive = true
        postCardView.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height - ((UIScreen.main.bounds.width - 32.0) * (1 / 1.41))) / 2.0).isActive = true
        postCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        postCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
    }

    /// Adds a textfield inside the rectangle to enter the text on the postcard
    func addPostCardTextfield() {
        postCardTextField = UITextField()
        postCardTextField.font = postcardFont
        postCardTextField.textAlignment = .center
        postCardTextField.textColor = .white
        postCardTextField.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        postCardTextField?.text = "Enter your text..."
    
        editScrollView.addSubview(postCardTextField)
        
        // Constraints
        postCardTextField.translatesAutoresizingMaskIntoConstraints = false
        postCardTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postCardTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        addDoneButtonOnKeyboard()
    }
    
    /// Adds a color pallete used to select a text color
    func addColorPalette() {
        
        let colors: [UIColor] = [.white, .black, .red, .blue, .green, .yellow, .cyan, .magenta, .orange]
        
        colorPaletteView = UIStackView()
        colorPaletteView.axis = .horizontal
        colorPaletteView.alignment = .center
        colorPaletteView.distribution = .equalSpacing
        view.addSubview(colorPaletteView)
        
        colorPaletteView.translatesAutoresizingMaskIntoConstraints = false
        colorPaletteView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        colorPaletteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        colorPaletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        colorPaletteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        
        for color in colors {
            let colorButton = UIButton()
            colorButton.backgroundColor = color
            colorButton.setTitle("", for: .normal)
            colorButton.addTarget(self, action: #selector(changeTextColor(sender:)), for: .touchUpInside)
            colorButton.layer.borderWidth = 2.0
            colorButton.layer.borderColor = UIColor.white.cgColor
            colorButton.layer.cornerRadius = 15.0
            colorPaletteView.addArrangedSubview(colorButton)
            
            colorButton.translatesAutoresizingMaskIntoConstraints = false
            colorButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            colorButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            
        }
        
    }
    
    /// @objc method used to change text color of the text on the postcard
    @objc func changeTextColor(sender: UIButton) {
        postcardTextColor = sender.backgroundColor!
        postCardTextField.textColor = sender.backgroundColor
    }
    
    /**
     Sends the postcard when an E-Mail account is provided
     
     - Parameters:
        - image: The image used to send
     
     - Returns: Void
     */
    func sendPostCard(_ image: UIImage) {
        
        guard let emailImage = image.jpegData(compressionQuality: 1.0) else { return }
        let fileName = marsImage.earthDate
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Message from Mars!")
            mail.addAttachmentData(emailImage, mimeType: "image/jpeg", fileName: fileName)
            present(mail, animated: true)
        } else {
            showAlert(with: "No E-Mail Account available", and: "An E-mail account needs to be setup to send the postcard.")
        }
        
    }

    
    /// Adds a 'Done' button to the keyboard tool bar to be able to dismiss the keyboard
    func addDoneButtonOnKeyboard() {
        // TODO: Adjust size for other sizes
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.tintColor = brandColor
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(editDone))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        postCardTextField.inputAccessoryView = doneToolbar
    }
    
    /// Resigns the text view as first responder
    @objc func editDone() {
        postCardTextField.resignFirstResponder()
    }
    
}

/// UIScrollViewDelegate implementation
/// Apple documentation: https://developer.apple.com/documentation/uikit/uiscrollviewdelegate
extension ImageEditViewController: UIScrollViewDelegate {
    
    /// Asks the delegate for the view to scale when zooming is about to occur in the scroll view.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uiscrollviewdelegate/1619426-viewforzooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return editImageView
    }
    
    /// Tells the delegate that the scroll view’s zoom factor changed.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uiscrollviewdelegate/1619409-scrollviewdidzoom
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(view.bounds.size)
    }
    
}

/// An interface for responding to user interactions with a mail compose view controller.
/// Apple documentation: https://developer.apple.com/documentation/messageui/mfmailcomposeviewcontrollerdelegate
extension ImageEditViewController: MFMailComposeViewControllerDelegate {
    
    /// Tells the delegate that the user wants to dismiss the mail composition view.
    /// Apple documentation: https://developer.apple.com/documentation/messageui/mfmailcomposeviewcontrollerdelegate/1616880-mailcomposecontroller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
