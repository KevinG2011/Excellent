//: Playground - noun: a place where people can play

import UIKit
import Foundation

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

//字符串
var eStr = String("1233")
for character in eStr.characters {
    print(character,""," ")
}
let catchar: [Character] = ["C","a","t","!","?"]
var catStr: String = String(catchar)
catStr.characters.count
catStr[catStr.startIndex]
let index = catStr[catStr.startIndex.advancedBy(2)]
catStr.insert("!", atIndex: catStr.endIndex)

//数组
var array = ["catfish","water","tulips","blue paint"]
array[2...3] = ["beaf","sheep"]
array.removeLast()
for (index,value) in array.enumerate() {
    print("Item \(String(index+1)): \(value)")
}

array = [String]()
array = [String](count:3,repeatedValue:"2.5")

let farmAnimals: Set = ["?","?","?","?","?"]
let cityAnimals: Set = ["?","?"]
print(farmAnimals.isDisjointWith(cityAnimals))

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

//switch用法
let veg = "rg"
switch veg {
case "r":
    print("r");
case let x where x == "rg":
    print("x == \(x)")
case let x where x.hasSuffix("g"):
    print("x hasSuffix \(x)")
default:
    print("k");
}

let vCount = 62
switch vCount {     //区间匹配
case 0:
    print("0")
case 1..<5:
    print(vCount)
default:
    print("default")
}

func greet(){
    guard let gCount = dict["Feb"] else {
        return
    }
}

//API可用性
if #available(iOS 9, OSX 10.10,*) {
    print("available iOS9")
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

//迭代字典
for (mon,num) in dict {
    print("Month : \(mon), Num : \(num)")
}

//函数定义与调用
func greet(name:String, day:String, eat:String) -> String {
    return "Hello \(name), today is \(day). eat \(eat)"
}
greet("Bob", day: "Tue", eat: "noodles");

//多重返回值
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

//输入输出参数
func pad(inout str: String) -> String {
    str = "-" + str
    return str
}

var inStr: String = "in"
pad(&inStr)
print(inStr)


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
retNums = nums.sort( < )
print(retNums);

hasAnyMatches(nums, cond: numCompare);

var closure = {
    (num:Int) -> Int in
    let ret = 3 * num
    return ret
}

let result = nums.map(closure);
print(result);

func someFunc(@noescape closure: ()-> Void) {  //非逃逸闭包
    closure()
}

var customers:[String] = ["Barry,","Daniella"]
var providers: [() -> String] = []          //自动逃逸闭包
func someAutoFunc(@autoclosure(escaping) provider: () -> String){
    providers.append(provider)
}
someAutoFunc(customers.removeLast())
someAutoFunc(customers.removeLast())
print(providers)

//枚举
enum Barcode {
    case UPCA(Int,Int,Int,Int)
    case QRCode(String)
}
var prodBarcode = Barcode.UPCA(8, 85909, 51226, 3)

enum ArithExpression {  //递归枚举
    case Number(Int)
    indirect case Addition(ArithExpression,ArithExpression)
    indirect case Multiply(ArithExpression,ArithExpression)
}

func evaluate(exp:ArithExpression) -> Int {
    switch exp {
    case .Number(let v):
        return v
    case .Addition(let v1, let v2):
        return evaluate(v1) + evaluate(v2)
    case .Multiply(let v1, let v2):
        return evaluate(v1) * evaluate(v2)
    }
}

let five = ArithExpression.Number(5)
let sum = ArithExpression.Addition(.Number(3), .Number(2))

//对象 类 基类 构造器
class Vehicle {
    var wheels = 0
    let text:String?    //常量属性
    var brand:String?   //可选属性类型
    //初始化
    init(_ wheels:Int,_ brand:String) { //不提供外部参数名字
        self.wheels = wheels
        self.text = ""
        self.brand = brand
    }
    
    convenience init() {
        self.init(0,"Unnamed")
    }
    
    //析构
    deinit {
        self.wheels = 0
        self.brand = nil
    }
    
    func desc() -> String {
        return "\(brand ?? "A Vehicle ") with \(wheels) wheels."
    }
    func run(direction:Int) {
        print(brand ?? "Vehicle" + " is Running towards \(direction)")
    }
}

//子类化
var bez = Vehicle(4,"Benze")
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
        super.init(4,"")
        self.driveType = driveType;
        self.brand = "unknown";
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


let aCar:Car? = Car(driveType: DriveType.RearDrive)
let dc = aCar?.driveControl
print(aCar?.driveType?.rawValue)

