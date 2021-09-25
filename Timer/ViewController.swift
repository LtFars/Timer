//
//  ViewController.swift
//  Timer
//
//  Created by Denis Snezhko on 25.09.2021.
//

import UIKit

class ViewController: UIViewController {
   
    private lazy var label: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 50)
        label.textColor = .orange
        label.text = "25:00"
        return label
    }()
    
    private lazy var button: UIButton = {
        var button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .orange
        button.frame = CGRect(x: 120,y: 120,width: 120,height: 120)
        button.frame.size = CGSize(width: 120,height: 120)
        button.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 40);
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(label)
        view.addSubview(button)
    }
    
    private func setupLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40).isActive = true
    }
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    // MARK: - Actions


}

