//
//  Program: The Dark Tower Adventures v0.05a
//     Date: 05/27/2019
//   Author: Dan Richter, aka Black Panther of Castle Rock BBS
//  Contact: Black Panther at Castle Rock BBS
//   telnet://bbs.castlerockbbs.com
//     http://www.castlerockbbs.com
//
//  This game has been a project of mine for over a year already.
//  It was inteded to be an actual door game written in Free Pascal
//  but without being able to get a doorkit to work properly, I was
//  forced to either change programming languages, or try out MPL.
//
//  There are some bugs in this game, along with some things that need
//  to be tweaked, but overall, it is playable.
//
//  If you find any bugs, or have any suggestions for improvments, please
//  let me know.
//
//  Program: gamestub
//     Date: 02/23/2015
//   Author: Darryl Perry, aka Gryphon of Cyberia BBS
//  Contact: Gryphon at Cyberia BBS
//   telnet://cyberia.darktech.org
//
//  This is a simple stub of a program written in Mystic Programming Language.
//  This will work for Mystic BBS v1.10 and possibly later versions.
//
//
//  TODO List:
//
//         Place weapons and armour into data files
//  Some   Create ansi screens
//  Done   Possibly add player fights
//  Done?  Equalize the stats for Masters - Gets too difficult too fast
//         Add an Inn, or somewhere for users to get a room to sleep
//            Will require a reset as player file will be updated
//            or write a script to update player records
//  Done   Add defense to Masters
//  Done   Generate a score file output
//         Menus should be in a repeat-until loop
//         See if I can figure out how to add IGM support
//  Done   Add some benefit to having beaten the game...
//

Uses Cfg
Uses User

Const
  pz = '|[X01|[Y24|01<|09MORE|01>'
  dailyfights = 25
  dailyhumanfights = 5


Type PlyrRec = Record         //modified from LORD structs
  Index        : Integer      //index number for storing player data
  Name         : String[40]
  Alias        : String[40]
  hit_points   : longint      //{player hit points}
  hit_max      : longint      //{hit_point max}
  weapon_num   : byte         //{weapon number}                     //changed to byte
  weapon       : string[20]   //{name of weapon}
  seen_master  : boolean      //changed to bool
  fights_left  : Byte         //{forest fights left}                //changed to byte
  human_left   : Byte         //{human fights left}                 //changed to byte
  gold         : longint      //{gold in hand}
  bank         : longint      //{gold in bank}
  def          : longint      //{total defense points }
  strength     : longint      //{total strength}
  level        : Byte         //{level of player}                   //changed to byte
  floor        : Byte         //which floor the player is on
  time         : longint      //player last played on}              //changed to longint
  arm          : string[20]   //{armour name}
  arm_num      : byte         //{armour number}                     //changed to byte
  dead         : Boolean      //changed to boolean
  exp          : longint      //{experience}
  sex          : Boolean      //changed to bool
  king         : byte         //{# of times player has won game}
End

type Plyrlist = Record
  Index        : Integer
  Alias        : String[40]
  exp          : LongInt
  level        : Byte
  dead         : Boolean
End

type monst = record               //regular enemy record
  name       : string[60];        //combine with mstr?
  strength   : longint;
  gold       : longint;
  weapon     : string[60];
  exp_points : longint;
  hit_points : longint;
  death      : string[100];
end;

type master = record                  //master enemy record
  name       : string[60];
  strength   : longint;
  def        : longint               //added defense
  gold       : longint;
  weapon     : string[60];
  exp_points : longint;
  hit_points : longint;
  death      : string[100];
end;

type wrec = record                  //weapon record
  index    : byte
  name     : string[20]
  price    : LongInt
  strength : integer
end

type arec = record                 //armour record
  index    : byte
  name     : string[20]
  price    : LongInt
  strength : integer
end

Var
  rcspath   : String                //path for all files needed to run
  PlyrFile  : String
  Plyr      : PlyrRec
  LPlyr     : PlyrRec
  ListPlyrs : Array[1..50] of Plyrlist
  PlyrCount : Integer = 0
  fMonFile  : File
  MonFile   : String
  Mon       : monst
  Mstr      : master
  MstrFile  : String
  fMstr     : File
  weapons   : Array[1..15] of wrec
  armours   : Array[1..15] of arec
  fDaily    : file
  DailyFile : String
  ScoreFile : String
  fScore    : file

procedure setweapons                   //should be in dat file
Begin
  //weapons[0].index:=0
  //weapons[0].name:='Fists'
  //weapons[0].price:=0
  //weapons[0].strength:=1
  weapons[1].index:=1
  weapons[1].name:='Stick'
  weapons[1].price:=200
  weapons[1].strength:=5
  weapons[2].index:=2
  weapons[2].name:='Dagger'
  weapons[2].price:=1000
  weapons[2].strength:=10
  weapons[3].index:=3
  weapons[3].name:='Short Sword'
  weapons[3].price:=3000
  weapons[3].strength:=20
  weapons[4].index:=4
  weapons[4].name:='Long Sword'
  weapons[4].price:=10000
  weapons[4].strength:=30
  weapons[5].index:=5
  weapons[5].name:='Huge Axe'
  weapons[5].price:=30000
  weapons[5].strength:=40
  weapons[6].index:=6
  weapons[6].name:='Bone Cruncher'
  weapons[6].price:=100000
  weapons[6].strength:=60
  weapons[7].index:=7
  weapons[7].name:='Twin Swords'
  weapons[7].price:=150000
  weapons[7].strength:=80
  weapons[8].index:=8
  weapons[8].name:='Power Axe'
  weapons[8].price:=200000
  weapons[8].strength:=120
  weapons[9].index:=9
  weapons[9].name:='Able''s Sword'
  weapons[9].price:=400000
  weapons[9].strength:=180
  weapons[10].index:=10
  weapons[10].name:='Wans''s Weapon'
  weapons[10].price:=1000000
  weapons[10].strength:=250
  weapons[11].index:=11
  weapons[11].name:='Spear Of Gold'
  weapons[11].price:=4000000
  weapons[11].strength:=350
  weapons[12].index:=12
  weapons[12].name:='Crystal Shard'
  weapons[12].price:=10000000
  weapons[12].strength:=500
  weapons[13].index:=13
  weapons[13].name:='Niras''s Teeth'
  weapons[13].price:=40000000
  weapons[13].strength:=800
  weapons[14].index:=14
  weapons[14].name:='Blood Sword'
  weapons[14].price:=100000000
  weapons[14].strength:=1200
  weapons[15].index:=15
  weapons[15].name:='Death Sword'
  weapons[15].price:=400000000
  weapons[15].strength:=1800
End

procedure setarmour                     //should be in dat file
Begin
  //armours[0].index:=0
  //armours[0].name:='Shirt'
  //armours[0].price:=0
  //armours[0].strength:=0
  armours[1].index:=1
  armours[1].name:='Coat'
  armours[1].price:=200
  armours[1].strength:=1
  armours[2].index:=2
  armours[2].name:='Heavy Coat'
  armours[2].price:=1000
  armours[2].strength:=3
  armours[3].index:=3
  armours[3].name:='Leather Vest'
  armours[3].price:=3000
  armours[3].strength:=10
  armours[4].index:=4
  armours[4].name:='Bronze Armour'
  armours[4].price:=10000
  armours[4].strength:=15
  armours[5].index:=5
  armours[5].name:='Iron Armour'
  armours[5].price:=30000
  armours[5].strength:=25
  armours[6].index:=6
  armours[6].name:='Graphite Armour'
  armours[6].price:=100000
  armours[6].strength:=35
  armours[7].index:=7
  armours[7].name:='Erdricks Armour'
  armours[7].price:=150000
  armours[7].strength:=50
  armours[8].index:=8
  armours[8].name:='Armour Of Death'
  armours[8].price:=200000
  armours[8].strength:=75
  armours[9].index:=9
  armours[9].name:='Able''s Armour'
  armours[9].price:=400000
  armours[9].strength:=100
  armours[10].index:=10
  armours[10].name:='Full Body Armour'
  armours[10].price:=1000000
  armours[10].strength:=150
  armours[11].index:=11
  armours[11].name:='Blood Armour'
  armours[11].price:=4000000
  armours[11].strength:=225
  armours[12].index:=12
  armours[12].name:='Magic Protection'
  armours[12].price:=10000000
  armours[12].strength:=300
  armours[13].index:=13
  armours[13].name:='Belars''s Mail'
  armours[13].price:=40000000
  armours[13].strength:=400
  armours[14].index:=14
  armours[14].name:='Golden Armour'
  armours[14].price:=100000000
  armours[14].strength:=600
  armours[15].index:=15
  armours[15].name:='Armour Of Lore'
  armours[15].price:=400000000
  armours[15].strength:=1000
End

Function ReadPlyr(I:Integer):Boolean                //read player info
Var Ret   : Boolean = False
Var Fptr  : File
Begin
  fAssign(Fptr,PlyrFile,66)
  fReset(Fptr)
  If IOResult = 0 Then Begin
    fSeek(Fptr,(I-1)*SizeOf(Plyr))
    If Not fEof(Fptr) Then Begin
      fReadRec(Fptr,Plyr)
      Ret:=True
    End
    fClose(Fptr)
  End
  ReadPlyr:=Ret