struct creature {
    let species: String?
    init?(species: String) {    //可失败构造器
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}

//可失败枚举构造
enum TemperatureUnit {
    case Kelvin,Celsius,Fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}

class SomeClass {
    let someAttr = 5
    required init() { //必要构造器,子类必须实现
        
    }
    
    let closeureAttr: Int = {
        print("closure init property!")
//        return someAttr * 2    //闭包执行时,实例其他部分还未初始化,不能访问其他属性
        return 10
    }()
}

let clazz:SomeClass = SomeClass()

class DataImporter {
    var fileName = "data.txt"
    static var totalCount:Int = 0 {
        willSet(newTotalCount) {    //willSet观察器
            print("Abount to set totalSteps to \(newTotalCount)")
        }
        didSet {
            if totalCount > oldValue {  //didSet观察器
                print("Added \(totalCount - oldValue) steps");
            }
        }
    }
}
class DataManager {
    lazy var importer = DataImporter() //懒加载
    var data = [String]()
    subscript(index:Int)->String {
        get {
            return data[index]
        }
    }
}
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")

//全局变量,枚举和结构体
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

//弱引用
class Person {
    let name: String
    var apartment: Apartment?
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    weak var tenant: Person?
    init(unit: String) {
        self.unit = unit
    }
    deinit {
        print("Apartment \(unit) is being deinitialized")
    }
}

//无主引用
class City {
    let name: String
    unowned let country: Country    //无主引用,非可选类型,永远有值
    init(name:String,country:Country) {
        self.name = name
        self.country = country
    }
}

class Country {
    let name: String
    var capitalCity:City!
    init(name:String,capitalName:String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

//闭包循环引用
class HTMLElement {
    let name: String
    let text: String?
    lazy var asHTML:Void -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "</\(self.name)>"
        }
    }
    
    init(name:String,text:String) {
        self.name = name;
        self.text = text;
    }
    
    deinit {
        print("<\(name)> dealloc")
    }
}

var paragraph:HTMLElement? = HTMLElement(name: "p", text: "Hello World!")
paragraph!.asHTML()
paragraph = nil

//抛异常,需要集成ErrorType
enum VendingMachineError:ErrorType {
    case InvalidSelection                       //选择无效
    case InsufficientFunds(coinsNeeded: Int)    //金额不足
    case OutOfStock                             //缺货
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var coinsDeposited = 0
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips"    : Item(price: 10, count: 4),
        "Pretzels" : Item(price: 12, count: 11),
    ]
    func dispenseSnack(snack:String) -> Int {
        print("Dispensing \(snack) ...")
        return 0
    }
    
    func vend(itemNamed name:String) throws -> Int {
        guard var item = inventory[name] else {
            throw VendingMachineError.InvalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.OutOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.InsufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        item.count -= 1
        inventory[name] = item
        return dispenseSnack(name)
    }
}

var vm:VendingMachine = VendingMachine()
let ret = try? vm.vend(itemNamed: "kid")    //如果vend抛出异常则ret是nil,否则ret是函数返回值

//扩展
extension Double {
    var km:Double {return self * 1_000.0}   //计算型属性
    var  m:Double {return self }
    var cm:Double {return self / 100.0}
    var mm:Double {return self / 1_000.0 }
    var ft:Double {return self / 3.28084 }
    
    func repetitions(task: () -> ()) {
        for _ in 1 ... Int(self) {
            task()
        }
    }
    
    func fr() -> Double {
        return floor(self)
    }
    
}

let oneInch = 25.4.mm
4.0.repetitions {
    print("Hi!")
}

//协议
protocol Serializable {
    var name: String { get }    //属性规定
    func toString() -> String   //方法规定
}

class LinerGenerator: Serializable {
    var name: String {
        return "Liner"
    }
    func toString() -> String {
        return ""
    }
    
    
}


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
    mutating func grow()
}

class Animal {
    var age:Int = 1
    func grow(){
        print("Animal is running!")
    }
}

class Bird: Animal,AnimalProtocol {
    var weight:Double = 10.0
    func eat() {
        print("Bird is Eating!")
    }
    override func grow() {
        
        print("Bird is flying!")
    }
}

var b:Bird = Bird()
b.grow()

let anim:AnimalProtocol = b
//anim.eat()          //Uncomment to see the error

struct Horse: AnimalProtocol {
    var age:Int = 1
    mutating func grow() {
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
    func grow() {
        print("Fish is swimming!");
    }
}

var f = Fish.GrossFish;
f.grow();
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





