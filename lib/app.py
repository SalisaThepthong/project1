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


#ดูข้อมูลทั้งหมด
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
    
#ลบข้อมูลกลุ่ม
@app.route('/delete_group/<string:id_Group>', methods=['DELETE'])
def delete_group(id_Group):
    try:
        # ค้นหากลุ่มตาม id_Group
        group = ContactGroup.query.filter_by(id_Group=id_Group).first()

        if group is None:
            return jsonify({'message': 'กลุ่มไม่พบ'}), 404

        # ลบสมาชิกทั้งหมดที่เชื่อมโยงกับกลุ่ม
        members = ContactProfes.query.filter_by(id_Group=id_Group).all()
        for member in members:
            db.session.delete(member)

       
        db.session.flush()

        # ลบกลุ่ม
        db.session.delete(group)
        db.session.commit()

        return jsonify({'message': 'ลบกลุ่มและสมาชิกสำเร็จ'}), 200

    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({'message': str(e)}), 500

# ลบสมาชิก
@app.route('/delete_member/<string:id_Member>', methods=['DELETE'])
def delete_member(id_Member):
    try:
        # ค้นหาสมาชิกตาม id_Profes
        member = ContactProfes.query.filter_by(id_Member=id_Member).first()

        if member is None:
            return jsonify({'message': 'ไม่พบสมาชิก'}), 404

        # ลบสมาชิก
        db.session.delete(member)
        db.session.commit()

        return jsonify({'message': 'ลบสมาชิกสำเร็จ'}), 200

    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({'message': str(e)}), 500
    #แก้ไขข้อมูล
# @app.route('/update_group_and_members', methods=['PUT'])
# def update_group_and_members():
#     data = request.json
#     group_id = data.get('id_group')
#     group_number = data.get('group_number')
#     group_name = data.get('group_name')
    
#     # ตรวจสอบว่ากลุ่มมีอยู่หรือไม่
#     group = ContactGroup.query.filter_by(id_Group=group_id).first()
#     if not group:
#         return jsonify({'message': 'Group not found'}), 404

#     # อัพเดตข้อมูลกลุ่ม
#     group.group_Number = group_number
#     group.group_Name = group_name

#     # อัพเดตสมาชิก
#     members = data.get('members', [])
#     for member in members:
#         existing_member = ContactProfes.query.filter_by(id_Member=member.get('id_member')).first()
#         if existing_member:
#             existing_member.member_Prefix = member.get('member_prefix')
#             existing_member.member_Name = member.get('member_name')
#             existing_member.member_Lname = member.get('member_lname')
#             existing_member.member_Email = member.get('member_email')
#             existing_member.member_Facebook = member.get('member_facebook')
#         else:
#             new_member = ContactProfes(
#                 id_Member=generate_member_id(),
#                 member_Prefix=member.get('member_prefix'),
#                 member_Name=member.get('member_name'),
#                 member_Lname=member.get('member_lname'),
#                 member_Email=member.get('member_email'),
#                 member_Facebook=member.get('member_facebook'),
#                 id_Group=group_id
#             )
#             db.session.add(new_member)

#     try:
#         db.session.commit()
#         return jsonify({'message': 'Group and members updated successfully'}), 200
#     except Exception as e:
#         db.session.rollback()
#         return jsonify({'message': str(e)}), 500
    # API สำหรับแก้ไขข้อมูลกลุ่ม
@app.route('/update_group/<id_group>', methods=['PUT'])
def update_group(id_group):
    data = request.json
    group = ContactGroup.query.filter_by(id_Group=id_group).first()
    
    if not group:
        return jsonify({'message': 'Group not found'}), 404

    group.group_Number = data.get('group_Number', group.group_Number)
    group.group_Name = data.get('group_Name', group.group_Name)

    db.session.commit()
    return jsonify({'message': 'Group updated successfully'}), 200

# API สำหรับแก้ไขข้อมูลสมาชิก
@app.route('/update_member/<id_member>', methods=['PUT'])
def update_member(id_member):
    data = request.json
    member = ContactProfes.query.filter_by(id_Member=id_member).first()
    
    if not member:
        return jsonify({'message': 'Member not found'}), 404

    member.member_Prefix = data.get('member_Prefix', member.member_Prefix)
    member.member_Name = data.get('member_Name', member.member_Name)
    member.member_Lname = data.get('member_Lname', member.member_Lname)
    member.member_Email = data.get('member_Email', member.member_Email)
    member.member_Facebook = data.get('member_Facebook', member.member_Facebook)
    member.id_Group = data.get('id_Group', member.id_Group)

    db.session.commit()
    return jsonify({'message': 'Member updated successfully'}), 200
#get เรียกกลุ่มมาshow ในหน้า edit
@app.route('/get_group/<string:group_id>', methods=['GET'])
def get_group(group_id):
    try:
        # ดึงข้อมูลกลุ่มตาม id_Group
        group = ContactGroup.query.filter_by(id_Group=group_id).first()
        if not group:
            return jsonify({'message': 'Group not found'}), 404

        # ส่งข้อมูลในรูปแบบ JSON
        group_data = {
            'group_Number': group.group_Number,
            'group_Name': group.group_Name
        }
        return jsonify(group_data), 200

    except Exception as e:
        print(f"Error fetching group: {str(e)}")
        return jsonify({'message': 'An error occurred while fetching group data'}), 500



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
