//: Playground - noun: a place where people can play

import UIKit

var cstr = "Welcome!"
let nstr:Float = 4
let ostr = cstr + "\(nstr)"

//元组
let httpError = (code:404,desc:"Not Found")
print(httpError.0)                      //下标访问
let (statusCode,statusMsg) = httpError //decompose 
print(statusCode)
let (sc,_) = httpError
print(sc)

//数组
var array = ["catfish","water","tulips","blue paint"]
var aArray = [String]();
aArray = []
array[0]

//字典
var dict = ["May":[5,15],"Feb":[2,"2"]]
dict["Feb"]
var aDict = [Double:Float]()
aDict = [:]

let scores = [75,43,103,87,12]
for score in scores {
    if score > 80 {
        print(score)
    }
}

//类型标注
var msg = "Hello"
var red,green,blue: String?
print(msg, terminator: "") //禁用换行符

//类型别名
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min

//可选类型,可选绑定
var optVal:String?
if let opt = optVal {
    print("hello, \(opt)")
} else {
    print("hello \(optVal ?? String(2))")
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
func calculate(scores: [Int]) -> (Int,Int,Int) {
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
print(stat.2);
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
    func desc() -> String {
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
            return driveType?.desc()
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
print(aCar?.driveType?.rawValue)

//枚举和结构体
if let cvtDriverType = DriveType(rawValue: 1) {
    let twDesc = cvtDriverType.desc()
}

enum Suit {
    case Spades,Hearts,Diamonds,Clubs
    func desc() -> String {
        switch self {
            case .Spades:
                return "spades"
            case .Hearts:
                return "hearts"
            case .Diamonds:
                return "diamonds"
            case .Clubs:
                return "clubs"
        }
    }
    
    func color() -> String {
        switch self {
        case .Spades:
            return "black"
        case .Clubs:
            return "black"
        case .Hearts:
            return "red"
        case .Diamonds:
            return "red"
        }
    }
}

struct Card {
    var suit:Suit
    func desc() -> String {
        return "The Suit \(suit.desc())"
    }
}

let card3rd = Card(suit: .Diamonds);
let cardDesc = card3rd.desc();

enum ServerResponse {
    case Result(String,String)
    case Error(String)
    case Unknown(String)
}

let success = ServerResponse.Result("6:00 am", "8:09 pm")
let failure = ServerResponse.Error("Out of cheese.")
let unknown = ServerResponse.Unknown("Unknown ")

//??
switch unknown {
    case let .Result(sunrise,sunset):
        let serverResponse = "Sunrise is at \(sunrise) and sunset is at \(sunset)."
    case let .Error(error):
        let serverResponse = "Failure... \(error)"
    case let .Unknown(unknown):
        let serverResponse = "Server... \(unknown)"
}

//协议和扩展
protocol AnimalProtocol {
    var age:Int { get }
    mutating func run()
}

class Animal {
    var age:Int = 1
    func run(){
        print("Animal is running!")
    }
}

class Bird: Animal,AnimalProtocol {
    var weight:Double = 10.0
    func eat() {
        print("Bird is Eating!")
    }
    override func run() {
        print("Bird is flying!")
    }
}

var b:Bird = Bird()
b.run()

let anim:AnimalProtocol = b
//anim.eat()          //Uncomment to see the error

struct Horse: AnimalProtocol {
    var age:Int = 1
    mutating func run() {
        print("Horse is galloping!")
        age += 1;
    }
}

//枚举实现协议
enum Fish: Float,AnimalProtocol {
    case GoldFish = 1,BlackFish,GrossFish
    var age: Int {
        get {
            return 10
        }
    }
    func run() {
        print("Fish is swimming!");
    }
}

var f = Fish.GrossFish;
f.run();
print(f.age)

//extension class
extension Int {
    var age:Int {
        get {
            return self
        }
    }
    
    func run() {
        print("numbers are dancing!");
    }
}

print(8.age)
8.run()

extension Double {
    var roundValue: Double {
       return round(self)
    }
}

print((9.3).roundValue)

//泛型
func repeatItem<Item>(item:Item,times:Int) -> [Item] {
    var ret = [Item]()
    for _ in 0..<times {
        ret.append(item)
    }
    return ret
}

var items:[Int] = repeatItem(4, times: 3);

//泛型枚举
enum OptionalValue<Wrapped> {
    case None
    case Some(Wrapped)
}
var val:OptionalValue<Int> = .None
val = .Some(100)

//doc 23?





