import UIKit

var greeting = "Hello, playground"

let end_date = Date.now.addingTimeInterval(120)
let now = Date.now

Log.logger.debug("\(now.distance(to: end_date))")
Log.logger.debug("\(end_date.distance(to: now))")
Log.logger.debug("\(now.addingTimeInterval(-120))")
