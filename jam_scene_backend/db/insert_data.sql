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
    'Bass'
),
(
    'Lead Singer'
),
(
    'Cowbell'
);

INSERT INTO instruments (
    name
) VALUES
(
    'Drums'
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

INSERT INTO ads (
    posted_by,
    title,
    post_date,
    description,
    city,
    state,
    zipcode,
    radius, 
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
    avail_sun_pm
) VALUES (
    'r4nD0mSt1ng1',
    'If you got sticks, hit me up!!',
    '2022-07-13',
    'We''re looking for a sick drummer to come jam with us next Saturday night. Hit us up if you''re interested!',
    'Seattle',
    'WA',
    '98101',
    '15',
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    FALSE,
    TRUE,
    FALSE,
    FALSE
);

INSERT INTO ads_instruments (
    adID,
    instrumentID
) VALUES (
    (SELECT id FROM ads WHERE posted_by = 'r4nD0mSt1ng1'),
    (SELECT id FROM instruments WHERE name = 'Drums')
);

INSERT INTO reviews (
    for_user,
    by_user,
    description
) VALUES (
    'r4nD0mSt1ng1',
    'r4nD0mSt1ng2',
    'Bobby Beats can really shred! Would totes jam with him again'
);