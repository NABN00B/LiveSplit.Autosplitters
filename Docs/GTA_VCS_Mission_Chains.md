# GTA Vice City Stories Mission Chains
This document is based on the MAIN.SCM of the International PSP version.

Mission chain counters are stored in the array $6 of size 12. Each element stores the value for the mission to be started next in the chain. Eg if `$6[0] == 2` then "Cleaning House" will be started when you enter Martinez's mission marker.

The numbers of required missions to be completed in each mission chain are stored in the array $4590 of size 12.

Whether mission chains are completed are stored in array $18 of size 12. Once an element of $6 (that is required for the current chapter) reaches a value higher than the value of the corresponding element of $4590, the value of the corresponding element of $18 will be set to 1. Eg if `$6[0] > $4590[0]` then `$18[0] = 1`.

The value of the current chapter is stored in variable $130. Once all elements of $18 (that are required for the current chapter) are equal to 1, the value of $130 will be incremented and the game progresses into the next chapter (or the credits at the end of Chapter 3).

The value of the current mission chain is stored in variable $2076.

The interesting part of the code begins at '99RED_9559'.

## Chapter 1 (`$130 == 0`)
#### $6[0] *Sgt. Jerry Martinez* (`$4590[0] == 3`)
1. Soldier
2. Cleaning House
3. Conduct Unbecoming

#### $6[1] *Phil Cassidy* (`$4590[1] == 4`)
1. Cholo Victory
2. Boomshine Blowout
3. Truck Stop
4. Marked Men

#### $6[2] *Marty J Williams* (`$4590[2] == 5`)
1. Shakedown
2. Fear the Repo
3. Waking Up the Neighbors
4. O, Brothel, Where Art Thou?
5. Got Protection?

#### $6[3] *Louise Cassidy-Williams* (`$4590[3] == 4`)
1. When Funday Comes
2. Takin' Out the White-Trash
3. D.I.V.O.R.C.E.
4. To Victor, the Spoils

## Chapter 2 (`$130 == 1`)
#### $6[3] *Louise Cassidy-Williams* (`$4590[3] == 3`)
1. Hose the Hoes
2. Robbing the Cradle
3. REMOVED

#### $6[4] *Lance Vance* (`$4590[4] == 6`)
1. Jive Drive
2. The Audition
3. REMOVED
4. Caught as an Act
5. Snitch Hitch
6. From Zero to Hero

Airport's mission is actually part of Lance's Chapter 2 chain.

#### $6[5] *Umberto Robina* (`$4590[5] == 4`)
1. Nice Package
2. Balls
3. Papi Don't Screech
4. Havana Good Time

#### $6[6] *Bryan Forbes* (`$4590[6] == 4`)
1. Money for Nothing
2. REMOVED
3. Leap and Bound
4. The Bum Deal

## Chapter 3 (`$130 == 2`)
#### $6[7] *Armando and Diego Mendez* (`$4590[7] == 6`)
1. The Mugshot Longshot
2. Hostile Takeover
3. Unfriendly Competition
4. REMOVED
5. High Wire
6. Burning Bridges

#### $6[8] *Reni Wassulmaier* (`$4590[8] == 7`)
1. Accidents Will Happen
2. The Colonel's Coke
3. Kill Phil
4. Say Cheese
5. Kill Phil: Part 2
6. So Long Schlong
7. In The Air Tonight

#### $6[4] *Lance Vance* (`$4590[4] == 10`)
1. Brawn of the Dead
2. REMOVED
3. Blitzkrieg
4. Turn on, Tune in, Bug out
5. Taking the Fall
6. White Lies
7. Where it Hurts Most
8. Blitzkrieg Strikes Again
9. Lost and Found
10. Light My Pyre

#### $6[9] *Gonzalez* (`$4590[9] == 4`)
1. REMOVED
2. Home's on the Range
3. Purple Haze
4. Farewell To Arms

#### $6[10] *Leo Teal* (`$4590[10] == 5`)
1. REMOVED
2. REMOVED
3. REMOVED
4. REMOVED
5. REMOVED

`$18[10] == 1` is not required for credits.

#### $6[11] *Ricardo Diaz* (`$4590[11] == 5`)
1. Steal the Deal
2. The Exchange
3. Domo Arigato Domestoboto
4. Over the Top
5. Last Stand

## Mission Tree
![alt text](https://cdn.discordapp.com/attachments/271678478829617152/547736119522099200/gta_vcs_mission_tree.png "GTA VCS Mission Tree by Powdinet")

Mission Tree by Powdinet (Published 2019.02.20.)
