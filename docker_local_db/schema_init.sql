create schema ucl_messenger;

drop table if exists ucl_messenger.users CASCADE;
drop table if exists ucl_messenger.users_properties CASCADE;
drop table if exists ucl_messenger.addresses CASCADE;
drop table if exists ucl_messenger.users_addresses CASCADE;
drop table if exists ucl_messenger.pii CASCADE;
drop table if exists ucl_messenger.types CASCADE;
drop table if exists ucl_messenger.users_types CASCADE;
drop table if exists ucl_messenger.messages CASCADE;


create table ucl_messenger.users (
    user_id                 serial primary key,
    first_name              varchar(256),
    last_name               varchar(256)
);

create table ucl_messenger.users_properties (
    user_id                   int not null references ucl_messenger.users("user_id"),
    password                  varchar(256),
    nickname                  varchar(256) unique not null
);

create table ucl_messenger.addresses(
    address_id                   serial primary key,
    street_name                  varchar(256),
    number                       int,
    country                      varchar(256),
    postcode                     varchar(256)
);

create table ucl_messenger.users_addresses (
    address_id                 int not null references ucl_messenger.addresses("address_id"),
    user_id                    int not null references ucl_messenger.users("user_id")
);

create table ucl_messenger.pii (
    user_id                   int not null references ucl_messenger.users("user_id"),
    email                     varchar(256),
    national_id               varchar(256),
    address_id                int not null references ucl_messenger.addresses("address_id")
);


create table ucl_messenger.types (
    type_id                 serial primary key,
    type                    varchar(32) check (type in ('teacher', 'teaching_assistant', 'student', 'staff'))
);

create table ucl_messenger.users_types (
    type_id                    int not null references ucl_messenger.types("type_id"),
    user_id                    int not null references ucl_messenger.users("user_id")
);

create table ucl_messenger.messages (
    message_id                       serial primary key,
    from_user_id                     int not null references ucl_messenger.users("user_id"),
    to_user_id                       int not null references ucl_messenger.users("user_id"),
    created_at                       timestamp without time zone not null,
    deleted                          boolean default false not null,
    message                          varchar(8192) not null
);

delete from ucl_messenger.users;
-- Sadly I could not find all of their last names so I used some of their nicknames instead.
insert into ucl_messenger.users(user_id, first_name, last_name) values
    (1, 'Bilbo', 'Baggins'),
    (2, 'Aragorn', 'Heir of Isildur'),
    (3, 'Legolas', 'Greenleaf'),
    (4, 'Frodo', 'Baggins'),
    (5, 'Gimli', 'The Elf-friend'),
    (6, 'Gollum', 'Smeagol'),
    (7, 'Samwise', 'Gamgee'),
    (8, 'Gandalf', 'The Wandering Wizard'),
    (9, 'Sauron', 'The Dark Lord'),
    (10, 'Pippin', 'Took');

delete from ucl_messenger.users_properties;
insert into ucl_messenger.users_properties(user_id, password, nickname) values
    (1, 'pass1', 'bilbo'),
    (2, 'pass2', 'aragorn'),
    (3, 'pass3', 'legolas'),
    (4, 'pass4', 'frodo'),
    (5, 'pass5', 'gimli'),
    (6, 'pass6', 'gollum'),
    (7, 'pass7', 'sam'),
    (8, 'pass8', 'gandalf'),
    (9, 'pass9', 'sauron'),
    (10, 'pass10', 'pippin');

delete from ucl_messenger.addresses;
insert into ucl_messenger.addresses(address_id, street_name, number, country, postcode) values
    (1, 'The Shire', 35, 'Kingdom of Arnor', 'Postcode1'),
    (2, 'Minas Tirith', 40, 'Gondor', 'Postcode2'),
    (3, 'Northern Mirkwood', 51, 'Woodland Realm', 'Postcode3'),
    (4, 'The Shire', 53, 'Kingdom of Arnor', 'Postcode4'),
    (5, 'Thorin''s Hall', 12, 'Blue Mountains', 'Postcode5'),
    (6, 'The Shire', 14, 'Kingdom of Arnor', 'Postcode6'),
    (7, 'The Shire', 16, 'Kingdom of Arnor', 'Postcode7'),
    (8, 'Valinor', 22, 'The Land across the Sea', 'Postcode8'),
    (9, 'The Dark Tower', 55, 'Mordor', 'Postcode9'),
    (10, 'The Shire', 99, 'Kingdom of Arnor', 'Postcode10');

