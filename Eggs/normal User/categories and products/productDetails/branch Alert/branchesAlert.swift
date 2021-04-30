//
//  branchesAlert.swift
//  Eggs
//
//  Created by Bassam on 4/30/21.
//  Copyright © 2021 Bassam Ramadan. All rights reserved.
//

import UIKit

class branchesAlert: common {

    @IBOutlet var branchesCollection: UICollectionView!
    var sellerId: Int?
    var branches = [branchData]()
    var selectedId = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        initCollectionView()
        getBranches(id: sellerId ?? 0) { (data) in
            self.branches.removeAll()
            self.branches.append(contentsOf: data)
            if !data.isEmpty{
                self.selectedId = data[0].id ?? 0
            }
            self.branchesCollection.reloadData()
        }
        
    }
    private func initCollectionView() {
        let nib = UINib(nibName: "branchesAlertCell", bundle: nil)
        branchesCollection.register(nib, forCellWithReuseIdentifier: "branchesAlertCell")
        branchesCollection.dataSource = self
        branchesCollection.delegate = self
    }
    @IBAction func ok(){
        AppDelegate.CartBranch = selectedId
        super.dismiss(animated: true)
    }
    @IBAction func close(){
        super.dismiss(animated: true)
    }
    @objc func selectedBranch(sender: UIButton){
        selectedId = sender.tag
        branchesCollection.reloadData()
    }
}
extension branchesAlert: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return branches.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.contentSize.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branchesAlertCell", for: indexPath) as! branchAlertCell
        cell.name.text = branches[indexPath.row].name ?? ""
        cell.checked.tag = branches[indexPath.row].id ?? 0
        cell.location.text = "\(branches[indexPath.row].cityName ?? "") - \(branches[indexPath.row].districtName ?? "")"
        cell.checked.addTarget(self, action: #selector(selectedBranch(sender:)), for: .touchUpInside)
        
        cell.checked.setImage(cell.checked.tag == selectedId ? #imageLiteral(resourceName: "ic_check_box_checked") : #imageLiteral(resourceName: "ic_check_box"), for: .normal)
        return cell
    }
}
