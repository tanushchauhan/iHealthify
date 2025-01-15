//
//  ChartsView.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/15/25.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @StateObject var viewModel = ChartsViewModel()
    @State var selectedChart: ChartOptions = .oneWeek
    
    var body: some View {
        VStack {
            Text("Charts - Step Count")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ZStack {
                switch selectedChart {
                case .oneWeek:
                    VStack {
                        HistoricDataView(average: $viewModel.oneWeekAverage, total: $viewModel.oneWeekTotal).padding(.bottom, 10)
                        
                        Chart {
                            ForEach(viewModel.oneWeekChartData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                            }
                        }
                    }
                case .oneMonth:
                    VStack {
                        HistoricDataView(average: $viewModel.oneMonthAverage, total: $viewModel.oneMonthTotal).padding(.bottom, 10)
                        
                        Chart {
                            ForEach(viewModel.oneMonthChartData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                            }
                        }
                    }
                case .threeMonth:
                    VStack {
                        HistoricDataView(average: $viewModel.threeMonthAverage, total: $viewModel.threeMonthTotal).padding(.bottom, 10)
                        
                        Chart {
                            ForEach(viewModel.threeMonthsChartData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                            }
                        }
                    }
                case .yearToDate:
                    VStack {
                        HistoricDataView(average: $viewModel.ytdAverage, total: $viewModel.ytdTotal).padding(.bottom, 10)
                        
                        Chart {
                            ForEach(viewModel.ytdChartData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .month), y: .value("Steps", data.count))
                            }
                        }
                    }
                case .oneYear:
                    VStack {
                        HistoricDataView(average: $viewModel.oneYearAverage, total: $viewModel.oneYearTotal).padding(.bottom, 10)
                        
                        Chart {
                            ForEach(viewModel.oneYearChartData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .month), y: .value("Steps", data.count))
                            }
                        }
                    }
                }
            }
            .foregroundColor(.green)
            .frame(maxHeight: 450)
            .padding(.horizontal)
            
            HStack {
                ForEach(ChartOptions.allCases, id:\.rawValue) { option in
                    Button(option.rawValue) {
                        withAnimation {
                            selectedChart = option
                        }
                    }
                    .padding()
                    .foregroundColor(selectedChart == option ? .white : .green)
                    .background(selectedChart == option ? .green : .clear)
                    .cornerRadius(10)
                }
            }
        }
        .alert("Oops", isPresented: $viewModel.showAlert, actions: {
            Button(role: .cancel) {
                viewModel.showAlert = false
            } label: {
                Text("Ok")
            }
        }, message: {
            Text("We encountered an issue retrieving your step data. Please ensure that access is granted and try again.")
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ChartsView()
}