delete from ucl_messenger.pii;
insert into ucl_messenger.pii(user_id, email, national_id, address_id) values
    (1, 'bilbobaggins@ucl.ac.uk', 'nationalid1', 1),
    (2, 'aragorn@ucl.ac.uk', 'nationalid2', 2),
    (3, 'legolas@ucl.ac.uk', 'nationalid3', 3),
    (4, 'frodobaggins@ucl.ac.uk', 'nationalid4', 4),
    (5, 'gimli@ucl.ac.uk', 'nationalid5', 5),
    (6, 'gollum@ucl.ac.uk', 'nationalid6', 6),
    (7, 'samwisegamgee@ucl.ac.uk', 'nationalid7', 7),
    (8, 'gandalf@ucl.ac.uk', 'nationalid8', 8),
    (9, 'sauron@ucl.ac.uk', 'nationalid9', 9),
    (10, 'pippintook@ucl.ac.uk', 'nationalid10', 10);

delete from ucl_messenger.types;
insert into ucl_messenger.types(type_id, type) values
    (1, 'student'),
    (2, 'teacher'),
    (3, 'teaching_assistant'),
    (4, 'staff');

delete from ucl_messenger.users_types;
insert into ucl_messenger.users_types(type_id, user_id) values
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (2, 8),
    (2, 9),
    (3, 10);

delete from ucl_messenger.users_addresses;
insert into ucl_messenger.users_addresses(address_id, user_id) values
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);

delete from ucl_messenger.messages;
insert into ucl_messenger.messages(message_id, from_user_id, to_user_id, created_at, deleted, message) values
    (1, 8, 4, '2050-01-16 15:35:19.254936+00', False, 'True courage is knowing not how to take a life, but when to spare it.'),
    (3, 8, 2, '2050-01-16 15:35:20.254936+00', False, 'He will need you before the end, Aragorn. The people of Rohan will need you. The defenses have to hold.'),
    (17, 8, 4, '2050-01-16 15:35:19.354936+00', False, 'True courage is knowing not how to take a life, but when to spare it.'),
    (7, 8, 10, '2050-01-16 15:35:19.254936+00', False, 'Fool of a Took! This is a serious journey, not a hobbit walking-party. Throw yourself in next time, and then you will be no further nuisance.'),
    (2, 8, 4, '2050-01-16 15:40:19.254936+00', False, 'A wizard is never late, nor is he early. He arrives precisely when he means to.'),
    (4, 2, 4, '2050-01-19 15:35:19.254936+00', False, 'IF BY MY LIFE OR DEATH I CAN PROTECT YOU, I WILL. YOU HAVE MY SWORD.'),
    (5, 3, 4, '2050-01-20 15:35:19.254936+00', False, 'And you have my bow.'),
    (6, 5, 4, '2050-01-21 15:35:19.254936+00', False, 'And my axe.'),
    (8, 4, 7, '2050-01-23 15:35:19.254936+00', False, 'But I have been too deeply hurt, Sam. I tried to save the Shire, and it has been saved, but not for me. It must often be so, Sam, when things are in danger: someone has to give them up, lose them, so that others may keep them.'),
    (9, 5, 10, '2050-01-24 15:35:19.254936+00', False, 'You Young Rascals! A Merry Hunt You''ve Led Us On, And Now We Find You Feasting, And...And SMOKING!'),
    (10, 10, 1, '2050-01-16 15:35:19.354936+00', False, 'Ash nazg durbatulûk, ash nazg gimbatul, ash nazg thrakatulûk, agh burzum-ishi krimpatul.')
;
 
