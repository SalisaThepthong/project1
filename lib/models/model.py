# models.py
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import LargeBinary
db = SQLAlchemy()
from werkzeug.security import generate_password_hash, check_password_hash
class Subject(db.Model):
    __tablename__ = 'subject'
    
    id_Subjects = db.Column(db.String(10), primary_key=True)
    courseCode = db.Column(db.String(50), nullable=False)
    name_Subjects = db.Column(db.String(100), nullable=False)
    branchIT = db.Column(db.Integer, nullable=False)
    branchCS = db.Column(db.Integer, nullable=False)
    yearCourseSub = db.Column(db.String(5), nullable=False)

    def __repr__(self):
        return f'<Subject {self.id_Subjects} - {self.courseCode}>'


class ContactGroup(db.Model):
    id_Group = db.Column(db.String(10), primary_key=True)
    group_Number = db.Column(db.String(50))
    group_Name = db.Column(db.String(100))
    # Remove group_Photo column

class ContactProfes(db.Model):
    id_Member = db.Column(db.String(10), primary_key=True)
    member_Prefix = db.Column(db.String(10))
    member_Name = db.Column(db.String(50))
    member_Lname = db.Column(db.String(50))
    member_Email = db.Column(db.String(100))
    member_Facebook = db.Column(db.String(100))
    # Remove member_Photo column
    id_Group = db.Column(db.String(10), db.ForeignKey('contact_group.id_Group'))



    def __repr__(self):
        return f'<ContactProfes {self.id_Member} - {self.member_Name} {self.member_Lname}>'
    

class User(db.Model):
    __tablename__ = 'users'
    
    id_User = db.Column(db.String(10), primary_key=True)
    prefix = db.Column(db.String(10), nullable=False)         # คำนำหน้าชื่อ เช่น นาย, นาง, นางสาว
    first_name = db.Column(db.String(50), nullable=False)      # ชื่อ
    last_name = db.Column(db.String(50), nullable=False)       # นามสกุล
    email = db.Column(db.String(100), unique=True, nullable=False)  # อีเมล (unique)
    password = db.Column(db.String(255), nullable=False)       # รหัสผ่าน (เข้ารหัส)
    role = db.Column(db.String(50), nullable=False)            # บทบาท เช่น แอดมิน, อาจารย์, นักศึกษา
    created_at = db.Column(db.DateTime, server_default=db.func.now())  # วันที่สร้างข้อมูล
    def __repr__(self):
        return f'<User {self.id_User} - {self.prefix} {self.first_name} {self.last_name}>'


    # ฟังก์ชันเข้ารหัสรหัสผ่าน
    def set_password(self, password):
        self.password = generate_password_hash(password)

    # ฟังก์ชันตรวจสอบรหัสผ่าน
    
    #id_User.set_password('melivecode')  # รหัสผ่านจะถูกแปลงเป็น hash ก่อนบันทึกลงฐานข้อมูล

    # ฟังก์ชันตรวจสอบรหัสผ่าน
    def check_password(self, password):
        return check_password_hash(self.password, password)

    # ฟังก์ชันแปลง object ให้เป็น dictionary เพื่อง่ายต่อการแสดงผล
    def to_dict(self):
        return {
            'id_User': self.id_User,
            'prefix': self.prefix,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'email': self.email,
            'role': self.role,
            'created_at': self.created_at
        }


# class GroupProject(db.Model):
#     __tablename__ = 'groupproject'

#     idGroupProject = db.Column(db.String(10), primary_key=True)
#     project_Code = db.Column(db.String(50), nullable=False)
#     name_Project_TH = db.Column(db.String(255), nullable=False)
#     name_Project_EN = db.Column(db.String(255), nullable=False)
#     CS_IT05D = db.Column(db.LargeBinary, nullable=False)  # ใช้ LargeBinary สำหรับ BLOB

#     def __repr__(self):
#         return f'<GroupProject {self.idGroupProject} - {self.project_Code}>'

# # from flask_sqlalchemy import SQLAlchemy

# # db = SQLAlchemy()

# class Students(db.Model):
#     __tablename__ = 'students'

#     id_Students = db.Column(db.String(50), primary_key=True)
#     code_Student = db.Column(db.String(50), nullable=False)
#     educationSector = db.Column(db.String(100), nullable=False)
#     year = db.Column(db.Integer, nullable=False)
#     branch = db.Column(db.String(100), nullable=False)
#     yearCourse = db.Column(db.Integer, nullable=False)
#     overall_Grade = db.Column(db.Numeric(3, 2), nullable=False)
#     id_User = db.Column(db.String(10), db.ForeignKey('users.id_User'), nullable=True)
#     id_Member = db.Column(db.String(10), db.ForeignKey('contactprofes.id_Member'), nullable=True)
#     idGroupProject = db.Column(db.Integer, db.ForeignKey('groupproject.idGroupProject'), nullable=True)

#     def __repr__(self):
#         return f'<Students {self.id_Students} - {self.code_Student}>'
