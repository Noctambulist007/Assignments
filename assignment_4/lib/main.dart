import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const ExpandableListDemo(),
    );
  }
}

class Category {
  final String title;
  final IconData icon;
  final List<SubItem> items;
  bool isExpanded;

  Category({
    required this.title,
    required this.icon,
    required this.items,
    this.isExpanded = false,
  });
}

class SubItem {
  final String title;
  final String description;
  final int imageId; // For picsum.photos ID

  SubItem({
    required this.title,
    required this.description,
    required this.imageId,
  });
}

class ExpandableListDemo extends StatefulWidget {
  const ExpandableListDemo({Key? key}) : super(key: key);

  @override
  State<ExpandableListDemo> createState() => _ExpandableListDemoState();
}

class _ExpandableListDemoState extends State<ExpandableListDemo> {
  final List<Category> categories = [
    Category(
      title: 'Electronics',
      icon: Icons.devices,
      items: [
        SubItem(
          title: 'Smartphones',
          description: 'Latest mobile devices with cutting-edge technology',
          imageId: 1,
        ),
        SubItem(
          title: 'Laptops',
          description: 'Powerful computers for work and gaming',
          imageId: 2,
        ),
      ],
    ),
    Category(
      title: 'Fashion',
      icon: Icons.shopping_bag,
      items: [
        SubItem(
          title: 'Men\'s Wear',
          description: 'Trendy clothing for modern men',
          imageId: 3,
        ),
        SubItem(
          title: 'Women\'s Wear',
          description: 'Stylish clothing for contemporary women',
          imageId: 4,
        ),
      ],
    ),
    Category(
      title: 'Home & Living',
      icon: Icons.home,
      items: [
        SubItem(
          title: 'Furniture',
          description: 'Modern and classic furniture pieces',
          imageId: 5,
        ),
        SubItem(
          title: 'Decor',
          description: 'Beautiful decorations for your home',
          imageId: 6,
        ),
      ],
    ),
    Category(
      title: 'Sports',
      icon: Icons.sports_baseball,
      items: [
        SubItem(
          title: 'Equipment',
          description: 'Professional sports gear',
          imageId: 7,
        ),
        SubItem(
          title: 'Sportswear',
          description: 'Comfortable athletic clothing',
          imageId: 8,
        ),
      ],
    ),
    Category(
      title: 'Books',
      icon: Icons.book,
      items: [
        SubItem(
          title: 'Fiction',
          description: 'Engaging stories and novels',
          imageId: 9,
        ),
        SubItem(
          title: 'Non-Fiction',
          description: 'Educational and informative books',
          imageId: 10,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Store'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(
                    category.icon,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: category.items.map((item) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://picsum.photos/id/${item.imageId}/400/200',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _showMessage(
                                    'Viewing details for ${item.title}');
                              },
                              icon: const Icon(Icons.visibility),
                              label: const Text('View Details'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {
                                _showMessage('${item.title} added to cart');
                              },
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Add to Cart'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
