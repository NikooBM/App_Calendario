import CoreML
import CreateML

class MLService {
    private var productivityModel: MLModel?
    
    func trainProductivityModel(with events: [Event]) async throws {
        let trainingData = events.map { event -> MLDataTable.Row in
            [
                "hourOfDay": Calendar.current.component(.hour, from: event.startDate),
                "dayOfWeek": Calendar.current.component(.weekday, from: event.startDate),
                "duration": event.endDate.timeIntervalSince(event.startDate),
                "category": event.category.rawValue,
                "energyLevel": 5 // Este dato vendría del feedback del usuario
            ]
        }
        
        let dataTable = try MLDataTable(rows: trainingData)
        let model = try MLRegressor(trainingData: dataTable, targetColumn: "energyLevel")
        self.productivityModel = try model.makeMLModel()
    }
    
    func predictEnergyLevel(for date: Date) -> Int {
        // Implementar predicción usando el modelo entrenado
        return 3
    }
} 