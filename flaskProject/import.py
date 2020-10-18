import pandas as pd
from database import Quotes, db

df = pd.read_json('Quotes.JSON')
for _, row in df.iterrows():
    quote = row['Quote']
    quote_type = row['Type']
    author = row['Author']
    new_quote = Quotes(quote=quote, type=quote_type, author=author)

    db.session.add(new_quote)
    db.session.commit()
