from app_config import app
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy(app)


class Quotes(db.Model):
    __tablename__ = 'quotes'

    qid = db.Column(db.INTEGER, primary_key=True)
    quote = db.Column(db.VARCHAR, nullable=False)
    type = db.Column(db.VARCHAR, nullable=False)
    author = db.Column(db.VARCHAR, nullable=False)


if __name__ == '__main__':
    db.create_all()
