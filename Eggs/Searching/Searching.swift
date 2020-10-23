//
//  Searching.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/22/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class Searching: common{
    @IBOutlet var searchTable : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 50
            , width: UIScreen.main.bounds.width, height: 50))
        //searchBar.searchBarStyle = .minimal
        searchBar.searchBarStyle = .prominent
        view.addSubview(searchBar)
        searchBar.placeholder = "placeholder"
        searchBar.barTintColor = .white
        searchBar.searchTextField()
        
        searchTable.delegate = self
        searchTable.dataSource = self
    }
    
    
}
extension Searching: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searching", for: indexPath)
        
        return cell
    }
    
    
}
extension UISearchBar{
    func searchTextField(){
        for subView in self.subviews {
            for subViewOne in subView.subviews {
                if let textField = subViewOne as? UITextField {
                    subViewOne.backgroundColor = UIColor(named: "screenBackground")
                    let imageView = UIImageView(image: #imageLiteral(resourceName: "ic_se_marker"))
                    textField.rightView = imageView
                    imageView.contentMode = .scaleAspectFit
                    textField.rightViewMode = UITextField.ViewMode.always
                    //use the code below if you want to change the color of placeholder
                    let textFieldInsideUISearchBarLabel =       textField.value(forKey: "placeholderLabel") as? UILabel
                        textFieldInsideUISearchBarLabel?.textColor = UIColor.black
                    }
            }
        }
        
    }
}
