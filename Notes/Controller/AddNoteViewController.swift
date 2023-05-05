//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Ali on 19/04/23.
//

import UIKit
import TextFieldEffects
import SQLite
import AudioToolbox

class AddNoteViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    
    let originalSize = CGSize(width: 60, height: 60)
    
    var isNewNote = true
    var index = 0
    
    var selectedColor = ""
    
    var newTask: NoteDataModel = NoteDataModel(title: "", subTitle: "", color: "", date: "")
    var currentTask = NoteDataModel(id: 0,title: "", subTitle: "", color: "?", date: "")
    
    
    //view for whole AddNoteView
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(color: .mainBack)
        return view
    }()
    
    //imageView for view background
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "appBack")
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    //imageView for view background
    let noteImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "newNoteBack")
        image.contentMode = .scaleToFill
        
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 1
        image.layer.shadowOffset = CGSize(width: 0, height: 2)
        image.clipsToBounds = true
        return image
    }()
    
    //textField for Title of task
    lazy var titleFextField: AkiraTextField = {
        let textField = AkiraTextField()
        textField.borderColor = .clear
        setToolbar(textField)
        textField.layer.cornerRadius = 8
        textField.textColor = .black
        textField.font = UIFont(name: "ChalkboardSE-bold", size: 20)
        textField.placeholder = "Write Title of your task"
        textField.placeholderColor = .systemTeal
        return textField
    }()
    
    
    //textField for Description of task
    lazy var descriptionFextView: AkiraTextView = {
        let textView = AkiraTextView()
        setToolbar(tv: textView)
        textView.backgroundColor = .clear
        textView.contentMode = .left
        textView.delegate = self
        textView.setLineSpacing(lineHeightMultiple: 0.8)
        textView.font = UIFont(name: "ChalkboardSE-light", size: 17)
        textView.text = "Write Description to your task"
        return textView
    }()
    
    //textField for Date of task
    lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "Select date"
        textField.font = UIFont(name: "ChalkboardSE-bold", size: 20)
        textField.layer.cornerRadius = 8
        textField.textColor = .black
        setToolbar(textField)
        return textField
    }()
    
    //stackView for Priority colorButtons
    lazy var colorStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: colorButtons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = (view.bounds.width - 90 - 180) / 2.4
        stack.alignment = .fill
        return stack
    }()
    
    //Priority colorButtons
    let colorButtons: [UIButton] = [0: "noteGreen", 1: "noteRed", 2: "noteBlue"].sorted(by: { $0.0 < $1.0 }).map { txt in
        let button = UIButton()
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 2
        
        button.tag = txt.key
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor(named: txt.value)!
        button.addTarget(self, action: #selector(colorTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    //finally addes new note to array
    let addNoteButton: UIButton = {
        let button = UIButton()
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 1.5
        
        button.addTarget(self, action: #selector(addNoteButtonTapping), for: .touchDown)
        button.addTarget(self, action: #selector(addNoteButtonCenceled), for: .touchDragOutside)
        button.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.setTitle("Add Note", for: .normal)
        button.titleLabel?.font = UIFont(name: "ChalkboardSE-bold", size: 25)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 5
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUILayout()
        setPickerDate()
        currentNote()
    }
    
    
    //func which works when viewController opened from note cell
    func currentNote() {
        
        if !isNewNote {
            title = "Edit Note"
            titleFextField.text = currentTask.title
            descriptionFextView.text = currentTask.subTitle
            descriptionFextView.textColor = .blue
            dateTextField.text = currentTask.date
            selectedColor = currentTask.color
            switch selectedColor {
            case "noteRed": addNoteButton.layer.borderColor = UIColor.appColor(color: .noteRed).cgColor
            case "noteGreen": addNoteButton.layer.borderColor = UIColor.appColor(color: .noteGreen).cgColor
            case "noteBlue": addNoteButton.layer.borderColor = UIColor.appColor(color: .noteBlue).cgColor
            default: print("")
            }
            addNoteButton.setTitle("Save changes", for: .normal)
            
        }else {
            title = "New Note"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.titleFextField.becomeFirstResponder()
            }
        }
    }
    
    
    //sets UILayout constraints
    func setUILayout() {
        view.addSubview(mainView)
        mainView.addSubview(backgroundImage)
        mainView.addSubview(noteImage)
        mainView.addSubview(titleFextField)
        mainView.addSubview(descriptionFextView)
        mainView.addSubview(colorStackView)
        mainView.addSubview(dateTextField)
        mainView.addSubview(addNoteButton)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(mainView)
        }
        
        noteImage.snp.makeConstraints { make in
            make.left.right.equalTo(mainView).inset(10)
            make.top.equalTo(mainView).inset(100)
            make.height.equalTo(view.bounds.width+30)
        }
        
        
        titleFextField.snp.makeConstraints { make in
            make.top.equalTo(mainView).inset(165)
            make.height.equalTo(60)
            make.left.equalTo(noteImage.snp.left).offset(35)
            make.right.equalTo(noteImage.snp.right).offset(-35)
        }
        
        descriptionFextView.snp.makeConstraints { make in
            make.top.equalTo(titleFextField.snp.bottom).offset(10)
            make.height.equalTo(120)
            make.left.equalTo(noteImage.snp.left).offset(35)
            make.right.equalTo(noteImage.snp.right).offset(-35)
        }
        
        colorStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionFextView.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.left.equalTo(noteImage.snp.left).offset(45)
            make.right.equalTo(noteImage.snp.right).offset(-45)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.centerX.equalTo(mainView)
            make.top.equalTo(colorStackView.snp.bottom).offset(20)
        }

        
        addNoteButton.snp.makeConstraints { make in
            make.top.equalTo(noteImage.snp.bottom).offset(45)
            make.height.equalTo(60)
            make.width.equalTo(200)
            make.centerX.equalTo(mainView)
        }
        
    }
    
    
    
}


