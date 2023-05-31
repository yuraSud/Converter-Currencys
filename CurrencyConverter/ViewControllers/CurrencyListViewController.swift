

import UIKit

class CurrencyListViewController: UIViewController {
   
    static let cellID = "CurrencyCell"
    
    var currencys: [Currency]?
    var completionChooseCurrency: ((Currency)->())?
    private var currencyTableView = UITableView()
    private var currencyTransform = TransformCurrency()
    private let searchController = UISearchController()
    private var headerTitlesArray: [String]?
    private var dataToSections: [[Currency]] = []
    private var filteredDataToSections: [Currency] = []
   
    
// MARK: - Life cycle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Currency"
        setupCurrencyTableView()
        setupLeftBarButton()
        fetchDataSourceForTable(model: currencys)
        configureSearchBar()
    }
    
 //MARK: - Function
    
    @objc func back() {
        dismiss(animated: true)
    }
    
    private func setupCurrencyTableView() {
        currencyTableView = UITableView(frame: view.bounds, style: .insetGrouped)
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        view.addSubview(currencyTableView)
        currencyTableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyListViewController.cellID)
        currencyTableView.backgroundColor = .clear
        currencyTableView.layer.shadowColor = UIColor.black.cgColor
        currencyTableView.layer.shadowOpacity = 0.3
        currencyTableView.layer.shadowRadius = 1
        currencyTableView.layer.shadowOffset = .init(width: 0, height: 3)
    }
    
    private func fetchDataSourceForTable(model: [Currency]?) {
        guard let models = model else {return}
        self.currencyTransform.createDataSourceHeaderAndSections(model: models)
            self.headerTitlesArray = self.currencyTransform.headerArray
            self.dataToSections = self.currencyTransform.sections
            DispatchQueue.main.async {
                self.currencyTableView.reloadData()
            }
    }
    
    private func setupLeftBarButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Currency", for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search"
    }
}

//MARK: - UITableViewDelegate
extension CurrencyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currency: Currency!
        if searchController.isActive && searchController.searchBar.text != "" {
            currency = filteredDataToSections[indexPath.row]
            dismiss(animated: false)
        } else {
            currency = dataToSections[indexPath.section][indexPath.row]
        }
        completionChooseCurrency?(currency)
        back()
    }
}

//MARK: - UITableViewDataSource
extension CurrencyListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }
        return dataToSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredDataToSections.count
        }
        return dataToSections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListViewController.cellID, for: indexPath) as? CurrencyCell else {return UITableViewCell()}
        
        var currency: Currency!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            currency = filteredDataToSections[indexPath.row]
        } else {
            currency = dataToSections[indexPath.section][indexPath.row]
        }
        
        cell.setLabel(currency: currency)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return "Find:"
        }
        return headerTitlesArray?[section]
    }
}

//MARK: - Search Controller Configuration

extension CurrencyListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        guard let currencys = currencys else {return}
        filteredDataToSections = currencys.filter({value in value.fullDescription.lowercased().contains(searchText.lowercased())
        })
        currencyTableView.reloadData()
    }
}
