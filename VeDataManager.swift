//
//  VeDataHandler.swift
//  V_POC
//
//  Created by Kumar Malana, Jatin on 4/17/17.
//  Copyright © 2017 Kumar Malana, Jatin. All rights reserved.
//

import UIKit

// Protocols for UITableViewCell where dataItems confirm prot0col VeBaseItem
protocol VeBaseCell: class {
    func configureCell(withItem: VeBaseItem)
}

// Protocol for DataModel
protocol VeBaseItem {
}

// DataHandler Class responsible for handling and supplying data to TableDatasource and Delegate Methods
class VeDataHandler: NSObject {
    private(set) var items = [VeBaseItem]()
    func addItem(item: VeBaseItem) {
        items.append(item)
    }

    // Generics  stating the Item needs to confirm both VeBaseItem and Equatable Protocol
    func removeItem<T: VeBaseItem>(dataItem: T) where T: Equatable {
        items = items.filter {
            if let e = $0 as? T, e == dataItem {
                return false
            }
            return true
        }
    }
}

// Generic Class to act as TableDataSource for all Controllers
class VeTableViewDataSource: NSObject, UITableViewDataSource {
    let dataHandler: VeDataHandler!
    var cellClassType: VeBaseCell.Type!
    var cellIdentifer: String!

    // Generics  stating the Item needs to confirm both VeBaseItem Protocol and should be of a UITableViewCell Class
    init<T: VeBaseCell>(tableView: UITableView, dataHandler: VeDataHandler, cellType: T.Type, cellId: String) where T: UITableViewCell {
        self.dataHandler = dataHandler
        cellClassType = cellType
        cellIdentifer = cellId
        super.init()
        tableView.dataSource = self
    }

    // MARK: TableDataSource
    func tableView(_: UITableView, numberOfRowsInSection
        _: Int) -> Int {
        return dataHandler.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDoItem = dataHandler.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as!
            VeBaseCell
        cell.configureCell(withItem: toDoItem)
        return cell as! UITableViewCell
    }
}

// Generic Class to act as TableViewDelegate for all Controllers
class VeTableViewDelegate: NSObject, UITableViewDelegate {
    let dataHandler: VeDataHandler
    var handleSelectionFor: ((_ indexPath: IndexPath) -> Void)?
    var handleEditingFor: ((_ indexPath: IndexPath) -> Void)?

    init(tableView: UITableView, dataHandler: VeDataHandler) {
        self.dataHandler = dataHandler
        super.init()
        tableView.delegate = self
    }

    // MARK: TableViewDelegate
    func tableView(
        _ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        handleSelectionFor?(indexPath)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            handleEditingFor?(indexPath)
            tableView.endUpdates()
        }
    }
}
