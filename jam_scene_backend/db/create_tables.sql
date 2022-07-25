/* Setup Tables */
DROP TABLE IF EXISTS instruments CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS ads CASCADE;

CREATE TABLE IF NOT EXISTS instruments (
    id SERIAL PRIMARY KEY,
    name text UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    id text PRIMARY KEY,
    email text NOT NULL,
    username text NOT NULL,
    first_name text,
    last_name text,
    city text,
    state text,
    zipcode text,
    influences text,
    recordings text,
    description text,
    join_date timestamp,
    avail_mon_am boolean, 
    avail_mon_pm boolean, 
    avail_tue_am boolean, 
    avail_tue_pm boolean, 
    avail_wed_am boolean, 
    avail_wed_pm boolean, 
    avail_thu_am boolean, 
    avail_thu_pm boolean, 
    avail_fri_am boolean, 
    avail_fri_pm boolean, 
    avail_sat_am boolean, 
    avail_sat_pm boolean, 
    avail_sun_am boolean, 
    avail_sun_pm boolean, 
    profile_photo text
);

CREATE TABLE IF NOT EXISTS users_instruments (
    id SERIAL PRIMARY KEY,
    userID text REFERENCES users(id) ON DELETE CASCADE,
    instrumentID integer REFERENCES instruments(id) ON DELETE CASCADE
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    for_user text REFERENCES users(id) ON DELETE CASCADE,
    by_user text REFERENCES users(id) ON DELETE CASCADE,
    time_posted timestamp,
    description text
);

CREATE TABLE IF NOT EXISTS ads (
    id SERIAL PRIMARY KEY,
    posted_by text REFERENCES users(id) ON DELETE CASCADE,
    title text,
    post_date timestamp,
    description text,
    city text,
    state text,
    zipcode text,
    radius integer,
    avail_mon_am boolean, 
    avail_mon_pm boolean, 
    avail_tue_am boolean, 
    avail_tue_pm boolean, 
    avail_wed_am boolean, 
    avail_wed_pm boolean, 
    avail_thu_am boolean, 
    avail_thu_pm boolean, 
    avail_fri_am boolean, 
    avail_fri_pm boolean, 
    avail_sat_am boolean, 
    avail_sat_pm boolean, 
    avail_sun_am boolean, 
    avail_sun_pm boolean
);

CREATE TABLE IF NOT EXISTS ads_instruments (
    id SERIAL PRIMARY KEY,
    adID integer REFERENCES ads(id) ON DELETE CASCADE,
    instrumentID integer REFERENCES instruments(id) ON DELETE CASCADE
);
