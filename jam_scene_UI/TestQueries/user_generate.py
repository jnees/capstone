# flake8: noqa
import datetime
import time
import requests
import json
import random as random


r = requests.get('https://randomuser.me/api/?results=200&nat=us')
data = json.loads(r.text)


lorem = [
    "I'm baby Mlkshk selvage aesthetic hella cray pok pok mixtape hashtag fixie air plant tacos brooklyn. Health goth kale chips glossier yuccie. Hexagon kickstarter waistcoat, fashion axe vaporware helvetica art party green juice dreamcatcher 3 wolf moon jean shorts humblebrag locavore trust fund.",
    "I'm baby Taxidermy poutine post-ironic hexagon pug food truck banh mi subway tile paleo bespoke. Trust fund tilde sustainable fingerstache biodiesel adaptogen.",
    "I'm baby Raw denim distillery hexagon keytar, austin listicle coloring book 8-bit truffaut pork belly man braid. Literally raclette tacos fixie flexitarian. Blue bottle kale chips gastropub, shoreditch fanny pack man braid live-edge.",
    "Concept of the number one paroxysm of global death white dwarf hundreds of thousands the ash of stellar alchemy globular star cluster. Preserve and cherish that pale blue dot courage of our questions a mote of dust suspended in a sunbeam Sea of Tranquility as a patch of light the sky calls to us. A mote of dust suspended in a sunbeam vastness is bearable only through love with pretty stories for which there's little good evidence descended from astronomers a mote of dust suspended in a sunbeam something incredible is waiting to be known.",
    "Sea of Tranquility Tunguska event the sky calls to us descended from astronomers Euclid Orion's sword. Bits of moving fluff bits of moving fluff preserve and cherish that pale blue dot concept of the number one finite but unbounded with pretty stories for which there's little good evidence. Encyclopaedia galactica two ghostly white figures in coveralls and helmets are softly dancing courage of our questions Drake Equation from which we spring bits of moving fluff.",
    "Apollonius of Perga circumnavigated two ghostly white figures in coveralls and helmets are softly dancing extraplanetary Drake Equation Hypatia? From which we spring another world as a patch of light Jean-François Champollion made in the interiors of collapsing stars as a patch of light. The carbon in our apple pies muse about another world the carbon in our apple pies laws of physics dream of the mind's eye.",
    "A billion trillion citizens of distant epochs globular star cluster decipherment preserve and cherish that pale blue dot laws of physics? Apollonius of Perga tendrils of gossamer clouds hundreds of thousands cosmic fugue rich in mystery concept of the number one?",
    "Chillwave cloud bread cronut paleo, 3 wolf moon umami chambray disrupt. Artisan austin waistcoat copper mug bushwick praxis cloud bread four dollar toast",
    "Ethical blog hoodie, drinking vinegar art party air plant asymmetrical artisan yuccie banjo hashtag you probably haven't heard of them quinoa. Coloring book copper mug single-origin coffee readymade master cleanse cliche, kitsch asymmetrical sartorial activated charcoal forage blue bottle.",
    "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder. After the avalanche, it took us a week to climb out.",
    "Complete mare chap farewell jolly hockey sticks real ale, ey up duck terribly. Macca treacle argy-bargy sod's law codswallop yorkshire mixture one off for sooth a diamond geezer, it's the dogs bollocks bangers and mash chin up",
    "Pennyboy Northeners rivetting stuff accordingly sausage roll The Hounds of Baskerville conkers, old chap one off could be a bit of a git absobloodylootely apple and pears clotted cream a tad, Kate and Will",
    "Brainbox got his end away curtain twitching put me soaps back on squirrel, cornish pasty daft cow narky one would like, ponce bit of alright fork out. Sonic Screwdriver splendid off the hook atrocious naff chaps pulled a right corker",
    "10 pence mix doing my head in bottled it. Chaps wellies a total jessie a week on Sunday have a gander, bossy britches marvelous trouble and strife grab a jumper pennyboy, nonsense a bit miffed ey up duck. Ey up a bottle of plonk made a pig's ear of it splendid fish fingers and custard bugger real ale that's ace",
    "Tiramisu chocolate tart icing chupa chups powder cake icing jelly beans. Powder brownie cotton candy jelly-o fruitcake apple pie. Cookie pudding icing marzipan I love I love chupa chups pastry I love.",
    "Powder brownie cake wafer toffee tart I love halvah. Sweet roll icing biscuit sweet roll tart gummi bears. Candy I love I love jelly-o bear claw cotton candy danish dessert I love. Tiramisu muffin I love",
    "Jelly-o croissant danish I love pie chocolate cake I love. Liquorice I love ice cream dessert I love tiramisu jelly fruitcake. Gummies marzipan candy fruitcake gummi bears chocolate.",
    "Gummies jelly beans I love candy sweet roll wafer wafer. Bonbon gummi bears bear claw ice cream marshmallow sugar plum cake. Wafer jelly beans dessert sweet roll liquorice cotton candy wafer sugar plum danish. Cupcake pie I love muffin jujubes.",
    "Sweet roll jelly beans I love danish I love liquorice wafer. Carrot cake candy pudding toffee cookie. Macaroon danish jelly powder carrot cake.",
]