End

Function ReadLPlyr(I:integer):Boolean       //read user info for listing and user fights
Var Ret  : Boolean = false                  //wanted to keep it seperated from player
Var Fptr1: File
Begin
  fAssign(Fptr1,PlyrFile,66)
  fReset(Fptr1)
  If IOResult = 0 Then Begin
    fSeek(Fptr1,(I-1)*SizeOf(LPlyr))
    If Not fEof(Fptr1) Then Begin
      fReadRec(Fptr1,LPlyr)
      Ret:=True
    End
    fClose(Fptr1)
  End
  ReadLPlyr:=Ret
End

Procedure SavePlyr(I:Integer)                  //save player's record
Var Ret  : Boolean = False
Var Fptr  : File
Begin
  fAssign(Fptr,PlyrFile,66)
  fReset(Fptr)
  If IOResult = 0 Then
    fSeek(Fptr,(I-1)*SizeOf(Plyr))
  Else Begin
    Plyr.Index:=1
    fRewrite(Fptr)
  End
  fWriteRec(Fptr,Plyr)
  fClose(Fptr)
End

Procedure SaveLPlyr(I:Integer)                  //save List player's record
Var Ret  : Boolean = False
Var Fptr  : File
Begin
  fAssign(Fptr,PlyrFile,66)
  fReset(Fptr)
  If IOResult = 0 Then
    fSeek(Fptr,(I-1)*SizeOf(LPlyr))
  Else Begin
    LPlyr.Index:=1
    fRewrite(Fptr)
  End
  fWriteRec(Fptr,LPlyr)
  fClose(Fptr)
End

Function FindPlyr(RN:String):Integer          //find player in .ply file
Var Ret  : Integer = 0
Var I    : Integer = 1
Begin
  RN:=Upper(RN)
  While ReadPlyr(I) And Ret = 0 Do Begin
    If Upper(Plyr.Name)=RN Then
      Ret:=Plyr.Index
    I:=I+1
  End
  FindPlyr:=Ret
End

Function FindPlyrAlias(AL:String):Integer    //find player by alias in .ply file
Var Ret  : Integer = 0
Var I    : Integer = 1
Begin
  AL:=Upper(AL)
  While ReadLPlyr(I) And Ret = 0 Do Begin
    If Upper(LPlyr.Alias)=AL Then
      Ret:=LPlyr.Index
    I:=I+1
  End
  FindPlyrAlias:=Ret
End

Procedure Init                              //Set up files
Begin
  GetThisUser
  rcspath:=AddSlash(CfgMPEPath+'rcstdta')
  PlyrFile:=rcspath+'rcstdta.ply'
  While ReadPlyr(PlyrCount+1) Do
    PlyrCount:=PlyrCount+1
  MonFile:=rcspath+'tdtaenem.dat'
  MstrFile:=rcspath+'tdtamstr.dat'
  DailyFile:=rcspath+'rcstdta.dly'
  ScoreFile:=rcspath+'tdta.asc'
End

procedure listplayers
Var
  Fptr1     :File
  x         :Byte=1
  y         :Byte=1
  temp      :Byte
  lastrecord:Byte=1
  ch        :Char
  tmp       :String=''
