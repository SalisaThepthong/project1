from sqlite3 import IntegrityError
from flask import Blueprint, request, jsonify
from model import Students, db, GroupProject

students_blueprint = Blueprint('students', __name__)



@students_blueprint.route('/add_group_and_student', methods=['POST'])
def add_group_and_student():
    data = request.get_json()

    # ตรวจสอบว่ามีข้อมูลที่จำเป็นหรือไม่
    if 'students' not in data or len(data['students']) < 1:
        return jsonify({'message': 'Error: At least one student is required.'}), 400

    try:
        # สร้างกลุ่มใหม่สำหรับนักเรียน
        new_group_id = 'GP' + str(GroupProject.query.count() + 1).zfill(2)  # สร้างรหัสกลุ่มโครงการใหม่

        # สร้างกลุ่มโปรเจกต์
        new_group = GroupProject(id_GroupProject=new_group_id)

        db.session.add(new_group)  # เพิ่มกลุ่มโปรเจกต์
        db.session.flush()  # เพื่อให้ได้ id_GroupProject ที่ถูกต้อง

        for student_data in data['students']:
            # สร้างรหัสนักเรียนใหม่
            new_student_id = 'S' + str(Students.query.count() + 1).zfill(2)  # สร้างรหัสนักเรียนใหม่

            # เพิ่มนักเรียนลงในกลุ่มที่สร้างขึ้น
            new_student = Students(
                id_Students=new_student_id,
                prefix=student_data['prefix'],
                first_name=student_data['first_name'],
                last_name=student_data['last_name'],
                code_Student=student_data['code_Student'],
                educationSector=student_data['educationSector'],
                year=int(student_data['year']),
                branch=student_data['branch'],
                yearCourse=int(student_data['yearCourse']),
                id_User=student_data['id_User'],
                id_group_project=new_group.id_GroupProject  # ใช้ ID กลุ่มที่สร้างขึ้น
            )
            db.session.add(new_student)

        db.session.commit()  # คอมมิตการเพิ่มนักเรียน

        return jsonify({'message': 'Group Project and Students added successfully!'}), 201
    except IntegrityError:
        db.session.rollback()
        return jsonify({'message': 'Error: ID already exists.'}), 400
    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({'message': str(e)}), 500
