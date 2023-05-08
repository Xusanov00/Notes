//
//  MainViewController.swift
//  Notes
//
//  Created by Ali on 19/04/23.
//

import UIKit
import SnapKit
import FSCalendar
import AudioToolbox


class MainViewController: UIViewController {
    
    //using in FSCalendar
    var eventColorArr: [UIColor] = []
    let formatter = DateFormatter()
    var selectedCalendarDate = ""
    
    //for ui layout
    let scWidth = UIScreen.main.bounds.width
    let scHeight = UIScreen.main.bounds.height
    
    
    
    
    //for cellMoreDetailView
    var oldView: MoreView = {
        let view = MoreView()
        return view
    }()
    var cellFrame: CGRect?
    var cellEdges: ConstraintItem?
    
    
    //for closing cellMoreDetailView
    lazy var cencelButton: UIButton = {
        let button = UIButton()
//        button.addTarget(self, action: #selector(cencelButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.isHidden = true
        return button
    }()
    
    
    //for switching notes between all notes and by calendar day notes
    var allNotesEnabled = false
    
    //name of images for collection view filter cells
    var collViewSortArray: [UIColor] = [.clear, .appColor(color: .noteRed), .appColor(color: .noteGreen), .appColor(color: .noteBlue)]
    
    //variable for default condition of filter
    var sortedType: noteType = .all
    
    
    //view for all ui details
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(color: .mainBack)
        return view
    }()
    
    
    
    //view for calendar
    let calendar = FSCalendar()
    lazy var calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(color: .calendarBack)
        view.layer.cornerRadius = 20
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        //FSCalendar
        calendar.setNeedsLayout()
        calendar.backgroundColor = .clear
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.delegate = self
        calendar.dataSource = self
        calendar.layer.cornerRadius = 10
        calendar.appearance.headerTitleColor = .appColor(color: .calendarYears)
        calendar.appearance.weekdayTextColor = .appColor(color: .calendarWeekdays)
        calendar.appearance.selectionColor = .clear
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.titleSelectionColor = .black
        calendar.appearance.eventSelectionColor = .systemTeal
        calendar.firstWeekday = 2
        calendar.appearance.todayColor = #colorLiteral(red: 0, green: 0.007745540235, blue: 0.787543118, alpha: 0.5)
        let date = Date()
        
        view.addSubview(calendar)
        calendar.snp.makeConstraints { $0.edges.equalTo(view).inset(15) }
        return view
    }()
    
    
    //Background for note type icons
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        return image
    }()
    
    //collectionView for tasks
    lazy var collView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    
    //tableView for taskCollectionView and Calendar
    lazy var tablView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
//        table.separatorStyle = .none
        return table
    }()
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setTableView()
        setLayoutConstraints()
        setNavigationBar()
    }
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tablView.reloadData()
        calendar.reloadData()
    }
    
    
    //setting Navigation bar
    func setNavigationBar() {
        title = "My Tasks"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .done, target: self, action: #selector(leftNavigationButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(rightNavigationButtonTapped))
        
    }
    
    
    // set Collection View
    func setCollectionView() {
        collView.delegate = self
        collView.dataSource = self
        collView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.id)
        let indexPath = IndexPath(item: 0, section: 0)
        collView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        collView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // set Table View
    func setTableView() {
        formatter.dateFormat = "dd.MM.yyyy"
        selectedCalendarDate = formatter.string(from: Date())
        tablView.delegate = self
        tablView.dataSource = self
        tablView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.id)
    }
    
    
    //MARK: Setting MainViewController UILayout constraints
    func setLayoutConstraints() {
        view.backgroundColor = .appColor(color: .mainBack)
        view.addSubview(mainView)
        view.addSubview(cencelButton)
        mainView.addSubview(tablView)
        //
        cencelButton.snp.makeConstraints({$0.edges.equalTo(view)})
        //
        tablView.snp.makeConstraints { make in
            make.edges.equalTo(mainView)
            make.bottom.equalTo(mainView).inset(20)
        }
        //
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        //
        mainView.addSubview(collView)
        collView.snp.makeConstraints { make in
            make.top.equalTo(mainView).inset(70)
            make.left.right.equalTo(mainView).inset(10)
            make.height.equalTo(150)
        }
    }
}





//MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if indexPath.row < 2 { return }
        
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()// vibration effect
        
        cellEdges = cell.snp.top
        cellFrame = cell.convert(cell.bounds, to: view)
        
        // удаляем старый вид перед созданием нового
//        oldView?.removeFromSuperview()
        
//        let newView = MoreView(frame: cellFrame!)
        view.addSubview(oldView)
        oldView.snp.makeConstraints({$0.edges.equalTo(cell.snp.edges).offset(0)})
//        cencelButton.isHidden = false
        oldView.isHidden = false
//        oldView = newView
//        guard let oldView else { return }
        let cellBottom = tableView.convert(cell.center, to: tableView.superview).y
        let navBottom = navigationController!.navigationBar.frame.maxY
        
//        moreViewLayout()// presents noteMoreView dependently by cell position
        
        UIView.animate(withDuration: 0.6) {[self] in //
            cencelButton.backgroundColor = #colorLiteral(red: 0.1293008327, green: 0.1293008327, blue: 0.1293008327, alpha: 0.8)
            oldView.snp.makeConstraints({$0.edges.equalTo(mainView)})
//            mainView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            view.layoutIfNeeded()
        }

        oldView.updateCell(cell: getSelectedCell(index: indexPath.row))
        self.navigationController?.isNavigationBarHidden = true
//        oldView.snp.makeConstraints({$0.edges.equalTo(mainView)})
        //constraint layout of noteMoreView which opens when note tapped
//        func moreViewLayout() {
//            if cellBottom < scHeight/2 {// whem cell is on the top half of screen
//                oldView.snp.updateConstraints { make in
//                    if cellBottom - 60 + scWidth < scHeight {// if there is enough space for moreNoteView
//                        if cellBottom - 60 > navBottom + 2 {
//                            make.top.equalTo(cell.snp.top).offset(0)
//                        }else {
//                            make.top.equalTo(mainView).inset(navBottom+2)
//                        }
//                    }else {// if there if not enough space
//                        make.top.equalTo(mainView).inset(navBottom+2)
//                    }
//                    make.height.equalTo(scWidth)
//                    make.bottom.lessThanOrEqualTo(mainView).inset(15)
//                    make.left.equalTo(mainView).inset(15)
//                    make.right.equalTo(mainView).inset(15)
//                }
//
//            }else {// whem cell is on the bottom half of screen
//                oldView.snp.updateConstraints { make in
//                    if cellBottom + 60 < scHeight + 15 {
//                        if cellBottom + 60 - scWidth > navBottom + 2 {
//                            make.bottom.equalTo(cell.snp.bottom).offset(0)
//                        }else {
//                            make.bottom.equalTo(mainView).inset(15)
//                        }
//                    }else {
//                        make.bottom.equalTo(mainView).inset(15)
//                    }
//                    make.height.equalTo(scWidth)
//                    make.left.equalTo(mainView).inset(15)
//                    make.right.equalTo(mainView).inset(15)
//                }
//            }
//        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row > 1 {// swipe available only for cells with index greater than 1
            let editAction = UIContextualAction(style: .normal, title: "Edit") {[self] _, _, _ in
                let vc = AddNoteViewController()
                vc.currentTask = getSelectedCell(index: indexPath.row) // passes selected task to AddNoteController
                vc.isNewNote = false
                navigationController?.pushViewController(vc, animated: true)
            }
            editAction.backgroundColor = .orange
            editAction.image = UIImage(systemName: "square.and.pencil")
            let configuration = UISwipeActionsConfiguration(actions: [editAction])
            return configuration
        }else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row > 1 {// swipe available only cells with index greater than 1
            let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [self] _, _ , _ in
                
                let yesButton = UIAlertAction(title: "Yes", style: .destructive) { _ in // "yes" button of AlertView
                    DatabaseManager.shared.deleteNoteById(id: getSelectedCell(index: indexPath.row).id!)// deletes cell by row (row is automatically detects in function)
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    tableView.reloadData()
                    calendar.reloadData()
                }
                let cencelButton = UIAlertAction(title: "cencel", style: .cancel) { _ in// "cencel" button of AlertView
                    self.tablView.reloadData()
                    calendar.reloadData()
                }
                self.present(Alert.alertView(title: "Warning!", message: "Do you really want to delete this note?", style: .actionSheet, actions: [cencelButton,yesButton]), animated: true)// presents while deleting table view "note" cell
                
            }
            deleteAction.image = UIImage(systemName: "trash.fill")
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }else {
            return nil
        }
    }
}

//MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    //numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getSelectedCellCount()
    }
    
    
    
    //cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = .appColor(color: .mainBack)
        
        if indexPath.row == 0 {
            cell.contentView.addSubview(collView)
            tableView.separatorStyle = .none
            collView.snp.makeConstraints { make in
                make.edges.equalTo(cell.contentView)
                make.height.equalTo(90)
            }
            return cell
            
        }// collection view cell which sorts notes
        
        else if indexPath.row == 1 {
            tableView.separatorStyle = .none
            cell.contentView.addSubview(calendarView)
            calendarView.snp.makeConstraints { make in
                make.edges.equalTo(cell.contentView).inset(10)
                make.height.equalTo(300)
            }
            return cell
            
        }// calendar view
        
        else {
            tableView.separatorStyle = .singleLine
            guard let cell = tablView.dequeueReusableCell(withIdentifier: NotesTableViewCell.id, for: indexPath) as? NotesTableViewCell else { return UITableViewCell() }
            cell.setUpLayoutConstraints()
            cell.updateCell(cell: getSelectedCell(index: indexPath.row))
            return cell
        }// note table view cell
        
    }
    
}


//MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    //numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collViewSortArray.count
    }
    
    //cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.id, for: indexPath) as? TaskCollectionViewCell else { return UICollectionViewCell() }
        cell.setUpLayoutConstraints()// collection view layout func
        if indexPath.row == 0 { cell.cellTitleName.isHidden = false }
        cell.updateCell(cell: collViewSortArray[indexPath.row])//updates collection view cell details value
        
        return cell
    }
    
    
    
}


//MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    //didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.id, for: indexPath) as? TaskCollectionViewCell else { return }
        
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()// vibration effect
        switch indexPath.row {// switches notes by color
        case 0: sortedType = .all
        case 1: sortedType = .noteRed
        case 2: sortedType = .noteGreen
        case 3: sortedType = .noteBlue
        default: print("")
        }
        tablView.reloadData()
        calendar.reloadData()
    }
    
}


//MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    //sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/4)-30, height: (UIScreen.main.bounds.width/4)-30)
    }
    
}



//MARK: button Actions
extension MainViewController {
    
    //navigation left bar button
    @objc func leftNavigationButtonTapped(sender: UIBarButtonItem) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()// vibration effect
        if allNotesEnabled {
            sender.image = UIImage(systemName: "calendar")
            allNotesEnabled = false
        }else {
            sender.image = UIImage(systemName: "list.bullet.clipboard.fill")
            allNotesEnabled = true
        }
        tablView.reloadData()
        calendar.reloadData()
    }
    
    //navigation right bar button
    @objc func rightNavigationButtonTapped() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()// vibration effect
        let vc = AddNoteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //works when tapped out of noteMoreDetailView
    func cencelButtonTapped() {
        
    }
    
    
}

