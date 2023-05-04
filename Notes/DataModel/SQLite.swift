//
//  SQLite.swift
//  Notes
//
//  Created by Ali on 28/04/23.
//




import Foundation
import SQLite


class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let db: Connection?
    
    private let notes = Table("notes")
    
    private let id = Expression<Int64>("id")
    private let title = Expression<String>("title")
    private let subtitle = Expression<String>("subtitle")
    private let color = Expression<String>("color")
    private let date = Expression<String>("date")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/notes.sqlite3")
            createTable()
        } catch {
//            db = nil
            db = try! Connection("\(path)/tasks.sqlite3")
            print ("Unable to open database")
        }
    }
    
    func createTable() {
        do {
            try db?.run(notes.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(title)
                table.column(subtitle)
                table.column(color)
                table.column(date)
            })
        } catch {
            print("Error creating table: \(error)")
        }
    }
    
    func addNote(note: NoteDataModel) {
        do {
            let insert = notes.insert(title <- note.title, subtitle <- note.subTitle, color <- note.color, date <- note.date)
            try db?.run(insert)
            let id = try db?.lastInsertRowid
            print("Inserted task with ID: \(id)")
            
        } catch {
            print("Insert failed")
        }
    }
    
    func updateNote(note: NoteDataModel) {
        guard let noteID = note.id else {
            print("Note does not have an ID")
            return
        }

        do {
            let taskToUpdate = notes.filter(id == noteID)
            try db?.run(taskToUpdate.update(title <- note.title, subtitle <- note.subTitle, color <- note.color, date <- note.date))
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }
    
    
    func getNotes() -> [NoteDataModel] {
        var sqliteNote = [NoteDataModel]()
        
        do {
            for row in try db!.prepare(self.notes) {
                sqliteNote.append(NoteDataModel(
                    id: row[id],
                    title: row[title],
                    subTitle: row[subtitle],
                    color: row[color],
                    date: row[date]
                ))
            }
        } catch {
            print("Select failed")
        }
        
        return sqliteNote
    }
    
    
    
    func deleteNoteById(id: Int64) -> Bool {
        do {
            let note = notes.filter(self.id == id)
            try db?.run(note.delete())
            print(DatabaseManager.shared.getNotes())
            return true
        } catch {
            print("Delete failed")
            return false
        }
    }
}
