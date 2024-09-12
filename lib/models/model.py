# models.py
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import LargeBinary
db = SQLAlchemy()

class Subject(db.Model):
    __tablename__ = 'subject'
    
    id_Subjects = db.Column(db.String(10), primary_key=True)
    courseCode = db.Column(db.String(50), nullable=False)
    name_Subjects = db.Column(db.String(100), nullable=False)
    branchIT = db.Column(db.Integer, nullable=False)
    branchCS = db.Column(db.Integer, nullable=False)

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