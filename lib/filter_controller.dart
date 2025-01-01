import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'filter_model.dart';

class FilterController extends GetxController {
  var searchQuery = ''.obs; // Search query
  var selectedCategories = <String>[].obs; // Selected categories
  var selectedLanguage = ''.obs; // Selected language
  var selectedSortOrder = ''.obs; // Sort order
  var priceRange = RangeValues(0, 1000).obs; // Price range filter

  // Mock course data
  List<Course> courses = [
    Course(
      title: "Flutter Development",
      imageUrl: "https://example.com/flutter-course.jpg",
      category: "Technology",
      price: 199.99,
      language: "English",
      rating: 4.5,
      duration: 30,
      lessons: 20,
    ),
    Course(
      title: "Business Management",
      imageUrl: "https://example.com/business-course.jpg",
      category: "Business",
      price: 299.99,
      language: "English",
      rating: 4.8,
      duration: 40,
      lessons: 25,
    ),
    Course(
      title: "Health & Wellness",
      imageUrl: "https://example.com/health-course.jpg",
      category: "Health",
      price: 99.99,
      language: "Spanish",
      rating: 4.2,
      duration: 20,
      lessons: 15,
    ),
    Course(
      title: "French Language Mastery",
      imageUrl: "https://example.com/french-course.jpg",
      category: "Education",
      price: 149.99,
      language: "French",
      rating: 4.7,
      duration: 35,
      lessons: 18,
    ),
  ];

  var filteredCourses = <Course>[].obs; // Filtered courses

  void toggleCategorySelection(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  void applyFilters() {
    var tempCourses = courses;

    // Filter by search query (title)
    if (searchQuery.value.isNotEmpty) {
      tempCourses = tempCourses.where((course) {
        final query = searchQuery.value.toLowerCase();
        return course.title.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by categories
    if (selectedCategories.isNotEmpty) {
      tempCourses = tempCourses
          .where((course) => selectedCategories.contains(course.category))
          .toList();
    }

    // Filter by language
    if (selectedLanguage.value.isNotEmpty) {
      tempCourses = tempCourses
          .where((course) => course.language == selectedLanguage.value)
          .toList();
    }

    // Filter by price range
    tempCourses = tempCourses.where((course) {
      return course.price >= priceRange.value.start &&
          course.price <= priceRange.value.end;
    }).toList();

    // Sort courses
    switch (selectedSortOrder.value) {
      case "Low to High":
        tempCourses.sort((a, b) => a.price.compareTo(b.price));
        break;
      case "High to Low":
        tempCourses.sort((a, b) => b.price.compareTo(a.price));
        break;
      case "Rating (High to Low)":
        tempCourses.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    filteredCourses.value = tempCourses;
  }
}
