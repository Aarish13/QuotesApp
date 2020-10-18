from app_config import app
from database import Quotes, db
from flask import request, jsonify


@app.route('/get_quotes')
def get_quotes():
    quotes = Quotes.query.all()
    quotes_list = []
    for i in quotes:
        quotes_list.append({
            'type': i.type,
            'quote': i.quote,
            'name': i.author
        })

    return jsonify(quotes_list)


@app.route('/post_quote', methods=['POST'])
def post_quote():
    query_parameters = request.json
    quote = query_parameters.get('quote')
    quote_type = query_parameters.get('type')
    author = query_parameters.get('name')
    new_quote = Quotes(quote=quote, type=quote_type, author=author)

    db.session.add(new_quote)
    db.session.commit()
    return jsonify(quote), 201


if __name__ == '__main__':
    app.run()