influences = [
    "The Beatles", "The Rolling Stones", "The Who","The Doors","The Beach Boys","The Mars Volta","Arcade Fire",
    "Talking Heads","Animal Collective","Built to Spill","Belle and Sebastian","Interpol","Queens of the Stone Age","Spoon",
    "The Strokes","The Cure","The Velvet Underground","The Smiths","The Go Team","Jonny Greenwood","Johnny Marr",
    "Ween","Weezer (prior to 1997)","Noel Gallagher","Primus","Peter Gabriel","Pearl Jam","Queen","Steve Winwood",
    "Radiohead","Oasis","Pink Floyd","Air","Daft Punk","Willy Nelson","Neutral Milk Hotel","Pixies","LCD Soundsystem",
    "Modest Mouse","The Avalanches","Future Islands","TV on the Radio","Phoebe Bridgers","Big Thief","The Black Keys",
    "The White Stripes","Beach House","The National","Death Cab for Cutie","Twin Shadow","The Cars","The Walkmen",
    "Mates of State","Elliot Smith","Tom Petty","Tom Waits","Crystal Castles","The Shins","Ariel Pink (the music, not the guy)",
    "Jackson Browne", "Thom Yorke", "Lykke Li", "Baths", "Of Montreal", "The Doobie Brothers", "Vampire Weekend", "Taylor Swift",
    "BRONCHO","Ratatat","The Postal Service","Bruce Hornsby","Weird Al","Wolf Parade""Chairlift","Sia","Metronomy""FEMME",
    "Nine Inch Nails","Deftones","Faith No More","Ministry","Jon Batiste","Mitski","Bright Eyes","Neon Indian","Outkast",
    "Battles","The Knife","Pulp","Jimmy Eat World","Katy Perry","David Bowie","Paul Simon","Electric Light Orchestra","Iggy Pop",
    "Peter Gabriel","Joe Jackson","Stevie Wonder","Gorillaz","Blur","Tears for fears","TOTO","Schlock Diesel"
]

# list of zip codes in seattle, wa
seattle_zips = ['98115','98103','98105','98118','98133','98125','98122','98198','98117','98155','98168','98144',
'98109','98146','98107','98116','98178','98119','98102','98106','98112','98188','98126','98108','98199','98166',
'98177','98121','98136','98104','98101','98148','98134','98164','98195','98154','98158','98174']

portland_zips = ['97201','97202','97203','97204','97205','97206','97207','97208','97209','97210',
'97211','97212','97213','97214','97215','97216','97217','97218','97219','97220','97221','97222',
'97223','97224','97225','97227','97228','97230','97231','97232','97233','97236','97238','97239',
'97240','97242','97250','97251','97252','97253','97254','97256','97258','97266','97267','97268',
'97269','97280','97281','97282','97283','97286','97290','97291','97292','97293','97294','97296',
'97298','97299']

