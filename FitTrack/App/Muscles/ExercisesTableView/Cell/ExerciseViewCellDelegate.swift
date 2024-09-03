//
//  ExerciseViewCellDelegate.swift
//  FitTrack
//
//  Created by Mariana Piz on 08.08.2024.
//

protocol ExerciseViewCellDelegate: AnyObject {
    func didTapCell(_ cell: ExerciseViewCell)
    func didTapMoreAbout(_ cell: ExerciseViewCell)
}
