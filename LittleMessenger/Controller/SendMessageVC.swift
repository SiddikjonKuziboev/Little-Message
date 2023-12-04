//
//  SendMessageVC.swift
//  LittleMessenger
//
//  Created by Kuziboev Siddikjon on 2/11/22.
//

import UIKit
import MobileCoreServices

struct Message {
    var  date: String
    var orders: [MessageRealmData]
}
class SendMessageVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!{
        didSet {
            textView.delegate = self
            textView.layer.cornerRadius = textView.bounds.height * 0.47
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            textView.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 5, right: 0)
        }
    }
        
    @IBOutlet weak var bottomContainerView: UIView! {
        didSet {
            bottomContainerView.layer.borderWidth = 0.5
            bottomContainerView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var keyboardHeight: CGFloat!
    
    var data: [Message] = []
    
    var dic: [String: [MessageRealmData]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        title = "Test Chat Application"
        keyboardHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData(isCurrentWriting: false)
    }
    
    func fetchData(isCurrentWriting: Bool) {
        
        
        
        if isCurrentWriting {
        }else {
            
            dic = RealmData.shared.findComicsByTitle()
       
               var message = [Message]()
               
               for (key , value) in dic {
                   if let _ = dic[key] {
                       for i in value {
                           dic[key]?.append(i)
                       }
                   } else {
                       dic[key] = value
                   }
               }
               
               for (key, value) in dic {
                   message.append(Message(date: key, orders: value))
               }
               
               let dateFormater = DateFormatter()
               //else (sort only with start_date)
               dateFormater.dateFormat = "ddyyyy"
               
               let sortedArray = message.sorted { dic, dic2 in
                   
                   let date1 = String(dic.date.suffix(6))
                   let date2 = String(dic2.date.suffix(6))
                   
                   let format1 = dateFormater.date(from: date1)
                   guard let format = format1 else {return true}
                   let format2 = dateFormater.date(from: date2)!
                   return format < format2
               }
           
           data = sortedArray
        }
        tableView.reloadData()

       }
    
    func addIteamToRealm(type: String, imgData: Data?) {
        let d = MessageRealmData()
        d.text = textView.text!
        d.type = type
        d.created_at = MessageRealmData.getCurrentTime()
        d.user = MessageRealmData.UserType.first.rawValue
        d.id = UUID().uuidString
        d.img = imgData
        RealmData.shared.saveIteams(data: d)
        textView.text.removeAll()
        
        let indexPath : IndexPath!
        if data.isEmpty {
            indexPath = IndexPath.init(row: 0, section: 0)
            data.append(Message(date: MessageRealmData.getCurrentTime(), orders: [d]))
            tableView.reloadData()
        }else {
            indexPath = IndexPath.init(row: data[data.count-1].orders.count, section: data.count-1)
            data[indexPath.section].orders.insert(d, at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
       
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
       
       @IBAction func sendBtnPressed(_ sender: Any) {
          if !textView.text.isEmpty {
              addIteamToRealm( type: Keys.text, imgData: nil)
              sendBtn.setImage(UIImage(named: "camera"), for: .normal)
          }else {
              showMediaAlert()
          }
        }
         
    
    
}

//MARK: Media alert

extension SendMessageVC {
    
    private func showMediaAlert(){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Photo", style: .default) { [self] _ in
            
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = false
            
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { [self] _ in
            let imgPicker = UIImagePickerController()
               imgPicker.delegate = self
               imgPicker.sourceType = .camera
               imgPicker.allowsEditing = false
               imgPicker.showsCameraControls = true
               self.present(imgPicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(photo)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

//MARK: TableView Delegate
extension SendMessageVC: UITableViewDelegate, UITableViewDataSource {
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 50, right: 0)
        tableView.register(MessageTVC.unib(), forCellReuseIdentifier: MessageTVC.identifier)
        tableView.register(PhotoTVC.unib(), forCellReuseIdentifier: PhotoTVC.identifier)
         }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = data[indexPath.section].orders[indexPath.row]
        if data.type == Keys.text {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as? MessageTVC {
                cell
                    .updateCell(message: data )
                cell.selectionStyle = .none
                return cell
            }
            
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTVC.identifier, for: indexPath) as? PhotoTVC {
                cell.updadeCell(data: data )
                cell.selectionStyle = .none
                return cell
            }
            
        }
        
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.9137254902, alpha: 1)
        label.text = String(data[section].date.prefix(11))
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let originalContentSize = label.intrinsicContentSize
        
        
        let containerView = UIView()
        containerView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: originalContentSize.height + 6).isActive = true
        label.widthAnchor.constraint(equalToConstant: originalContentSize.width + 16).isActive = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        
        return containerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) {[self] _  in

            if let _ = tableView.cellForRow(at: indexPath) as? MessageTVC {
                    let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        RealmData.shared.deleteIteam(data:  self.data[indexPath.section].orders[indexPath.row])

                            self.tableView.beginUpdates()
                        self.data[indexPath.section].orders.remove(at: indexPath.row)

                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        tableView.endUpdates()

                        }
                    }
                    return UIMenu(title: "", children: [delete])


            }else if let _ = tableView.cellForRow(at: indexPath) as? PhotoTVC{


                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

                    self.tableView.beginUpdates()
                        RealmData.shared.deleteIteam(data:  self.data[indexPath.section].orders[indexPath.row])

                    self.tableView.deleteRows(at: [indexPath], with: .automatic)

                    self.data[indexPath.section].orders.remove(at: indexPath.row)
                    tableView.endUpdates()
                }
                }
                
                return UIMenu(title: "", children: [ delete])

            }
            else{
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                }
                return UIMenu(title: "", children: [delete])
            }
        }
    }

    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return makeTargetedPreview(for: configuration)
        
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    
    @available(iOS 13.0, *)
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        if let cell = tableView.cellForRow(at: indexPath) as? MessageTVC {
            return UITargetedPreview(view: cell.containerView, parameters: parameters)
        }else if let cell = tableView.cellForRow(at: indexPath) as? PhotoTVC{
            return UITargetedPreview(view: cell.containerView, parameters: parameters)
        }
        return UITargetedPreview(view: UIView())

    }
    
    
}



