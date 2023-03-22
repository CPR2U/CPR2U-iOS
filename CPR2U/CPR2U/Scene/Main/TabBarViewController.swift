//
//  TabBarViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/22.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBar()
    }

    private func setUpTabBar() {
        let educationVC = EducationMainViewController()
        let callVC = UIViewController()
        let mypageVC = UIViewController()
        
        educationVC.title = "Education"
        callVC.title = "Call"
        mypageVC.title = "Mypage"
        
        educationVC.tabBarItem.image = UIImage.init(systemName: "book")
        callVC.tabBarItem.image = UIImage.init(systemName: "bell")
        mypageVC.tabBarItem.image = UIImage.init(systemName: "person")
        
        educationVC.navigationItem.largeTitleDisplayMode = .always
        mypageVC.navigationItem.largeTitleDisplayMode = .always
        
        let navigationEdu = UINavigationController(rootViewController: educationVC)
        let navigationCall = UINavigationController(rootViewController: callVC)
        let navigationMypage = UINavigationController(rootViewController: mypageVC)
        
        
        navigationEdu.navigationBar.prefersLargeTitles = true
        navigationMypage.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navigationEdu, navigationCall, navigationMypage], animated: false)
        
        selectedIndex = 1
    }
}
