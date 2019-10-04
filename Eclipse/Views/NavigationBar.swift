//
//  NavigationBar.swift
//  Eclipse
//
//  Created by Lukas Kasakaitis on 11.09.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

/// NavBarButton Enum which represent different UIBarButtons on a NavigationBar Object
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

/// Navigation Bar used for each child view
class NavigationBar {
    
    /// Properties
    let navBar = UINavigationBar()
    let navItem = UINavigationItem()
    let title: String
    let navigationBarStyle: UIBarStyle
    let tintColor: UIColor
    let mainView: UIView
    var leftButton: NavBarButton?
    var rightButton: NavBarButton?
    var leftButtonAction: Selector?
    var rightButtonAction: Selector?
    
    /**
    Initializes a NavigationBar
     
     - Parameters:
        - mainView: The view used to display the
        - navigationBarStyle: The UIBarStyle of the UINavigationBar
        - tintColor: The tint color for the UINavigationBar
        - title: The title on the UINavigationBar
        - leftButton: The left UIBarButton on the UINavigationBar
        - rightButton: The right UIBarButton on the UINavigationBar
        - leftButtonAction: The @objc action used for the left UIBarButton
        - rightButtonAction: The @objc action used for the right UIBarButton
     
     - Returns: A NavigationBar with the given options
     */
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
    
    /**
     Sets up the constraints for the Navigation Bar
     */
    private func setupContraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0.0).isActive = true
        navBar.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0.0).isActive = true
        navBar.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0.0).isActive = true
    }
    
    /**
     Configures all the options for the UINavigationBar
     */
    private func configureNavBar() {
        navItem.title = title
        navItem.leftBarButtonItem = leftButton?.button(action: leftButtonAction)
        navItem.rightBarButtonItem = rightButton?.button(action: rightButtonAction)
        navBar.barStyle = navigationBarStyle
        navBar.tintColor = tintColor
        navBar.setItems([navItem], animated: true)
        mainView.addSubview(navBar)
    }
    
    /**
     Loads the navigation bar onto the view
     */
    func load() {
        configureNavBar()
        setupContraints()
    }
    
}
