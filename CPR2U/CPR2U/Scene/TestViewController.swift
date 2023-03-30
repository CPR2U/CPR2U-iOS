//
//  TestViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/30.
//

import UIKit

class TestViewController: UIViewController {

    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("BUTTON", for: .normal)
        button.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
    }
    
    @objc func test() {
        let navigationController = UINavigationController(rootViewController: DispatchViewController(callId: 1))
            present(navigationController, animated: true, completion: nil)
    }
    
}
