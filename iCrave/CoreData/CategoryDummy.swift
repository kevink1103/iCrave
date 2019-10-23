//
//  CategoryDummy.swift
//  iCrave
//
//  Created by Kevin Kim on 22/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation

func loadDummyCategories() {
    let categories = [
        "Food": "red",
        "Octopus": "orange",
        "Supermarket": "yellow",
        "School": "green",
        "Club": "blue",
        "Furniture": "purple",
        "Shopping": "pink",
        "Vacation": "teal",
        "Hobby": "indigo",
        "Gambling": "gray",
        "Secret": "black",
        "Charity": "white"
    ]
    for category in categories {
        Category.create(title: category.key, color: category.value)
    }
}
