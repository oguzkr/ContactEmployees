//
//  ApiClient.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 9.11.2021.
//

import Foundation


class EmployeesViewModel {
    
    var employees = [Employee]()
    
    func getEmployees(branch: Branch, completed: @escaping (_ success: Bool) -> ()){
        if let url = URL(string: ServiceType.employees(branch: branch)) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error == nil{
                    do{
                        if let employeeData = data {
                            let result = try JSONDecoder().decode(EmployeeModel.self, from: employeeData)
                            DispatchQueue.main.async {
                                if let employees = result.employees {
                                    self.employees = employees
                                    completed(true)
                                }
                            }
                        }
                    }catch{
                        print("Task failed successfully: \(error)")
                        completed(false)
                    }
                } else {
                    print("Task failed successfully")
                    completed(false)
                }
            }.resume()
        }
    }
}
