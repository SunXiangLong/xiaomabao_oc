//
//  fleaMarketBillVC.swift
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/6.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

import UIKit


class fleaMarketBillCell: UITableViewCell{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var money: UILabel!
   
    override func awakeFromNib() {
        self.uiedgeInsetsZero()
    }
    
    
    
    
}
class fleaMarketBillVC: BkBaseViewController {


    @IBOutlet weak var balanceOf: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension fleaMarketBillVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "fleaMarketBillCell", for: indexPath) as!  fleaMarketBillCell
        if indexPath.row == 3{
            cell.nextImage.isHidden = false
            cell.money.isHidden = true
        }else{
            cell.nextImage.isHidden = true
            cell.money.isHidden = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier:  "fleaMarketWithdrawalVC", sender: nil);
    }
    
}

