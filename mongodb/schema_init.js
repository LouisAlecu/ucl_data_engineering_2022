use ucl_messenger

db.ucl_messenger.insertOne({
    "first_name": "Bilbo",
    "last_name": "Baggins",
    "user_properties": {
        "password": "pass1",
        "nickname": "bilbo"
    },
    "addresses": [
        {
            "street_name": "The Shire",
            "number": 35,
            "country": "Kingdom of Arnor",
            "postcode": "Postcode1"
        }
    ],
    "pii": {
        "email": "bilbobaggins@ucl.ac.uk",
        "national_id": "nationalid1"
    },
    "type": "student"
})

db.ucl_messenger.insertOne({
    "first_name": "Gandalf",
    "last_name": "The Wandering Wizard",
    "user_properties": {
        "password": "pass8",
        "nickname": "gandalf"
    },
    "addresses": [
        {
            "street_name": "Valinor",
            "number": 22,
            "country": "The Land across the Sea",
            "postcode": "Postcode8"
        }
    ],
    "pii": {
        "email": "gandalf@ucl.ac.uk",
        "national_id": "nationalid8"
    },
    "type": "student"
})



