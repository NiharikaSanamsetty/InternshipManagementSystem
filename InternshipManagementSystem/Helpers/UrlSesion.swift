import Foundation

func sendEmail(to:String,subject:String,emailBody:String) {
    
 
let semaphore = DispatchSemaphore (value: 0)

let parameters = "{\n    \"to\" : \"\(to)\",\n    \"from\" : \"\",\n    \"subject\" : \"\(subject)\",\n    \"htmlText\" : \"\(emailBody)\"\n\n}"
let postData = parameters.data(using: .utf8)

var request = URLRequest(url: URL(string: "https://us-central1-internshipmanagementsyst-e9f1e.cloudfunctions.net/sendEmail")!,timeoutInterval: Double.infinity)
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpMethod = "POST"
request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in
  guard let data = data else {
    print(String(describing: error))
    semaphore.signal()
    return
  }
  print(String(data: data, encoding: .utf8)!)
  semaphore.signal()
}

task.resume()
semaphore.wait()


}
