//
//  ContentView.swift
//  weather
//
//  Created by Владислав Космачев.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var cityView:Bool = true
    @State var lat:Double = 0.0
    @State var lon:Double = 0.0
    
    var body: some View {
        VStack{
            if(cityView == false){
                MainView(cityView: $cityView, lat:$lat, lon:$lon)
            } else {
                Search(cityView: $cityView, lat:$lat, lon:$lon).padding()
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct MainView: View{
    
    @StateObject var mainVM = API()
    var gradient = GradientColor()
    
    @Binding var cityView:Bool
    @Binding var lat:Double
    @Binding var lon:Double
    
    var body:some View{
        ScrollView{
            VStack{
                ZStack{
                    VStack{
                        HStack{
                            Text("\(mainVM.nameCity)").font(.title).foregroundColor(.gray)
                                Image(systemName: mainVM.aqiStatus).resizable().foregroundColor(.green).frame(width: 30, height: 30).padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                            Spacer()
                        }.padding(EdgeInsets(top: 40, leading: 16, bottom: 16, trailing: 0))
                        TemperatureTitle(mainVM: mainVM)
                    }
                }
                Blocks(mainVM: mainVM, cityView: $cityView)
                Spacer()
            }
        }.background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: Double(gradient.grad(value: Int(mainVM.temp), maxValue: 60).colorR), green: Double(gradient.grad(value: Int(mainVM.temp), maxValue: 60).colorG), blue: Double(gradient.grad(value: Int(mainVM.temp), maxValue: 60).colorB))]), startPoint: .top, endPoint: .bottom)
        ).foregroundColor(.white).onAppear{
            mainVM.getAirPollution(lat: lat, lon: lon)
            mainVM.getData(lat: lat, lon: lon)
            mainVM.getExtendedData(lat: lat, lon: lon)
        }
    }
}

/// Группа заголовков
struct TemperatureTitle: View {
    
    @ObservedObject var mainVM: API
    
    var body: some View{
        HStack{
                VStack {
                    HStack{
                        VStack {
                            ZStack{
                                HStack(spacing:0){
                                Text("\(Int(mainVM.temp))°C").font(.system(size: 86.0))
                                AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/\(mainVM.icon)@2x.png"))
                                Spacer()
                            }
                        
                            }
                        }
                    }
                    HStack{
                        Text("Min:")
                        Text("\(Int(mainVM.tempMin))°C")
                        Text("Max:")
                        Text("\(Int(mainVM.tempMax))°C")
                        Spacer()
                    }.font(.callout)
                    HStack{
                        Text("\(mainVM.description)").foregroundColor(.gray)
                        Spacer()
                    }
            }.font(.title)
        }.padding().foregroundColor(.gray)
    }
}

struct Warning: View{
    
    @ObservedObject var mainVM: API
    
    var body: some View {
        if (!mainVM.alerts.isEmpty){
            VStack{
                HStack{
                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
                    Text("Важные сообщения").font(.system(size: 14))
                    Spacer()
                }
                VStack{
                    ForEach(mainVM.alerts, id: \.self){ alert in
                        HStack{
                            Text("\(alert)")
                            Spacer()
                        }
                    }.padding(2)
                }
            }.blockLong()
        }
    }
}

struct AQI: View{
    
    @ObservedObject var mainVM: API
    
