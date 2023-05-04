//
//  MoreUIView.swift
//  Notes
//
//  Created by Ali on 02/05/23.
//

import Foundation
import UIKit
import SnapKit

class MoreView: UIView {
    
    
    //cell background view
    lazy var moreViewsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    //view for keeping labels
    let contentVIew: UIView = {
        let view = UIView()
        return view
    }()
    
    //view for titleLabel background
    let titleBackView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 10
        return view
    }()
    
    //view for separator line with 1px height
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    //Title Label
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChalkboardSE-bold", size: 17)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Title Label
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChalkboardSE-light", size: 15)
        label.textColor = .label
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setLineSpacing(lineHeightMultiple: 0.67)
        label.textAlignment = .left
        
        label.numberOfLines = 0
        return label
    }()
    
    
    //Title Label
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "ChalkboardSE-regular", size: 12)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayoutConstraints()
    }
    
    
    func updateCell(cell: NoteDataModel) {
        titleBackView.backgroundColor = UIColor(named: cell.color)!
        titleLabel.text = cell.title
        dateLabel.text = cell.date
        subTitleLabel.text = cell.subTitle
    }
    
    ///Setting tableView Layout Constraints
    func setUpLayoutConstraints() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.systemOrange.cgColor
        self.layer.borderWidth = 1.5
        
        self.addSubview(moreViewsScrollView)
        moreViewsScrollView.addSubview(contentVIew)
        self.backgroundColor = .systemBackground
        contentVIew.addSubview(titleBackView)
        titleBackView.addSubview(dateLabel)
        titleBackView.addSubview(titleLabel)
        contentVIew.addSubview(separatorView)
        contentVIew.addSubview(subTitleLabel)
        
        moreViewsScrollView.snp.makeConstraints({$0.edges.equalTo(self)})
        
        
        contentVIew.snp.makeConstraints { make in
            make.height.equalTo(moreViewsScrollView.bounds.height+30)
            make.width.equalTo(moreViewsScrollView.bounds.width)
            make.edges.equalTo(moreViewsScrollView)
        }
        
        titleBackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentVIew).inset(5)
            make.height.equalTo(100)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleBackView).inset(20)
            make.top.equalTo(titleBackView).inset(15)
            make.height.lessThanOrEqualTo(90)
            make.right.equalTo(dateLabel.snp.left).offset(-5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.top.equalTo(titleBackView).inset(5)
            make.right.equalTo(titleBackView).inset(10)
        }
        
        separatorView.snp.makeConstraints { make in
            make.left.right.equalTo(contentVIew).inset(15)
            make.height.equalTo(1)
            make.top.equalTo(titleBackView.snp.bottom).offset(3)
        }
        
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(5)
            make.left.right.equalTo(moreViewsScrollView).inset(15)
            make.bottom.lessThanOrEqualTo(moreViewsScrollView).inset(10)
        }
        
        
        
    }
}
