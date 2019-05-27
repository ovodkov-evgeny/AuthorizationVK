//
//  SelectDayControl.swift
//  GeekBrains UI
//
//  Created by Antol Peshkov on 09/03/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit



class FilterCharControl: UIControl {
    
    weak var tableView:UITableView!
    var friendsChar:[Character] = []//User.getFriendsChar()
    
    var selectedChar: Character? {
        didSet {
            updateSelectedDay()
        }
    }
    
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    private func setupView() {
        
        backgroundColor = UIColor.white.withAlphaComponent(0)
        
        for char in friendsChar {
            let button = UIButton(type: .system)
            button.setTitle(char.description, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectDay(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        addSubview(stackView)
    }
    
    private func updateSelectedDay() {
        for button in buttons {
            guard let text = button.titleLabel?.text else { continue }
            let char = Character(text)
            
            button.isSelected = (char == selectedChar)
        }
    }
    
    @objc func selectDay(_ sender: UIButton) {
        guard let textLabel = sender.titleLabel?.text else { return }
        guard let section = friendsChar.firstIndex(of: Character(textLabel)) else { return }
        let indexPath = IndexPath(row: 0, section: section)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
