# subject_routes.py
from flask import Blueprint, request, jsonify
from model import db, Subject

subject_blueprint = Blueprint('subject', __name__)

@subject_blueprint.route('/add_subject', methods=['POST'])
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

@subject_blueprint.route('/showCourse', methods=['GET'])
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

@subject_blueprint.route('/update_subject/<string:subject_id>', methods=['PUT'])
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

@subject_blueprint.route('/delete_subject/<string:id>', methods=['DELETE'])
def delete_subject(id):
    subject = Subject.query.filter_by(courseCode=id).first()
    if not subject:
        return jsonify({'message': 'Subject not found'}), 404

    try:
        db.session.delete(subject)
        db.session.commit()
        return jsonify({'message': 'Subject deleted successfully!'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': 'An error occurred while deleting the subject'}), 500
