/* Setup Tables */
DROP TABLE IF EXISTS instruments CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS ads CASCADE;

CREATE TABLE IF NOT EXISTS instruments (
    id SERIAL PRIMARY KEY,
    name text UNIQUE NOT NULL,
    icon text
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email text NOT NULL,
    first_name text,
    last_name text,
    location text,
    influences text,
    recordings text,
    description text,
    join_date timestamp,
    instruments integer REFERENCES instruments,
    availability_mon_am boolean, 
    availability_mon_pm boolean, 
    availability_tue_am boolean, 
    availability_tue_pm boolean, 
    availability_wed_am boolean, 
    availability_wed_pm boolean, 
    availability_thu_am boolean, 
    availability_thu_pm boolean, 
    availability_fri_am boolean, 
    availability_fri_pm boolean, 
    availability_sat_am boolean, 
    availability_sat_pm boolean, 
    availability_sun_am boolean, 
    availability_sun_pm boolean, 
    profile_photo text
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    for_user integer REFERENCES users,
    by_user integer REFERENCES users,
    stars integer CHECK (stars >= 1 AND stars <= 5),
    description text
);

CREATE TABLE ads (
    id SERIAL PRIMARY KEY,
    posted_by integer REFERENCES users,
    title text,
    post_date timestamp,
    instruments_seeking integer REFERENCES instruments,
    description text,
    location text,
    radius integer,
    proposed_availability_mon_am boolean, 
    proposed_availability_mon_pm boolean, 
    proposed_availability_tue_am boolean, 
    proposed_availability_tue_pm boolean, 
    proposed_availability_wed_am boolean, 
    proposed_availability_wed_pm boolean, 
    proposed_availability_thu_am boolean, 
    proposed_availability_thu_pm boolean, 
    proposed_availability_fri_am boolean, 
    proposed_availability_fri_pm boolean, 
    proposed_availability_sat_am boolean, 
    proposed_availability_sat_pm boolean, 
    proposed_availability_sun_am boolean, 
    proposed_availability_sun_pm boolean
);
