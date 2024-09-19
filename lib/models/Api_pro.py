# Api_pro.py
from flask import Blueprint, request, jsonify
from model import db, ContactGroup, ContactProfes

Profes_blueprint = Blueprint('Profes', __name__)


#เพิ่ม กลุ่ม และ สมาชิก
def generate_group_id():
    count = ContactGroup.query.count()
    new_id = 'G' + str(count + 1).zfill(3)
    return new_id

def generate_member_id():
    count = ContactProfes.query.count()
    new_id = 'M' + str(count + 1).zfill(3)
    return new_id

@Profes_blueprint.route('/add_group_and_members', methods=['POST'])
def add_group_and_members():
    data = request.json
    group_id = generate_group_id()
    group_number = data.get('group_number')
    group_name = data.get('group_name')

    new_group = ContactGroup(
        id_Group=group_id,
        group_Number=group_number,
        group_Name=group_name
    )
    db.session.add(new_group)

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
    
# แสดงกลุ่ม และ สมาชิก
@Profes_blueprint.route('/groups', methods=['GET'])
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
# ลบกลุ่ม และ สมาชิก----------------------------------------------
@Profes_blueprint.route('/delete_group/<string:id_Group>', methods=['DELETE'])
def delete_group(id_Group):
    try:
        group = ContactGroup.query.filter_by(id_Group=id_Group).first()

        if group is None:
            return jsonify({'message': 'Group not found'}), 404

        members = ContactProfes.query.filter_by(id_Group=id_Group).all()
        for member in members:
            db.session.delete(member)

        db.session.flush() #ไว้เคลียค่าในตาราง ให้สามารถลบได้

        db.session.delete(group)
        db.session.commit()

        return jsonify({'message': 'Group and members deleted successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'message': str(e)}), 500



#     ลบ สมาชิก
@Profes_blueprint.route('/delete_member/<string:id_Member>', methods=['DELETE'])
def delete_member(id_Member):
    try:
        member = ContactProfes.query.filter_by(id_Member=id_Member).first()

        if member is None:
            return jsonify({'message': 'Member not found'}), 404

        db.session.delete(member)
        db.session.commit()

        return jsonify({'message': 'Member deleted successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'message': str(e)}), 500
    

    # จัดการกลุ่มและสมาชิก
@Profes_blueprint.route('/group_and_members/<string:group_id>', methods=['GET', 'PUT'])
def manage_group_and_members(group_id):
    # Handle GET request
    if request.method == 'GET':
        try:
            # Fetch the group by group_id
            group = ContactGroup.query.filter_by(id_Group=group_id).first()
            if not group:
                return jsonify({'message': 'Group not found'}), 404

            # Fetch all members in the group (if needed later)
            members = ContactProfes.query.filter_by(id_Group=group_id).all()
            member_list = []
            for member in members:
                member_data = {
                    'id_Member': member.id_Member,
                    'member_Prefix': member.member_Prefix,
                    'member_Name': member.member_Name,
                    'member_Lname': member.member_Lname,
                    'member_Email': member.member_Email,
                    'member_Facebook': member.member_Facebook,
                }
                member_list.append(member_data)

            # Prepare the response data for the group and its members
            group_data = {
                'group_Number': group.group_Number,
                'group_Name': group.group_Name,
                'members': member_list
            }
            return jsonify(group_data), 200

        except Exception as e:
            return jsonify({'message': 'An error occurred while fetching group and members data', 'error': str(e)}), 500

    # Handle PUT request
    elif request.method == 'PUT':
        data = request.json
        try:
            # Update the group
            group = ContactGroup.query.filter_by(id_Group=group_id).first()
            if not group:
                return jsonify({'message': 'Group not found'}), 404

            group.group_Number = data.get('group_Number', group.group_Number)
            group.group_Name = data.get('group_Name', group.group_Name)

            # Update members (optional - if needed later)
            members_data = data.get('members', [])
            for member_data in members_data:
                member = ContactProfes.query.filter_by(id_Member=member_data['id_Member'], id_Group=group_id).first()
                if member:
                    member.member_Prefix = member_data.get('member_Prefix', member.member_Prefix)
                    member.member_Name = member_data.get('member_Name', member.member_Name)
                    member.member_Lname = member_data.get('member_Lname', member.member_Lname)
                    member.member_Email = member_data.get('member_Email', member.member_Email)
                    member.member_Facebook = member_data.get('member_Facebook', member.member_Facebook)

            # Commit the changes
            db.session.commit()
            return jsonify({'message': 'Group and members updated successfully'}), 200

        except Exception as e:
            return jsonify({'message': 'An error occurred while updating group and members data', 'error': str(e)}), 500
