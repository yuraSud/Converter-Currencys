import UIKit
import CoreData

class StartViewController: UIViewController {
    
    let lastUpdatedLabel = UILabel()
    let currencyView = CurrencyView()
    private let appNameLabel = UILabel()
    private var datepickerView: DatePickerView!
    private let backgroundImageView = UIImageView()
    private let nationalBankExchangeRateButton = UIButton(type: .system)
    
    private var valueTF: Double = 1
    private let numberRowsInMainTable = 6
    private var currencysFromInternet: [Currency]?
    private var currensItemToReSave: Currency?
    private var arrayCurrencysFromCoreData = [String]()
    private let coreData = CoreDataManager.instance
    private let networkManager = NetworkManager()
    private var nbuCourse = false
    
    var currencysArray:[Currency] = [] {
        didSet{
            DispatchQueue.main.async {
                self.currencyView.addCurrencyButton.isHidden = self.currencysArray.count >= self.numberRowsInMainTable ? true : false
            }
            reloadTable()
        }
    }
    
    private var saleCourse = true {
        didSet{
            reloadTable()
        }
    }
       
    private var dateFetchToLabel: Date! {
        didSet{
            updateDateLabel(dateUpdate: dateFetchToLabel)
        }
    }
    
    //MARK: - Life cycle App:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        addTargetButtons()
        fetchDataSourceForTableFromCoreData(Date())
    }
    
    
    //MARK: - @objc functions:
    
    @objc private func addCurrency() {
        let listCurrencyVC = CurrencyListViewController()
        let navContrroler = UINavigationController(rootViewController: listCurrencyVC)
        listCurrencyVC.completionChooseCurrency = { [weak self] item in
            guard let self = self else {return}
            if self.currencysArray.count < self.numberRowsInMainTable {
                self.currencysArray.append(item)
                self.coreData.newCurrencyCore(item)
            }
        }
        listCurrencyVC.currencys = currencysFromInternet
        navigationController?.present(navContrroler, animated: true)
    }
    
    @objc private func segmentAction(sender: UISegmentedControl) {
        saleCourse = sender.selectedSegmentIndex == 0 ? true : false
    }
    
    @objc private func currencyNbuFromDate() {
        if !nbuCourse {
            datepickerView = DatePickerView(frame: self.view.bounds)
            datepickerView.cancelButton.addTarget(self, action: #selector(closeDatePickerView), for: .touchUpInside)
            datepickerView.okButton.addTarget(self, action: #selector(pushDateFromPicker), for: .touchUpInside)
            view.addSubview(datepickerView)
        } else {
            nbuCourse = false
            nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
            fetchDataSourceForTableFromCoreData(Date())
        }
    }
    
    @objc private func pushDateFromPicker() {
        nationalBankExchangeRateButton.setTitle("Return to course PB", for: .normal)
        nbuCourse = true
        fetchDataSourceForTableFromCoreData(datepickerView.datePicker.date)
        closeDatePickerView()
    }
    
    @objc private func closeDatePickerView() {
        datepickerView.removeFromSuperview()
    }
    
    @objc private func choiseShared() {
        let alert = UIAlertController(title: "Choose what you want to share", message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share ", style: .destructive){_ in
            self.shareScreenShotAndText()
        }
        let textAction = UIAlertAction(title: "Share text", style: .default){_ in
            self.shareText()
        }
        let imageAction = UIAlertAction(title: "Share image", style: .default){_ in
            self.shareScreenShotImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(shareAction)
        alert.addAction(textAction)
        alert.addAction(imageAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - Functions:
    
    private func configureView() {
        configBackgroundImageView()
        configAppNameLabel()
        configLastUpdatedLabel()
        configNationalBankExchangeRateButton()
        configCurrencyView()
        setUpView()
        setConstraints()
        setDelegateTable()
    }
    
    private func addTargetButtons() {
        currencyView.addCurrencyButton.addTarget(self, action: #selector(addCurrency), for: .touchUpInside)
        currencyView.exchangeRateSegmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        nationalBankExchangeRateButton.addTarget(self, action: #selector(currencyNbuFromDate), for: .touchUpInside)
        currencyView.shareButton.addTarget(self, action: #selector(choiseShared), for: .touchUpInside)
    }
    
    private func reloadTable() {
      DispatchQueue.main.async {
          self.currencyView.currencyTable.reloadData()
      }
    }
    
    private func updateDateLabel(dateUpdate: Date) {
        DispatchQueue.main.async {
            self.lastUpdatedLabel.text = "Last Updated\n\(dateUpdate.formateDateToUpdateLabel())"
        }
    }
    
    private func fetchDataSourceForTableFromInternet(_ date: Date) {
        networkManager.fetchCurrency(for: date) { (data, error)  in
            guard let data = data else {
                self.alertNoInternet()
                return
            }
            self.coreData.newjsonCurrencys(jsonCurrencyData: data, date: date)
            self.transformDataToCurrencyModelAndRecordCurrencyArrayFromInternet(data)
            self.addStoreCurrencystoCurrencyArrayForTable(self.arrayCurrencysFromCoreData)
            self.dateFetchToLabel = date
        }
    }
    
    private func alertNoInternet() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Attention\nData not received.", message: "Please check your internet connection", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "OK", style: .cancel){_ in
                self.lastUpdatedLabel.text = "Not internet\nConnection"
                self.currencysArray = []
            }
            alert.addAction(actionOk)
            self.present(alert, animated: true)
        }
    }
    
    private func transformDataToCurrencyModelAndRecordCurrencyArrayFromInternet(_ jsonData: Data?)  {
        networkManager.parseCurrency(jsonData) { model in
            self.currencysFromInternet = model?.currencys
        }
    }
    
    private func addStoreCurrencystoCurrencyArrayForTable(_ arrayCurrencysFromCoreData:[String]) {
        
        guard let fullArrayCurrency = currencysFromInternet else {return}
        var mokcurrencysArray = [Currency]()
        
        arrayCurrencysFromCoreData.forEach{ item in
            for currency in fullArrayCurrency {
                if currency.currency == item {
                    mokcurrencysArray.append(currency)
                }
            }
        }
        currencysArray = mokcurrencysArray
    }
}

//MARK: - CoreData:

extension StartViewController {
    
    private func fetchDataSourceForTableFromCoreData(_ dateToFetch: Date) {
        //Проверка на то что в хранилище есть данные
        let jsonCurrencys = coreData.getJsonCurrencysForDate(date: dateToFetch)
        
        // Записываем массив имен валют из коре Даты которые у нас в основной таблице
        arrayCurrencysFromCoreData = coreData.getCurrencyFromCore()
        
        guard let jsonData = jsonCurrencys?.jsonData else {
            //Если отсутствуют то берем данные с интернета
            fetchDataSourceForTableFromInternet(dateToFetch)
            return}
        
        // Берем данные с кореДата и трансформируем их
        dateFetchToLabel = jsonCurrencys?.dateFetch
        transformDataToCurrencyModelAndRecordCurrencyArrayFromInternet(jsonData)
        addStoreCurrencystoCurrencyArrayForTable(arrayCurrencysFromCoreData)
    }
}
    
//MARK: - UITableViewDelegate

extension StartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MainCell
        cell.selectionStyle = .none
        tableView.deselectRow(at: indexPath, animated: false)
       
        currensItemToReSave = cell.currency
        cell.currencyTextField.blueLayerTF()
        cell.currencyTextField.becomeFirstResponder()
        cell.currencyTextField.delegate = self
        cell.contentView.isUserInteractionEnabled = false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.row != 0 ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete && indexPath.row != 0 {
            currencysArray.remove(at: indexPath.row)
            coreData.deleteCurrencyCore(indexPath.row)
        }
    }
}

//MARK: - UITableViewDataSource

extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableView.mainCellID, for: indexPath) as? MainCell else { return UITableViewCell() }
        cell.currencyTextField.tag = indexPath.row
        cell.currency = currencysArray[indexPath.row]
        cell.setLabel(sell: saleCourse,nbu: nbuCourse, valueFromTF: valueTF)
        return cell
    }
}

