//
//  fleaMarketMyReleaseVC.swift
//  XiaoMaBao
//
//  Created by xiaomabao on 2017/7/6.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

import UIKit
class fleaMarketMyReleaseCell: UITableViewCell{

    @IBOutlet weak var browse: UILabel!
    @IBOutlet weak var praise: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    @IBOutlet weak var goodsCenter: UILabel!
    @IBOutlet weak var goodsImage: UIImageView!
    override func awakeFromNib() {
        self.uiedgeInsetsZero()
    }

    @IBAction func editor(_ sender: Any) {
    
    }
    @IBAction func delte(_ sender: Any) {
    
    }
    
}

class fleaMarketMyReleaseVC: BkBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
extension fleaMarketMyReleaseVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "fleaMarketMyReleaseCell", for: indexPath) as!  fleaMarketMyReleaseCell
        
        return cell
    }


}