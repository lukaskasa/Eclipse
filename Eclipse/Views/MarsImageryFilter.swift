//
//  MarsImageryFilter.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 19.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class MarsImageryFilter: NSObject {
    
    let view: UIView
    var containerView: UIView
    var pickerView: UIPickerView
    var filterAction: (() -> Void)?
    var bottomConstraint: NSLayoutConstraint?
    
    var sols: [Int] {
        var sols: [Int] = []
        var numberOfSols = 1000
        while numberOfSols >= 1 {
            sols.append(numberOfSols)
            numberOfSols -= 1
        }
        return sols
    }
    
    var cameras = ["FHAZ", "RHAZ", "MAST", "CHEMCAM", "MAHLI", "MARDI", "NAVCAM", "PANCAM", "MINITES"]
    
    
    init(view: UIView) {
        self.view = view
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300.0))
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250.0))
        super.init()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func setup() {
        pickerView.backgroundColor = .darkGray
        view.addSubview(containerView)
        containerView.addSubview(pickerView)
        // Add constraints
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        
        pickerView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0).isActive = true
        pickerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0).isActive = true
        pickerView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0).isActive = true
        
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: containerView.frame.height)
        bottomConstraint?.isActive = true
        addSetButtonOnKeyboard()
    }
    
    /// Adds a 'Set' button to the keyboard tool bar to be able to dismiss the pickerview
    func addSetButtonOnKeyboard() {
        // TODO: Adjust size for other sizes
        let setToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        setToolbar.barStyle = .black
        setToolbar.isTranslucent = true
        setToolbar.tintColor = UIColor.white
        
        let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(close))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let set: UIBarButtonItem = UIBarButtonItem(title: "Set", style: UIBarButtonItem.Style.done, target: self, action: #selector(setParams))
        
        var items = [UIBarButtonItem]()
        items.append(cancel)
        items.append(flexSpace)
        items.append(set)
        
        setToolbar.items = items
        setToolbar.sizeToFit()
        
        containerView.addSubview(setToolbar)
        setToolbar.translatesAutoresizingMaskIntoConstraints = false
        setToolbar.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0).isActive = true
        setToolbar.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0).isActive = true
    }
    
    @objc func setParams() {
        filterAction?()
        self.bottomConstraint?.isActive = false
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.containerView.frame.height)
        self.bottomConstraint?.isActive = true
        UIView.animate(withDuration: 0.4) { self.view.layoutIfNeeded() }
    }
    
    @objc func close() {
        bottomConstraint?.isActive = false
        bottomConstraint = self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.containerView.frame.height)
        self.bottomConstraint?.isActive = true
        UIView.animate(withDuration: 0.4) { self.view.layoutIfNeeded() }
    }
    
    func open() {
        self.bottomConstraint?.isActive = false
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0)
        self.bottomConstraint?.isActive = true
        UIView.animate(withDuration: 0.4) { self.view.layoutIfNeeded() }
    }

}

extension MarsImageryFilter: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return sols.count
        case 1:
            return cameras.count
        default:
            return 0
        }
        
    }
    
}

extension MarsImageryFilter: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch component {
        case 0:
            return NSAttributedString(string: "Sol: \(sols[row].description)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        case 1:
            return NSAttributedString(string: "Cam: \(cameras[row])", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        default:
            return nil
        }

    }
    
}
