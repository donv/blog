# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

uwe = User.create! email: 'uwe@kubosch.no',
    first_name: 'Uwe',
    last_name: 'Kubosch',
    salted_password: '',
    salt: 'salt',
    verified: true,
    role: 'ADMIN',
    security_token: 'token',
    token_expiry: 1.year.from_now,
    deleted: false,
    delete_after: nil

uwe.change_password('secret', 'secret').save!
