import 'package:flutter/material.dart';

class FarmerUploadProducePage extends StatefulWidget {
  const FarmerUploadProducePage({super.key});

  @override
  _FarmerUploadProducePageState createState() => _FarmerUploadProducePageState();
}

class _FarmerUploadProducePageState extends State<FarmerUploadProducePage> {
  // Add state variables and controllers here later
  final TextEditingController _produceNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _selectedFrequency = 'Daily'; // Default selection
  String _receiveMessages = 'Yes'; // Default selection

  @override
  void dispose() {
    _produceNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is handled by FarmerHomePage
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Produce Name Input
            Text('Produce Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _produceNameController,
              decoration: InputDecoration(
                hintText: 'Enter produce name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            SizedBox(height: 16),

            // Description Input
            Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            SizedBox(height: 16),

            // Price Input
            Text('Price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter the weight in KG',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            SizedBox(height: 16),

            // Upload Image Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement image upload logic
                },
                icon: Icon(Icons.cloud_upload_outlined, color: Colors.black87), // Upload icon
                label: Text(
                  'Upload Image',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.orange[300] // Example button color
                ),
              ),
            ),
            SizedBox(height: 24),

            // Select Harvest Frequency
            Text('Select harvest frequency', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines of chips
              children: <Widget>[
                _buildFrequencyButton('Daily'),
                _buildFrequencyButton('Weekly'),
                _buildFrequencyButton('Bi-weekly'),
                _buildFrequencyButton('Monthly'),
                _buildFrequencyButton('Seasonal'),
                _buildFrequencyButton('Once'),
                _buildFrequencyButton('As needed'),
              ],
            ),
             SizedBox(height: 24),

            // Specify (Notifications/Delivery Time)
            Text('Specify', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 // Low Stock
                 Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.calendar_today, size: 30, color: Colors.orange[700]),
                      ),
                      SizedBox(height: 4),
                      Text('Low Stock', style: TextStyle(fontSize: 12))
                    ],
                 ),
                 // Restock Alert
                 Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.notifications_none, size: 30, color: Colors.black87), // Bell icon
                      ),
                       SizedBox(height: 4),
                       Text('Restock Alert', style: TextStyle(fontSize: 12))
                    ],
                 ),
                 // Delivery Time
                 Column(
                    children: [
                       Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.access_time, size: 30, color: Colors.black87), // Clock icon
                      ),
                      SizedBox(height: 4),
                      Text('Delivery Time', style: TextStyle(fontSize: 12))
                    ],
                 ),
              ],
            ),
            SizedBox(height: 16),
            // Delivery Time Slider (Placeholder)
            Text('Set duration for delivery', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
               children: [
                  Expanded(
                    child: Slider(
                      value: 30, // Placeholder value
                      min: 0,
                      max: 120,
                      divisions: 120,
                      label: '30 mins', // Placeholder label
                      onChanged: (double value) {
                        // TODO: Implement slider logic
                      },
                       activeColor: Colors.orange,
                        inactiveColor: Colors.orange[100],
                    ),
                  ),
                  Text('30 mins', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Placeholder label
               ],
            ),

            SizedBox(height: 24),

            // Receive client messages?
            Text('Receive client messages?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                _buildMessagePreferenceButton('Yes'),
                SizedBox(width: 16),
                _buildMessagePreferenceButton('No'),
              ],
            ),
            SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement submit logic
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
                 style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.orange[700] // Example button color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyButton(String text) {
    final isSelected = _selectedFrequency == text;
    return ChoiceChip(
      label: Text(text),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFrequency = text;
          });
        }
      },
       selectedColor: Colors.orange[700],
        backgroundColor: Colors.grey[300],
         labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
         elevation: 1,
    );
  }

   Widget _buildMessagePreferenceButton(String text) {
    final isSelected = _receiveMessages == text;
    return ChoiceChip(
      label: Text(text),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _receiveMessages = text;
          });
        }
      },
       selectedColor: Colors.grey[700],
        backgroundColor: Colors.grey[300],
         labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
         elevation: 1,
    );
  }

} 