//MARK: - TextFieldDelegate
extension StartViewController: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let value = textField.text,
              let valueTFDouble = Double(value),
              let currensValue = currensItemToReSave
        else {return true}
       
        //Обнуляем значение textFieldDoubleValue во всех валютах в массиве currencysArray
        currencysArray.indices.forEach { item in
            currencysArray[item].textFieldDoubleValue = nil
        }
        
        if let i = currencysArray.firstIndex(where: { $0.currency == currensValue.currency}) {
            currencysArray[i].textFieldDoubleValue = valueTFDouble
        }
        valueTF = textField.tag == 0 ? valueTFDouble : valueTFDouble * (currensValue.saleRateNB ?? 0)
        reloadTable()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.noDigits()
    }
}

//MARK: -  UIConfiguration:

extension StartViewController {
    
    private func setUpView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(appNameLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(nationalBankExchangeRateButton)
        view.addSubview(currencyView)
    }

    private func setDelegateTable() {
        currencyView.currencyTable.dataSource = self
        currencyView.currencyTable.delegate = self
    }
    
    private func configBackgroundImageView() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named:  "image_background")
    }
    
    private func configAppNameLabel() {
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.text = "Currency Converter"
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .left
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    private func configLastUpdatedLabel() {
        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.text = "Last Updated\n26.04.2023 12:43"
        lastUpdatedLabel.textColor = .systemGray
        lastUpdatedLabel.numberOfLines = 2
        lastUpdatedLabel.textAlignment = .left
        lastUpdatedLabel.font = .systemFont(ofSize: 14)
    }
    
    private func configNationalBankExchangeRateButton() {
        nationalBankExchangeRateButton.translatesAutoresizingMaskIntoConstraints = false
        nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
        nationalBankExchangeRateButton.setTitleColor(UIColor.systemBlue, for: .normal)
        nationalBankExchangeRateButton.layer.borderWidth = 1
        nationalBankExchangeRateButton.layer.cornerRadius = 15
        nationalBankExchangeRateButton.layer.borderColor = UIColor.systemBlue.cgColor
        nationalBankExchangeRateButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
    }
    
    private func configCurrencyView() {
        currencyView.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Constraints

extension StartViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            
            appNameLabel.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -20),
            appNameLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16),
            
            lastUpdatedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lastUpdatedLabel.bottomAnchor.constraint(equalTo: nationalBankExchangeRateButton.topAnchor, constant: -40),
            
            nationalBankExchangeRateButton.heightAnchor.constraint(equalToConstant: 40),
            nationalBankExchangeRateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nationalBankExchangeRateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nationalBankExchangeRateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            currencyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currencyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currencyView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 20),
            currencyView.bottomAnchor.constraint(equalTo: lastUpdatedLabel.topAnchor, constant: -15)
        ])
    }
}

