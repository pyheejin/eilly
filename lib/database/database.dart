import 'package:eilly/database/models.dart';
import 'package:eilly/widget/storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _db;
  static const _databaseName = 'eilly_db.db';

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), _databaseName);
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 유저 테이블 생성
    db.execute(
      '''
      CREATE TABLE IF NOT EXISTS user
        (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          email TEXT,
          password TEXT,
          nickname TEXT,
          imageUrl TEXT
        )
      ''',
    );

    // 카테고리 테이블 생성
    db.execute(
      '''
      CREATE TABLE IF NOT EXISTS category
        (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT,
          imageUrl TEXT,
          selectedImageUrl TEXT
        )
      ''',
    );

    // 카테고리 데이터 저장
    db.execute('''INSERT INTO category (name, imageUrl, selectedImageUrl)
                  VALUES ('전체',
                  'https://pilly.kr/images/store/concern/icon-total_off.png',
                  'https://pilly.kr/images/store/concern/icon-total_on.png')''');
    db.execute('''INSERT INTO category (name, imageUrl, selectedImageUrl)
                  VALUES ('눈건강',
                  'https://pilly.kr/images/store/concern/icon-ophthalmologic_off.png',
                  'https://pilly.kr/images/store/concern/icon-ophthalmologic_on.png')''');
    db.execute('''INSERT INTO category (name, imageUrl, selectedImageUrl)
                  VALUES ('면역력',
                  'https://pilly.kr/images/store/concern/icon-immune_function_off.png',
                  'https://pilly.kr/images/store/concern/icon-immune_function_on.png')''');
    db.execute('''INSERT INTO category (name, imageUrl, selectedImageUrl)
                  VALUES ('만성질환',
                  'https://pilly.kr/images/store/concern/icon-chronic_diseases_off.png',
                  'https://pilly.kr/images/store/concern/icon-chronic_diseases_on.png')''');
    db.execute('''INSERT INTO category (name, imageUrl, selectedImageUrl)
                  VALUES ('모발 / 두피',
                  'https://pilly.kr/images/store/concern/icon-hair_scalp_off.png',
                  'https://pilly.kr/images/store/concern/icon-hair_scalp_on.png')''');
    db.execute('''INSERT INTO category (name, imageUrl, selectedImageUrl)
                  VALUES ('피부',
                  'https://pilly.kr/images/store/concern/icon-skin_health_off.png',
                  'https://pilly.kr/images/store/concern/icon-skin_health_on.png')''');
    db.execute('''INSERT INTO category (name, imageUrl, selectedImageUrl)
                  VALUES ('위 / 소화',
                  'https://pilly.kr/images/store/concern/icon-stomache_off.png',
                  'https://pilly.kr/images/store/concern/icon-stomache_on.png')''');

    // 상품 테이블 생성
    db.execute(
      '''
      CREATE TABLE IF NOT EXISTS product 
        (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          categoryId INTEGER,
          name TEXT, 
          price INTEGER,
          imageUrl TEXT,
          description TEXT
        )
      ''',
    );

    // 상품 데이터 저장
    db.execute(
        '''INSERT INTO product (name, categoryId, price, imageUrl, description)
                  VALUES ('메가 프로폴리스 면역젤리', 13900, 3,
                  'https://img.pilly.kr/product/store/PDJWHTYK4379/product_01@3x.png?v=v202405101220?v=v202405101220',
                  '프로폴리스 젤리를 한번 더 업그레이드한 3.0버전으로 플라보노이드 함량은 2.35배 up 아연 2.55mg을 추가해 항산화, 구강항균, 정상면역 삼중 기능성 확보')''');

    db.execute(
        '''INSERT INTO product (name, categoryId, price, imageUrl, description)
                  VALUES ('루테인', 4, 10600,
                  'https://img.pilly.kr/product/store/PDVCBZUX4669/product_01@3x.png?v=v202405101220?v=v202405101220',
                  '필리 루테인은 인도 카르나타카에서 재배된 마리골드꽃추출물을 사용하고 어두운 곳에서 시각 적응을 위해 필요한 비타민A를 포함하여 우수한 품질관리를 통해 만들었습니다.')''');

    db.execute(
        '''INSERT INTO product (name, categoryId, price, imageUrl, description)
                  VALUES ('프레스샷', 3, 25700,
                  'https://img.pilly.kr/product/store/PDPTAVCZ7443/product_01@3x.png?v=v202405101220?v=v202405101220',
                  '어디서나 간편하게 섭취 가능하고 흡수가 빠른 액상 제형의 11중 기능성 올인원 영양 앰플')''');

    // 장바구니 테이블 생성
    db.execute(
      '''
      CREATE TABLE IF NOT EXISTS cart 
        (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          userId INTEGER,
          productId INTEGER,
          quantity INTEGER
        )
      ''',
    );

    // 주문 테이블 생성
    db.execute(
      '''
      CREATE TABLE IF NOT EXISTS 'order'
        (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          paymentId INTEGER,
          productId INTEGER,
          quantity INTEGER,
          price INTEGER
        )
      ''',
    );

    // 구매내역 테이블 생성
    db.execute(
      '''
      CREATE TABLE IF NOT EXISTS payment
        (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          userId INTEGER,
          name TEXT,
          phone INTEGER,
          address TEXT,
          addressDetail TEXT,
          deliveryMessage TEXT,
          price INTEGER
        )
      ''',
    );
  }

  Future<List<CategoryModel>> getCategories() async {
    Database db = await _database;
    List<Map<String, dynamic>> maps = await db.query(
      'category',
      columns: [
        'id',
        'name',
        'imageUrl',
        'selectedImageUrl',
      ],
    );
    return List<CategoryModel>.from(
      maps.map((map) => CategoryModel.fromJson(map)),
    );
  }

  Future<CategoryModel> getCategoryDetail(int categoryId) async {
    Database db = await _database;
    List<Map<String, dynamic>> maps = await db.query(
      'category',
      columns: [
        'id',
        'name',
        'imageUrl',
        'selectedImageUrl',
      ],
      where: 'id = ?',
      whereArgs: [categoryId],
    );
    return CategoryModel.fromJson(maps.first);
  }

  Future<List<ProductModel>> getProducts(int categoryId) async {
    Database db = await _database;

    String categoryFilter =
        'select * from product where categoryId >= $categoryId order by id desc;';

    if (categoryId > 1) {
      categoryFilter =
          'select * from product where categoryId = $categoryId order by id desc;';
    }

    List<Map<String, dynamic>> maps = await db.rawQuery(categoryFilter);

    return List<ProductModel>.from(
      maps.map((map) => ProductModel.fromJson(map)),
    );
  }

  Future<int> getProductCount(int categoryId) async {
    Database db = await _database;

    String categoryFilter =
        'select COUNT(*) as count from product where categoryId >= $categoryId order by id desc;';

    if (categoryId > 1) {
      categoryFilter =
          'select COUNT(*) as count from product where categoryId = $categoryId order by id desc;';
    }

    List<Map<String, dynamic>> maps = await db.rawQuery(categoryFilter);

    return maps.first['count'];
  }

  Future<ProductModel> getProductDetail(int productId) async {
    Database db = await _database;
    List<Map<String, dynamic>> maps = await db.query(
      'product',
      columns: [
        'id',
        'categoryId',
        'name',
        'price',
        'imageUrl',
        'description',
      ],
      where: 'id = ?',
      whereArgs: [productId],
    );
    return ProductModel.fromJson(maps.first);
  }

  Future<List<QuestionModel>> getQuestions() async {
    Database db = await _database;

    String sql = '''select q.id, q.type, q.title, a.title as answer, q.isEnd
                    from question q left outer join answer a
                    on q.id = a.questionId GROUP BY q.id order by q.id ASC''';

    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    return List<QuestionModel>.from(
      maps.map((map) => QuestionModel.fromJson(map)),
    );
  }

  Future<int> getQuestionCount() async {
    Database db = await _database;

    String sql = '''SELECT COUNT(*) as count FROM question;''';

    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return maps.first['count'];
  }

  Future<List<QuestionModel>> getQuestionDetail(int questionId) async {
    Database db = await _database;

    String sql = '''select q.id, q.type, q.title, 
                    a.title as answer, q.isEnd, a.id as answerId
                    from question q left outer join answer a
                    on q.id = a.questionId
                    where q.id = $questionId order by q.id ASC''';

    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    return List<QuestionModel>.from(
      maps.map((map) => QuestionModel.fromJson(map)),
    );
  }

  Future<UserModel> getUserDetail(int userId) async {
    Database db = await _database;
    List<Map<String, dynamic>> maps = await db.query(
      'user',
      columns: [
        'id',
        'email',
        'password',
        'nickname',
        'imageUrl',
      ],
      where: 'id = ?',
      whereArgs: [userId],
    );
    return UserModel.fromJson(maps.first);
  }

  Future<void> updateUserDetailNickname(int userId, String nickname) async {
    Database db = await _database;

    await db.update(
      'user',
      {'nickname': nickname},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<CartModel>> getCarts(int userId) async {
    Database db = await _database;

    String sql = '''select c.id, p.name, p.price, p.imageUrl, c.quantity, 
                    c.userId, c.productId, SUM(p.price*c.quantity) over() as sumPrice
                    from cart c inner join product p
                    on c.productId = p.id
                    where c.userId = $userId''';

    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    return List<CartModel>.from(
      maps.map((map) => CartModel.fromJson(map)),
    );
  }

  Future<int> getCartCount(int userId) async {
    Database db = await _database;

    String sql = '''select c.id, p.name, p.price, p.imageUrl, c.quantity, 
                    c.userId, c.productId, SUM(p.price) over() as sumPrice
                    from cart c inner join product p
                    on c.productId = p.id
                    where c.userId = $userId''';

    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return maps.length;
  }

  Future<void> insertCart(int userId, int productId) async {
    Database db = await _database;

    String sql = '''SELECT * FROM cart 
                    WHERE userId = $userId 
                    AND productId = $productId LIMIT 1''';
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    if (maps.isEmpty) {
      await db.insert(
        'cart',
        {
          'userId': userId,
          'productId': productId,
          'quantity': 1,
        },
      );
    } else {
      await db.update(
        'cart',
        {'quantity': maps.first['quantity'] + 1},
        where: 'userId = ? and productId = ?',
        whereArgs: [userId, productId],
      );
    }
  }

  Future<void> deleteCart(int userId, int productId) async {
    Database db = await _database;

    await db.delete(
      'cart',
      where: 'userId = ? and productId = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<void> deleteCartAll(int userId) async {
    Database db = await _database;

    await db.delete(
      'cart',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> increaseCartItem(int userId, int productId) async {
    Database db = await _database;

    String sql = '''SELECT * FROM cart 
                    WHERE userId = $userId 
                    AND productId = $productId LIMIT 1''';
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    await db.update(
      'cart',
      {'quantity': maps.first['quantity'] + 1},
      where: 'userId = ? and productId = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<void> decreaseCartItem(int userId, int productId) async {
    Database db = await _database;

    String sql = '''SELECT * FROM cart 
                    WHERE userId = $userId 
                    AND productId = $productId LIMIT 1''';
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    if (maps.first['quantity'] == 1) {
      await db.delete(
        'cart',
        where: 'userId = ? and productId = ?',
        whereArgs: [userId, productId],
      );
    } else {
      await db.update(
        'cart',
        {
          'quantity': maps.first['quantity'] - 1,
        },
        where: 'userId = ? and productId = ?',
        whereArgs: [userId, productId],
      );
    }
  }

  Future<List<SurveyModel>> getSurveyList(int userId) async {
    Database db = await _database;

    String sql =
        '''select s.id, p.name, p.price, s.userId, s.productId, p.description, p.imageUrl
                    from survey s inner join product p on s.productId = p.id
                    where s.userId = 1''';

    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    return List<SurveyModel>.from(
      maps.map((map) => SurveyModel.fromJson(map)),
    );
  }

  Future<void> insertSurvey(int userId) async {
    Database db = await _database;

    String sql = '''INSERT INTO survey (userId)
                    VALUES ($userId) RETURNING id''';
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    final surveyId = maps.first['id'];
    saveStorage('surveyId', surveyId.toString());
  }

  Future<int> insertSurveyResult(
      int surveyId, List<Map<String, dynamic>> results) async {
    Database db = await _database;

    for (var data in results) {
      if (data['answerId'] != null) {
        for (var answerId in data['answerId'].split(',')) {
          await db.insert(
            'survey_result',
            {
              'surveyId': surveyId,
              'questionId': data['questionId'],
              'answerId': answerId,
              'description': data['description'],
            },
          );
        }
      } else {
        await db.insert(
          'survey_result',
          {
            'surveyId': surveyId,
            'questionId': data['questionId'],
            'answerId': data['answerId'],
            'description': data['description'],
          },
        );
      }
    }

    // 추천 상품 저장
    String sql = '''SELECT a.categoryId, COUNT(a.categoryId) as count
                    FROM survey_result r
                    INNER JOIN survey s ON r.surveyId = s.id
                    INNER JOIN answer a ON a.id = r.answerId
                    WHERE s.id = 1
                    GROUP BY a.categoryId
                    ORDER BY count desc;''';
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    final categoryId = maps.first['categoryId'];

    String productSql =
        '''SELECT * FROM product WHERE categoryId = $categoryId''';
    List<Map<String, dynamic>> productMaps = await db.rawQuery(productSql);

    final productId = productMaps.first['id'];

    await db.update(
      'survey',
      {
        'productId': productId,
      },
      where: 'id = ?',
      whereArgs: [surveyId],
    );
    return productId;
  }

  // 주문
  Future<void> insertOrder(
      List<OrderModel> orders, PaymentModel payment) async {
    Database db = await _database;

    String sql =
        '''INSERT INTO payment (userId, name, phone, address, addressDetail, deliveryMessage, price)
            VALUES (${payment.userId}, '${payment.name}', '${payment.phone}', '${payment.address}', '${payment.addressDetail}', '${payment.deliveryMessage}', ${payment.price}) RETURNING id''';
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);

    final paymentId = maps.first['id'];

    for (var order in orders) {
      await db.insert(
        'order',
        {
          'paymentId': paymentId,
          'productId': order.productId,
          'quantity': order.quantity,
          'price': order.price,
        },
      );
    }

    // 완료 후 장바구니 상품 삭제
    await db.delete(
      'cart',
      where: 'userId = ?',
      whereArgs: [payment.userId],
    );
  }

  Future<List<Map<String, dynamic>>> getPaymentList(int userId) async {
    Database db = await _database;

    String sql = '''SELECT p.id, p.price, product.name, product.imageUrl, 
                    (SELECT COUNT(*) as count FROM 'order' WHERE paymentId = p.id) as count
                    FROM payment p 
                    INNER JOIN 'order' o on o.paymentId = p.id
                    INNER JOIN product on product.id = o.productId
                    WHERE p.userId = 1
                    GROUP BY p.id''';

    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return maps;
  }
}