denver_zips = [
    '80012','80014','80022','80033','80127','80201','80202','80203','80204','80205','80206','80207',
'80208','80209','80210','80211','80212','80214','80215','80216','80217','80218','80219','80220','80221',
'80222','80223','80224','80225','80226','80227','80228','80229','80230','80231','80232','80233','80234',
'80235','80236','80237','80238','80239','80244','80246','80247','80248','80249','80250','80251','80252',
'80256','80257','80259','80260','80261','80262','80263','80264','80265','80266','80271','80273','80274',
'80279','80280','80281','80290','80291','80293','80294','80295','80299'
]

cities = {"Seattle": seattle_zips, "Portland": portland_zips, "Denver": denver_zips}
city_state = {"Seattle": "WA", "Portland": "OR", "Denver": "CO"}

# map of state names to abbreviations
states = {
    'Alabama': 'AL','Alaska': 'AK','Arizona': 'AZ','Arkansas': 'AR','California': 'CA','Colorado': 'CO',
    'Connecticut': 'CT','Delaware': 'DE','Florida': 'FL','Georgia': 'GA','Hawaii': 'HI','Idaho': 'ID',
    'Illinois': 'IL','Indiana': 'IN','Iowa': 'IA','Kansas': 'KS','Kentucky': 'KY','Louisiana': 'LA',
    'Maine': 'ME','Maryland': 'MD','Massachusetts': 'MA','Michigan': 'MI','Minnesota': 'MN',
    'Mississippi': 'MS','Missouri': 'MO','Montana': 'MT','Nebraska': 'NE','Nevada': 'NV','New Hampshire': 'NH',
    'New Jersey': 'NJ','New Mexico': 'NM','New York': 'NY','North Carolina': 'NC','North Dakota': 'ND',
    'Ohio': 'OH','Oklahoma': 'OK','Oregon': 'OR','Pennsylvania': 'PA','Rhode Island': 'RI','South Carolina': 'SC',
    'South Dakota': 'SD','Tennessee': 'TN','Texas': 'TX','Utah': 'UT','Vermont': 'VT','Virginia': 'VA',
    'Washington': 'WA','West Virginia': 'WV','Wisconsin': 'WI','Wyoming': 'WY',
}

# get current datetime as a string
today = datetime.datetime.now()

# data = json.loads(r.text)
for user in data['results']:
    city = random.choice(list(cities.keys()))
    user_details = {
        'uid': user['login']['uuid'],
        'username': user['login']['username'],
        'first_name': user['name']['first'],
        'last_name': user['name']['last'],
        'email': user['email'],
        'city': city,
        'state': city_state[city],
        'zip_code': cities[city][random.randint(0, len(cities[city]) - 1)],
        'join_date': today,
        'description': lorem[random.randint(0, len(lorem) - 1)],
        'recordings': "www.spotify.com/{}".format(user['login']['username']),
        'influences': ", ".join([influences[random.randint(0, len(influences) - 1)] for i in range(random.randint(3, 7))]),
        'photo': user['picture']['large'],
        'avail_mon_am': random.choice([True, False]),
        'avail_mon_pm': random.choice([True, False]),
        'avail_tue_am': random.choice([True, False]),
        'avail_tue_pm': random.choice([True, False]),
        'avail_wed_am': random.choice([True, False]),
        'avail_wed_pm': random.choice([True, False]),
        'avail_thu_am': random.choice([True, False]),
        'avail_thu_pm': random.choice([True, False]),
        'avail_fri_am': random.choice([True, False]),
        'avail_fri_pm': random.choice([True, False]),
        'avail_sat_am': random.choice([True, False]),
        'avail_sat_pm': random.choice([True, False]),
        'avail_sun_am': random.choice([True, False]),
        'avail_sun_pm': random.choice([True, False]),
        'instruments':sorted(list(set([random.randint(1, 13) for i in range(random.randint(1, 5))])))
        }

    user_details = json.dumps(user_details, default=str)
    print(user_details)
    
    # TODO: This route now requires a token to be passed in as a header 'authorization'.
    r = requests.post('https://jam-scene-app.herokuapp.com/users', data=user_details, headers={'Content-Type': 'application/json',
        'Accept': 'application/json', 'authorization': token},)
    time.sleep(random.randint(1, 2))