    private let converter = Converter()
    @State var hideAQI:Bool = true
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: mainVM.aqiStatus).foregroundColor(.green)
                Text("AQI").font(.system(size: 14))
                Spacer()
                Button(action: {
                    hideAQI.toggle()
                }) {
                    Image(systemName: hideAQI == false ? "chevron.down.circle" : "chevron.forward.circle").foregroundColor(.blue)
                }
            }
            if (hideAQI == false){
                VStack{
                    Divider()
                    HStack{
                        Text("PM2.5")
                        Spacer()
                        Text("\(converter.converter2F(value: mainVM.pm25))")
                    }
                    HStack{
                        Text("NH3")
                        Spacer()
                        Text("\(converter.converter2F(value: mainVM.nh3))")
                    }
                    HStack{
                        Text("NO2")
                        Spacer()
                        Text("\(converter.converter2F(value: mainVM.no2))")
                    }
                    HStack{
                        Text("SO2")
                        Spacer()
                        Text("\(converter.converter2F(value: mainVM.so2))")
                    }
                    HStack{
                        Text("CO")
                        Spacer()
                        Text("\(converter.converter2F(value: mainVM.co))")
                    }
                    HStack{
                        Text("O3")
                        Spacer()
                        Text("\(converter.converter2F(value: mainVM.o3))")
                    }
                    HStack{
                        Text("PM10")
                        Spacer()
                        Text("\(converter.converter2F(value: mainVM.pm10))")
                    }
                    HStack{
                        Text("SO2")
                        Spacer()
                        Text("\(converter.converter2F(value: mainVM.so2))")
                    }
                }
            }
        }.blockLong()
    }
}

struct HourWeather: View{
    
    @ObservedObject var mainVM: API
    
    private let converter = Converter()
    
    var body: some View{
        VStack{
            HStack{
                Image(systemName: "clock").foregroundColor(.orange)
                Text("Почасовой прогноз").font(.system(size: 14))
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(mainVM.hourly){ hour in
                        VStack{
                            Text("\(converter.converterDateHour(value:hour.dt))")
                            Spacer()
                            VStack(spacing:0){
                                AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/\(hour.icon).png"))
                                if (hour.snow != 0.0){
                                    Text("\(Int(hour.snow*100.0)) %").foregroundColor(.blue)
                                }
                            }
                            Spacer()
                            Text("\(Int(hour.temp))°C")
                        }
                    }.padding(2)
                }
            }
        }.blockLong()
    }
}

struct DailyWeather: View {
    
    @ObservedObject var mainVM: API
    
    private let converter = Converter()
    
    @State var hide:Bool = true
    
    var body: some View{
        VStack{
            HStack{
                Image(systemName: "calendar").foregroundColor(.orange)
                Text("Прогноз на 8 дней").font(.system(size: 14))
                Spacer()
                Button(action: {
                    hide.toggle()
                }) {
                    Image(systemName: hide == false ? "chevron.down.circle" : "chevron.forward.circle").foregroundColor(.blue)
                }
            }
            if (hide == false){
                VStack{
                    ForEach(mainVM.daily){ daily in
                        Divider()
                        VStack{
                            HStack{
                                Text("\(converter.converterDateWeek(value:daily.dt))")
                                Spacer()
                            }
                            HStack{
                                Text("\(Int(daily.temp))°C").font(.system(size: 20.0))
                                VStack{
                                    AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/\(daily.icon).png"))
                                    if (daily.pop != 0.0){
                                        Text("\(Int(daily.pop*100.0)) %").foregroundColor(.blue)
                                    }
                                }
                                VStack{
                                    Spacer()
                                    HStack{
                                        Text("\(daily.description)")
                                        Spacer()
                                    }
                                    Spacer()
                                    HStack{
                                        Text("Min: \(Int(daily.min))°C")
                                        Spacer()
                                        Text("Max: \(Int(daily.max))°C")
                                    }
                                }
                                Spacer()
                            }
                            HStack{
                                VStack{
                                    HStack{
                                        Text("Утром")
                                        Spacer()
                                    }
                                    HStack{
                                        HStack{
                                            Image(systemName: "thermometer")
                                            Text("\(Int(daily.tempMorn))°C")
                                            Spacer()
                                            Image(systemName: "hand.raised")
                                            Text("\(Int(daily.feelsLikeMorn))°C")
                                            Spacer()
                                        }.frame(width: 180)
                                        Spacer()
                                    }
                                    HStack{
                                        Text("Днем")
                                        Spacer()
                                    }
                                    HStack{
                                        HStack{
                                            Image(systemName: "thermometer")
                                            Text("\(Int(daily.tempDay))°C")
                                            Spacer()
                                            Image(systemName: "hand.raised")
                                            Text("\(Int(daily.feelsLikeDay))°C")
                                            Spacer()
                                        }.frame(width: 180)
                                        Spacer()
                                    }
                                    HStack{
                                        Text("Вечером")
                                        Spacer()
                                    }
                                    HStack{
                                        HStack{
                                            Image(systemName: "thermometer")
                                            Text("\(Int(daily.tempEve))°C")
                                            Spacer()
                                            Image(systemName: "hand.raised")
                                            Text("\(Int(daily.feelsLikeEve))°C")
                                            Spacer()
                                        }.frame(width: 180)
                                        Spacer()
                                    }
                                    HStack{
                                        Text("Ночью")
                                        Spacer()
                                    }
                                    HStack{
                                        HStack{
                                            Image(systemName: "thermometer")
                                            Text("\(Int(daily.tempNight))°C")
                                            Spacer()
                                            Image(systemName: "hand.raised")
                                            Text("\(Int(daily.feelsLikeNight))°C")
                                            Spacer()
                                        }.frame(width: 180)
                                        Spacer()
                                    }
                                }
                            }
                            Spacer()
                        }
                    }.padding(2)
                }
            }
        }.blockLong()
    }
}


