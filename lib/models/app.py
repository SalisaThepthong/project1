from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from model import db
from Api_pro import Profes_blueprint
from Api_sub import subject_blueprint



app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@127.0.0.1/thesis'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)
migrate = Migrate(app, db)
CORS(app)

# ลงทะเบียนบลูปริ้นท์
app.register_blueprint(Profes_blueprint, url_prefix='/Profes')
app.register_blueprint(subject_blueprint, url_prefix='/subject')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
