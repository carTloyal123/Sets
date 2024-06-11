import UIKit

var greeting = "Hello, playground"

let end_date = Date.now.addingTimeInterval(120)
let now = Date.now

print("\(now.distance(to: end_date))")
print("\(end_date.distance(to: now))")
print("\(now.addingTimeInterval(-120))")
