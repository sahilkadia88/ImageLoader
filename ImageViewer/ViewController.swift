//
//  ViewController.swift
//  ImageViewer
//
//  Created by Sahil Kadia on 6/29/18.
//  Copyright © 2018 Sahil Kadia. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {

   
    @IBOutlet weak var imageTable: UITableView!
    var ImageArray:NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        CallAPI()
        
    }

    func CallAPI()
    {
        
        let url = URL(string:"https://picsum.photos/list")
        let request = NSMutableURLRequest(url:url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data,response,error in
            
            if error != nil
            {
                print("Error")
                
            }
            else
            {
                do
                {
                    let parsedArray = try JSONSerialization.jsonObject(with: data!, options:[]) as? [AnyObject]
                    //print("ParsedArray:\(parsedArray!)")
                    
                    self.ImageArray = NSMutableArray()
                    for newArr in parsedArray!
                    {
                        let Io: ImageObj = ImageObj()
                        Io.format = newArr["format"] as! String
                        Io.width = newArr["width"] as! Int
                        Io.height = newArr["height"] as! Int
                        Io.filename = newArr["filename"] as! String
                        Io.id = newArr["id"] as! Int
                        Io.author = newArr["author"] as! String
                        Io.author_url = newArr["author_url"] as! String
                        Io.post_url = newArr["post_url"] as! String
                        self.ImageArray.add(Io)

                    }
                DispatchQueue.main.async {
                        self.imageTable.delegate = self
                        self.imageTable.dataSource = self
                        self.imageTable.reloadData()
                    }
                    
                }
                catch let error as NSError {
                    
                     print("Error: \(error.localizedDescription)")
                    
                }
            }
            
        }
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ImageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageTable.dequeueReusableCell(withIdentifier: "Cell") as! ImageTableViewCell

        let objMov:ImageObj = self.ImageArray[indexPath.row]as! ImageObj
        let name = "Author: \(objMov.author!)"
        let authUrl = "Url: \(objMov.author_url!)"
        cell.authorname.text = name
        cell.authorurl.text = authUrl
        cell.authorImage.downloadedFrom(link: "https://picsum.photos/\(objMov.width!)/\(objMov.height!)?image=\(objMov.id!)", contentMode: .scaleAspectFit)
        
        return cell
    }

}


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
