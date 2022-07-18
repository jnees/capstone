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
    userID text REFERENCES users(id),
    instrumentID integer REFERENCES instruments(id)
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    for_user integer REFERENCES users(id),
    by_user integer REFERENCES users(id),
    description text
);

CREATE TABLE IF NOT EXISTS ads (
    id SERIAL PRIMARY KEY,
    posted_by integer REFERENCES users(id),
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
    adID integer REFERENCES ads(id),
    instrumentID integer REFERENCES instruments(id)
);

-- Queries for inserting sample data into database

INSERT INTO users(
    id,
    email,
    username,
    first_name,
    last_name,
    city,
    state,
    zipcode,
    influences,
    recordings,
    description,
    join_date,
    avail_mon_am,
    avail_mon_pm,
    avail_tue_am,
    avail_tue_pm,
    avail_wed_am,
    avail_wed_pm,
    avail_thu_am,
    avail_thu_pm,
    avail_fri_am,
    avail_fri_pm,
    avail_sat_am,
    avail_sat_pm,
    avail_sun_am,
    avail_sun_pm,
    profile_photo
) VALUES (
    'r4nD0mSt1ng1',
    'grungebob@signofhorns.com',
    'GrungeBob',
    'Robert',
    'Smith',
    'Seattle',
    'WA',
    '98101',
    'Nirvana, Pearl Jam',
    'www.spotify.com/grungebob',
    'This is Bob (aka GrungeBob aka Bobby Beats). I''m looking to make some noise. Hit me up if you need a guitarist or drummer. I might need to borrow your amp.',
    '2021-12-10',
    FALSE,
    FALSE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    'link/to/prof/pic'
);

INSERT INTO users(
    id,
    email,
    username,
    first_name,
    last_name,
    city,
    state,
    zipcode,
    influences,
    recordings,
    description,
    join_date,
    avail_mon_am,
    avail_mon_pm,
    avail_tue_am,
    avail_tue_pm,
    avail_wed_am,
    avail_wed_pm,
    avail_thu_am,
    avail_thu_pm,
    avail_fri_am,
    avail_fri_pm,
    avail_sat_am,
    avail_sat_pm,
    avail_sun_am,
    avail_sun_pm,
    profile_photo
) VALUES (
    'r4nD0mSt1ng2',
    'sally.rager@signofhorns.com',
    'AlGoreRhythms',
    'Sally',
    'BoBally',
    'Seattle',
    'WA',
    '98101',
    'Nirvana, Pearl Jam',
    'www.spotify.com/sallyrager',
    'I came here to chew bubblegum and rage, and I''m all out of bubblegum. Hit me up if you''re metal enough to bite off a bat''s head but you won''t because you''re vegan.',
    '2021-12-10',
    FALSE,
    FALSE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    TRUE,
    FALSE,
    FALSE,
    FALSE,
    TRUE,
    TRUE,
    FALSE,
    TRUE,
    'link/to/prof/pic'
);

INSERT INTO instruments (
    name
) VALUES
(
    'Lead Singer'
),
(
    'Background Singer'
),
(
    'Drums'
),
(
    'Guitar'
),
(
    'Bass'
),
(
    'Cowbell'
),
(
    'Piano'
),
(
    'Synthesizer'
),
(
    'Violin'
),
(
    'Saxophone'
),
(
    'Bassoon'
),
(
    'Flute'
),
(
    'Other'
);

INSERT INTO users_instruments (
    userID,
    instrumentID
) VALUES 
(
    'r4nD0mSt1ng1',
    (SELECT id FROM instruments WHERE name = 'Bass')
),
(
    'r4nD0mSt1ng1',
    (SELECT id FROM instruments WHERE name = 'Cowbell')
),
(
    'r4nD0mSt1ng2',
    (SELECT id FROM instruments WHERE name = 'Lead Singer')
)
;


INSERT INTO users_instruments (
    userID,
    instrumentID
) VALUES 
(
    (SELECT id FROM users WHERE username = 'AlGoreRhythms'),
    (SELECT id FROM instruments WHERE name = 'Cowbell')
)
;
