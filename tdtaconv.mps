//program tdtaconv;
// This is the conversion program for converting user records to new version

type ritems = Record
  iname       : string
  ihit_points : integer
  ihit_max    : integer
  ihit_multi  : real
  ifights_left: byte
  ihuman_left : byte
  iint_multi  : real
  idef_multi  : real
  istr_multi  : real
End

type
  oldrec = record
  Index        : Integer;      //index number for storing player data
  Name         : String[40];
  Alias        : String[40];
  hit_points   : longint;      //{player hit points}
  hit_max      : longint;      //{hit_point max}
  weapon_num   : byte;         //{weapon number}                     //changed to byte
  weapon       : string[20];   //{name of weapon}
  seen_master  : boolean;      //changed to bool
  fights_left  : Byte;         //{forest fights left}                //changed to byte
  human_left   : Byte;         //{human fights left}                 //changed to byte
  gold         : longint;      //{gold in hand}
  bank         : longint;      //{gold in bank}
  def          : longint;      //{total defense points }
  strength     : longint;      //{total strength}
  level        : Byte;         //{level of player}                   //changed to byte
  floor        : Byte;         //which floor the player is on
  time         : longint;      //player last played on}              //changed to longint
  arm          : string[20];   //{armour name}
  arm_num      : byte;         //{armour number}                     //changed to byte
  dead         : Boolean;      //changed to boolean
  exp          : longint;      //{experience}
  sex          : Boolean;      //changed to bool
  king         : byte;         //{# of times player has won game}
  end;

Type newrec = Record         //modified from LORD structs
  Index        : Integer;      //index number for storing player data
  Name         : String[40];   //Real Name
  Alias        : String[40];   //Player Alias
  hit_points   : longint;      //{player hit points}
  hit_max      : longint;      //{hit_point max}
  hit_multi    : real;         //hit_max Multiplier
  weapon_num   : byte;         //{weapon number}                     //changed to byte
  weapon       : string[20];   //{name of weapon}
  seen_master  : boolean;      //changed to bool
  fights_left  : Byte;         //{forest fights left}                //changed to byte
  human_left   : Byte;         //{human fights left}                 //changed to byte
  gold         : longint;      //{gold in hand}
  bank         : longint;      //{gold in bank}
  int_multi    : real;         //Gold Interest Multiplier
  def          : longint;      //{total defense points }
  def_multi    : real;         //Defense Multiplier
  strength     : longint;      //{total strength}
  str_multi    : real;         //Strength Multiplier
  level        : Byte;         //{level of player}                   //changed to byte
  floor        : Byte;         //which floor the player is on
  time         : longint;      //player last played on}              //changed to longint
  arm          : string[20];   //{armour name}
  arm_num      : byte;         //{armour number}                     //changed to byte
  dead         : Boolean;      //changed to boolean
  exp          : longint;      //{experience}
  sex          : Boolean;      //changed to bool
  king         : byte;         //{# of times player has won game}
  room         : Boolean;      //Staying in Inn
  items        : Array[1..10] of ritems
End;

Var
  oldfile : string;
  newfile : string;
  orec    : oldrec;
  nrec    : newrec;
  fptr    : file
  fptr1   : file
  x       : integer=1;
  y       : byte
begin
  ClrScr
  WriteLn('Starting Conversion')
  oldfile:='rcstdta.ply';
  newfile:='newtdta.ply';
  fAssign(fptr,oldfile,66);
  fReset(fptr);
  If IOResult=0 then
  Begin
    WriteLn('Opened oldfile')
    fAssign(fptr1,newfile,66);
    fReWrite(fptr1);
    If IOResult=0 then
    Begin
      WriteLn('Opened newfile')
      While not fEOF(fptr) do
      Begin
      //Repeat
        fSeek(fptr,(x-1)*SizeOf(orec));
        fReadRec(fptr,orec)
        WriteLn(orec.Alias)
        nrec.Alias:=orec.Alias;
        nrec.arm:=orec.arm;
        nrec.arm_num:=orec.arm_num;
        nrec.bank:=orec.bank;
        nrec.dead:=orec.dead;
        nrec.def:=orec.def;
        nrec.def_multi:=0;
        nrec.exp:=orec.exp;
        nrec.fights_left:=orec.fights_left;
        nrec.floor:=orec.floor;
        nrec.gold:=orec.gold;
        nrec.hit_max:=orec.hit_max;
        nrec.hit_multi:=0;
        nrec.hit_points:=orec.hit_points;
        nrec.human_left:=orec.human_left;
        nrec.Index:=orec.Index;
        nrec.int_multi:=0;
        nrec.king:=orec.king;
        nrec.level:=orec.level;
        nrec.Name:=orec.Name;
        nrec.room:=false;
        nrec.seen_master:=orec.seen_master;
        nrec.sex:=orec.sex;
        nrec.strength:=orec.strength;
        nrec.str_multi:=0;
        nrec.time:=orec.time;
        nrec.weapon:=orec.weapon;
        nrec.weapon_num:=orec.weapon_num;
        for y:=1 to 10 do
        Begin
          nrec.items[y].iname:='None'
          nrec.items[y].ihit_points:=0
        End
        fSeek(fptr1,(x-1)*SizeOf(nrec));
        fWriteRec(fptr1,nrec);

        x:=x+1;
        //Until EOF(fptr)
      end;
    end;
  end;

  fClose(fptr);
  fClose(fptr1)
  gotoxy(1,24)
end.
