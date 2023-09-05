class User {
  final String fullName;
  final String email;
  final String dob;
  final String passwrd;
  final double weight;
  final double height;

  User({
    required this.fullName,
    required this.email,
    required this.passwrd,
    required this.dob,
    required this.weight,
    required this.height,
  });

  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database table.
  Map<String, dynamic> toMap() {
    return {
      'fullname': fullName,
      'email': email,
      'passwrd': passwrd,
      'dob': dob,
      'weight': weight,
      'height': height,
    };
  }

  // Convert a Map into a User. The Map must contain all of the fields as keys.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fullName: map['fullname'],
      email: map['email'],
      passwrd: map['passwrd'],
      dob: map['dob'],
      weight: map['weight'],
      height: map['height'],
    );
  }

  // Override the toString method to return a custom string representation
  @override
  String toString() {
    return "User:{fullname: $fullName, email: $email, password: $passwrd, dob: $dob, weight: $weight, height: $height}\n";
  }
}
