class CategoryModel {
  int? id;
  String name;
  String imageUrl;
  String selectedImageUrl;

  // 생성자
  CategoryModel({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.selectedImageUrl,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'selectedImageUrl': selectedImageUrl,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      selectedImageUrl: json['selectedImageUrl'],
    );
  }
}

class ProductModel {
  int? id;
  int categoryId;
  String name;
  int price;
  String imageUrl;
  String description;

  // 생성자
  ProductModel({
    this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      categoryId: json['categoryId'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }
}

class QuestionModel {
  int? id;
  String type;
  String title;
  String? answer;
  int? answerId;
  int isEnd;

  // 생성자
  QuestionModel({
    this.id,
    required this.type,
    required this.title,
    this.answer,
    this.answerId,
    required this.isEnd,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'answer': answer,
      'answerId': answerId,
      'isEnd': isEnd
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      answer: json['answer'],
      answerId: json['answerId'],
      isEnd: json['isEnd'],
    );
  }
}

class UserModel {
  int? id;
  String email;
  String password;
  String? nickname;
  String? imageUrl;

  // 생성자
  UserModel({
    this.id,
    required this.email,
    required this.password,
    this.nickname,
    this.imageUrl,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'nickname': nickname,
      'imageUrl': imageUrl,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      nickname: json['nickname'],
      imageUrl: json['imageUrl'],
    );
  }
}

class CartModel {
  int? id;
  int userId;
  int productId;
  int quantity;
  String? name, imageUrl;
  int? price, sumPrice;

  // 생성자
  CartModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.name,
    this.imageUrl,
    this.price,
    this.sumPrice,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'sumPrice': sumPrice,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      quantity: json['quantity'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      sumPrice: json['sumPrice'],
    );
  }
}

class SurveyModel {
  int? id;
  int userId;
  int productId;
  String name;
  int price;
  String imageUrl;
  String description;

  // 생성자
  SurveyModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }
}

class OrderModel {
  int? id;
  int? paymentId;
  int productId;
  int quantity;
  int price;

  // 생성자
  OrderModel({
    this.id,
    this.paymentId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paymentId': paymentId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      paymentId: json['paymentId'],
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}

class PaymentModel {
  int? id;
  int userId;
  String name;
  String phone;
  String address;
  String addressDetail;
  String deliveryMessage;
  int price;

  // 생성자
  PaymentModel({
    this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.addressDetail,
    required this.deliveryMessage,
    required this.price,
  });

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'addressDetail': addressDetail,
      'deliveryMessage': deliveryMessage,
      'price': price,
    };
  }

  // JSON 데이터를 Model객체로 변환하는 팩토리 생성자
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      addressDetail: json['addressDetail'],
      deliveryMessage: json['deliveryMessage'],
      price: json['price'],
    );
  }
}
