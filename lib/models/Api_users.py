from flask import Blueprint, request, jsonify
from model import db, User
from werkzeug.security import check_password_hash
import jwt
import datetime
Users_blueprint = Blueprint('users', __name__)

@Users_blueprint.route('/register', methods=['POST'])
def register():
    data = request.json
    new_id = 'R' + str(User.query.count() + 1).zfill(2)  # สร้างรหัสผู้ใช้

    # สร้างผู้ใช้ใหม่จากข้อมูลที่ได้รับ
    new_user = User(
        id_User=new_id,
        prefix=data['prefix'],
        first_name=data['first_name'],
        last_name=data['last_name'],
        email=data['email'],
        role=data['role']
    )

    # เข้ารหัสรหัสผ่านก่อนบันทึก
    new_user.set_password(data['password'])  # ตรงนี้คือการเข้ารหัสรหัสผ่านที่รับมาจาก request

    # ตรวจสอบว่า email ซ้ำหรือไม่
    if User.query.filter_by(email=data['email']).first():
        return jsonify({'message': 'อีเมลนี้ถูกใช้ไปแล้ว'}), 400

    try:
        # บันทึกผู้ใช้ลงฐานข้อมูล
        db.session.add(new_user)
        db.session.commit()
        return jsonify({'message': 'สมัครสมาชิกสำเร็จ', 'user': new_user.to_dict()}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': 'เกิดข้อผิดพลาดในการสมัครสมาชิก', 'error': str(e)}), 500


SECRET_KEY = 'your_secret_key'

@Users_blueprint.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data.get('username')
    password = data.get('password')
    expires_in = data.get('expiresIn', 60000)  # ค่าดีฟอลต์คือ 60000 ms (60 วินาที)

    # ตรวจสอบว่ามีการกรอก username และ password มาหรือไม่
    if not username or not password:
        return jsonify({"status": "error", "message": "Missing username and/or password"}), 400

    # ค้นหาผู้ใช้จากฐานข้อมูลโดยใช้ email (username)
    user = User.query.filter_by(email=username).first()

    # ตรวจสอบรหัสผ่าน
    if user and user.check_password(password):
        # สร้าง JWT token
        expiration_time = datetime.datetime.utcnow() + datetime.timedelta(milliseconds=expires_in)
        token = jwt.encode({
            'id': user.id_User,
            'exp': expiration_time
        }, SECRET_KEY, algorithm='HS256')

        return jsonify({
            "status": "ok",
            "message": "Logged in",
            "accessToken": token,
            "expiresIn": expires_in,
            "user": {
                "id": user.id_User,
                "fname": user.first_name,
                "lname": user.last_name,
                "username": user.email,
                "email": user.email,
                #"avatar": "https://www.example.com/users/{}.png".format(user.id_User)  # รูปประจำตัว
                "role": user.role
            }
        }), 200

    # ถ้ารหัสผ่านไม่ถูกต้อง
    return jsonify({"status": "error", "message": "Login failed"}), 401