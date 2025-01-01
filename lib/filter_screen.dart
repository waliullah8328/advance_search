import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'filter_controller.dart';

class FilterScreen extends StatelessWidget {
  final FilterController controller = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Filter"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Field
                TextFormField(
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Search Courses",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),

                // Sort By Dropdown
                const Text(
                  "Sort By",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: controller.selectedSortOrder.value.isEmpty
                      ? null
                      : controller.selectedSortOrder.value,
                  hint: const Text("Select Sort Order"),
                  isExpanded: true,
                  items: [
                    "Low to High",
                    "High to Low",
                    "Rating (High to Low)"
                  ].map((sortOption) {
                    return DropdownMenuItem<String>(
                      value: sortOption,
                      child: Text(sortOption),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedSortOrder.value = value ?? '';
                  },
                ),
                const SizedBox(height: 24),

                // Category Filter
                const Text(
                  "Select Categories",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.courses
                      .map((course) => course.category)
                      .toSet()
                      .map((category) {
                    final isSelected =
                    controller.selectedCategories.contains(category);
                    return GestureDetector(
                      onTap: () {
                        controller.toggleCategorySelection(category);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Language Filter
                const Text(
                  "Select Language",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: controller.courses
                      .map((course) => course.language)
                      .toSet()
                      .map((language) {
                    return RadioListTile<String>(
                      value: language,
                      groupValue: controller.selectedLanguage.value,
                      onChanged: (value) {
                        controller.selectedLanguage.value = value ?? '';
                      },
                      title: Text(language),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Price Range Filter
                const Text(
                  "Select Price Range",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    RangeSlider(
                      values: controller.priceRange.value,
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      labels: RangeLabels(
                        "\$${controller.priceRange.value.start.toStringAsFixed(0)}",
                        "\$${controller.priceRange.value.end.toStringAsFixed(0)}",
                      ),
                      onChanged: (range) {
                        controller.priceRange.value = range;
                      },
                    ),
                    Text(
                      "Price: \$${controller.priceRange.value.start.toStringAsFixed(0)} - \$${controller.priceRange.value.end.toStringAsFixed(0)}",
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Apply Filters Button
                ElevatedButton(
                  onPressed: () {
                    controller.applyFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text("Apply Filters"),
                ),
                const SizedBox(height: 24),

                // Filtered Courses List
                if (controller.filteredCourses.isEmpty)
                  const Center(child: Text("No courses match the filters"))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = controller.filteredCourses[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            course.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(course.title),
                          subtitle: Text(
                              "${course.category} | \$${course.price.toStringAsFixed(2)} | ${course.rating}★"),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${course.duration} hrs"),
                              Text("${course.lessons} lessons"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
