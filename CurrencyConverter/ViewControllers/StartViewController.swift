import UIKit
import CoreData

class StartViewController: UIViewController {
    
    var currencysFromInternet: [Currency]?
    
    var currencysArray = [Currency]() {
        didSet{
            DispatchQueue.main.async {
                self.currencyView.addCurrencyButton.isHidden = self.currencysArray.count == 5 ? true : false
            }
            reloadTable()
        }
    }
    
    var saleCourse = true {
        didSet{
            reloadTable()
        }
    }
    
    var nbuCourse = false {
        didSet{
            reloadTable()
        }
    }
    var arrayCurrencysFromCoreData = [String]()
    private let currencyView = CurrencyView()
    private var datepicker: DatePickerView!
    private let backgroundImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let lastUpdatedLabel = UILabel()
    private let nationalBankExchangeRateButton = UIButton(type: .system)
    private let coreData = CoreDataManager.instance
    private var valueTF: Double = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        addTargetButtons()
        fetchDataSourceForTableFromCoreData(Date())
    }
    
    
    //MARK: - @objc functions:
    
    @objc func addCurrency(){
        let listCurrencyVC = CurrencyListViewController()
        let navContrroler = UINavigationController(rootViewController: listCurrencyVC)
        listCurrencyVC.completionChooseCurrency = { item in
            if self.currencysArray.count < 5 {
                self.currencysArray.append(item)
                self.coreData.newCurrencyCore(item)
            }
        }
        listCurrencyVC.currencys = currencysFromInternet
        navigationController?.present(navContrroler, animated: true)
    }
    
    @objc func segmentAction(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
           saleCourse = true
        } else if sender.selectedSegmentIndex == 1 {
            saleCourse = false
        }
    }
    
    @objc func currencyNbuFromDate(){
        if !nbuCourse {
            datepicker = DatePickerView(frame: self.view.frame)
            datepicker.cancelButton.addTarget(self, action: #selector(closeDatePicker), for: .touchUpInside)
            datepicker.okButton.addTarget(self, action: #selector(pushDateFromPicker), for: .touchUpInside)
            view.addSubview(datepicker)
        } else {
            nbuCourse = false
            nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
        }
    }
    
    @objc func pushDateFromPicker(){
        print(datepicker.datePicker.date.formateDate(), "берем новую дату")
        nationalBankExchangeRateButton.setTitle("Return to course PB", for: .normal)
        nbuCourse = true
        fetchDataSourceForTableFromCoreData(datepicker.datePicker.date)
// учесть что запрос будет по дате, обновление идет по изменения этой переменной!!!
        closeDatePicker()
    }
    
    @objc func closeDatePicker(){
        datepicker.removeFromSuperview()
    }
    
    //MARK: - Functions:
    private func configureView(){
        configBackgroundImageView()
        configAppNameLabel()
        configLastUpdatedLabel()
        configNationalBankExchangeRateButton()
        configCurrencyView()
        setUpView()
        setConstraints()
        setDelegateTable()
    }
    
    private func setUpView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(appNameLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(nationalBankExchangeRateButton)
        view.addSubview(currencyView)
    }
    
    func setDelegateTable(){
        currencyView.currencyTable.dataSource = self
        currencyView.currencyTable.delegate = self
    }
    
    func addTargetButtons(){
        currencyView.addCurrencyButton.addTarget(self, action: #selector(addCurrency), for: .touchUpInside)
        currencyView.exchangeRateSegmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        nationalBankExchangeRateButton.addTarget(self, action: #selector(currencyNbuFromDate), for: .touchUpInside)
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.currencyView.currencyTable.reloadData()
        }
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
        lastUpdatedLabel.font = UIFont(name: "Regular", size: 12)
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
    
    private func fetchDataSourceForTableFromInternet(_ date: Date) {
        FetchWeatherManager().fetchCurrency(for: date) { data, error  in
            self.coreData.newjsonCurrencys(jsonCurrencyData: data, date: date)
            self.transformDataToCurrencyModel(data)
            self.addStoreCurrencystoArrayTable(self.arrayCurrencysFromCoreData)
        }
    }
    
    private func fetchDataSourceForTableFromCoreData(_ dateToFetch: Date) {
        //Проверка на то что в хранилище есть данные
       
        let jsonCurrencys = coreData.getJsonCurrencysForDate(date: dateToFetch)
        arrayCurrencysFromCoreData = coreData.getCurrencyFromCore()
      
        print(arrayCurrencysFromCoreData, "Array bykv")
       
        guard let jsonData = jsonCurrencys?.jsonData else {
            print("дата не получил с коре")
        //Если отсутствуют то берем данные с интернета
            fetchDataSourceForTableFromInternet(dateToFetch)
            return}
        
        // Берем данные с кореДата и трансформируем их
        transformDataToCurrencyModel(jsonData)
        addStoreCurrencystoArrayTable(arrayCurrencysFromCoreData)
    }
    
    private func transformDataToCurrencyModel(_ jsonData: Data?) {
        FetchWeatherManager().parseCurrency(jsonData) { model in
            self.currencysFromInternet = model?.currencys
            print(model?.currencys[8].purchaseRate, "euro")
        }
    }
    
    private func addStoreCurrencystoArrayTable(_ arrayCurrencysFromCoreData:[String]){
        
        guard let fullArrayCurrency = currencysFromInternet else {return}
        currencysArray.removeAll()
        
        arrayCurrencysFromCoreData.forEach{ item in
            for currency in fullArrayCurrency {
                if currency.currency == item {
                    currencysArray.append(currency)
                }
            }
        }
        //reloadTable()
    }
}
    
//MARK: - UITableViewDelegate

extension StartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //guard indexPath.row == 0 else {return}
        let cell = tableView.cellForRow(at: indexPath) as! MainCell
        guard cell.currency?.currency == "UAH" else {return}
        cell.currencyTextField.becomeFirstResponder()
        cell.currencyTextField.delegate = self
    }
}

//MARK: - UITableViewDataSource

extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableView.mainCellID, for: indexPath) as? MainCell else { return UITableViewCell() }
        
        let currenc = currencysArray[indexPath.row]
        cell.currency = currenc
        cell.setLabel(currency: currenc, sell: saleCourse,nbu: nbuCourse, valueFromTF: valueTF)
        return cell
    }
}

//MARK: - TextFieldDelegate
extension StartViewController: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let value = textField.text,
              let valueTFDouble = Double(value)
        else {return true}
        valueTF = valueTFDouble
        reloadTable()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
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

