// Initialization in Swift

// Reference
// https://www.raywenderlich.com/119922/swift-tutorial-initialization-part-1
// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-ID203

import Foundation

// Use of an instance includes accessing properties, setting properties and calling methods

// Default Initializer

struct RocketConfiguration {
    // 1
    let name: String = "Athena 9 Heavy"
    let numberOfFirstStageCores: Int = 3
    let numberOfSecondStageCores: Int = 1
    // 2
    var anOptionalStoredPropertyVariable: Int?
    // 3
    let numberOfStageReuseLandingLegs: Int? = nil
}

let athena9Heavy = RocketConfiguration()
// This uses a default initializer "()" to instantiate athena9Heavy. 

// 1 You can use default initializers when your types either don’t have any stored properties, or all of the type’s stored properties have default values. This holds true for both structures and classes.

// 2 Default initializers work with optional stored property VARIABLES bc they are initialzed to nil by default

// 3 Optional Stored Property CONSTANTS will not work with default initializer. Constant optionals are rare. To fix, just assign a default value to nil



//---------------------------------------------------------------------------------

// Memberwise Initializers

// This struct has 3 stored properties with no default values and no initializer
struct RocketStageConfiguration {
    let propellantMass: Double
    let liquidOxygenMass: Double
    // 4
    let nominalBurnTime: Int// = 180
    
    // 5 custom initializer
//    init(propellantMass: Double, liquidOxygenMass: Double) {
//        self.propellantMass = propellantMass
//        self.liquidOxygenMass = liquidOxygenMass
//        self.nominalBurnTime = 180
//    }
}

// 6
extension RocketStageConfiguration {
    init(propellantMass: Double, liquidOxygenMass: Double) {
        self.propellantMass = propellantMass
        self.liquidOxygenMass = liquidOxygenMass
        self.nominalBurnTime = 180
    }
}

// Swift structures (and only structures) automatically generate a memberwise initializer. This means you get a ready-made initializer for all the stored properties that don’t have default values.

// Be careful when making changes to the struct as it will break the memberwise instance initialization

// let stageOneConfiguration = RocketStageConfiguration(liquidOxygenMass: 276.0, nominalBurnTime: 180, propellantMass: 119.1)

// 4 By setting a default property value in the struct, the above memberwise initializer becomes invalid. memberwise initializers ONLY provide parameters for stored properties without default values.

// let stageOneConfiguration = RocketStageConfiguration(propellantMass: 119.1,  liquidOxygenMass: 276.0, nominalBurnTime: 180)

// 5 the above memberwise initializer fails becuase you only get a memberwise initializer if a structure does not define any initializers. As soon as you define an initializer, you lose the automatic memberwise initializer.

//let stageOneConfiguration = RocketStageConfiguration(propellantMass: 119.1, liquidOxygenMass: 276.0)


// 6 if you still need the automatic memberwise initializer, you can move the custom initializer into an extension BEFORE you instantiate an instance

let stageOneConfiguration = RocketStageConfiguration(propellantMass: 119.1,
    liquidOxygenMass: 276.0, nominalBurnTime: 180)

// if we were to remove "nominalBurnTime" from the above memberwise initializer, it would still work!
// If the main struct definition doesn’t include any initializers, Swift will still automatically generate the default memberwise initializer. Then you can add your custom ones via extensions to get the best of both worlds.



//---------------------------------------------------------------------------------

// Custom Initializers


// Defining a custom initializer is very similar to defining a method, because an initializer’s argument list behaves exactly the same as a method’s. For example, you can define a default argument value for any of the initializer parameters.


struct Weather {
    let temperatureCelsius: Double
    let windSpeedKilometersPerHour: Double
    
    // 7
    init(temperatureFahrenheit: Double = 72, windSpeedMilesPerHour: Double = 6){
        self.temperatureCelsius = (temperatureFahrenheit - 32) / 1.8
        self.windSpeedKilometersPerHour = windSpeedMilesPerHour * 1.609344
    }
    
//    init(temperatureFahrenheit: Double, windSpeedMilesPerHour: Double) {
//        self.temperatureCelsius = (temperatureFahrenheit - 32) / 1.8
//        self.windSpeedKilometersPerHour = windSpeedMilesPerHour * 1.609344
//    }
}

