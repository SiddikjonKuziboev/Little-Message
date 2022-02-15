//
//  PhotoTVC.swift
//  LittleMessenger
//  Created by Kuziboev Siddikjon on 2/13/22.
//

import UIKit


class PhotoTVC: UITableViewCell {
    
    static let identifier = "PhotoTVC"
    static func unib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bigStack: UIStackView!
    
    @IBOutlet weak var conViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var realTimeLbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    var context = CIContext(options: nil)
    
    
    var trailingConst : NSLayoutConstraint!
    var leadingConst: NSLayoutConstraint!
    
    var delegate: ChatDelegate?
    var index : IndexPath!
    var didSelect = false
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        imgView.applyBlurEffect()
//        containerView.layer.cornerRadius = 5
        bigStack.addShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor, offSet: CGSize(width: 0.0, height: 2.0), radius: 0)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConst.isActive = false
        trailingConst.isActive = false
    }
    
    
    func updadeCell(data: MessageRealmData){

        trailingConst = containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        leadingConst = containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)

        
        if data.user == MessageRealmData.UserType.second.rawValue {
            bigStack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            trailingConst.isActive = true
            lblTitle.textAlignment = .left
            bigStack.backgroundColor = #colorLiteral(red: 0.8056958318, green: 0.9051255584, blue: 0.7225129008, alpha: 1)
        }else{
            leadingConst.isActive = true
            bigStack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            bigStack.backgroundColor = .white
            lblTitle.textAlignment = .right

        }

        imgView.image = UIImage.init(data: data.img ?? Data())
        
        realTimeLbl.text = GetDate.dateToString(date: data.created_at, format: "HH:mm")
    }
  
}
