import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://localhost:8001/products';

class ApiService extends StatefulWidget {
  const ApiService({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ApiService();
  }
}

class _ApiService extends State<ApiService> {
  List<dynamic> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // ฟังก์ชันดึงข้อมูลสินค้า
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      setState(() {
        productList = json.decode(response.body);
      });
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลสินค้าได้');
    }
  }

  // ฟังก์ชันสำหรับเพิ่มสินค้า
  void addProduct(String name, double price, String description) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      fetchProducts(); // รีเฟรชข้อมูลสินค้า
      Navigator.pop(context); // ปิดหน้าฟอร์ม
    } else {
      throw Exception('ไม่สามารถเพิ่มสินค้าได้');
    }
  }

  // ฟังก์ชันสำหรับแก้ไขสินค้า
  void editProduct(
      String id, String name, double price, String description) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      fetchProducts(); // รีเฟรชข้อมูลสินค้า
      Navigator.pop(context); // ปิดหน้าฟอร์ม
    } else {
      throw Exception('ไม่สามารถแก้ไขสินค้าได้');
    }
  }

  // ฟังก์ชันสำหรับลบสินค้า
  void deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      fetchProducts(); // รีเฟรชข้อมูลสินค้า
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ลบสินค้าสำเร็จ')));
    } else {
      throw Exception('ไม่สามารถลบสินค้าได้');
    }
  }

  // ฟังก์ชันที่เปิดฟอร์มเพิ่มสินค้า
  void showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('เพิ่มสินค้าใหม่'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'ราคา'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'คำอธิบาย'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิดฟอร์ม
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;
                final description = descriptionController.text;
                addProduct(name, price, description);
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันที่เปิดฟอร์มแก้ไขสินค้า
  void showEditProductDialog(String id, String currentName, double currentPrice,
      String currentDescription) {
    final nameController = TextEditingController(text: currentName);
    final priceController =
        TextEditingController(text: currentPrice.toString());
    final descriptionController =
        TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('แก้ไขสินค้า'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'ราคา'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'คำอธิบาย'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิดฟอร์ม
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;
                final description = descriptionController.text;
                editProduct(id, name, price, description);
              },
              child: Text('บันทึกการเปลี่ยนแปลง'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันแสดงกล่องยืนยันการลบ
  void showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการลบสินค้า'),
          content: Text('คุณแน่ใจว่าจะลบสินค้านี้?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิดกล่องยืนยัน
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                deleteProduct(id); // ลบสินค้า
                Navigator.pop(context); // ปิดกล่องยืนยัน
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Product List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: productList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                var product = productList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    leading:
                        Icon(Icons.shopping_cart, color: Colors.blue, size: 30),
                    title: Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ราคา: \$${product['price']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'คำอธิบาย: ${product['description']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            showEditProductDialog(
                              product['id'].toString(),
                              product['name'],
                              product['price'],
                              product['description'],
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDeleteConfirmationDialog(
                                product['id'].toString());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddProductDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        tooltip: 'เพิ่มสินค้า',
      ),
    );
  }
}
