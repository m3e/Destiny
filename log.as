//PROGRESS
/*

8/6/14:  Took another long break.  Just jumped back into the code, I'm working on dialogue boxes for
when the level loads and there should be text.  There's probably a bunch of stuff I need, I don't 
remember.  Just going to start working again and see what happens.

_m3


5/25/14:  Have done a lot of work.  Besides doing major overhauls and clean ups in like 50% of my
major class's codes, I also worked out a bunch of the bugs and whatnot.  What maintains (before I
start adding more) to add right now is DoubleClick feature on inventory to auto-equip, my AI is
currently set in a way that means it might be able to break if there are too many people.  Also, I
don't want to allow enemy units to attack when someone is standing in the same square.  Someone has
suggested I move to min-max, though I'm nervous that it will make my AI either too strong, simple, and
CPU intensive, or to save cpu power, too weak and unimaginative.  I'm not sure right now, but at
least I have a greater understanding of my code now more than I have any time in the future.  These
long breaks have an odd way of changing how you read and understand your code.

_m3 -m3 m3- m3_ 

5/17/14:  Bugs... bugs everywhere..

Made a Dijktra's Algorith pathing that works well, figuring out how to make it ignore objects of the same class
and consider objects of different classes as obstacles.  Also for some reason, saving with multiple heroes is a 
problem.

_m3

UPDATE:

Uh, so I created a new variable called unitLocations which pretty much is both allylocations and enemylocations
combined.  I'm not even sure why ally&enemy are seperate, but that's fine I'm not worried about it.  Also I pretty
awesomely fixed the whole saving/loading with multiple heroes displaying so things are going pretty well.  I'm
not even sure what I'm trying to do now.  Also, I updated assessground so it wasn't using a* for every single
block.  I'm gonna work on assessground so the AI is a little tighter and not half-assed.

Also, Mark came from Cali to Texas yesterday, so he's visiting and I really want a motorcycle.  That is life right
now.

_m3

5/14/14:  Nice!  It's been about a month since I last updated.  Well, I left home on 4/23 and went to Cali.  It was
awesome and LA is fricking incredible.  Maybe one day I'll move out there, I don't know.  Right now I'm in Fort Worth,
Texas with Roy and Marianna.  It's pretty nice out here, though I've only been here a few days.  I'm just getting
resituated in this house.  It's pretty cool, anyways, onto gaming.

So I've not programmed for quite a while since I felt like I have on direction with this game.  Well, now I have 
realized that I will never get a direction if I just wait for one to come to me.  I've decided to just go forward
with any idea I have, seeing that I will never finish this game if I think I'm going to have the whole concept down
from day 1.  So fuck it, let's just move forward and see what happens.  I'm going to program so levels, maybe some
dialogue to make it feel like a story, and perhaps an award system where it makes you want to advance and collect loot
and experience.  To make the game fun you should start weak, then become stronger as you progress.  Failure should be
a possibility at all times, but the reason you continue is because you feel as though you personally assured your own
success.  Let's see, good luck Michael!

-M3

4/16/14:

Happy New Year!  Just kidding, but I haven't updated this log since last year so.. sup.  So that Best Buy job worked
out pretty well I guess.  I made some money, bought a PS4 and a big TV, then quit after 4 months.  I suppose this is 
the first log note I'll make that I'm leaving Reading, PA and moving to California and Texas for a little bit.  I 
have no idea what will happen when I'm out there.  I suppose when I look back on this little journal of mine I'll
laugh and smile and see the progress life has made.  Really though, I'm sitting here.. just thinking.. what will my
next few months be like?  I know it'll work out fine.  I'm confident.

As far as this game goes, I really stopped developing it once I started working.. hopefully while I'm travelling, 
I'll find time to program and learn new things about developing.  Roy says flash isn't dying, I need to commit and
really create something that a child can enjoy.  Screw this "let's make games easy," I want to challenge people, 
similar to how a game of chess challenges you to make a good decision.  As far as picking back up, I guess I'm
going to play around for a little, and hopefully start making classes and varied enemies, though I have yet to 
decide how I want to make varied enemies.  Seperate classes?  One class with seperate possible variables?  I'm sure
I don't want to pidgeon-hole every enemy into being basically just different numbers, but perhaps every hero/enemy
should just be considered a UNIT.  I figure that will be useful in the future when items come into play that only
affect units and such.  But being a human character and a enemy character are quite different..  We'll see!  I guess
this is hello and welcome back to the video game, Michael. 

_m3

Oh, btw, the whole M3 thing is from Best Buy Geek Squad because I was the 3rd Michael to work there. I like it, I'm
going to adopt it.  3 is also a backwards E and my el-rayes hearts were backwards 3s... E>

12/11/13:

The year is almost over, but I've done a crapload.  This year was very productive.  I've done a lot in terms
of this game.  The AI is now pretty good about finding spots.  The AI is pretty good, though it needs to be
aware that it can move around walls instead of always taking the shortest route.  I'm working on menus and
have begun to really think about game design.  This is a big moment for me since I can save/load freely, have made
level creation a simple task, am finished with buying items/equipping items/having an inventory.  Pretty much I
have a foundation.  This is where things should get interesting as I start adding more game related functionality
such as gaining levels, promotions, quests, and general game related things.

Overall things have gone well.  I wish I could have released this year, but obviously this thing will take more
time than I was hoping.  There's so much that goes into creating a game that is enjoyable than I would have
imagined.  I mean, how do you know what to set the enemy HP/dmg to?  Must I realistically keep a note of how
strong a player could possibly be at a given moment, then cater to their strength?  Because higher level monsters
give more XP, I guess that makes it much more favorable to advance.  Staying in low level areas would prohibit
you from gaining levels more quickly.  I need to facilitate a desire to advance and that's what I'm pondering.

I'm working at best buy, going out, trying to gain skills for this "real world."  Whatever, life moves on.  Hello,
Michael of the Future.  This is Michael of the Present.  What's that?  You're Michael of the Present too?  So there
is no future.  That makes sense.  _m3

2/14/13:

Been doing a lot, but primarily my focus is on AI.  This shit is hard, but I'm having slight breakthroughs.

Currently working on assessground, near the decideturns function.  About to make battleNodes class which will track 
what combination of moves is best.

1/20/13:

Implemented Save/Load feature.  Added MainMenu.  Switched to more OOP programming, seperated level1 class into 
actually being seperate functional classes.  Left working on Load.as.  Can load from main screen if continuing old save.
Need to be able to fast load if current map == the map the save is on.  Final load will be from main town while not battling.
Progress is good, money will be mine!

1/18/13:

Somehow managed to make a Save&Load menu that has.. functionality.  Currently only saving hero's stats and crudely using a 
load command to retrieve it.  I suppose it works, so I can't complain and must move forward!

1/15/13:

Stopped collision during pathfinding.  Created timers for each enemies turn.  Stopped allowing player to move during
enemy turn; this creates an issue because currently, enemyList does not splice the dead enemy.  Intentions to change that,
however must consider pros and cons.  Enemy pathfinding is selfish in terms of AI; also it seems slow sometimes.

I WAS NOT SENDING CLONES, I SENT THE REAL THINGS, OH GOD THE HUMANITY.

1/13/13:
 
MADE A (SUCCESSFUL) SUCCESSFUL PATHFINDER!!  Fuck that took a while :D It works very well, as far as finding paths
on a completely traversable terrain.  I suppose I need to implement things such as unwalkable terrain, group think,
wall detection.  However, it works.

1/12/13:

Made a (relatively) successful pathfinder using A*.  Still gives random errors during testing, I don't know why.

1/11/13:

Added a shitty TimerEvent to control shoddy enemy movement towards the first person he sees. Essentially based off
no criteria at all.  Intentions to switch to A*.

1/5/13:

Fixed neatArray to display properly.

1/4/13:

Changed assessArea from target based usage to global use once turn is ended.
^-X,Y coordinates no longer used, switched to index based off enemyList Array.

Left while setting up neatArray.  A map array that cleanly places people with single digit names.  Last issue is 
when characters move, even though I reset the Array every time, they show up in their previous locations.

*/