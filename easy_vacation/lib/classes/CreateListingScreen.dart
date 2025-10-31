import 'package:easy_vacation/shared/colors.dart';
import 'package:easy_vacation/shared/shared_styles.dart';
import 'package:easy_vacation/styles/CreateListingStyles.dart';
import 'package:easy_vacation/styles/RegistrationStyles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateListing extends StatefulWidget {
  const CreateListing({super.key});

  @override
  State<CreateListing> createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> options = ['Stay', 'Activity', 'Vehicle'];
  String? selectedOption = 'Stay';

  void radio_function(String? val) {
    setState(() {
      selectedOption = val!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              screen_title('Create New Listing'),
              space(30),

              // 🖼️ Add Photos Section
              header2('Add Photos'),
              space(10),
              Center(
                child: InkWell(
                  onTap: () {
                    // TODO: Implement photo upload
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: grey.withOpacity(0.5)),
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      color: Colors.grey,
                      size: 45,
                    ),
                  ),
                ),
              ),

              space(30),

              // 🏷️ What are you listing
              header2('What are you listing?'),
              space(10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: options.map((option) {
                  final isSelected = selectedOption == option;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      style: radio_button_style(isSelected),
                      onPressed: () => setState(() => selectedOption = option),
                      child: Text(option, style: const TextStyle(fontSize: 18)),
                    ),
                  );
                }).toList(),
              ),

              space(30),

              // 🧾 Form Fields
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: input_decor('Title', const Icon(Icons.title)),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please add a title'
                              : null,
                    ),
                    space(20),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: input_decor(
                        'Description',
                        const Icon(Icons.description_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please add a description'
                              : null,
                    ),
                    space(20),

                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: input_decor(
                        'Price',
                        const Icon(Icons.attach_money_rounded),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please add a price'
                              : null,
                    ),
                    space(20),

                    TextFormField(
                      controller: _locationController,
                      decoration: input_decor(
                        'Location',
                        const Icon(Icons.map_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Please pin a location'
                              : null,
                    ),
                    space(40),
                  ],
                ),
              ),

              // 💳 Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: login_button_style.copyWith(
                    minimumSize:
                        MaterialStateProperty.all(const Size(0, 55)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Navigate to payment
                    }
                  },
                  child: Text(
                    'Continue To Payment',
                    style: login_text_style,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
