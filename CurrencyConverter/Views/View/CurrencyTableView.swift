
import UIKit

class CurrencyTableView: UITableView {

    static let mainCellID = "MainID"
    
    override init(frame: CGRect, style: UITableView.Style){
        super.init(frame: frame, style: style)
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTable() {
        translatesAutoresizingMaskIntoConstraints = false
        register(MainCell.self, forCellReuseIdentifier: CurrencyTableView.mainCellID)
        rowHeight = 65
        separatorStyle = .none
    }
}