Begin
  While ReadLPlyr(x) Do
  Begin
    ListPlyrs[x].Index:=LPlyr.index
    ListPlyrs[x].alias:=LPlyr.alias
    ListPlyrs[x].level:=LPlyr.level
    ListPlyrs[x].exp:=LPlyr.exp
    ListPlyrs[x].dead:=LPlyr.dead
    x:=x+1
    lastrecord:=lastrecord+1
  End
  temp:=lastrecord+1
  For x:=1 to lastrecord do
  Begin
    For y:=1 to lastrecord do
    Begin
      if ListPlyrs[x].exp > ListPlyrs[y].exp then
      Begin
        ListPlyrs[temp]:=ListPlyrs[x]
        ListPlyrs[x]:=ListPlyrs[y]
        ListPlyrs[y]:=ListPlyrs[temp]
      End
    End
  End
  ClrScr
  fAssign(fScore,ScoreFile,66)
  fReWrite(fScore)
  if IOResult<>0 then break
  WriteLn('')
  fWriteLn(fScore,'')
  WriteLn('|09  List of Players in |03The Dark Tower Adventures')
  fWriteLn(fScore,PadCt('List of Players in The Dark Tower Adventures',78,' '))
  WriteLn('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
  fWriteLn(fScore,PadCt('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-',78,' '))
  WriteLn('|09   Name |[X30Level |[X45Experience')
  fWriteLn(fScore,'   Name                       Level           Experience')
  WriteLn('')
  fWriteLn(fScore,'')
  For x:=1 to lastrecord-1 do
  Begin
    If ListPlyrs[x].exp<>0 then                //Don't display someone with 0 experience
    Begin
      Write('|09|[X04'+ListPlyrs[x].Alias+'|[X30 '+Int2Str(ListPlyrs[x].level)+'|[X45 '+StrComma(ListPlyrs[x].exp))
      tmp:=PadRt(ListPlyrs[x].Alias,30,'.')+' '+PadRt(Int2Str(ListPlyrs[x].level),16,'.')+' '+PadRt(StrComma(ListPlyrs[x].exp),15,'.'+' ')
      if ListPlyrs[x].dead then
      Begin
        WriteLn('|[X60|04-|05=|13>|12DEAD|13<|05=|04-')
        tmp:=tmp+PadRt('  -=>DEAD<=-',11,' ')
      End
      Else
        Begin
        Writeln('')
        End
      fWriteLn(fScore,tmp)
    End
  End
  fClose(fScore)
  WriteLn('')
  ReadPlyr(Plyr.index)
End

procedure endit                           //player exiting the game
begin
  ClrScr                                  //Random ANSI?
  if not FileExist(rcspath+'exitgame.ans') then
  Begin
    Writeln('|03  Quitting To The Fields...')
    Writeln('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    writeln('|09  You find a comfortable place to sleep under a small tree... ')
    writeln('')
  End
  Else DispFile(rcspath+'exitgame.ans')
  WriteLn(pz)
  ReadKey
  writeln('|09  RETURNING TO THE MUNDANE WORLD...|DE|DE|DE')
  halt
End

procedure deaduserdaily(name,monster:string)         //User was killed - daily news
Var ch  : char                                       //these could be combined
Begin
  fAssign(fDaily,DailyFile,66)
  fReset(fDaily)
  if IOResult=0 then
  Begin
    fSeek(fDaily,FSize(fDaily))
    fWriteLn(fDaily,'')
    fWriteLn(fDaily,'|00'+DateStr(datetime,1)+': |09'+name+'|00 has been killed by |09'+monster)
    fClose(fDaily)
  End
End

procedure userkilldaily(name,monster:string)        //Master was killed - daily news
Begin
  fAssign(fDaily,DailyFile,66)
  fReset(fDaily)
  if IOResult=0 then
  Begin
    fSeek(fDaily,FSize(fDaily))
    FwriteLn(fDaily,'')
    fWriteLn(fDaily,'|00'+DateStr(datetime,1)+': |01'+monster+'|00 has been defeated by |09'+name)
    fClose(fDaily)
  End
End

Procedure PlayerStat
Var ch : char
Begin
  ClrScr
  DispFile(rcspath+'stats.ans')
  Writeln('|[X02|[Y02|09  '+Plyr.Alias+'|03''s Stats...')
  WriteLn('|[X02|[Y03|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
  Writeln('|[X02|[Y04|09  Experience         : |03'+Int2Str(Plyr.exp))
  Writeln('|[X02|[Y05|09  Level              : |03'+Int2Str(Plyr.level))
  Write('|[X02|[Y06|09  HitPoints          : |03')
  if (Plyr.hit_points<0) then Plyr.hit_points:=0
  WriteLn(Int2Str(Plyr.hit_points)+'|09 of |03'+Int2Str(Plyr.hit_max))
  Writeln('|[X02|[Y07|09  Moves Left         : |03'+Int2Str(Plyr.fights_left))
  WriteLn('|[X02|[Y08|09  Player Fights Left : |03'+Int2Str(Plyr.human_left))
  Writeln('|[X02|[Y09|09  Gold In Hand       : |03'+Int2Str(Plyr.gold))
  WriteLn('|[X02|[Y10|09  Gold In Bank       : |03'+Int2Str(Plyr.bank))
  Writeln('|[X02|[Y11|09  Weapon             : |03'+Plyr.weapon)
  WriteLn('|[X02|[Y12|09  Attack Strength    : |03'+Int2Str(Plyr.strength))
  Writeln('|[X02|[Y13|09  Armour             : |03'+Plyr.arm)
  WriteLn('|[X02|[Y14|09  Defensive Strength : |03'+Int2Str(Plyr.def))
  Write('|[X02|[Y15|09  Seen Master        : |03')
  if Plyr.seen_master then writeln('Yes') else WriteLn('No')
  WriteLn('|[X02|[Y16|09  Player Floor       : |03'+Int2Str(Plyr.floor))
  WriteLn('|[X02|[Y17|09  Date Last Played   : |03'+DateStr(Plyr.time,1))
  Writeln('|[X02|[Y18|09  Times Won          : |03'+Int2Str(Plyr.king))
  Write(pz)
  ch:=readkey
End

procedure healer                    //heal your player
Var ch   : char
Var temp :integer
Var temp1:integer
Var z    : char
Begin
  ClrScr
  if not FileExist(rcspath+'healers.ans') then
  Begin
    WriteLn('')
    WriteLn('|09  The Dark Tower Adventures - |03Healers')
    WriteLn('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    WriteLn('|09  You enter the smoky healers hut.')
    WriteLn('|03  "What can I do for you today, warrior?"|09 the old')
    WriteLn('|09  healer asks.')
    WriteLn('')
    WriteLn('|09  (|03H|01)eal all possible')
    WriteLn('|09  (|03C|01)ertain amount healed')
    WriteLn('|09  (|03R|01)eturn')
  End
  Else DispFile(rcspath+'healers.ans')
  WriteLn('')
  WriteLn('|09  HitPoints: (|03'+Int2Str(Plyr.hit_points)+'|09 of |03'+Int2Str(Plyr.hit_max)+'|09)  Gold: |03'+Int2Str(Plyr.gold))
  WriteLn('|09  (it costs |155 |09 to heal 1 hitpoint')
  WriteLn('')
  WriteLn('|09  The Healers   |02(H,C,R)')
  WriteLn('')
  Write('|09  Your command, |03'+Plyr.Alias+'|09? :')
  ch:=upper(OneKey('HCR',True))
  Case ch Of
    'H': Begin
           if Plyr.hit_points<=Plyr.hit_max then
             temp:=(Plyr.hit_max-Plyr.hit_points)*5
           else Begin
             WriteLn('|03  You look fine to me...')
             WriteLn(pz)
             ch:=ReadKey
             Break
           End
           if Plyr.gold<temp then
           Begin
             temp1:=Plyr.gold/5
             temp:=temp1*5
             Plyr.gold:=Plyr.gold-temp
             Plyr.hit_points:=Plyr.hit_points+temp1
             WriteLn('|09     Restored '+Int2Str(temp1)+' hit points')
             Writeln(pz)
             ch:=ReadKey
             Break
           End
           if Plyr.gold>=temp then begin
             Plyr.gold:=Plyr.gold-temp
             Plyr.hit_points:=Plyr.hit_max
           End
           WriteLn('')
           WriteLn(pz)
           z:=ReadKey
         End
    'C': Begin
           ClrScr
           WriteLn('')
           WriteLn('|15  Healers')
           WriteLn('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
           WriteLn('')
           WriteLn('|09  HitPionts: (|03'+Int2Str(Plyr.hit_points)+'|09 of |03'+Int2Str(Plyr.Hit_max)+'|09) Gold: |03'+Int2Str(Plyr.gold))
           WriteLn('|09  (it costs |155|09 to heal 1 hitpoint)')
           WriteLn('')
           WriteLn('|09  "How many hit points would you like healed?"')
           Write('|03  Amount :')
           temp:= Str2Int(Input(30,30,1,''))
           if Plyr.hit_points+temp <= Plyr.hit_max then begin
             if temp*5<=Plyr.gold then begin
               Plyr.gold:=Plyr.gold-(temp*5)
               Plyr.hit_points:=Plyr.hit_points+temp
               WriteLn('|15     Done!')
               WriteLn('')
               WriteLn(pz)
               z:=ReadKey
               healer
             End
           End
         End
    'R': break
  End
End

procedure mstrfight                   //Fighting masters
Var MHPoint : integer                 //ANSI?
Var PHPoint : integer
Var ch      : char
Var y       : char
Var I       : word
Begin
  I:=Plyr.level
  fAssign(fMstr,MstrFile,66)
  fReset(fMstr)
  if IOResult = 0 then begin
    fSeek(fMstr,(I-1)*SizeOf(Mstr))
    If Not fEof(fMstr) Then begin
      fReadRec(fMstr,Mstr)
    End
    fClose(fMstr)
  End
  if Plyr.exp>=Mstr.strength then
  Begin
    WriteLn('')
    WriteLn('|09  You are battling |03'+Mstr.name)
    WriteLn('')
    Repeat
      WriteLn('')
      WriteLn('|09  Your Hitpoints : |03'+Int2Str(Plyr.hit_points))
      WriteLn('  |03'+Mstr.name+'|09''s Hitpoints : |03'+Int2Str(Mstr.hit_points))
      WriteLn('')
      WriteLn('|09  (|03A|01)ttack')
      WriteLn('|09  (|03S|01)tats')
      WriteLn('|09  (|03R|01)un')
      WriteLn('')
      Write('|09  Your command: ')
      ch:=Upper(OneKey('ASR',True))
      Case ch Of
        'A': Begin
               Plyr.seen_master:=true
               PHPoint:=((Plyr.strength/2)+(random(Plyr.strength/2)))-Mstr.def
               MHPoint:=((Mstr.strength/2)+(random(Mstr.strength/2)))-Plyr.def
               if PHPoint>0 then
               Begin
                 WriteLn('  You hit '+Mstr.name+' for '+Int2Str(PHPoint)+' damage!')
                 mstr.hit_points:=mstr.hit_points-PHPoint
                 if mstr.hit_points>0 then
                 Begin
                   if MHPoint>0 then
                   Begin
                     WriteLn('|04  ** |03'+mstr.name+'|09 hits you with its |03'+mstr.weapon+'|09  for |03'+Int2Str(MHPoint)+'|09 damage! |04 **|01')
                     Plyr.hit_points:=Plyr.hit_points-MHPoint
                   End
                   Else Begin
                     WriteLn('|09  ** |03'+mstr.name+'|09 attacks with its |03'+mstr.weapon+'|09 and Misses...')
                   End
                 End
               End
               Else Begin
                 Writeln('|09 Your attack missed')
                 if MHPoint>0 then
                 Begin
                   Writeln('|04 ** |03'+Mstr.name+'|09 hit you with their |03'+Mstr.weapon+'|09 for |03'+Int2Str(MHPoint)+'|09 damage! |04 **')
                   Plyr.hit_points:=Plyr.hit_points-MHPoint
                 End
               End
             End
        'S': Begin
               PlayerStat
               ClrScr
             End
        'R': Begin
               If Random(100)<=30 then break
                  Else Begin
                   MHPoint:=((mstr.strength/2)+(random(mstr.strength/2)))-Plyr.def
                   if MHPoint>0 then
                   Begin
                      WriteLn('|04  ** |03'+mstr.name+'|09 hits you with its |03'+mstr.weapon+'|09 for |03'+Int2Str(MHPoint)+'|09 damage! |04 **')
                     Plyr.hit_points:=Plyr.hit_points-MHPoint
                   End
                   Else Begin
                     WriteLn('')
                     WriteLn('|01  ** |03'+mstr.name+' |09attacks with its |03'+mstr.weapon+' |09and Misses...')
                   End
                 End
            End
      End
    Until (Plyr.hit_points<=0)or(mstr.hit_points<=0)
    if Plyr.hit_points<=0 then begin
      Plyr.dead:=true
      Plyr.floor:=Plyr.level
      deaduserdaily(Plyr.alias,mstr.name)
      SavePlyr(Plyr.index)
      WriteLn('|03  Sorry, but you''re dead. Come back tomorrow...')
      endit
    End
    if mstr.hit_points<=0 then begin
      Plyr.gold:=Plyr.gold+mstr.gold
      Plyr.exp:=Plyr.exp+mstr.exp_points
      Plyr.seen_master:=true
      Plyr.level:=Plyr.level+1
      Plyr.hit_max:=Plyr.hit_max*2
      Plyr.hit_points:=Plyr.hit_max
      Plyr.level:=Plyr.floor
      WriteLn('')
      WriteLn('  '+Mstr.death)
      WriteLn('')
      userkilldaily(Plyr.alias,'Master '+mstr.name)
      break
    End
    Else Plyr.floor:=Plyr.level
    WriteLn(pz)
    y:=ReadKey
  End
  Else Begin
      WriteLn('|09         I don''t think you''re ready yet...')
      Plyr.floor:=Plyr.level
      WriteLn(pz)
      ch:=ReadKey
    End
End

procedure monfight                      //ANSI screen?
Var x       : byte=0                    //Monster fights
Var MHPoint : integer
Var PHPoint : integer
Var ch      : char
Var y       : char
Var temp    : byte
Begin
  if Plyr.fights_left=0 then Begin
    WriteLn('|09  You have no moves left for today')
    Break
  End
  fAssign(fMonFile,MonFile,66)
  fReset(fMonFile)
  if IoResult = 0 then Begin
    if (Plyr.hit_points>0)and(Plyr.fights_left>0) then
    Begin
      temp:=(Plyr.floor-1)*11
      Repeat x:=Random(130)+1
      until (x<=Plyr.floor*11)and(x>=temp+1)
      fSeek(fMonFile,(x-1)*SizeOf(mon))
      fReadRec(fMonFile,mon)
      fClose(fMonFile)
      ClrScr
      WriteLn('|09  **|15FIGHT|09**')
      WriteLn('')
      WriteLn('|09  You have encounted '+mon.name)
      Repeat
        WriteLn('')
        WriteLn('|09  Your Hitpoints : '+Int2Str(Plyr.hit_points))
        WriteLn('|09  '+mon.name+'''s Hitpoints : '+Int2Str(mon.hit_points))
        WriteLn('')
        WriteLn('|09  (|03A|09)ttack')
        WriteLn('|09  (|03S|09)tats')
        WriteLn('|09  (|03R|09)un')
        WriteLn('')
        Write('|09  Your command, |03'+Plyr.alias+' : ')
        ch:=Upper(OneKey('ASR',True))
        Case ch Of
          'A': Begin
                 PHpoint:=((Plyr.strength/2)+(random(Plyr.strength/2)))
                 MHPoint:=((mon.strength/2)+(random(mon.strength/2)))-Plyr.def
                 WriteLn('')
                 WriteLn('|09  You hit '+mon.name+' for '+Int2Str(PHpoint)+' damage!')
                 mon.hit_points:=mon.hit_points-PHPoint
                 if mon.hit_points>0 then
                 Begin
                   if MHPoint>0 then
                   Begin
                     WriteLn('|04  ** |03'+mon.name+'|09 hits you with its |03'+mon.weapon+'|09 for |03'+Int2Str(MHPoint)+'|09 damage! |04 **')
                     Plyr.hit_points:=Plyr.hit_points-MHPoint
                   End
                   Else Begin
                     WriteLn('')
                     WriteLn('|04  ** |03'+mon.name+' |09attacks with its |03'+mon.weapon+' |09and Misses...')
                   End
                 End
               End
          'S': Begin
                 PlayerStat
                 ClrScr
               End
          'R': Begin
                 If Random(100)<=30 then break
                 Else Begin
                   MHPoint:=((mon.strength/2)+(random(mon.strength/2)))-Plyr.def
                   if MHPoint>0 then
                   Begin
                      WriteLn('|04  ** |03'+mon.name+'|09 hits you with its |03'+mon.weapon+'|09 for |03'+Int2Str(MHPoint)+'|09 damage! |04 **')
                     Plyr.hit_points:=Plyr.hit_points-MHPoint
                   End
                   Else Begin
                     WriteLn('')
                     WriteLn('|01  ** |03'+mon.name+' |09attacks with its |03'+mon.weapon+' |09and Misses...')
                   End
                 End
               End
        End
      Until (Plyr.hit_points<=0)or(mon.hit_points<=0)
      if Plyr.hit_points<=0 then begin
        Plyr.dead:=true
        deaduserdaily(Plyr.alias,mon.name)
        SavePlyr(Plyr.index)
        WriteLn('|09  Sorry, but you''re dead. Come back tomorrow...')
        WriteLn(pz)
        ch:=ReadKey
        endit
      End
      if mon.hit_points<=0 then begin
        Plyr.gold:=Plyr.gold+mon.gold
        Plyr.exp:=Plyr.exp+mon.exp_points
        Plyr.fights_left:=Plyr.fights_left-1
        WriteLn('')
        WriteLn('  |09'+mon.death)
        WriteLn('')
      End
      WriteLn(pz)
      y:=ReadKey
    End
  End
End

procedure setstats1               //reset stats for restart
Begin
  Plyr.hit_points:=20
  Plyr.hit_max:=20
  Plyr.weapon_num:=Plyr.king+1
  Plyr.weapon:=weapons[Plyr.weapon_num].name
  Plyr.seen_master:=false
  Plyr.fights_left:=dailyfights
  Plyr.human_left:=dailyhumanfights
  Plyr.gold:=500
  Plyr.bank:=0
  Plyr.def:=1
  Plyr.strength:=5
  Plyr.level:=1
  Plyr.time:=DateTime
  Plyr.arm_num:=Plyr.king+1
  Plyr.arm:=armours[Plyr.arm_num].name
  Plyr.dead:=false
  Plyr.exp:=1
  Plyr.king:=Plyr.king+1
  Plyr.floor:=1
  SavePlyr(Plyr.index)
End

procedure endbattle                //Final battle
Var MHPoint : integer
Var PHPoint : integer
Var ch      : char
Var y       : char
Var FBat    : PlyrRec
Begin
  FBat:=Plyr
  ClrScr
  WriteLn('')
  WriteLn('|09  You walk into a long, dark room.|DE|DE|DE|DE|DE')
  WriteLn('|09  As you walk forward, you hear the door slam behind you.|DE|DE|DE|DE|DE')
  WriteLn('|09  A shadow appears from the far side of the room.|DE|DE|DE|DE|DE')
  WriteLn('')
  WriteLn('|09  The shadow comes closer, closer.|DE|DE|DE|DE|DE')
  WriteLn('|09  The footsteps get louder, louder.|DE|DE|DE|DE|DE')
  WriteLn('')
  WriteLn('|09  You are finally able to see a shape appearing.|DE|DE|DE|DE|DE')
  WriteLn('|09  As it come into view...|DE|DE|DE|DE|DE|DE')
  WriteLn('|09  You start to make out the face...|DE|DE|DE|DE|DE|DE')
  WriteLn('|09  It can''t be...|DE|DE|DE|DE|DE|DE')
  WriteLn('')
  WriteLn('|09  You find yourself face to face with... |DE|DE|DE|DE|DE|DE|DE|DE')
  WriteLn('')
  WriteLn('|09  YOURSELF!??!?!?!?!|DE|DE|DE|DE|DE')
  WriteLn('')
  WriteLn('|09  "Prepare for battle..."|DE|DE|DE|DE|DE')
  ClrScr
  WriteLn('')
  WriteLn('|09  You are battling |04'+FBat.alias)
  WriteLn('')
  Repeat
    WriteLn('')
    WriteLn('|01  Your Hitpoints : |09'+Int2Str(Plyr.hit_points))
    WriteLn('|09  '+FBat.alias+'|01''s Hitpoints : |09'+Int2Str(FBat.hit_points))
    WriteLn('')
    WriteLn('|01  (|09A|01)ttack')
    WriteLn('')
    Write('|01  Your command: ')
    ch:=Upper(OneKey('A',True))
    Case ch Of
      'A': Begin
             Plyr.seen_master:=true
             PHPoint:=((Plyr.strength/2)+(random(Plyr.strength/2)))
             MHPoint:=((FBat.strength/2)+(random(FBat.strength/2)))
             WriteLn('  You hit '+FBat.alias+' for '+Int2Str(PHPoint)+' damage!')
             FBat.hit_points:=FBat.hit_points-PHPoint
             if FBat.hit_points>0 then
             Begin
               if MHPoint>0 then
               Begin
                 WriteLn('|04  ** |04'+FBat.alias+'|01 hits you with its |03'+FBat.weapon+'|01 for |03'+Int2Str(MHPoint)+'|01 damage! |04 **|01')
                 Plyr.hit_points:=Plyr.hit_points-MHPoint
               End
               Else
               Begin
                 WriteLn('')
                 WriteLn('|01  ** |04'+FBat.alias+'|01 attacks with its |03'+FBat.weapon+'|01 and Misses...')
               End
             End
           End
    End
  Until (Plyr.hit_points<=0)or(FBat.hit_points<=0)
  Plyr.king:=PLyr.king+1
  SavePlyr(Plyr.index)
  WriteLn(pz)
  y:=ReadKey
  setstats1
  DispFile(rcspath+'beach')
  WriteLn('|[X01|[Y23'+pz)
  ch:=ReadKey
  ClrScr
  WriteLn('')
  WriteLn('|09  You wake up on a beach...|DE|DE')
  halt
End

procedure foundhealth
Var ch : char
Begin
  ClrScr
  DispFile(rcspath+'evnthlth.ans')
  WriteLn('|[X05|[Y09|03A |09vial containing a green liquid in it...')
  WriteLn('|[X05|[Y11|03Y|09ou feel brave and drink it...')
  WriteLn('|[X05|[Y13|03A|09fter drinking it...')
  WriteLn('|[X05|[Y15|03Y|09ou feel refreshed!')
  Plyr.hit_points:=Plyr.hit_max
  Plyr.fights_left:=Plyr.fights_left-1
  SavePlyr(Plyr.index)
  WriteLn(pz)
  ch:=ReadKey
End

procedure losehealth
Var ch : char
Begin
  ClrScr
  DispFile(rcspath+'evnthlth.ans')
  WriteLn('|[X05|[Y09|03A|09 vial containing a green liquid in it...')
  WriteLn('|[X05|[Y11|03Y|09ou feel brave and drink it...')
  WriteLn('|[X05|[Y13|03A|09fter drinking it...')
  WriteLn('|[X05|[Y15|03Y|09ou feel weaker.')
  Plyr.hit_points:=Plyr.hit_points/2
  Plyr.fights_left:=Plyr.fights_left-1
  SavePlyr(Plyr.index)
  WriteLn(pz)
  ch:=ReadKey
End

procedure foundweapon
Var ch : char
Begin
  ClrScr
  if Plyr.weapon_num<15 then
  Begin
    DispFile(rcspath+'evntwepn.ans')
    WriteLn('|[X05|[Y08|03A|09n upgraded weapon!')
    WriteLn('|[X05|[Y10|03Y|09our |03'+weapons[Plyr.weapon_num].name+'|09 is now a |03'+weapons[Plyr.weapon_num+1].name+'|09!')
    Plyr.weapon_num:=Plyr.weapon_num+1
    Plyr.weapon:=weapons[Plyr.weapon_num].name
    Plyr.strength:=weapons[Plyr.weapon_num].strength
    Plyr.fights_left:=Plyr.fights_left-1
    SavePlyr(Plyr.index)
    WriteLn(pz)
    ch:=ReadKey
  End
  Else Begin
    WriteLn('')
    WriteLn('|09  You cannot upgrade your weapon anymore.')
    WriteLn('')
    WriteLn('|09  You already have the highest level weapon!')
    WriteLn(pz)
    ch:=ReadKey
  End
End

procedure loseweapon
Var ch : char
Begin
  ClrScr
  DispFile(rcspath+'evntwepn.ans')
  if Plyr.weapon_num>1 then
  Begin
    WriteLn('|[X05|[Y08|03Y|09our |03'+weapons[Plyr.weapon_num].name+'|09 got')    WriteLn('|[X05|[Y10|09downgraded to |03'+weapons[Plyr.weapon_num-1].name+'|09...')
    Plyr.weapon_num:=Plyr.weapon_num-1
    Plyr.weapon:=weapons[Plyr.weapon_num].name
    Plyr.strength:=weapons[Plyr.weapon_num].strength
  End
  Else Begin
    WriteLn('|[X05|[Y08|03Y|09our |03'+Plyr.weapon+'|09 got')
    WriteLn('|[X05|[Y10|09downgraded to |03Fists|09...')
    WriteLn('|[X05|[Y12|09There is no armour lower than what you have...')
    Plyr.weapon_num:=0
    Plyr.weapon:='Fists'
    Plyr.strength:=1
  End
  Plyr.fights_left:=Plyr.fights_left-1
  SavePlyr(Plyr.index)
  WriteLn(pz)
  ch:=ReadKey
End

procedure foundarmour
Var ch: char
Begin
  if Plyr.arm_num<15 then
  Begin
    ClrScr
    DispFile(rcspath+'evntarmr.ans')
    WriteLn('|[X05|[Y08|03N|09ew upgraded armour!')
    WriteLn('|[X05|[Y10|03Y|09our |03'+armours[Plyr.arm_num].name+'|09 is now a |03'+armours[Plyr.arm_num+1].name+'|09!')
    Plyr.arm_num:=Plyr.arm_num+1
    Plyr.arm:=armours[Plyr.arm_num].name
    Plyr.def:=armours[Plyr.arm_num].strength
    Plyr.fights_left:=Plyr.fights_left-1
    SavePlyr(Plyr.index)
    WriteLn(pz)
    ch:=ReadKey
  End
  Else Begin
    ClrScr
    WriteLn('')
    WriteLn('|09  You cannot upgrade your armour anymore.')
    WriteLn('')
    WriteLn('|09  You are at the highest armour already!')
    WriteLn(pz)
    ch:=ReadKey
  End
End

procedure losearmour
Var ch: char
Begin
  ClrScr
  DispFile(rcspath+'evntarmr.ans')
  WriteLn('|[X05|[Y08|03A|09n armour magnet!')
  if Plyr.arm_num>1 then
  Begin
    WriteLn('|[X05|[Y10|03Y|09our |03'+armours[Plyr.arm_num].name+'|09 got')
    WriteLn('|[X05|[Y12|09downgraded to |03'+armours[Plyr.arm_num-1].name+'|09...')
    Plyr.arm_num:=Plyr.arm_num-1
    Plyr.arm:=armours[Plyr.arm_num].name
    Plyr.def:=armours[Plyr.arm_num].strength
  End
  Else Begin
    WriteLn('|[X05|[Y10|03Y|09our |03'+Plyr.arm+'|09 got')
    WriteLn('|[X05|[Y12|09downgraded to |03Shirt|09...')
    WriteLn('|[X05|[Y14|09There is no armour lower than what you have...')
    Plyr.arm_num:=0
    Plyr.arm:='Shirt'
    Plyr.def:=0
  End
  Plyr.fights_left:=Plyr.fights_left-1
  SavePlyr(Plyr.index)
  WriteLn(pz)
  ch:=ReadKey
End


procedure foundgold
Var ch   : char
Var temp :word=0
Var temp1:word=0
Begin
  ClrScr
  if not FileExist(rcspath+'evntgold.ans') then WriteLn('|X[05|[Y05|09While looking around the room, you find...|DE|DE|DE')
  Else DispFile(rcspath+'evntgold.ans')
  WriteLn('|[X05|[Y08|03A|09 bag of |03GOLD!')
  temp:=Random(10)+1
  temp1:=(Plyr.gold/temp)
  WriteLn('|[X05|[Y10|03T|09he bag contains |03'+Int2Str(temp1)+'|09 gold!')
  Plyr.gold:=Plyr.gold+temp1
  Plyr.fights_left:=Plyr.fights_left-1
  SavePlyr(Plyr.index)
  WriteLn('|[X01|[Y23'+pz)
  ch:=ReadKey
End

procedure losegold
Var ch   : char
Var temp :word=0
Var temp1:word=0
Begin
  ClrScr
  if not FileExist(rcspath+'evntgold.ans') then WriteLn('|X[05|[Y05|09While looking around the room, you find...|DE|DE|DE')
  Else DispFile(rcspath+'evntgold.ans')
  WriteLn('|[X05|[Y08|03A|09 Gold Eating reptile!')
  temp:=Random(10)+5
  temp1:=(Plyr.gold/temp)
  WriteLn('|[X05|[Y10|03I|09t eats |03'+Int2Str(temp1)+'|09 gold!')
  Plyr.gold:=Plyr.gold-temp1
  Plyr.fights_left:=Plyr.fights_left-1
  SavePlyr(Plyr.index)
  WriteLn('|[X01|[Y23'+pz)
  ch:=ReadKey
End

procedure forest                            //Needs better ANSI
Var
  ch : char
  x  : char
  ran: Boolean=false
  tmp: integer
  done:Boolean=false
Begin
  ClrScr
  //Plyr.seen_master:=false
  If Plyr.hit_points<=0 then            // Comment out for testing
  Begin
    WriteLn('           |09You''re Dead. Come back again tomorrow and try')
    WriteLn(pz)
    Plyr.dead:=true
    Plyr.gold:=0
    SavePlyr(Plyr.index)
    x:=ReadKey
    endit
  End
  repeat
  if not FileExist(rcspath+'tower.ans') then
  Begin
    WriteLn('|09  You are currently on floor |03'+Int2Str(Plyr.floor)+'|09 of the tower.')
    WriteLn('|09  Take a look around. You never know what you might find...')
    WriteLn('')
    WriteLn('')
    WriteLn('|09  (|01L|03)ook around the room                          (|01H|09)ealers''s Hut')
    WriteLn('')
    WriteLn('|09  (|01U|01)p a level                                    (|01D|09)own a level')
    WriteLn('')
    if Plyr.level=12 then WriteLn('|03  (|11O|03)|09pen the final door')
    WriteLn('|09  (|01R|03)eturn to town')
    WriteLn('')
  End
  else Begin
    DispFile(rcspath+'tower.ans')
    Write('|[X59|[Y04|03'+Int2Str(Plyr.floor))
    if Plyr.level=12 then WriteLn('|[X03|[Y08|03(|11O|03)|09pen the final door')
  End
  WriteLn('|[X05|[Y20|09HitPoints: (|03'+Int2Str(Plyr.hit_points)+'|09 of |03'+Int2Str(Plyr.hit_max)+'|09)  Moves: |03'+Int2Str(Plyr.fights_left)+'|09 Gold: |03'+Int2Str(Plyr.gold))
  WriteLn('|[X05|[Y21|09The Tower - Floor |03'+Int2Str(Plyr.floor)+'    |09(L,H,U,D,R)')
  Write('|[X05|[Y23|03Y|09our command, |03'+Plyr.Alias+'|09? : ')
  ch:=''
  ch:=upper(OneKey('LHRUDO',True))
  Case ch Of
    'R': Begin
           done:=true
           break
         End
    'O': Begin
           If Plyr.level=12 then
           Begin
             endbattle
           End
         End
    'U': Begin
         Plyr.floor:=Plyr.floor+1
         if Plyr.floor>12 then Plyr.floor:=12
         if Plyr.floor>Plyr.level then
         Begin
          if Plyr.seen_master then
           Begin
             WriteLn('|09       You are only allowed to fight a master once per day.')
             WriteLn('|09       Please try again tomorrow')
             Plyr.floor:=Plyr.level
             WriteLn(pz)
             x:=ReadKey
           End
           if not Plyr.seen_master then
           Begin
             WriteLn('|09       You will need to prove you are strong enough for the next level.')
             WriteLn('|09')
             WriteLn('|09       If you win a battle with the Master, you will be allowed entrance.')
             WriteLn('')
             WriteLn(pz)
             x:=ReadKey
             mstrfight
           End
          End
         End
    'D': Begin
         Plyr.floor:=Plyr.floor-1
         if Plyr.floor<1 then Plyr.floor:=1
         forest
         End
    'H': Begin
           healer
         End
    'L': Begin
           if Plyr.fights_left>0 then
           Begin
             tmp:=(random(200)+1)
             Case tmp Of
             5,6,7 : Begin
                       foundgold
                       ran:=true
                       End
             97 : Begin
                       losegold
                       ran:=true
                       End
             89,91,92,94 : Begin
                       foundhealth
                       ran:=true
                       End
             12 : Begin
                       losehealth
                       ran:=true
                       End
             65 : Begin
                       foundweapon
                       ran:=true
                       End
             78 : Begin
                       foundarmour
                       ran:=true
                       End
             23 : Begin
                       loseweapon
                       ran:=true
                       End
             37 : Begin
                       losearmour
                       ran:=true
                       End
             End
             if not ran then monfight
             ch:=''
           End
           Else
           Begin
             WriteLn('')
             WriteLn('|09  You are out of moves for today.')
             WriteLn('')
             //Plyr.fights_left:=Plyr.fights_left+50
             WriteLn(pz)
             x:=ReadKey
             done:=true
           End
           ran:=false
         End
  End
  until done
End

procedure bank
Var ch : char
Var x  : char
Var dep: LongInt
Begin
  ClrScr
  if not FileExist(rcspath+'bank.ans') then
  Begin
    WriteLn('')
    WriteLn('|03  T|09he |03D|09ark |03T|09ower |03A|09dventures - |09 Bank')
    WriteLn('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    WriteLn('|09  A polite clerk approaches.  |03"Can I help you sir?"')
    WriteLn('')
    WriteLn('|09  (|03D|09)eposit Gold')
    WriteLn('|09  (|03W|09)ithdraw Gold')
    WriteLn('|09  (|03R|09)eturn to Town')
    WriteLn('')
  End
  Else DispFile(rcspath+'bank.ans')
  WriteLn('|[X05|[Y16|09Gold In Hand: |03'+StrComma(Plyr.gold)+' |09Gold In Bank: |03'+StrComma(Plyr.bank))
  WriteLn('|[X05|[Y18|09The Bank |01(W,D,R,Q)')
  WriteLn('|[X05|[Y19|09Your command, |03'+Plyr.Alias+'? :')
  ch:=upper(OneKey('WDRQ',True))
  Case ch Of
    'D': Begin
           if not FileExist(rcspath+'bankd.ans') then
           Begin
             WriteLn('')
             WriteLn('|09  Ye Olde Bank')
             WriteLn('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
           End
           else DispFile(rcspath+'bankd.ans')
           WriteLn('|[X05|[Y16|09Gold In Hand: |03'+StrComma(Plyr.gold)+' |09Gold In Bank: |03'+StrComma(Plyr.bank))
           WriteLn('|[X05|[Y18|09"How much gold would you like to deposit?"')
           Write('|[X05|[Y19|09Amount: ')
           dep:= Str2Int(Input(30,30,1,''))
           if dep <= Plyr.gold then begin
             Plyr.bank:=Plyr.bank+dep
             Plyr.gold:=Plyr.gold-dep
             WriteLn('')
             WriteLn('|03         D|09one! |03'+StrComma(dep)+'|09 deposited.')
           End
           Else WriteLn('|03         You don''t have that much...')
           WriteLn(pz)
           x:=ReadKey
           bank
         End
    'W': Begin
           if not FileExist(rcspath+'bankw.ans') then
           Begin
             WriteLn('')
             WriteLn('|09  Ye Olde Bank')
             WriteLn('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
           End
           else DispFile(rcspath+'bankw.ans')
           WriteLn('|[X05|[Y16|09Gold In Hand: |03'+StrComma(Plyr.gold)+' |09Gold In Bank: |03'+StrComma(Plyr.bank))
           WriteLn('|[X05|[Y18|09"How much gold would you like to withdraw?"')
           Write('|[X05|[Y19|09Amount: ')
           dep:= Str2Int(Input(30,30,1,''))
           if dep <= Plyr.bank then begin
             Plyr.gold:=Plyr.gold+dep
             Plyr.bank:=Plyr.bank-dep
             WriteLn('')
             WriteLn('|03          D|09one! |03'+StrComma(dep)+'|03 withdrawn.')
           End
           Else WriteLn('|03          You don''t have that much...')
           WriteLn(pz)
           x:=ReadKey
           bank
         End
    'R': break
    'Q': break
  End
End

procedure weaponshop
Var ch : string[2]
Var x  : char
Begin
  ClrScr
  if not FileExist(rcspath+'weapon.ans') then
  Begin
    WriteLn('')
    WriteLn('|09  Welcome to the Weapon Shop')
    WriteLn('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    WriteLn('|03  "What can I get for you?", |09the nice young woman asked.')
    WriteLn('')
    WriteLn('|09  (|03A|09) Stick                     200  |09  (|03I|09) Able''s Sword          400,000')
    WriteLn('|09  (|03B|09) Dagger                  1,000  |09  (|03J|09) Wan''s Weapon        1,000,000')
    WriteLn('|09  (|03C|09) Short Sword             3,000  |09  (|03K|09) Spear of Gold       4,000,000')
    WriteLn('|09  (|03D|09) Long Sword             10,000  |09  (|03L|09) Crystal Shard      10,000,000')
    WriteLn('|09  (|03E|09) Huge Axe               30,000  |09  (|03M|09) Niras''s Teeth      40,000,000')
    WriteLn('|09  (|03F|09) Bone Cruncher         100,000  |09  (|03N|09) Blood Sword       100,000,000')
    WriteLn('|09  (|03G|09) Twin Swords           150,000  |09  (|03O|09) Death Sword       400,000,000')
    WriteLn('|09  (|03H|09) Power Axe             200,000')
    WriteLn('')
    WriteLn('|09  (|03S|09) Sell your current weapon')
    WriteLn('|09  (|03R|09) I changed my mind...')
  end
  else dispfile(rcspath+'weapon.ans')
  WriteLn('')
  WriteLn('|03  '+StrComma(Plyr.gold)+'|09 gold in hand - |03'+Plyr.weapon)
  Write('|09  Your command : ')
  ch:=upper(OneKey('ABCDEFGHIJKLMNORS',True))
  if upper(ch)='R' then
  Begin
    WriteLn('')
    WriteLn('|03         Well, maybe next time...')
    WriteLn(pz)
    x:=ReadKey
    break
  End
  if ch='A'then ch:='1'                  //this could be made cleaner
  if ch='B'then ch:='2'
  if ch='C'then ch:='3'
  if ch='D'then ch:='4'
  if ch='E'then ch:='5'
  if ch='F'then ch:='6'
  if ch='G'then ch:='7'
  if ch='H'then ch:='8'
  if ch='I'then ch:='9'
  if ch='J'then ch:='10'
  if ch='K'then ch:='11'
  if ch='L'then ch:='12'
  if ch='M'then ch:='13'
  if ch='N'then ch:='14'
  if ch='O'then ch:='15'
  if ch='S'then
  Begin
    WriteLn('')
    If InputYN('|09      Are you sure you want to sell your |03'+Plyr.weapon+'|09 for |03'+StrComma((weapons[Plyr.weapon_num].price)/2)+'? ') then
    Begin
      WriteLn('')
      Plyr.gold:=Plyr.gold+weapons[Plyr.weapon_num].price/2
      Plyr.weapon_num:=0
      Plyr.weapon:=weapons[Plyr.weapon_num].name
      Plyr.strength:=weapons[Plyr.weapon_num].strength
      WriteLn('|09         Sold!')
      ch:=''
      WriteLn(pz)
      x:=ReadKey
      weaponshop
    End
    Else
    Begin
      WriteLn('')
      WriteLn('|09         Maybe next time...')
      WriteLn(pz)
      ch:=''
      x:=ReadKey
      weaponshop
    End
  End
  if (Str2Int(ch)<16)and(Str2Int(ch)>0)then
  Begin
    if Plyr.gold >= weapons[Str2Int(ch)].price then
    Begin
      Plyr.gold:=Plyr.gold-weapons[Str2Int(ch)].price
      Plyr.weapon_num:=weapons[Str2Int(ch)].index
      Plyr.weapon:=weapons[Str2Int(ch)].name
      Plyr.strength:=weapons[Str2Int(ch)].strength
      WriteLn('')
      WriteLn('|09       You have purchased the |03'+Plyr.weapon+'|09 for |03'+StrComma(weapons[Str2Int(ch)].price)+'|09 gold')
      ch:=''
      WriteLn(pz)
      x:=ReadKey
      weaponshop
    End
    Else
    Begin
      WriteLn('|09       You can''t afford the |03'+weapons[Str2Int(ch)].name+'|09 for |03'+StrComma(weapons[Str2Int(ch)].price)+'|09 gold')
      WriteLn('')
      ch:=''
      WriteLn(pz)
      x:=ReadKey
      weaponshop
    End
  End
End

procedure armourshop
Var ch : string[2]
Var x  : char
Begin
  ClrScr
  if not FileExist(rcspath+'armour.ans') then
  Begin
    WriteLn('')
    WriteLn('|09  Welcome to the Armour Shop')
    WriteLn('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    WriteLn('|03  "What can I get for you?", |09the nice young woman asked.')
    WriteLn('')
    WriteLn('|09  (|03A|09) Coat                      200  |09  (|03I|09) Able''s Armour          400,000')
    WriteLn('|09  (|03B|09) Heavy Coat              1,000  |09  (|03J|09) Full Body Armour     1,000,000')
    WriteLn('|09  (|03C|09) Leather Vest            3,000  |09  (|03K|09) Blood Armour         4,000,000')
    WriteLn('|09  (|03D|09) Bronze Armour          10,000  |09  (|03L|09) Magic Protection    10,000,000')
    WriteLn('|09  (|03E|09) Iron Armour            30,000  |09  (|03M|09) Belars'' Mail        40,000,000')
    WriteLn('|09  (|03F|09) Graphite Armour       100,000  |09  (|03N|09) Golden Armour      100,000,000')
    WriteLn('|09  (|03G|09) Edricks Armour        150,000  |09  (|03O|09) Armour Of Lore     400,000,000')
    WriteLn('|09  (|03H|09) Armour of Death       200,000')
    WriteLn('')
    WriteLn('|09  (|03S|09) Sell your current armour')
    WriteLn('|09  (|03R|09) I changed my mind...')
  end
  else dispfile(rcspath+'armour.ans')
  WriteLn('')
  WriteLn('|03  '+StrComma(Plyr.gold)+'|09 gold in hand - |03'+Plyr.arm)
  Write('|09  Your command : ')
  ch:=upper(OneKey('ABCDEFGHIJKLMNORS',True))
  if upper(ch)='R' then
  Begin
    WriteLn('')
    WriteLn('|09         Well, maybe next time...')
    WriteLn(pz)
    x:=ReadKey
    break
  End
  if ch='A'then ch:='1'             //This should be reworked to make cleaner
  if ch='B'then ch:='2'
  if ch='C'then ch:='3'
  if ch='D'then ch:='4'
  if ch='E'then ch:='5'
  if ch='F'then ch:='6'
  if ch='G'then ch:='7'
  if ch='H'then ch:='8'
  if ch='I'then ch:='9'
  if ch='J'then ch:='10'
  if ch='K'then ch:='11'
  if ch='L'then ch:='12'
  if ch='M'then ch:='13'
  if ch='N'then ch:='14'
  if ch='O'then ch:='15'
  if ch='S'then
  Begin
    WriteLn('')
    If InputYN('|09      Are you sure you want to sell your |03'+Plyr.arm+'|09 for |03'+StrComma((armours[Plyr.arm_num].price)/2)+'? ') then
    Begin
      WriteLn('')
      Plyr.gold:=Plyr.gold+armours[Plyr.arm_num].price/2
      Plyr.arm_num:=0
      Plyr.arm:=armours[Plyr.arm_num].name
      Plyr.def:=armours[Plyr.arm_num].strength
      WriteLn('|09          Sold!')
      ch:=''
      WriteLn(pz)
      x:=ReadKey
      armourshop
    End
    Else Begin
      WriteLn('')
      WriteLn('|09          Maybe next time...')
      WriteLn(pz)
      ch:=''
      x:=ReadKey
      armourshop
    End
  End
  if (Str2Int(ch)<16)and(Str2Int(ch)>0)then
  Begin
    if Plyr.gold >= armours[Str2Int(ch)].price then
    Begin
      Plyr.gold:=Plyr.gold-armours[Str2Int(ch)].price
      Plyr.arm_num:=armours[Str2Int(ch)].index
      Plyr.arm:=armours[Str2Int(ch)].name
      Plyr.def:=armours[Str2Int(ch)].strength
      WriteLn('')
      WriteLn('|09         You have purchased the |03'+Plyr.arm+'|09 for |03'+StrComma(armours[Str2Int(ch)].price)+'|09 gold')
      ch:=''
      WriteLn(pz)
      x:=ReadKey
      armourshop
    End
    Else
    Begin
      WriteLn('|09         You can''t afford the |03'+armours[Str2Int(ch)].name+'|09 for |03'+StrComma(armours[Str2Int(ch)].price)+'|09 gold')
      WriteLn('')
      ch:=''
      WriteLn(pz)
      x:=ReadKey
      armourshop
    End
  End
End

procedure UserFight                       //fight other users
Var
  FgtInd  : byte
  ch      : char
  MHPoint : integer
  PHPoint : integer
  x       : char
Begin
  listplayers
  WriteLn('|09  Who would you like to attack?')
  Write('|09  Enter their name here: |03')
  FgtInd:=FindPlyrAlias(Input(30,30,1,''))      //finds the index number of user
  if (ReadLPlyr(FgtInd))and(LPlyr.dead=false)and(LPlyr.index<>Plyr.index) then  //user exists, and isn't dead
  Begin
    WriteLn('|09 Do you really want to battle |03'+LPlyr.alias+'|09? (Y/N)')
    x:=ReadKey
    if upper(x)='Y' then
    begin
      ReadPlyr(Plyr.index)
      LPlyr.hit_points:=LPlyr.hit_max
      WriteLn('|[X05|09You are battling |03'+LPlyr.alias)
      WriteLn('')
      Repeat
        WriteLn('')
        WriteLn('|03  '+Plyr.alias+'''s |09Hitpoints : |03'+Int2Str(Plyr.hit_points))
        WriteLn('|03  '+LPlyr.alias+'''s |09Hitpoints : |03'+Int2Str(LPlyr.hit_points))
        WriteLn('')
        WriteLn('|09  (|03A|09)ttack')
        WriteLn('|09  (|03S|09)tats')
        WriteLn('|09  (|03R|09)un')
        WriteLn('')
        Write('|09  Your command: ')
        ch:=Upper(OneKey('ASR',True))
        Case ch Of
          'A': Begin
                 PHPoint:=((Plyr.strength/2)+(random(Plyr.strength/2)))-(LPlyr.def)
                 MHPoint:=((LPlyr.strength/2)+(random(LPlyr.strength/2)))-(Plyr.def)
                 WriteLn('')
                 if PHPoint>0 then
                 Begin
                   WriteLn('|09  You hit |03'+LPlyr.alias+'|09 for |03'+Int2Str(PHPoint)+'|09 damage!')
                   LPlyr.hit_points:=LPlyr.hit_points-PHPoint
                 if LPlyr.hit_points>0 then
                 Begin
                   if MHPoint>0 then
                   Begin
                     WriteLn('|04 ** |03'+LPlyr.alias+'|09 hits you with their |03'+ LPlyr.weapon+'|09 for |03'+Int2Str(MHPoint)+'|09 damage! |04 **')
                     Plyr.hit_points:=Plyr.hit_points-MHPoint
                   End
                   Else Begin
                     WriteLn('|04 ** |03'+LPlyr.alias+'|09 attacks with its |03'+LPlyr.weapon+'|09 and misses...')
                   End
                  End
                 End
                 Else Begin
                   WriteLn('|09  Your attack missed')
                   if MHPoint>0 then
                   Begin
                     WriteLn('|04 ** |03'+LPlyr.alias+'|09 hits you with their |03'+ LPlyr.weapon+'|09 for |03'+Int2Str(MHPoint)+'|09 damage! |04 **')
                     Plyr.hit_points:=Plyr.hit_points-MHPoint
                   End
                   Else Begin
                     WriteLn('|04 ** |03'+LPlyr.alias+'|09 attacks with its |03'+LPlyr.weapon+'|09 and misses...')
                   End
                 End
               End
        'S': Begin
               PlayerStat
               ClrScr
             End
        'R': Begin
               If Random(100)<=30 then break
               Else Begin
                 MHPoint:=((LPlyr.strength/2)+(random(LPlyr.strength/2)))-Plyr.def
                 if MHPoint>0 then
                 Begin
                   WriteLn('|04 ** |03'+LPlyr.alias+'|09 hits you with their |03'+LPlyr.weapon+'|09 for |03'+Int2Str(MHPoint)+'|09 damage! |04**')
                   Plyr.hit_points:=Plyr.hit_points-MHPoint
                 End
                 Else Begin
                   WriteLn('')
                   WriteLn('|09 ** |03'+LPlyr.alias+'|09 attacks with thier |03'+LPlyr.weapon+'|09 and misses...')
                 End
             End
        End
      End
      Until (Plyr.hit_points<=0)or(LPlyr.hit_points<=0)
      if Plyr.hit_points<=0 then begin
        Plyr.dead:=true
        deaduserdaily(Plyr.alias,LPlyr.alias)
        LPlyr.gold:=LPlyr.gold+Plyr.gold
        Plyr.gold:=0
        LPlyr.exp:=LPlyr.exp+Plyr.exp
        SavePlyr(Plyr.index)
        SaveLPlyr(FgtInd)
        WriteLn('|09  Sorry, but you''re dead. Come back tomorrow...')
        WriteLn(pz)
        x:=ReadKey
        endit
      End
      if LPlyr.hit_points<=0 then begin
        Plyr.gold:=Plyr.gold+LPlyr.gold
        LPlyr.gold:=0
        Plyr.exp:=Plyr.exp+LPlyr.exp
        Plyr.human_left:=Plyr.human_left-1
        LPlyr.dead:=true
        SavePlyr(Plyr.index)
        SaveLPlyr(FgtInd)
        userkilldaily(Plyr.alias,LPlyr.alias)
        WriteLn('|09 You have beaten |03'+LPlyr.alias+'|09 in battle!')
        WriteLn(pz)
        x:=ReadKey
      End
    End
  End
  Else
  Begin
    if LPlyr.dead=true then WriteLn('|09Cannot fight a dead player.'+pz)
    if LPlyr.index=Plyr.index then WriteLn('|09Why do you want to fight yourself?'+pz)
    ReadKey
  End
End

procedure dailynews
Var ch       : char
Var s        : string
Var x        : Byte=0
Var y        : Byte=0
Var fTemp    : file
Var tempfile : string=rcspath+'daily.tmp'  //create temp file for trimming daily happenings
Begin
  ClrScr
  WriteLn('')
  s:=''
  fAssign(fDaily,DailyFile,66)
  fAssign(fTemp,tempfile,66)
  //if FileExist(rcspath+'tcstdta.dly') then fReset(fDaily) Else fReWrite(fDaily)
  fReset(fDaily)
  fReWrite(fTemp)
  if IOResult=0 then
  Begin                           //Trims the rcstdta.dly file to 20 lines
    While not fEof(fDaily) Do
    Begin
      fReadLn(fDaily,s)
      fWriteLn(fTemp,s)
      x:=x+1
    End
    fClose(fDaily)
    if x>=20 then
    Begin
      fRewrite(fDaily)
      fReset(fTemp)
      For y:=x downto 20 do
      Begin
        fReadLn(fTemp,s)
        s:=''
      End
      Repeat
        fReadLn(fTemp,s)
        fWriteLn(fDaily,s)
      Until fEof(fTemp)
    End
  fClose(fTemp)
  fClose(fDaily)
  fileErase(rcspath+'daily.tmp')
  End
//Displays the rcstdta.dly file of events
  if not FileExist(rcspath+'news.ans') then
  Begin
    WriteLn('')
    WriteLn('|09  Here''s what''s been happening in |03The Dark Tower Adventures...')
    WriteLn('|09-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
  End
  Else
  Begin
    ClrScr
    DispFile(rcspath+'news.ans')
  End
  fReset(fDaily)
  if IOResult=0 then
  Begin
    WriteLn('|23')               //changes background color to match ansi
    GotoXY(1,4)
    While not fEof(fDaily) Do
    Begin
      fReadLn(fDaily,s)
      WriteLn(s)
    End
  End
  WriteLn('|16'+pz)              //change background back to black
  ch:=ReadKey
  fClose(fDaily)
End

procedure town
Var
  ch : char
  x  : char
Begin
  If (Plyr.hit_points<=0)or(Plyr.dead) then
  Begin
    WriteLn('       You''re Dead. Come back again tomorrow and try again.')
    //Plyr.hit_points:=Plyr.hit_max         //put in place for testing
    WriteLn(pz)
    Plyr.dead:=true                         //change to false for testing
    Plyr.gold:=0
    SavePlyr(Plyr.index)
    ch:=ReadKey
    endit                                   //comment out for testing
  End
  ClrScr
  Plyr.time:=datetime
  SavePlyr(Plyr.index)
  DispFile(rcspath+'town.ans')
  WriteLn('')
  Write('|03  Y|09our command, |03'+Plyr.Alias+' : ')
  ch := upper(OneKey('FAKDLHVQYU',True))
  Case ch Of
    'F': Begin
           forest
           town
         End
    'A': Begin
           armourshop
           town
         End
    'K': Begin
           weaponshop
           town
         End
    'D': Begin
           dailynews
           town
         End
    'H': Begin
           healer
           town
         End
    'Y': Begin
           bank
           town
         End
    'L': Begin
           SavePlyr(Plyr.index)
           listplayers
           WriteLn(pz)
           x:=ReadKey
           town
         End
    'V': Begin
           PlayerStat
           town
         End
    'U': Begin
           UserFight
           town
         End
    'Q': endit
  End
End

procedure newuserdaily(name:string)   //puts entry into daily news when new user enters
Begin
  fAssign(fDaily,DailyFile,66)
  if FileExist(rcspath+'rcstdta.dly') then fReset(fDaily) else fRewrite(fDaily)
    fSeek(fDaily,FSize(fDaily))
    fWriteLn(fDaily,'')
    fWriteLn(fDaily,'|00'+DateStr(datetime,1)+': |09'+name+'|00 has just woken up on the beach')
    fClose(fDaily)
End

procedure setstats           //sets the initial stats for new user
Begin
  Plyr.hit_points:=20
  Plyr.hit_max:=20
  Plyr.weapon_num:=Plyr.king+1
  Plyr.weapon:=weapons[Plyr.weapon_num].name
  Plyr.seen_master:=false
  Plyr.fights_left:=dailyfights
  Plyr.human_left:=dailyhumanfights
  Plyr.gold:=500
  Plyr.bank:=0
  Plyr.def:=1
  Plyr.strength:=5
  Plyr.level:=1
  Plyr.time:=DateTime
  Plyr.arm_num:=Plyr.king+1
  Plyr.arm:=armours[Plyr.arm_num].name
  Plyr.dead:=false
  Plyr.exp:=1
  Plyr.king:=0
  Plyr.floor:=1
  SavePlyr(Plyr.index)
End

procedure app
Var ch : char
begin
  ClrScr
  WriteLn('')
  WriteLn('|03** |09Welcome to the realm gunslinger! |03**')
  WriteLn('')
  WriteLn('|09What would you like as an alias?')
  WriteLn('')
  write('|03Name: ')
  Plyr.Alias := input(20,20,3,'')
  writeln('')
  write('|09'+Plyr.Alias+'? [Y/N] : ')
  ch := upper(readkey)
  if ch=upper('N') then app
  if ch='' then app
  WriteLn('')
  WriteLn('')
  WriteLn('|09And your gender?  |03(M/F): |DE')
  WriteLn('|09I''ll give you a minute to check...')
  ch := upper(readkey)
  if ch=upper('M')then Plyr.sex:=true
  else Plyr.sex:=false
  WriteLn('')
  WriteLn('|09With a name like "|03'+Plyr.Alias+'|09", no one is going to believe it.')
  WriteLn('')
  WriteLn(pz)
  ch:=ReadKey
  setstats
  newuserdaily(Plyr.Alias)
  DispFile(rcspath+'beach')
  WriteLn('|[X01|[Y23'+pz)
  Ch:=ReadKey
  ClrScr
  DispFile(rcspath+'intro.ans')
  WriteLn(pz)
  ch:=ReadKey
  playerstat
  dailynews
  town
 End

procedure Apply
Var Ch  : String
Begin
  ClrScr
  DispFile(rcspath+'apply')
  ch := OneKey('YN',True)
  Case ch Of
    'Y': app
    'N': Apply
  End
End

Procedure NewPlyr
Begin
  PlyrCount:=PlyrCount+1
  Plyr.Index:=PlyrCount
  Plyr.Name:=UserName
  Plyr.Alias:=UserAlias
  SavePlyr(Plyr.Index)
  Apply
End

Function datecheck(t,p:longint):Boolean
Var
  date1day : word
  date1mon : word
  date1yer : word
  date2day : word
  date2mon : word
  date2yer : word
  ret      : boolean=false
Begin
  date1day:=Str2Int(WordGet(2,DateStr(t,1),'/'))
  date1mon:=Str2Int(WordGet(1,DateStr(t,1),'/'))
  date1yer:=Str2Int(WordGet(3,DateStr(t,1),'/'))
  date2day:=Str2Int(WordGet(2,DateStr(p,1),'/'))
  date2mon:=Str2Int(WordGet(1,DateStr(p,1),'/'))
  date2yer:=Str2Int(WordGet(3,DateStr(p,1),'/'))
  if date1yer>date2yer then ret:=true
  else if date1mon>date2mon then ret:=true
  else if date1mon=date2mon then
  begin
    if date1day>date2day then ret :=true
  End
  datecheck:=ret
End

procedure checkdate              //compares today's date with last time player was in game
Begin
  if datecheck(DateTime,Plyr.time) then
  Begin
    Plyr.seen_master:=false
    Plyr.fights_left:=25
    Plyr.human_left:=5
    Plyr.hit_points:=Plyr.hit_max
    Plyr.dead:=false
    Plyr.bank:=Plyr.bank+(Plyr.bank/10)
    SavePlyr(Plyr.Index)
  End
End

Procedure Main
Var
  X    : Integer
  Done : Boolean = False
  Ch   : Char
  z    : Char
Begin
  ClrScr
  Write('|09   Traveling to The Dark Tower...|DE|DE|DE|DE')
  DispFile(rcspath+'splash')
  WriteLn('|[X01|[Y23'+pz)
  Ch:=Upper(readkey)
  While Not Done Do Begin
    ClrScr
    DispFile(rcspath+'menu')
    Ch:=OneKey('LISQ',True)
    Case Ch Of
      'L': Begin
             ListPlayers
             WriteLn(pz)
             z:=ReadKey
           End
      'I': DispFile(rcspath+'info')
      'S': Begin
             X:=FindPlyr(UserName)
             If X > 0 Then Begin
               ReadPlyr(X)
               checkdate
               setweapons
               setarmour
               playerstat
               dailynews
               town
             End
             Else Begin
               setweapons
               setarmour
               NewPlyr
             End
      End
      'Q': Done:=True
    End
  End
End

Begin
  Init
  Main
End
