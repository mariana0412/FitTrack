//
//  MusclesViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

class MusclesViewModel {
    
    let navigationBarTitle = "Muscles"
    let navigationBarRightButtonTitle = "Reset"
    let moreAboutButtonTitle = "More about  \u{2192}"
    
    var muscleGroups: [MuscleGroup] = []
    
    private var coordinator: MusclesCoordinator?
    
    init(coordinator: MusclesCoordinator?) {
        self.coordinator = coordinator
    }
    
    func loadExercises(completion: @escaping () -> Void) {
        JsonUtils.decode(fileName: "Exercises", type: [MuscleGroup].self) { [weak self] muscleGroups in
            self?.muscleGroups = muscleGroups ?? []
            completion()
        }
    }
}