//MARK: - ImageView Delegate
extension SendMessageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeImage:
            
            let originalImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            guard NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TempImage.png") != nil else {
                return
            }
            let imgData = originalImg.jpegData(compressionQuality: 0.1)!
            
            addIteamToRealm(type: Keys.photo, imgData: imgData)

        default:
            break
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: Keyboard Handling
extension SendMessageVC {
    
    private func keyboardHandling(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        
        if let keyFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyFrame.cgRectValue
            keyboardHeight = keyboardRect.height
            
            if UIScreen.main.bounds.height < 670 {
                
                UIView.animate(withDuration: 0.1) {
                    self.bottomContainerView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight)
                } completion: { (_) in }
                tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50+self.keyboardHeight, right: 0)
                //tableView.scrollToBottom(with: true)
                
            }else{
                
                UIView.animate(withDuration: 0.1) {
                    self.bottomContainerView.transform = CGAffineTransform(translationX: 0, y: -(self.keyboardHeight-20))
                } completion: { (_) in }
                tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50+self.keyboardHeight, right: 0)
                //tableView.scrollToBottom(with: true)
                
            }
            
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.init(rawValue: UInt(curveValue))) {
            self.bottomContainerView.transform = .identity
        } completion: { (_) in }
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        
    }
}

//MARK: TextView Delegate

extension SendMessageVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //HANDLE shouldChangeTextIn for range
        let textt: NSString = (textView.text ?? "") as NSString
        let resultString = textt.replacingCharacters(in: range, with: text)
        
        if resultString.count > 0 {
            
            sendBtn.setImage(UIImage(named: "up-arrow-button"), for: .normal)
            
        } else {
            sendBtn.setImage(UIImage(named: "camera"), for: .normal)
        }
        
        
        if textView.contentSize.height >= 150 {
            textView.isScrollEnabled = true
        }else {
            textView.isScrollEnabled = false
        }
        return true
    }
    
}
