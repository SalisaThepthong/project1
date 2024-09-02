from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@127.0.0.1/thesis'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)
CORS(app)

class Subject(db.Model):
    id_Subjects = db.Column(db.String(10), primary_key=True)
    courseCode = db.Column(db.String(50), nullable=False)
    name_Subjects = db.Column(db.String(100), nullable=False)
    branchIT = db.Column(db.Integer, nullable=False)
    branchCS = db.Column(db.Integer, nullable=False)
##C06 520214 Programming Platform and Environments 1 0

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
                'courseCode': subject.courseCode,
                'name_Subjects': subject.name_Subjects,
                'branchIT': subject.branchIT,
                'branchCS': subject.branchCS
            })
        
        return jsonify(subjects_list)
    except Exception as e:
        print(f"Error occurred: {e}")
        return jsonify({'message': 'Internal server error'}), 500
    

@app.route('/update_subject/<string:subject_id>', methods=['PUT'])
def update_subject(subject_id):
    data = request.json
    subject = Subject.query.get(subject_id)
    if subject:
        # ปรับค่าต่างๆ จากข้อมูลที่ส่งมา
        subject.courseCode = data.get('courseCode', subject.courseCode)
        subject.name_Subjects = data.get('name_Subjects', subject.name_Subjects)
        subject.branchIT = data.get('branchIT', subject.branchIT)
        subject.branchCS = data.get('branchCS', subject.branchCS)
        
        # บันทึกการเปลี่ยนแปลงในฐานข้อมูล
        db.session.commit()
        
        # ส่งข้อความยืนยันการอัปเดต
        return jsonify({'message': 'Subject updated successfully'})
    else:
        # ถ้าข้อมูลวิชาไม่พบในฐานข้อมูล
        return jsonify({'error': 'Subject not found'}), 404




# Endpoint สำหรับลบวิชาเรียน
@app.route('/delete_subject/<string:id>', methods=['DELETE'])
def delete_subject(id):
    subject = Subject.query.filter_by(id_Subjects=id).first()
    if not subject:
        return jsonify({'message': 'ไม่พบข้อมูลวิชาเรียน'}), 404
    
    try:
        db.session.delete(subject)
        db.session.commit()
        return jsonify({'message': 'ลบวิชาเรียนสำเร็จ!'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': 'เกิดข้อผิดพลาดในการลบข้อมูล'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
