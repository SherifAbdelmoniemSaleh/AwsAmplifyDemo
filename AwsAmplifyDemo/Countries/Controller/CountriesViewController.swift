//
//  CountriesViewController.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 07/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class CountriesViewController: UIViewController {
    @IBOutlet weak var countriesTableView: UITableView!
    let tableViewCell = "CountryTableViewCell"
    let disposeBag = DisposeBag()
    let vm = CountriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        subscribeToLoading()
        subscribeToResponse()
        getCountries()
        
    }
    
    func subscribeToLoading() {
        vm.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        self.vm.countriesModelObservable
            .bind(to: self.countriesTableView
                .rx
                .items(cellIdentifier: tableViewCell,
                       cellType: CountryTableViewCell.self)) { row, country, cell in
                        print(row)
                        cell.textLabel?.text = country.name
        }
        .disposed(by: disposeBag)
    }
    
    func getCountries() {
        vm.getAllCountries()
    }
}
