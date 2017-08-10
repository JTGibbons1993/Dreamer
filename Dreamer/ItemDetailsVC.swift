//
//  ItemDetailsVC.swift
//  Dreamer
//
//  Created by user on 8/8/17.
//  Copyright © 2017 John. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleView: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImage: UIImageView!
    

    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
      
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Bester Buy"
        let store3 = Store(context: context)
        store3.name = "Worst Buy"
        let store4 = Store(context: context)
        store4.name = "Pot Pie's Super Store"
        let store5 = Store(context: context)
        store5.name = "The Outer Corner"
        let store6 = Store(context: context)
        store6.name = "The Pizza Store!"
 
        ad.saveContext()
        getStores()
        //if we pass an item into the Main View, it will load the data for the item
        if itemToEdit != nil {loadItemData()}
        
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    //number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    //number of columns/components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected...
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            //set the stores array at the top equal to the results fetched
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
           // handle error
        }
    }
    
    @IBAction func savedPressed(_ sender: UIButton) {
//insert item and image into NSManageObjectContext by initializing it
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImage.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        item.toImage = picture//assign an entity to an entity (associate an image to the item)
        
        //assign the content inside the text fields to the above object's attributes
        if let title = titleView.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue //set string as double
        }
        if let details = detailsField.text {
            item.details = details
        }
        //assigning a store via relationship to this Item object
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)] //"inComponent" indicates the column, NOT the row, so it's zero if there's only one column
        
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }
    
//edit already saved items
    func loadItemData() {
        if let item = itemToEdit {
            titleView.text = item.title
            priceField.text = String(item.price)
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            //loop through the pickerView until the correct one is found and assign that one to be viewed
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        //if there is a match the row will be assigned to the index
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while(index < stores.count)
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    
    }
//access camera roll to add image 
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
