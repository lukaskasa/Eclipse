//
//  NavigationBar.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 11.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

enum NavBarButton {
    
    case back, close, search, controls, send, edit, next, backStep, celsius, fahrenheit
    
    func button(action: Selector?) -> UIBarButtonItem? {
        
        switch self {
        case .back:
            return UIBarButtonItem(image: UIImage(named: "exit"), style: .done, target: self, action: action)
        case .close:
            return UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: action)
        case .search:
            return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: action)
        case .controls:
            return UIBarButtonItem(image: UIImage(named: "controls"), style: .plain, target: self, action: action)
        case .edit:
            return UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: action)
        case .celsius:
            return UIBarButtonItem(title: "℃", style: .plain, target: self, action: action)
        case .fahrenheit:
            return UIBarButtonItem(title: "℉", style: .plain, target: self, action: action)
        case .send:
            return UIBarButtonItem(image: UIImage(named: "email"), style: .plain, target: self, action: action)
        case .next:
            return UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: self, action: action)
        case .backStep:
            return UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: action)
        }

    }
    
}

class NavigationBar {
    
    let navBar = UINavigationBar()
    let navItem = UINavigationItem()
    let title: String
    let navigationBarStyle: UIBarStyle
    let tintColor: UIColor
    var leftButton: NavBarButton?
    var rightButton: NavBarButton?
    var leftButtonAction: Selector?
    var rightButtonAction: Selector?
    
    let mainView: UIView

    init(for mainView: UIView, navigationBarStyle: UIBarStyle = .black, tintColor: UIColor = .white, title: String, leftButton: NavBarButton?, rightButton: NavBarButton?, leftButtonAction: Selector?, rightButtonAction: Selector?) {
        self.mainView = mainView
        self.navigationBarStyle = navigationBarStyle
        self.tintColor = tintColor
        self.title = title
        self.leftButton = leftButton
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.rightButton = rightButton
        self.rightButtonAction = rightButtonAction
    }
    
    private func setupContraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0.0).isActive = true
        navBar.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0.0).isActive = true
        navBar.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0.0).isActive = true
    }
    
    private func configureNavBar() {
        navItem.title = title
        navItem.leftBarButtonItem = leftButton?.button(action: leftButtonAction)
        navItem.rightBarButtonItem = rightButton?.button(action: rightButtonAction)
        navBar.barStyle = navigationBarStyle
        navBar.tintColor = tintColor
        navBar.setItems([navItem], animated: true)
        mainView.addSubview(navBar)
    }
    
    func load() {
        configureNavBar()
        setupContraints()
    }
    
}
