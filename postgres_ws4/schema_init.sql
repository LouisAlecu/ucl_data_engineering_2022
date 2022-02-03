create schema fantasy_pi_schema;

drop table if exists fantasy_pi_schema.games_dates cascade;
create table fantasy_pi_schema.games_dates (
    game_date_id    serial primary key,
    game_start      timestamp without time zone not null unique,
    game_end        timestamp without time zone not null unique
);

drop table if exists fantasy_pi_schema.games_types cascade;
create table fantasy_pi_schema.games_types (
    game_type_id    serial primary key,
    game_type       varchar(20)
);

drop table if exists fantasy_pi_schema.games cascade;
create table fantasy_pi_schema.games (
    game_id         serial primary key,
    game_name       varchar(100),
    game_fee        numeric not null,

    game_date_id    int not null references fantasy_pi_schema.games_dates("game_date_id") on delete cascade on update cascade,
    game_start      timestamp without time zone not null,
    game_end        timestamp without time zone not null,
    
    game_type_id    int not null references fantasy_pi_schema.games_types("game_type_id") on delete cascade on update cascade,
    game_type       varchar(100) not null,
    
    is_public       boolean not null,

    unique (game_id, game_start, game_end)
);


drop table if exists fantasy_pi_schema.users cascade;
create table fantasy_pi_schema.users (
    user_id      serial primary key,
    email        varchar(500) unique not null
);

drop table if exists fantasy_pi_schema.companies cascade;
create table fantasy_pi_schema.companies (
    company           varchar(500) unique not null,
    ticker            varchar(10) unique not null,
    industry          varchar(200),

    unique (ticker),
    primary key (company, ticker)
);


drop table if exists fantasy_pi_schema.portfolios cascade;
create table fantasy_pi_schema.portfolios (
    portfolio_id           serial primary key,
    portfolio_name         varchar(500),
    user_id                int references fantasy_pi_schema.users("user_id") on delete cascade on update cascade,
    game_id                integer references fantasy_pi_schema.games("game_id") on delete cascade on update cascade,

    unique(game_id, user_id, portfolio_name)
);


drop table if exists fantasy_pi_schema.portfolios_breakdown cascade;
create table fantasy_pi_schema.portfolios_breakdown (
    game_id                integer references fantasy_pi_schema.games("game_id") on delete cascade on update cascade,
    user_id                int references fantasy_pi_schema.users("user_id") on delete cascade on update cascade,
    portfolio_id           integer references fantasy_pi_schema.portfolios("portfolio_id") on delete cascade on update cascade,
    ticker                 varchar(10) references fantasy_pi_schema.companies("ticker") on delete cascade on update cascade,
    percentage_invested    integer,

    constraint percentage_validity check (percentage_invested > 0 and percentage_invested <= 100)
);


drop table if exists fantasy_pi_schema.prices;
create table fantasy_pi_schema.prices (
    prices_id         serial primary key,
    ticker            varchar(10) references fantasy_pi_schema.companies("ticker") on delete cascade on update cascade,
    timestamp         timestamp without time zone,
    closing           float,
    opening           float
);

