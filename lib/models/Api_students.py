from sqlite3 import IntegrityError
from flask import Blueprint, request, jsonify
from model import Students, db, GroupProject

students_blueprint = Blueprint('students', __name__)

@students_blueprint.route('/add_group_and_student', methods=['POST']) 
def add_group_and_student():
    data = request.get_json()

    if 'students' not in data or len(data['students']) < 1:
        return jsonify({'message': 'Error: ได้รับข้อมูลไม่ครบ กรุณาตรวจสอบ และลองอีกครั้ง'}), 400

    try:
        # สร้างกลุ่มใหม่สำหรับนักเรียน
        new_group_id = 'GP' + str(GroupProject.query.count() + 1).zfill(2)
        new_group = GroupProject(id_GroupProject=new_group_id)
        db.session.add(new_group)
        db.session.flush()

        for student_data in data['students']:
            if not student_data.get('id_User'):
                raise ValueError("id_User is required for all students")

            new_student_id = 'S' + str(Students.query.count() + 1).zfill(2)
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
                id_group_project=new_group.id_GroupProject
            )
            db.session.add(new_student)

        db.session.commit()
        return jsonify({'message': 'เพิ่มกลุ่มโปรเจกต์และนักเรียนเรียบร้อยแล้ว', 'group_id': new_group_id}), 201
    except ValueError as e:
        db.session.rollback()
        return jsonify({'message': str(e)}), 400
    except IntegrityError as e:
        db.session.rollback()
        return jsonify({'message': f'Error: ข้อมูลไม่ถูกต้องหรือซ้ำ: {str(e)}'}), 400
    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify({'message': str(e)}), 500