// 7 by defining default argument values for the initializer parameters, we can call the initializer with no parameters
let currentWeather = Weather()
currentWeather.temperatureCelsius
currentWeather.windSpeedKilometersPerHour

// An initializer must assign a value to every single stored property that does not have a default value, or else you’ll get a compiler error. Remember that optional variables automatically have a default value of nil.

let moreCurrentWeather = Weather(temperatureFahrenheit: 87, windSpeedMilesPerHour: 2)

// We can now use the default initializer or memberwise custom initializer


//---------------------------------------------------------------------------------

// Avoiding Duplication with Initializer Delegation

// adding another initialzer, the delegating initializer
// Delegate initialization is useful when you want to provide an alternate initializer argument list but you don’t want to repeat logic that is in your custom initializer. Also, using delegating initializers helps reduce the amount of code you have to write.

struct GuidanceSensorStatus {
    var currentZAngularVelocityRadiansPerMinute: Double
    let initialZAngularVelocityRadiansPerMinute: Double
    var needsCorrection: Bool
    
    init(zAngularVelocityDegreesPerMinute: Double, needsCorrection: Bool = false) {
        let radiansPerMinute = zAngularVelocityDegreesPerMinute * 0.01745329251994
        self.currentZAngularVelocityRadiansPerMinute = radiansPerMinute
        self.initialZAngularVelocityRadiansPerMinute = radiansPerMinute
        self.needsCorrection = needsCorrection
    }
    
    // 8
    init(zAngularVelocityDegreesPerMinute: Double, needsCorrection: Int) {
        self.init(zAngularVelocityDegreesPerMinute: zAngularVelocityDegreesPerMinute,
                  needsCorrection: (needsCorrection > 0))
    }
}

// 8 the delegating initializer delegates initialization to another initializer. To delegate, just call any other initializer on self.

let guidanceStatus = GuidanceSensorStatus(zAngularVelocityDegreesPerMinute: 2.2)
guidanceStatus.currentZAngularVelocityRadiansPerMinute // 0.038
guidanceStatus.needsCorrection // false

// Keep in mind, delegating initializers cannot actually initialize any properties. There’s a good reason for this: the initializer you are delegating to could very well override the value you’ve set, and that’s not safe. The only thing a delegating initializer can do is manipulate values that are passed into another initializer.

// If we want to give a default value,



//---------------------------------------------------------------------------------

// Introducing Two-Phase Initialization

// Phase 1 starts at the beginning of initialization and ends once all stored properties have been assigned a value. The remaining initialization execution is phase 2. You cannot use the instance you are initializing during phase 1, but you can use the instance during phase 2. If you have a chain of delegating initializers, phase 1 spans the call stack up to the non-delegating initializer. Phase 2 spans the return trip from the call stack.


struct CombustionChamberStatus {
    var temperatureKelvin: Double
    var pressureKiloPascals: Double
    
    init(temperatureKelvin: Double, pressureKiloPascals: Double) {
        print("Phase 1 init")
        self.temperatureKelvin = temperatureKelvin
        self.pressureKiloPascals = pressureKiloPascals
        print("CombustionChamberStatus fully initialized")
        print("Phase 2 init")
    }
    
    init(temperatureCelsius: Double, pressureAtmospheric: Double) {
        print("Phase 1 delegating init")
        let temperatureKelvin = temperatureCelsius + 273.15
        let pressureKiloPascals = pressureAtmospheric * 101.325
        self.init(temperatureKelvin: temperatureKelvin, pressureKiloPascals: pressureKiloPascals)
        print("Phase 2 delegating init")
    }
}

CombustionChamberStatus(temperatureCelsius: 32, pressureAtmospheric: 0.96)



// Handling Initialization Failures

// #1 Using Failable Initializers

// failable initializers return optional values, and  can return nil to express an initialization failure.

struct TankStatus {
    var currentVolume: Double
    var currentLiquidType: String?
    
    // 9
    init?(currentVolume: Double, currentLiquidType: String?) {
        if currentVolume < 0 {
            return nil
        }
        if currentVolume > 0 && currentLiquidType == nil {
            return nil
        }
        self.currentVolume = currentVolume
        self.currentLiquidType = currentLiquidType
    }
}

