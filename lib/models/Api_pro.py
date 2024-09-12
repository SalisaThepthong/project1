# Api_pro.py
from flask import Blueprint, request, jsonify
from model import db, ContactGroup, ContactProfes


Profes_blueprint = Blueprint('Profes', __name__)

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

@Profes_blueprint.route('/delete_group/<string:id_Group>', methods=['DELETE'])
def delete_group(id_Group):
    try:
        group = ContactGroup.query.filter_by(id_Group=id_Group).first()

        if group is None:
            return jsonify({'message': 'Group not found'}), 404

        members = ContactProfes.query.filter_by(id_Group=id_Group).all()
        for member in members:
            db.session.delete(member)

        db.session.flush()

        db.session.delete(group)
        db.session.commit()

        return jsonify({'message': 'Group and members deleted successfully'}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'message': str(e)}), 500

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

@Profes_blueprint.route('/update_group/<id_group>', methods=['PUT'])
def update_group(id_group):
    data = request.json
    group = ContactGroup.query.filter_by(id_Group=id_group).first()

    if not group:
        return jsonify({'message': 'Group not found'}), 404

    group.group_Number = data.get('group_Number', group.group_Number)
    group.group_Name = data.get('group_Name', group.group_Name)

    db.session.commit()
    return jsonify({'message': 'Group updated successfully'}), 200

@Profes_blueprint.route('/update_member/<id_member>', methods=['PUT'])
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

@Profes_blueprint.route('/get_group/<string:group_id>', methods=['GET'])
def get_group(group_id):
    try:
        group = ContactGroup.query.filter_by(id_Group=group_id).first()
        if not group:
            return jsonify({'message': 'Group not found'}), 404

        group_data = {
            'group_Number': group.group_Number,
            'group_Name': group.group_Name
        }
        return jsonify(group_data), 200

    except Exception as e:
        return jsonify({'message': 'An error occurred while fetching group data'}), 500
