class Contact {
  String name;
  String phone;
  String email;

  Contact({required this.name, required this.phone, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