// instantiation logic checks for failure
if let tankStatus = TankStatus(currentVolume: 50.0, currentLiquidType: nil) {
    print("Tank status created")
} else {
    print("Initialization failed")
}

// 9 add ? to init to make it failable and add if statements to detect an invalid input

//---------------------------------

// #2 Throwing From an Initializer

// Failable initializers are great when returning nil is an option. For more serious errors, the other way to handle failure is throwing from an initializer.

enum InvalidAstronautDataError: Error {
    case EmptyName
    case InvalidAge
}

struct Astronaut {
    let name: String
    let age: Int
    
    init(name: String, age: Int) throws {
        if name.isEmpty {
            throw InvalidAstronautDataError.EmptyName
        }
        if age < 18 || age > 70 {
            throw InvalidAstronautDataError.InvalidAge
        }
        self.name = name
        self.age = age
    }
}

let johnny = try? Astronaut(name: "Johnny Astronaut", age: 17) // nil

// When you call a throwing initializer, you write the try keyword — or the try? or try! variations — to identify that it can throw an error. In this case, you use try? so the value returned in the error case is nil.



//---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------



// Initializer Delegation


// #1a Designated Initializers

class RocketComponent {
    let model: String
    let serialNumber: String
    let reusable: Bool
    
    // Init #1a - Designated
    init(model: String, serialNumber: String, reusable: Bool) {
        self.model = model
        self.serialNumber = serialNumber
        self.reusable = reusable
    }
    
    // Init #1b - Convenience
    convenience init(model: String, serialNumber: String) {
        self.init(model: model, serialNumber: serialNumber, reusable: false)
    }
    
//    // Init #1c - Designated
//    init?(identifier: String, reusable: Bool) {
//        let identifierComponents = identifier.components(separatedBy: "-")
//        guard identifierComponents.count == 2 else {
//            return nil
//        }
//        self.reusable = reusable
//        self.model = identifierComponents[0]
//        self.serialNumber = identifierComponents[1]
//    }
    
    // Init #1c - Convenience
    convenience init?(identifier: String, reusable: Bool) {
        let identifierComponents = identifier.components(separatedBy: "-")
        guard identifierComponents.count == 2 else {
            return nil
        }
        self.init(model: identifierComponents[0], serialNumber: identifierComponents[1],
                  reusable: reusable)
    }
}

// Recall that a chain of delegating initializers eventually ends by a call to a non-delegating initializer. In the world of classes, a designated initializer is just a fancy term for a non-delegating initializer. Just like with structures, these initializers are responsible for providing initial values to all non-optional stored properties declared without a default value.

let payload = RocketComponent(model: "RT-1", serialNumber: "234", reusable: false)



// #1b Convenience Initializers
// in the world of classes, delegating initializers are called convenience initializers
// The only difference here is that you have to prefix the declaration with the convenience keyword.

let fairing = RocketComponent(model: "Serpent", serialNumber: "0")
// Similar to how they work with structs, convenience initializers let you have simpler initializers that just call through to a designated initializer.


// Failing and Throwing from Designated Initializers

// #1c - Designated

let component = RocketComponent(identifier: "R2-D21", reusable: true)
let nonComponent = RocketComponent(identifier: "", reusable: true)

//Notice in the sidebar how nonComponent is correctly set to nil because the identifier does not follow the model-serial number format.


//Failing and Throwing From Convenience Initializers


// #1c - Convenience
// This is better

// When writing initializers, make the designated initializers non-failable and have them set all the properties. Then your convenience initializers can have the failiable logic and delegate the actual initialization to the designated initializer.

// Note that there is a downside to this approach, relating to inheritance. Don’t worry, we’ll explore how to overcome this downside in the last section of this tutorial.

// That’s all there is to know about class initialization for root classes. Root classes, which don’t inherit from other classes, are what you’ve been working with so far.

//---------------------------------------------------------------------------------


// Subclassing

// The rest of this tutorial focuses on class initialization with inheritance.


// https://www.raywenderlich.com/121603/swift-tutorial-initialization-part-2
















