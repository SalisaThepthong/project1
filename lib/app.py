# app.py
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from model import db, Subject,ContactGroup, ContactProfes  # นำเข้าโมเดลจาก models.py
from werkzeug.utils import secure_filename
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@127.0.0.1/thesis'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
#app.config['UPLOAD_FOLDER'] = 'path_to_upload_folder'
db.init_app(app)
migrate = Migrate(app, db)
CORS(app)

# API สำหรับเพิ่มข้อมูลวิชา
@app.route('/add_subject', methods=['POST'])
def add_subject():
    data = request.json
    new_id = 'C' + str(Subject.query.count() + 1).zfill(2)
    new_subject = Subject(
        id_Subjects=new_id,
        courseCode=data['courseCode'],
        name_Subjects=data['name_Subjects'],
        branchIT=data['branchIT'],
        branchCS=data['branchCS']
    )
    db.session.add(new_subject)
    db.session.commit()
    return jsonify({'message': 'Subject added successfully'}), 201

# API สำหรับแสดงข้อมูลวิชา
@app.route('/showCourse', methods=['GET'])
def show_courses():
    try:
        subjects = Subject.query.all()
        subjects_list = []

        for subject in subjects:
            branchIT_text = "IT" if subject.branchIT == 1 else ""
            branchCS_text = "CS" if subject.branchCS == 1 else ""

            if branchIT_text and branchCS_text:
                print("IT,CS")
            elif branchIT_text:
                print("IT")
            elif branchCS_text:
                print("CS")

            subjects_list.append({
                'id_Subjects': subject.id_Subjects,
                'courseCode': subject.courseCode,
                'name_Subjects': subject.name_Subjects,
                'branchIT': subject.branchIT,
                'branchCS': subject.branchCS
            })
            print(subjects_list)

        return jsonify(subjects_list)
    except Exception as e:
        print(f"Error occurred: {e}")
        return jsonify({'message': 'Internal server error'}), 500

# API สำหรับอัปเดตข้อมูลวิชา
@app.route('/update_subject/<string:subject_id>', methods=['PUT'])
def update_subject(subject_id):
    data = request.json
    subject = Subject.query.get(subject_id)
    if subject:
        subject.courseCode = data.get('courseCode', subject.courseCode)
        subject.name_Subjects = data.get('name_Subjects', subject.name_Subjects)
        subject.branchIT = data.get('branchIT', subject.branchIT)
        subject.branchCS = data.get('branchCS', subject.branchCS)
        db.session.commit()
        return jsonify({'message': 'Subject updated successfully'})
    else:
        return jsonify({'error': 'Subject not found'}), 404

# API สำหรับลบข้อมูลวิชา
@app.route('/delete_subject/<string:id>', methods=['DELETE'])
def delete_subject(id):
    subject = Subject.query.filter_by(courseCode=id).first()
    if not subject:
        return jsonify({'message': 'ไม่พบข้อมูลวิชาเรียน'}), 404

    try:
        db.session.delete(subject)
        db.session.commit()
        return jsonify({'message': 'ลบวิชาเรียนสำเร็จ!'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': 'เกิดข้อผิดพลาดในการลบข้อมูล'}), 500
#----------------------------------------------------------------------------------



def generate_group_id():
    count = ContactGroup.query.count()
    new_id = 'G' + str(count + 1).zfill(3)
    return new_id

def generate_member_id():
    count = ContactProfes.query.count()
    new_id = 'M' + str(count + 1).zfill(3)
    return new_id


@app.route('/add_group_and_members', methods=['POST'])
def add_group_and_members():
    data = request.json
    group_id = generate_group_id()
    group_number = data.get('group_number')
    group_name = data.get('group_name')

    # Create group without photo
    new_group = ContactGroup(
        id_Group=group_id,
        group_Number=group_number,
        group_Name=group_name
    )
    db.session.add(new_group)

    # Create members without photo
    members = data.get('members', [])
    for member in members:
        new_member = ContactProfes(
            id_Member=generate_member_id(),
            member_Prefix=member.get('member_prefix'),
            member_Name=member.get('member_name'),
            member_Lname=member.get('member_lname'),
            member_Email=member.get('member_email'),
            member_Facebook=member.get('member_facebook'),
            id_Group=group_id
        )
        db.session.add(new_member)

    try:
        db.session.commit()
        return jsonify({'message': 'Group and members added successfully'}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': str(e)}), 500



@app.route('/groups', methods=['GET'])
def get_groups():
    try:
        groups = ContactGroup.query.all()
        result = []
        for group in groups:
            members = ContactProfes.query.filter_by(id_Group=group.id_Group).all()
            member_list = [
                {
                    'id': member.id_Member,
                    'prefix': member.member_Prefix,
                    'name': member.member_Name,
                    'lastName': member.member_Lname,
                    'email': member.member_Email,
                    'facebook': member.member_Facebook
                }
                for member in members
            ]
            result.append({
                'id': group.id_Group,
                'name': group.group_Name,
                'members': member_list
            })
        return jsonify(result)
    except Exception as e:
        return jsonify({'message': str(e)}), 500






if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