/// Группа блоков
struct Blocks: View {
    
    @ObservedObject var mainVM: API
    
    private let converter = Converter()
    
    @Binding var cityView:Bool
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                HStack{
                    Button(action: {
                        cityView = true
                    }) {
                        Image(systemName: "list.bullet").foregroundColor(.blue)
                    }
                }.blockCircle().padding()
            }
            Warning(mainVM: mainVM)
            AQI(mainVM: mainVM)
            HourWeather(mainVM: mainVM)
            DailyWeather(mainVM: mainVM)
            HStack{
                Spacer()
                    VStack {
                        HStack{
                            Image(systemName: "sunrise")
                            Text("Восход").font(.system(size: 14))
                            Spacer()
                        }
                        HStack{
                            Text("\(converter.converterDate(value: mainVM.sunrise))")
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "sunset")
                            Text("Закат").font(.system(size: 14))
                            Spacer()
                        }
                        HStack{
                            Text("\(converter.converterDate(value: mainVM.sunset))")
                            Spacer()
                        }
                    }.block()
                Spacer()
                    VStack{
                        HStack{
                            Image(systemName: "wind").foregroundColor(.blue)
                            Text("Ветер").font(.system(size: 14))
                            Spacer()
                        }
                        HStack{
                            Text("\(String.init(format: "%.2f", mainVM.windSpeed)) м/с")
                            Spacer()
                        }
                    }.block()
                Spacer()
            }
            HStack{
                Spacer()
                    VStack{
                        HStack{
                            Image(systemName: "cloud")
                            Text("Облачность").font(.system(size: 14))
                            Spacer()
                        }
                        HStack{
                            Text("\(mainVM.clouds) %")
                            Spacer()
                        }
                    }.block()
                Spacer()
                    VStack{
                        HStack{
                            Image(systemName: "thermometer")
                            Text("Давление").font(.system(size: 14))
                            Spacer()
                        }
                        HStack{
                            Text("\(mainVM.pressure)")
                            Spacer()
                        }
                }.block()
                Spacer()
            }
            HStack{
                Spacer()
                    VStack{
                        HStack{
                            Image(systemName: "humidity")
                            Text("Влажность").font(.system(size: 14))
                            Spacer()
                        }
                        HStack{
                            Text("\(mainVM.humidity) %")
                            Spacer()
                        }
                    }.block()
                Spacer()
                    VStack{
                        HStack{
                            Image(systemName: "hand.raised")
                            Text("Ощущается как").font(.system(size: 14))
                            Spacer()
                        }
                        HStack{
                            Text("\(Int(mainVM.feelsLike))°C")
                            Spacer()
                        }
                    }.block()
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
