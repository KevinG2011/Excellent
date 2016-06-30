//: Playground - noun: a place where people can play

import UIKit

var cstr = "Welcome!"
let nstr:Float = 4
let ostr = cstr + "\(nstr)"

var array = ["catfish","water","tulips","blue paint"]
array[0]

var dict = ["May":[5,15],"Feb":[2,"2"]]
dict["Feb"]
var aArray = [String]();
aArray = []
var aDict = [Double:Float]()
aDict = [:]

let scores = [75,43,103,87,12]
for score in scores {
    if score > 80 {
        print(score)
    }
}

//缺省值
var optVal:String?
let defVal:Double = 2
if let opt = optVal {
    print("hello, \(opt)")
} else {
    print("hello \(optVal ?? String(defVal))")
}

//switch用法
let veg = "rg"
switch veg {
case "r":
    print("r");
case let x where x.hasSuffix("g"):
    print("Is it a spicy \(x)");
default:
    print("k");
}

//迭代字典
for (mon,num) in dict {
    print("Month : \(mon), Num : \(num)")
}

//while,repeat循环
var n = 2
while n < 200 {
    n = n * 4
}
print(n)

var m = 2
repeat {
    m = m * 2
} while m < 100
print(m)

//for循环
for i in 0..<10 {
    //    print(i)
}

var k = 0
for i in 1...3 {
    k += i;
}
print(k)

//函数定义与调用
func greet(name:String, day:String, eat:String) -> String {
    return "Hello \(name), today is \(day). eat \(eat)"
}
greet("Bob", day: "Tue", eat: "noodles");

//元组返回多个值
func calculate(scores: [Int]) -> (min:Int,max:Int,sum:Int) {
    var min = scores[0];
    var max = scores[0];
    var sum = 0;
    for score in scores {
        if score > max {
            max = score
        }else if score < min {
            min = score
        }
        sum += score;
    }
    
    return (min,max,sum);
}

let stat = calculate([5,3,100,3,9]);
print(stat.sum);
print(stat.0);

//可变长参数
func sumOf(args:Int...) -> Int {
    var sum = 0
    for num in args {
        sum += num;
    }
    return sum;
}

sumOf()
sumOf(1,2,3)

func avgOf(args:Int...) -> Int {
    var sum = 0
    var count = 0
    for num in args {
        sum += num;
        count += 1;
    }
    
    if count > 0 {
        return sum / count;
    } else {
        return 0;
    }
}

avgOf(1,2,3)

//嵌套函数
func ret3rd() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}

print(ret3rd())

//返回值是函数
func make() -> (Int -> String) {
    func stos(a:Int) -> String {
        return "\(a)";
    }
    return stos;
}

var itom = make();
itom(3);

//多种闭包
func hasAnyMatches(list:[Int],cond:Int -> Bool) -> Bool {
    for item in list {
        if cond(item) {
            return true;
        }
    }
    
    return false;
}

func numCompare(num:Int) -> Bool {
    return num < 10;
}

var nums = [20,17,7,6,12];
var retNums = nums.map({
    num in 3 * num
})
print(retNums);
retNums = nums.map{ $0 * 2 }
print(retNums);
retNums = nums.sort{ $0 < $1 }
print(retNums);

hasAnyMatches(nums, cond: numCompare);

var closure = {
    (num:Int) -> Int in
    let ret = 3 * num
    return ret
}

let result = nums.map(closure);
print(result);

//对象和类
class Vehicle {
    var wheels = 0;
    var brand:String?;
    //初始化
    init(wheels:Int,brand:String) {
        self.wheels = wheels;
        self.brand = brand;
    }
    //析构
    deinit {
        self.wheels = 0;
        self.brand = nil;
    }
    
    func desc() -> String {
        return "\(brand ?? "A Vehicle ") with \(wheels) wheels."
    }
    func run(direction:Int) {
        print(brand ?? "Vehicle" + " is Running towards \(direction)")
    }
}

//子类化
var bez = Vehicle(wheels: 4,brand: "Benze")
print(bez.desc())

//枚举定义
enum DriveType: Int {
    case FrontDrive = 1
    case RearDrive,UnknownDrive
    func driveDesc() -> String {
        switch self {
        case .FrontDrive:
            return "前驱"
        case .RearDrive:
            return "后驱"
        default:
            return String(self.rawValue)
        }
    }
}

class Car: Vehicle {
    var driveType:DriveType?
    var driveControl:String? {
        get {
            return driveType?.driveDesc()
        }
        set {
            //newValue是新值
            if newValue == "前驱" {
                self.driveType = DriveType.FrontDrive
            } else if newValue == "后驱" {
                self.driveType = DriveType.RearDrive
            } else {
                self.driveType = DriveType.UnknownDrive
            }
        }
    }
    
    init(driveType:DriveType) {
        super.init(wheels: 4, brand: "")
        self.driveType = driveType;
        brand = "unknown";
    }
    
    func shake() {
        print("A Car is shaking!")
    }
    
    //覆盖
    override func run(direction: Int) {
        print("A Car is Running towards \(direction)")
    }
}

var car = Car(driveType: DriveType.FrontDrive)
car.run(2)
car.driveControl
car.driveControl = "后驱"
car.driveType

let aCar:Car? = Car(driveType: DriveType.RearDrive)
let dc = aCar?.driveControl

//枚举和结构体