//MARK: tableView cell count func
extension MainViewController {
    ///returns selected cell count automaticaly by its position (color and date)
    func getSelectedCellCount() -> Int {
        
        if allNotesEnabled {
            
            switch self.sortedType {
            case .all: return DatabaseManager.shared.getNotes().sorted{
                $0.date.toDate()! < $1.date.toDate()!}.count + 2
            case .noteRed: return DatabaseManager.shared.getNotes().filter({ $0.color == "noteRed" }).sorted{
                $0.date.toDate()! < $1.date.toDate()!}.count + 2
            case .noteGreen: return DatabaseManager.shared.getNotes().filter({ $0.color == "noteGreen" }).sorted{
                $0.date.toDate()! < $1.date.toDate()!}.count + 2
            case .noteBlue: return DatabaseManager.shared.getNotes().filter({ $0.color == "noteBlue" }).sorted{
                $0.date.toDate()! < $1.date.toDate()!}.count + 2
            }
        }else {
            
            switch self.sortedType {
            case .all: return DatabaseManager.shared.getNotes().filter({ $0.date == selectedCalendarDate}).sorted{
                $0.date.toDate()! < $1.date.toDate()!}.count + 2
            case .noteRed: return DatabaseManager.shared.getNotes().filter({ $0.date == selectedCalendarDate}).filter({ $0.color == "noteRed" }).sorted{
                $0.date.toDate()! < $1.date.toDate()!}.count + 2
            case .noteGreen: return DatabaseManager.shared.getNotes().filter({ $0.date == selectedCalendarDate}).filter({ $0.color == "noteGreen" }).sorted{
                $0.date.toDate()! < $1.date.toDate()!}.count + 2
            case .noteBlue: return DatabaseManager.shared.getNotes().filter({ $0.date == selectedCalendarDate}).filter({ $0.color == "noteBlue" }).sorted{
                $0.date.toDate()! < $1.date.toDate()!}.count + 2
            }
        }
    }
}

//MARK: tableView cell func
extension MainViewController {
    ///returns selected cell automaticaly by its position (color and date)
    func getSelectedCell(index: Int) -> NoteDataModel {
        
        if index > 1 {
            if allNotesEnabled {
                
                switch self.sortedType {
                case .all: return DatabaseManager.shared.getNotes().sorted{
                    $0.date.toDate()! < $1.date.toDate()!}[index - 2]
                case .noteRed: return DatabaseManager.shared.getNotes().filter({ $0.color == "noteRed" }).sorted{
                    $0.date.toDate()! < $1.date.toDate()!}[index - 2]
                case .noteGreen: return DatabaseManager.shared.getNotes().filter({ $0.color == "noteGreen" }).sorted{
                    $0.date.toDate()! < $1.date.toDate()!}[index - 2]
                case .noteBlue: return DatabaseManager.shared.getNotes().filter({ $0.color == "noteBlue" }).sorted{
                    $0.date.toDate()! < $1.date.toDate()!}[index - 2]
                }
            }else {
                
                switch self.sortedType {
                case .all: return DatabaseManager.shared.getNotes().filter({ $0.date == selectedCalendarDate}).sorted{
                    $0.date.toDate()! < $1.date.toDate()!}[index - 2]
                case .noteRed: return DatabaseManager.shared.getNotes().filter({ $0.date == selectedCalendarDate}).filter({ $0.color == "noteRed" }).sorted{
                    $0.date.toDate()! < $1.date.toDate()!}[index - 2]
                case .noteGreen: return DatabaseManager.shared.getNotes().filter({ $0.date == selectedCalendarDate}).filter({ $0.color == "noteGreen" }).sorted{
                    $0.date.toDate()! < $1.date.toDate()!}[index - 2]
                case .noteBlue: return DatabaseManager.shared.getNotes().filter({ $0.date == selectedCalendarDate}).filter({ $0.color == "noteBlue" }).sorted{
                    $0.date.toDate()! < $1.date.toDate()!}[index - 2]
                }
            }
        }else {
            return NoteDataModel(title: "", subTitle: "", color: "red", date: "")
        }
        
    }
    
    
}
