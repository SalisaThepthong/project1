# models.py
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import LargeBinary
db = SQLAlchemy()
from werkzeug.security import generate_password_hash, check_password_hash
class Subject(db.Model):
    __tablename__ = 'subject' # ชื่อตาราง ในฐานข้อมูล
    
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
    __tablename__ = 'contact_profes'

    id_Member = db.Column(db.String(10), primary_key=True)
    member_Email = db.Column(db.String(100), nullable=True)
    member_Facebook = db.Column(db.String(100), nullable=True)

    # Foreign Keys
    id_Group = db.Column(db.String(10), db.ForeignKey('contact_group.id_Group'), nullable=False)
    id_User = db.Column(db.String(10), db.ForeignKey('users.id_User'), nullable=False)

    # Relationships
    group = db.relationship('ContactGroup', backref=db.backref('members', lazy=True))
    user = db.relationship('User', backref=db.backref('members', lazy=True))

    def __repr__(self):

        return f'<ContactProfes {self.id_Member} - {self.member_Email}>'


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

    # Relationships
    students = db.relationship('Students', back_populates='user')
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

# โมเดลสำหรับตาราง GroupProject
class GroupProject(db.Model):
    __tablename__ = 'groupproject' # ชื่อตาราง ในฐานข้อมูล
    
    id_GroupProject = db.Column(db.String(10), primary_key=True)
    project_Code = db.Column(db.String(50), nullable=True)
    name_Project_TH = db.Column(db.String(255), nullable=True)
    name_Project_EN = db.Column(db.String(255), nullable=True)
    CS_IT05D = db.Column(db.LargeBinary, nullable=True)  # BLOB สำหรับเก็บไฟล์ PDF

    students = db.relationship("Students", back_populates="group_project")

# โมเดลสำหรับตาราง Students
class Students(db.Model): 
    __tablename__ = 'students'
    
    # คอลัมน์
    id_Students = db.Column(db.String(10), primary_key=True)
    prefix = db.Column(db.String(10), nullable=False)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    code_Student = db.Column(db.String(10), nullable=False)
    educationSector = db.Column(db.String(10), nullable=False)
    year = db.Column(db.Integer, nullable=False)
    branch = db.Column(db.String(100), nullable=False)
    yearCourse = db.Column(db.Integer, nullable=False)
    overall_Grade = db.Column(db.Numeric(3, 2), nullable=True)
    
    id_User = db.Column(db.String(10), db.ForeignKey('users.id_User'), nullable=False)
    id_GroupProject = db.Column(db.String(10), db.ForeignKey('groupproject.id_GroupProject'))  # ForeignKey ที่ถูกต้อง

    # ความสัมพันธ์
    user = db.relationship("User", back_populates="students")
    group_project = db.relationship("GroupProject", back_populates="students")
    
    # Constructor ที่รองรับ id_group_project
    def __init__(self, id_Students, prefix, first_name, last_name, code_Student, educationSector, year, branch, yearCourse, id_User, id_group_project):
        self.id_Students = id_Students
        self.prefix = prefix
        self.first_name = first_name
        self.last_name = last_name
        self.code_Student = code_Student
        self.educationSector = educationSector
        self.year = year
        self.branch = branch
        self.yearCourse = yearCourse
        self.id_User = id_User
        self.id_group_project = id_group_project
