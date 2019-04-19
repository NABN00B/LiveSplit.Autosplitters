## GTA Liberty City Stories
Based on the MAIN.SCM of the v1 American Disc PSP version. Each variable stores the value for the mission to be started next in the chain. Eg if ($241 == 2) then "Slacker" will be started when you enter Vincenzo's mission marker.

### Portland
#### $241 *Vincenzo Cilli* (VICGOV)
1. Home Sweet Home
2. Slacker
3. Dealing Revenge
4. Snuff
5. Smash and Grab
6. Hot Wheels
7. The Portland Chainsaw Masquerade

#### $244 *Salvatore Leone* (SALGOV)
1. The Offer
2. Ho Selecta!
3. Frighteners
4. Rollercoaster Ride
5. Contra-Banned
6. Sindacco Sabotage
7. The Trouble with Triads
8. Driving Mr Leone

#### $247 *JD O'Toole* (JDTGOV)
1. Bone Voyeur!
2. Don in 60 Seconds
3. A Volatile Situation
4. Blow up 'Dolls'
5. Salvatore's Salvation
6. The Guns of Leone
7. Calm before the Storm
8. The Made Man

If ($247 < 7) and the player is wearing the "Leone's suit" ('PLR'), the "I ain't got no work for no Leone." cutscene mission will be started instead.

#### $250 *Ma Cipriani* (MACGOV)
1. Snappy Dresser
2. Big Rumble in Little China
3. Grease Sucho
4. Dead Meat
5. No Son of Mine

#### $253 *Maria* (MARGOV)
1. Shop 'til you Strop
2. Taken for a Ride
3. Booby Prize
4. Biker Heat
5. Overdose of Trouble

### Staunton Island
#### $296 *Salvatore Leone* (SALSGOV)
1. A Walk In The Park
2. Making Toni
3. Caught In The Act
4. Search And Rescue
5. Taking The Peace
6. Shoot The Messenger

#### $299 *Leon McAffrey* (RAYSGOV)
1. Sayonara Sindaccos
2. The Whole 9 Yardies
3. Crazy '69'
4. Night Of The Livid Dreads
5. Munitions Dump

#### $302 *Donald Love* (DONSGOV)
1. The Morgue Party Candidate
2. Steering The Vote
3. Cam-Pain
4. Friggin' The Riggin'
5. Love & Bullets
6. Counterfeit Count
7. Love On The Rocks

#### $305 *Church Confessional* (NEDSGOV)
1. L.C. Confidential
2. The Passion Of The Heist
3. Karmageddon
4. False Idols

### Shoreside Vale
#### $446 *Salvatore Leone* (SALHGOV)
1. Rough Justice
2. Dead Reckoning
3. Shogun Showdown
4. The Shoreside Redemption
5. The Sicilian Gambit

If ($446 == 1) and the player is not wearing the "Lawyer's suit" ('PLR2'), at first the objective to pick up the "Lawyer's suit" will be unlocked instead, afterwards player will be told to change into the "Lawyer's suit" instead.

#### $449 *Donald Love* (DONHGOV)
1. Panlantic Land Grab
2. Stop the Press
3. Morgue Party Resurrection
4. No Money, Mo' Problems
5. Bringing the House Down
6. Love on the Run

8-Ball's missions are actually part of Donald Love's Shoreside Vale chain.

#### $452 *Toshiko Kasen* (TOSHGOV)
1. More Deadly than the Male
2. Cash Clash
3. A Date with Death
4. Cash in Kazuki's Chips

## GTA Vice City Stories
Based on the MAIN.SCM of the International PSP version. Each variable stores the value for the mission to be started next in the chain when you start a story mission. Eg if ([0] == 2) then "Cleaning House" will be started when you enter Martinez's mission marker.

Possible candidates for mission chain variables are $6, $18 and $4590, all three are arrays with 12 elements.
The value of the current chapter seems to be stored in $130.

The interesting part of the code begins at '99RED_9559'.

### Chapter 1
$130 == 0

#### [0] *Sgt. Jerry Martinez*
1. Soldier
2. Cleaning House
3. Conduct Unbecoming

#### [1] *Phil Cassidy*
1. Cholo Victory
2. Boomshine Blowout
3. Truck Stop
4. Marked Men

#### [2] *Marty J Williams*
1. Shakedown
2. Fear the Repo
3. Waking Up the Neighbors
4. O, Brothel, Where Art Thou?
5. Got Protection?

#### [3] *Louise Cassidy-Williams*
1. When Funday Comes
2. Takin' Out the White-Trash
3. D.I.V.O.R.C.E.
4. To Victor, the Spoils

### Chapter 2
$130 == 1

#### [3] *Louise Cassidy-Williams*
1. Hose the Hoes
2. Robbing the Cradle
3. nothing (removed mission)

#### [4] *Lance Vance*
1. Jive Drive
2. The Audition
3. nothing (removed mission)
4. Caught as an Act
5. Snitch Hitch
6. From Zero to Hero

#### [5] *Umberto Robina*
1. Nice Package
2. Balls
3. Papi Don't Screech
4. Havana Good Time

#### [6] *Bryan Forbes*
1. Money for Nothing
2. nothing (removed mission)
3. Leap and Bound
4. The Bum Deal

### Chapter 3
$130 == 2

#### [7] *Mendez brothers*
1. The Mugshot Longshot
2. Hostile Takeover
3. Unfriendly Competition
4. nothing (removed mission)
5. High Wire
6. Burning Bridges

#### [8] *Reni Wassulmaier*
1. Accidents Will Happen
2. The Colonel's Coke
3. Kill Phil
4. Say Cheese
5. Kill Phil: Part 2
6. So Long Schlong
7. In The Air Tonight

#### [4] *Lance Vance*
1. Brawn of the Dead
2. nothing (removed mission)
3. Blitzkrieg
4. Turn on, Tune in, Bug out
5. Taking the Fall
6. White Lies
7. Where it Hurts Most
8. Blitzkrieg Strikes Again
9. Lost and Found
10. Light My Pyre

#### [9] *Gonzalez*
1. nothing (removed mission)
2. Home's on the Range
3. Purple Haze
4. Farewell To Arms

#### [10] *Leo Teal*
1. nothing (removed mission)
2. nothing (removed mission)
3. nothing (removed mission)
4. nothing (removed mission)
5. nothing (removed mission)

#### [11] *Ricardo Diaz*
1. Steal the Deal
2. The Exchange
3. Domo Arigato Domestoboto
4. Over the Top
5. Last Stand