//MARK: @objc Buttons
extension AddNoteViewController {
    
    
    @objc func colorTapped(sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        // Reset size of previously selected button
        for button in colorButtons where button.isSelected {
            button.transform = CGAffineTransform.identity
        }
        for button in colorButtons {
            button.layer.borderWidth = 1.5
        }
        // Set size of selected button
        sender.layer.borderWidth = 5
        UIView.animate(withDuration: 0.1, delay: 0) {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()// vibration effect
        switch sender.tag {
        case 0:
            addNoteButton.layer.borderColor = UIColor.appColor(color: .noteGreen).cgColor
            selectedColor = "noteGreen"
        case 1:
            addNoteButton.layer.borderColor = UIColor.appColor(color: .noteRed).cgColor
            selectedColor = "noteRed"
        case 2:
            addNoteButton.layer.borderColor = UIColor.appColor(color: .noteBlue).cgColor
            selectedColor = "noteBlue"
        default: print("pinButton switch default selected")
        }
        
        for button in colorButtons {
            button.isSelected = (button == sender)
        }
        
    }
    
    
    @objc func addNoteButtonTapping(sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @objc func addNoteButtonCenceled(sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0) {
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
    //MARK: saves all addes and opens next ViewController
    @objc func addNoteButtonTapped(sender: UIButton) {
        
        UIView.animate(withDuration: 0.1, delay: 0) {
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        if titleFextField.text == "" || dateTextField.text == "" || !selectedColor.contains("note") { // checking fields for emptity in new note case
            
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            present(Alert.alertView(title: "Hey!", message: "Please fill all fields and choose color to your note", style: .alert, actions: [okAction]), animated: true)
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }else {
            
            if isNewNote { // if it is new note
                
                if let borderColor = sender.layer.borderColor {
                    let color = UIColor(cgColor: borderColor)
                    switch color {
                    case .red: newTask.color = "noteRed"
                    case .green: newTask.color = "noteGreen"
                    case .blue: newTask.color = "noteBlue"
                    default: print("")
                    }
                }
                
                if descriptionFextView.text == "Write Description to your task" { descriptionFextView.text = "" }
                
                DatabaseManager.shared.addNote(note: NoteDataModel(title: titleFextField.text!, subTitle: descriptionFextView.text, color: selectedColor, date: dateTextField.text!))
                
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                navigationController?.popViewController(animated: true)
                
            }else { // if it is already existed note
                if descriptionFextView.text == "Write Description to your task" { descriptionFextView.text = "" }
                DatabaseManager.shared.updateNote(note: NoteDataModel(id: currentTask.id,title: titleFextField.text!, subTitle: descriptionFextView.text, color: selectedColor, date: dateTextField.text!))
                
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
    
    
    //MARK: - cencel Button of keyboard
    @objc func cencelAction() {
        if titleFextField.isFirstResponder {
            if titleFextField.text != currentTask.title {
                addAlert(titleFextField)
            }
            titleFextField.resignFirstResponder()
        }else if descriptionFextView.isFirstResponder {
            if descriptionFextView.text != currentTask.subTitle && descriptionFextView.text != "Write Description to your task" {
                addAlert(tv: descriptionFextView)
            }
            descriptionFextView.resignFirstResponder()
        }else if dateTextField.isFirstResponder {
            dateTextField.text = ""
            dateTextField.resignFirstResponder()
        }
    }
    
    //MARK: - done Button of keyboard
    @objc func doneBtnAction(_ tf: UITextField) {
        if titleFextField.isFirstResponder {
            titleFextField.resignFirstResponder()
            if descriptionFextView.text == "Write Description to your task" || descriptionFextView.text == "" { // gives first responder if desctyptionTextView is empty
                descriptionFextView.becomeFirstResponder()
            }
        }else if descriptionFextView.isFirstResponder {
            descriptionFextView.resignFirstResponder()
            if dateTextField.text == "" { // gives first responder if datePickerView is empty
                dateTextField.becomeFirstResponder()
            }
        }else if dateTextField.isFirstResponder {
            dateTextField.resignFirstResponder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "dd.MM.yyyy"
            dateTextField.text = dateFormatter.string(from: datePicker.date)
            dateTextField.resignFirstResponder()
        }
        
    }
    
    //MARK: datePickers rollWheel
    @objc func datePickerRolls(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
}


extension AddNoteViewController {
    
    //MARK: - setPickerDate
    func setPickerDate() {
        datePicker.preferredDatePickerStyle = .wheels // type of datePicker
        datePicker.datePickerMode = .date // time version of datePicker
        datePicker.locale = .current // time from datePicker starts
        datePicker.backgroundColor = .systemBackground
        datePicker.addTarget(self, action: #selector(datePickerRolls), for: .valueChanged)
        setMinMaxMode(picker: datePicker)
        dateTextField.inputView = datePicker
        
    }
    
    
    //MARK: - setMinMaxMode
    func setMinMaxMode(picker: UIDatePicker) {
        let calendar = Calendar(identifier: .islamic) // type of calendar
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        components.year = 8
        components.month = 1
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = -23
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
    }
    
    
    //MARK: - setToolbar
    func setToolbar(_ tf: UITextField? = nil, tv: UITextView? = nil) {
        let okBtn = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(doneBtnAction))
        let cencelBtn = UIBarButtonItem(title: "cencel", style: .done, target: self, action: #selector(cencelAction))
        let spaceView = UIBarButtonItem(systemItem: .flexibleSpace)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        toolbar.items = [cencelBtn, spaceView, okBtn]
        if let tf = tf { tf.inputAccessoryView = toolbar }
        if let tv = tv { tv.inputAccessoryView = toolbar }
    }
    
}


extension AddNoteViewController {
    func addAlert(_ tf: UITextField? = nil, tv: UITextView? = nil) {
        let alert = UIAlertController(title: "Warning!", message: "Do you really want to cencel? all changes will be lost", preferredStyle: .alert)
        
        let noBtn = UIAlertAction(title: "No", style: .cancel)
        let yesBtn = UIAlertAction(title: "Sure", style: .destructive) { [self] _ in
            if let tf = tf { tf.text = currentTask.title
                tf.resignFirstResponder()
            }
            if let tv = tv { tv.text = currentTask.subTitle
                tv.resignFirstResponder()
            }
        }
        
        alert.addAction(noBtn)
        alert.addAction(yesBtn)
        
        self.present(alert, animated: true)
    }
}


//MARK: descriptionFextView delegate
extension AddNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write Description to your task" {
            descriptionFextView.text = ""
        }else {
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionFextView.text.isEmpty {
            descriptionFextView.text = "Write Description to your task"
        }
    }
}



