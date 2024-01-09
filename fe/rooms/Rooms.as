package fe.rooms {
	
	public class Rooms {
		public var rooms:Array;
		
		var l_plant:RoomsPlant;
		var l_sewer:RoomsSewer;
		var l_stable:RoomsStable;
		var l_mane:RoomsMane;
		var l_canter:RoomsCanter;
		var l_mbase:RoomsMbase;
		var l_encl:RoomsEncl;
		var l_pi:RoomsPi;
		
		var l_prob:RoomsProb;
		var l_camp:RoomsCamp;
		var l_serial:RoomsSerial;
		var l_serial2:RoomsSerial2;
		
		public function Rooms() {
			rooms=new Array();
			l_plant=new RoomsPlant();
			l_sewer=new RoomsSewer();
			l_stable=new RoomsStable();
			l_mane=new RoomsMane();
			l_canter=new RoomsCanter();
			l_mbase=new RoomsMbase();
			l_encl=new RoomsEncl();
			l_pi=new RoomsPi();
			
			l_camp=new RoomsCamp();
			l_serial=new RoomsSerial();
			l_serial2=new RoomsSerial2();
			l_prob=new RoomsProb();
			
			//сюжетные
			rooms['rooms_begin']=rooms_begin;
			rooms['rooms_surf']=rooms_surf;
			rooms['rooms_garages']=rooms_garages;
			rooms['rooms_way']=rooms_way;
			
			//лагеря
			rooms['rooms_rbl']=l_camp.rooms_rbl;
			rooms['rooms_covert']=l_camp.rooms_covert;
			rooms['rooms_src']=l_camp.rooms_src;
			
			//сюжетные 0.7
			rooms['rooms_nio']=l_serial.rooms_nio;
			rooms['rooms_raiders']=l_serial.rooms_raiders;
			rooms['rooms_core']=l_serial.rooms_core;
			rooms['rooms_mtn']=l_serial.rooms_mtn;
			rooms['rooms_minst']=l_serial.rooms_minst;
			
			//сюжетные 0.8
			rooms['rooms_workshop']=l_serial2.rooms_workshop;
			rooms['rooms_hql']=l_serial2.rooms_hql;
			rooms['rooms_post']=l_serial2.rooms_post;
			rooms['rooms_comm']=l_serial2.rooms_comm;
			rooms['rooms_art']=l_serial2.rooms_art;
			rooms['rooms_pis']=l_serial2.rooms_pis;
			rooms['rooms_thunder']=l_serial2.rooms_thunder;
			rooms['rooms_grave']=l_serial2.rooms_grave;
			
			//рандомные
			rooms['rooms_plant']=l_plant.rooms;
			rooms['rooms_sewer']=l_sewer.rooms;
			rooms['rooms_stable']=l_stable.rooms;
			rooms['rooms_mane']=l_mane.rooms;
			rooms['rooms_canter']=l_canter.rooms;
			rooms['rooms_mbase']=l_mbase.rooms;
			rooms['rooms_encl']=l_encl.rooms;
			rooms['rooms_pi']=l_pi.rooms;
			
			//испытания
			rooms['rooms_prob']=l_prob.rooms;
		}
		


var rooms_begin:XML=<all>
  <land serial="1"/>
  <room name="room_3_0" x="3" y="0">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C.C._._._._._._._._._._._._._K._K._K._K._._._.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C.C._._._._._._._._._._._._._K._K._K._K._._._.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C.C._._._._K._K._K._K._._._.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._K._K._K._K._._._.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._K._K._K._K._._._.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._K._K._K._K._._._.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._K._K._K._K._._._.C</a>
    <a>C.C.C.C.C.C.C.C._Б-._-._-._-.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._K._K._K._K._._._.C</a>
    <a>C.C.C.C.C.C.C.C._Б._._._._._._._._._.E._._._._.C._._._._._K._K._K._._._._._._._._._._K._K._K._K._._._.C</a>
    <a>C.C.C.C.C.C.C.C._Б._._._._._._._._._.E._._._._._._._._._._K._K._K._._._._._._._._._._K._K._K._K._._._.C</a>
    <a>C.C.C.C.C.C.C.C._Б._._._._._._._._._.E._._._._._._._._._._K._K._K._._._._._._._._._._K._K._K._K._._._.C</a>
    <a>C.C.C.C.C.C.C.C._Б._._._._._._._.C.C.C.C.C.C.C.C.C.C.C.C._K-._K-._K-.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_._._._._._._._._Б._._._._._._._._._.EA._A._A._A._A.C.C.C.C.C._K._K._K._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._Б._._._._._._._._._.EA._A._A._A._A.C.C.C.C.C._K._K._K._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._Б._._._._._._._._._.EA._A._A._A._A.C.C.C.C.C._K._K._K._._._._._._._._._._._._._._._._._</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._EБ._E.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EБ._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EБ._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EБ._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._E-._E-._E-._E-._E-._E-._E-._E-._E-._E-._E-._E-._E-._E-._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EБ._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EБ._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EБ._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EБ._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <obj id="chest" code="gO5yOvJSFpQtPyKd" lock="0" cont="case" x="20" y="15">
      <item id="col1" imp="1"/>
      <scr act="off" targ="trDestroy"/>
    </obj>
    <obj id="chest" x="14" y="7" lock="1" lockhp="1000" cont="case" code="YHNxJTtfKVYIBil8" uid="trSign5">
      <item id="col1" imp="1"/>
      <scr targ="trSignTum" act="sign" val="1"/>
    </obj>
    <obj id="bigbox" x="4" y="23" code="BySPhCCt31MPQkHT"/>
    <obj id="bigbox" x="12" y="23" code="h2ihIavjsNb0hHb9"/>
    <obj id="bigbox" x="36" y="23" code="Hdi6VZyTN9KTNvhh"/>
    <obj id="bigbox" x="41" y="23" code="YI7bSBMyxznzPycu"/>
    <obj id="bigbox" x="8" y="23" code="Oi7Ih7u1q5pU9YZZ"/>
    <obj id="box" x="16" y="23" code="sTWQ97LdmRrDr0wJ"/>
    <obj id="box" x="37" y="21" code="UwBfMk6gEC56nO6h"/>
    <obj id="box" x="41" y="21" code="S3FLWHlLi9P4pC37"/>
    <obj id="box" x="3" y="19" code="FlOiGgYP6cLZaQO8"/>
    <obj id="door1" lock="1" x="23" y="11" code="n2rh2CtIuxEw1Rju">
      <scr targ="trDoor" act="off"/>
      <scr eve="die" targ="trDoor" act="off"/>
    </obj>
    <obj id="wallcab" x="45" y="22" code="m1HICm5a2u086NPl">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="case" x="29" y="2" code="ixa0pvAl9lwzb8HH">
      <item id="col1" imp="1"/>
      <scr targ="trBoxes" act="off"/>
    </obj>
    <obj id="tarakan" x="9" y="19" code="zEESKSb4dzhSBl3R"/>
    <obj id="tarakan" x="19" y="23" code="J4Iv6KsPwaBLFrFn"/>
    <obj id="tarakan" x="40" y="23" code="vERQmTL2s9zW0zYj"/>
    <obj id="box" x="6" y="19" code="xwAs0F11wD36OEn2"/>
    <obj id="medbox" x="13" y="18" code="S60YL5s8s7AfZX9Y" cont="">
      <item id="pot0"/>
      <item id="pot1"/>
      <scr act="mess" val="trMedic"/>
    </obj>
    <obj id="woodbox" x="45" y="11" code="xg9qwzrMlGn0WRaL"/>
    <obj id="woodbox" x="43" y="11" code="JGvwTbaR3kZ607RL"/>
    <obj id="tarakan" x="2" y="23" code="bgWGs1jkyZxWtcSW"/>
    <obj id="woodbox" x="43" y="8" code="X2C3FtFqWFfQ1Rk3"/>
    <obj id="woodbox" x="41" y="11" code="d1s7EIY37TU2jYbM"/>
    <obj id="instr1" code="tuWP6YXWrsfo94IW" x="23" y="3" lock="0" cont="" uid="trSignTum">
      <item id="mont" kol="2" imp="1"/>
    </obj>
    <obj id="area" code="unGCSPPdrP9xKZpP" x="9" y="15" mess="trInstr">
      <scr>
        <s act="off" targ="this"/>
        <s targ="trSign4" act="sign" val="1"/>
      </scr>
    </obj>
    <obj id="area" uid="trDestroy" code="RToYLHBFSIXNdOOv" x="13" y="15" h="7" w="4" mess="trDestroy" off="1"/>
    <obj id="area" uid="trDoor" code="kLLq89oVA2uQ52MB" x="20" y="11" mess="trDoor" off="1"/>
    <obj id="area" uid="trBoxes" code="AMRIbkD5MGCWpVAK" x="38" y="11" mess="trBoxes" down="1"/>
    <obj id="instr2" code="ntIKBNePdAamKjUA" x="3" y="5" cont="" uid="trSign4">
      <item id="screwdriver" imp="1"/>
    </obj>
    <obj id="area" code="FLqEGWa7eW6gKhtM" x="32" y="15" mess="trBattle">
      <scr act="off" targ="this"/>
    </obj>
    <obj id="player" code="mgZfDjsqt1hhy1RT" x="2" y="15"/>
    <back id="light2" x="2" y="2"/>
    <back id="electro" x="5" y="4"/>
    <back id="fuse" x="1" y="5"/>
    <back id="depot" x="2" y="21"/>
    <back id="depot" x="5" y="21"/>
    <back id="depot" x="8" y="21"/>
    <back id="depot" x="11" y="21"/>
    <back id="depot" x="14" y="21"/>
    <back id="light3" x="21" y="18"/>
    <back id="light3" x="25" y="18"/>
    <back id="light3" x="39" y="18"/>
    <back id="light3" x="43" y="18"/>
    <back id="light4" x="13" y="9"/>
    <back id="wires1" x="7" y="6"/>
    <back id="wires1" x="7" y="4"/>
    <back id="wires1" x="7" y="2"/>
    <back id="wires1" x="7" y="0"/>
    <back id="electro" x="23" y="1"/>
    <back id="wires1" x="21" y="1"/>
    <back id="wires1" x="21" y="3"/>
    <back id="vent" x="5" y="2"/>
    <back id="vent" x="9" y="2"/>
    <back id="draw" x="13" y="4"/>
    <back id="draw" x="18" y="1"/>
    <back id="web1bl" x="28" y="0"/>
    <back id="web1br" x="20" y="13"/>
    <options backwall="tDirt"/>
  </room>
  <room name="room_0_0" x="0" y="0">
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._._._._._._.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._._._._._._.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._._._._._._.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._._._А.C._Б._.C.C.C.C.C.C.C</a>
    <a>H.H.H.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._._._А.C._Б._._._._._._._._</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._.C.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._._._А.C._Б._._._._._._._._</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._.C.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._._._А.C._Б._._._._._._._._</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._А.C.C.C.C.C.C.C.C.C.C</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._._._._._._._._А.C.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._._._._._._._._А.C.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._._._._._._._._А.C.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._._._._._._._._А.C.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._._._._._._-._-._-._-.C.C.C._._._._._._._._А.C.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._._._._._._._._._.C.C.C._._._._._._._._А.C.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._._._._._._._._._._._._._._._._._._._._._._._.C.C.C._._._._._._._._А.C.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="plesen" x="14" y="14"/>
    <obj id="area" code="lADgEJRS20ZdhKWt" x="39" y="3" mess="trDown"/>
    <obj id="player" x="7" y="15" code="UbwC3OvWeHCLZUMC" turn="1"/>
    <obj id="area" code="oxXmuzyaHm4QUxbd" x="6" y="15" scr="beginBeg"/>
    <obj id="area" code="TlujXOwJjAa5XExw" x="19" y="15" h="7" mess="trJump"/>
    <back id="potek" x="12" y="6"/>
    <back id="plesen" x="4" y="14"/>
    <back id="potek" x="2" y="6"/>
    <back id="konstr" x="5" y="8"/>
    <back id="pipe2" x="29" y="13"/>
    <obj id="area" code="D9kKc2amh6Hri3I6" x="36" y="15" h="7" mess="trUp"/>
    <back id="plesen" x="24" y="14"/>
    <back id="plesen" x="34" y="14"/>
    <back id="konstr" x="5" y="12"/>
    <back id="konstr" x="5" y="4"/>
    <back id="konstr" x="17" y="12"/>
    <back id="konstr" x="17" y="8"/>
    <back id="konstr" x="17" y="4"/>
    <back id="web1tl" x="34" y="1"/>
    <back id="web1tr" x="38" y="1"/>
    <options backwall="tLeaking"/>
  </room>
  <room name="room_4_1" x="4" y="1">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._А.C.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C.C.C._._._А.C.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C.C.C._._._А.C.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C.C.C._._._А.C.H.H.H.H.H.H</a>
    <a>C._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C._E._E._EА.CE.CE.CE.CE.CE.C.C.C.C.C.C.C.C.C.C.C.C._._._А.C.H.H.H.H.H.H</a>
    <a>C._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C._E._E._EА.CE.CE.CE.CE.CE.C.C.C.C.C.C.C.C.C.C.C.C._._._А.C.H.H.H.H.H.H</a>
    <a>C._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C._E._E._EА.CE.CE.CE.CE.CE.C.C.C.C.C.C.C.C.C.C.C.C._._._А.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C._._._._._._._._._._._._._._._._А._._._._._._._._._._._._._._._._.C._._._._._._._._._.C</a>
    <a>C.C.C.C.C._._._._._._._._._._._._._._._._А._._._._._._._._._._._._._._._._.C._._._._._._._._._.C</a>
    <a>C.C.C.C.C._._._._._._._._._._._._._._._._А._._._._._._._._._._._._._._._._.C._._._._._._._._._.C</a>
    <a>C.C.C.C.C._._._._._._._._._._._._._.C.C.C.C.C._Б._._._._._._._._._._._._._.C.C.C.C.C.C._-._-._-._А-.C</a>
    <a>C.C.C.C.C._*._*._*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C._Б._._._._._._._._._._._._._._._._._._._._._._._А.C</a>
    <a>C.C.C.C.C._*._*._*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C._Б._._._._._._._._._._._._._._._._._._._._._._._А.C</a>
    <a>C.C.C.C.C._*._*._*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C._Б._._._._._._._._._._._._._._._._._._._._._._._А.C</a>
    <a>C.C.C.C.C._*._*._*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C._Б._._._._._._._._._._._._._._._._._._._._._._._А.C</a>
    <a>C.C.C.C.C._*._*._*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C._Б._._._._._._._._._._._._._._._._._._._._._._._А.C</a>
    <a>C.C.C.C.C._*._*._*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E._E._EА.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H</a>
    <a>_*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H</a>
    <a>_*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H</a>
    <a>C.C.C.C.C._*._*._*._*._*._*.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H</a>
    <a>C.C.C.C.C._*._*._*._*._*._*.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H.H.H</a>
    <back id="vent" x="4" y="5"/>
    <obj id="wallcab" x="2" y="5" code="WuNUi6Ha4QuIBzGF" lock="0">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="area" code="Ql4ZQrrKdr49LpuD" x="43" y="15" mess="trRun"/>
    <obj id="area" code="B5KauyziWA9zwvoo" x="18" y="9" mess="trFloat"/>
    <obj id="player" code="PozeK7v0R3HWTGQB" x="44" y="9"/>
    <obj id="platform1" open="1" uid="trPl" code="rE7udlQoBfbzNSv5" x="27" y="16"/>
    <obj id="woodbox" x="22" y="3" code="ZNpRjKtNMEObGYvs"/>
    <obj id="knop1" code="wIx3z013ypGZZ4jo" x="28" y="22">
      <scr>
        <s act="swap" targ="trPl"/>
        <s act="mess" val="trPl"/>
      </scr>
    </obj>
    <back id="vent" x="6" y="5"/>
    <back id="plesen" x="27" y="22"/>
    <obj id="woodbox" x="15" y="11" code="HDda2jS6fHHLZrAg"/>
    <back id="potek" x="27" y="7"/>
    <back id="potek" x="17" y="7"/>
    <back id="potek" x="7" y="7"/>
    <back id="potek" x="0" y="7"/>
    <back id="web1br" x="23" y="1"/>
    <back id="web1bl" x="38" y="7"/>
    <back id="web1bl" x="1" y="4"/>
    <back id="web1bl" x="27" y="21"/>
    <back id="web1br" x="34" y="21"/>
    <options wrad="0" backwall="tConcreteDirt"/>
  </room>
  <room name="room_1_4" x="1" y="4">
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.D.D.D.D._._А.D.D.D</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.D.D.D.D._._А.D.D.D</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.D.D.D.D._._А.D.D.D</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.D.D.D.D._._А.D.D.D</a>
    <a>B.B.B.B.B.B._A._A.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.D.D.D.D._._А.D.D.D</a>
    <a>B.B.B.B.B.B._A-._A-.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.D.D.D.D._._А.D.D.D</a>
    <a>B.B.B.B.B.B._A._A.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.D.D.D.D._._А.D.D.D</a>
    <a>B.B.B.B.B.B._A._A.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.D.D.D.D._._А.D.D.D</a>
    <a>B.B._A._A._A._A._A._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._А.D.D.D</a>
    <a>B.B._A._A._A._A._A._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._А.D.D.D</a>
    <a>B.B._A._A._A._A._A._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._А.D.D.D</a>
    <a>B.B._A._A._A._A._A._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._А.D.D.D</a>
    <a>B.B._A._A._A._A._A._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._А.D.D.D</a>
    <a>B.B._A-._A-._A-._A-._A-._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._А.D.D.D</a>
    <a>B.B._A._A._A._A._A._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._._._</a>
    <a>B.B._A._A._A._A._A._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._._._</a>
    <a>B.B._A-._A-._A-._A-._A-._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._-._-._-._-.D.D.D.D.D.D.D.D.D</a>
    <a>B.B._A._A._A._A._A._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D.D.D.D.D.D</a>
    <a>B.B._A._A._A._A._A._A._A._A._A.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D.D.D.D.D.D</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <obj id="weapcase" code="Bs0KwbxiKhRrFWK1" x="3" y="18" cont="" lock="0">
      <item id="oldr^1" kol="2"/>
      <item id="p32" kol="2"/>
    </obj>
    <obj id="expl1" code="bWXjh7rXXpl6hS8W" x="14" y="13"/>
    <obj id="expl1" uid="trExpl1" code="CBa1zmb7OcmAEy5j" x="14" y="10">
      <scr eve="die" targ="trExpl2" act="off"/>
    </obj>
    <obj id="detonator" code="iNsO0TcTwnWxGEhO" x="16" y="18">
      <scr targ="trExpl1" act="dam"/>
    </obj>
    <obj id="expl1" code="wJJWrKfPwnmrjRRI" x="14" y="16"/>
    <obj id="safe" code="ARvRFdgPxkwgqbys" x="3" y="15" lock="1" mine="0"/>
    <obj id="area" uid="trExpl2" code="ClSnzpn3gxk9DCvN" x="22" y="18" h="12" w="5">
      <scr>
        <s act="dialog" val="begDialExpl"/>
        <s act="off" targ="this"/>
      </scr>
    </obj>
    <obj id="scorp" code="kmjZVzTZgN92Hi1Q" x="6" y="4"/>
    <obj id="wallcab" code="ATfeHxU60Ao4umf5" x="3" y="11"/>
    <obj id="medbox" code="XnXVHyZRHzBKiUWo" x="5" y="11"/>
    <obj id="player" code="w27jbnqQDlF68AQJ" x="40" y="15"/>
    <back id="chole2" x="8" y="9"/>
    <options wrad="6" wtip="1" color="green" backwall="tMossy"/>
  </room>
  <room name="room_2_3" x="2" y="3">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.B._J._J._J._J._J._J._J._J._J.B.B.B.B.B</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.B._J._J._J._J._J._J._J._J._J.B.B.B.B.B</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.B._J._J._J._J._J._J._J._J._J._._._._._</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.B._J._J._J._J._J._J._J._J._J._._._._._</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C._C._C.C._._._._._Б._._._._._._._А._._._._.C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C._C._C.C._._._._._Б._._._._._._._А._._._._.C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._._._._._._Б._._._._._._._А._._._._._._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._._._._._._Б._._._._._._._А._._._._._._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C._A._A._A._A._A._A._A._A.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C._._._._._._._._.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C._._._._._._._._.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C._._А.C.C.C.C.C.C._F._F._F._F._F._F._F._F._F._F.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_._._._._._._._._._._._._А._._._._._._._F._F._F._F._F._F._F._F._F._F._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._А._._._._._._._F._F._F._F._F._F._F._F._F._F._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._А._._._._._._._F._F._F.AF.AF.AF.AF._F._F._F._._._._._._._._._._._._._._._._._._._</a>
    <a>A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A</a>
    <obj id="spikes" code="AGbxdIQOvRe3hLdr" x="22" y="18"/>
    <obj id="spikes" code="DZvYHCrBPfxSJeEO" x="23" y="18"/>
    <obj id="spikes" code="nvyfqnqmmebUjXbf" x="24" y="18"/>
    <obj id="spikes" code="w0OqEYtBn8tyE3ip" x="25" y="18"/>
    <obj id="spikes" code="oaohhy0eMvgTM3A8" x="26" y="18"/>
    <obj id="door1" code="rSFrMs4qfICMhq53" x="32" y="15"/>
    <obj id="spikes" code="HMwv3iaBH9EADDqv" x="21" y="18"/>
    <obj id="door1" code="klVTzy8M8jp8OoQr" x="15" y="15"/>
    <obj id="molerat" code="yw1TT09asWMeFW8I" x="39" y="15"/>
    <obj id="trap" code="peINh0YW4SqWhvND" x="4" y="15"/>
    <obj id="tarakan" code="TjW5rXhySRzsd4B6" x="29" y="23"/>
    <obj id="tarakan" code="RT9U762G1PkT4y42" x="16" y="23"/>
    <obj id="rat" code="alEOCrId9bwTtPyx" x="9" y="23"/>
    <obj id="rat" code="ARYTTTIdpo5GeYNL" x="34" y="23"/>
    <obj id="trap" code="Z41KApdLvEDlLFRg" x="9" y="15"/>
    <obj id="door1" code="XDoTXvS8TUMbax74" x="43" y="4"/>
    <obj id="chest" code="x8tfEPYWDm59ToUx" x="39" y="4"/>
    <obj id="bloat" code="KgfxAGCH4iYUduFp" x="39" y="2"/>
    <obj id="checkpoint" code="GhkPoHGDt1JlSALV" x="23" y="22"/>
    <obj id="hatch2" uid="trHatch1" code="ovUsEJMMuJ46lkkK" x="11" y="16" lock="3"/>
    <obj id="knop1" code="lOUcBh1erp1p3wdi" x="11" y="22">
      <scr act="unlock" targ="trHatch1"/>
    </obj>
    <obj id="term3" code="ZfTrOrjppTxrdugq" x="36" y="3"/>
    <back id="poster" x="40" y="2"/>
    <back id="light3" x="35" y="1"/>
    <back id="light4" x="36" y="12"/>
    <back id="light4" x="42" y="12"/>
    <back id="light4" x="10" y="12"/>
    <back id="light4" x="4" y="12"/>
    <back id="rgraff" x="22" y="2"/>
    <back id="rgraff" x="21" y="6"/>
    <back id="rgraff" x="23" y="10"/>
    <back id="wires1" x="20" y="20"/>
    <back id="wires1" x="20" y="22"/>
    <back id="wires1" x="27" y="20"/>
    <back id="wires1" x="27" y="22"/>
    <options wrad="0"/>
  </room>
  <room name="room_2_2" x="2" y="2">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._E._E._E._E.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._-._-._-._-.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C.C.C.C</a>
    <a>C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C.C.C.C</a>
    <a>C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C.C.C.C</a>
    <a>C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C.C.C.C</a>
    <a>C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C.C.C.C</a>
    <a>C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C.C.C.C</a>
    <a>C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C.C.C.C</a>
    <a>C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C.C.C.C</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <back id="pipe2" x="0" y="17"/>
    <obj id="rat" code="Wnj1VrOxLk1Ft8Wy" x="6" y="19"/>
    <obj id="rat" code="VPI0a9KGMTVgR21v" x="14" y="19"/>
    <back id="pipe2" x="36" y="17"/>
    <back id="pipe2" x="24" y="17"/>
    <obj id="player" code="Xxdd3kzjZu5UZhPl" x="16" y="3"/>
    <back id="pipe2" x="12" y="17"/>
    <back id="chole4" x="9" y="7"/>
    <back id="chole6" x="29" y="7"/>
    <back id="chole3" x="29" y="11"/>
    <back id="chole2" x="21" y="8"/>
    <options wrad="0" bezdna="1" backwall="tLeaking"/>
  </room>
  <room name="room_1_1" x="1" y="1">
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._._._._</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._._._._</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._А.L.L.L</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._А.L.L.L</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._А._.L.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._А._.L.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._А._.L.D</a>
    <a>L.L._._._._._._._._.D.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._._А._.L.D</a>
    <a>L.L._._._._._._._._.D.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._-._-._-._-.L.D</a>
    <a>L.L._._._._._._._._.D.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._._._.L.D</a>
    <a>L.L._._._._._._._._.D.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._._._.L.D</a>
    <a>L.L.L.L.L._-._-._-._-._-.D.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._-._-._-._-.L.D</a>
    <a>L.L._._._._._._._._.D.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D._._._._.L.D</a>
    <a>L.L._._._._._._._._._._S._S._S._S._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.L.D</a>
    <a>L.L._._._._._._._._._._S._S._S._S._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.L.D</a>
    <a>L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.L.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <obj id="safe" code="Q1dy5dISVMxQBOKr" x="3" y="15" lock="1" mine="1"/>
    <obj id="radbarrel" code="XWOM0rLCStP30qS5" x="24" y="15"/>
    <obj id="radbarrel" code="wCZoiaQIvyrcmI6A" x="26" y="15"/>
    <obj id="radbarrel" code="rHZTgkTaOQkMJyR7" x="28" y="15"/>
    <obj id="medbox" code="CvX1eXm6TF9d5LsC" x="3" y="10" cont="">
      <item id="antiradin"/>
      <item id="antiradin"/>
    </obj>
    <obj id="door1" code="lzwONl55vYvc4yWJ" x="40" y="15" open="1"/>
    <obj id="radbarrel" code="S8N6lI96bdc5Vf62" x="30" y="15"/>
    <obj id="wallcab" code="TI5gHx1RIlznnNf2" x="5" y="10">
      <item id="col1" imp="1"/>
      <scr act="mess" val="trAntirad"/>
    </obj>
    <obj id="area" code="eSWv0duGTCg3xM9m" x="42" y="15" mess="trRad"/>
    <back id="lgreen" x="23" y="14" h="6" w="9" a="0.2"/>
    <back id="wires1" x="15" y="14"/>
    <back id="wires1" x="10" y="14"/>
    <back id="rad" x="43" y="13"/>
    <options rad="0.5" backwall="tMossy"/>
  </room>
  <room name="room_3_2" x="3" y="2">
    <a>H.H.H.H.H.H.C._C._CА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.C._C._CА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.C._C._CА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.C._C._CА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.C._C._CА.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.C._C._CА._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.C._C._CА._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.C.C.C.C.C.C.C.C.C.C._C._CА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._C._CА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._C._CА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._C._CА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._C._CА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_._._._._._._._.C.C.C._._._._._._._А._._._._._.C.C.C._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._.C.C.C._._._._._._._А._._._._._.C.C.C._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._.C.C.C._._._._._._._А._._._._._.C.C.C._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._.C.C.C._._._._._._._._._._._._.C.C.C._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._G._G._G._._._._._._._._._._._._._G._G._G._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._G._G._G._._._._._._._._._._._._._G._G._G._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._G._G._G._._._._._._._._._._._._._G._G._G._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <a>B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B</a>
    <back id="exit_light" x="38" y="13"/>
    <obj id="area" uid="trCrossroad" code="b8lLkxltkExFi04s" x="8" y="19" w="18" mess="trExit" off="1"/>
    <obj id="area" code="ek94tBtWG73c5ZaK" x="35" y="19" h="7" trig="1" uid="trig_storyDial1" scr="beginStory"/>
    <obj id="area" code="VN08VNx96n9XqL3S" x="11" y="19" w="12" h="1" scr="beginUp"/>
    <obj id="checkpoint" code="ipOg2rQEBh7NsjGg" x="16" y="19"/>
    <obj id="player" code="ABEQjFReiP5Q4vrG" x="10" y="6"/>
    <back id="hkonstr" x="17" y="13"/>
    <obj id="area" code="RiWE7ABoZtLfggXI" x="46" y="19" h="7">
      <scr>
        <s act="gotoland" val="surf"/>
        <s act="passed"/>
      </scr>
    </obj>
    <back id="hkonstr" x="11" y="13"/>
    <back id="wires2" x="14" y="18"/>
    <back id="wires2" x="14" y="16"/>
    <back id="wires2" x="14" y="14"/>
    <back id="wires2" x="14" y="12"/>
    <back id="vkonstr" x="8" y="17"/>
    <back id="vkonstr" x="24" y="17"/>
    <options wrad="0" backwall="tLeaking" music="music_strange"/>
  </room>
  <room name="room_3_3" x="3" y="3">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>CC.CC.CC.CC.CC.CC.CC.CC._C._C._C._C._C._C._._._._._._._._._.F._._._._._._._._._._.F._._._._._._._K._K._K._K._K._.G</a>
    <a>CC.CC.CC.CC.CC.CC.CC.CC._C._C._C._C._C._C._._._._._._._._._.F._._._._._._._._._._.F._._._._._._._K._K._K._K._K._.G</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C.C.C.G._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._-._K-._KГ._K._K._K._.G</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C.C.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._KГ._K._K._.G</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._KГ._K._.G</a>
    <a>C.C.C.C.C.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._KВ._K-._-.G</a>
    <a>C.C.C.C.C.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._KВ._K._K._.G</a>
    <a>C.C.C.C.C.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._K._KВ._K._K._K._.G</a>
    <a>C.C.C.C.C.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._-._K-._KГ._K._K._K._.G</a>
    <a>C.C.C.C.C.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._KГ._K._K._.G</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.G._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._KГ._K._.G</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C._C.E._._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._KВ._K-._-.G</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C._C.E._._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._KВ._K._K._.G</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C._C.E._._._._._._._._._._._._._._._._._._._._._._._._._._._K._KВ._K._K._K._.G</a>
    <a>_C._C._C._C._C._C._C._C._C._C._C._C._C._C.E._._._._._._._._._._._._._._._._._._._._._._._._._._-._K-._KГ._K._K._K._.G</a>
    <a>C.C._._.C.C.C.C.C.C.C.C.C.C.C.G._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._KГ._K._K._.G</a>
    <a>C.C._._.C.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._KГ._K._.G</a>
    <a>C.C._._А.C.G.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._K._K._K._K._K-._-.G</a>
    <a>C.C._._А.C.G.G.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._.F.F.F.F._._._._._._._._._._._K._K._K._K._K._.G</a>
    <a>C.C._._А.C.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G;._._._._._._._._._._._._._._._._._._._._._._K._K._K._K._K._.G</a>
    <a>_._._._А.C.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G;._._._._._._._._._._._._._._._._._._._._K._K._K.G;K.GK.G.G</a>
    <a>_._._._А.C.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G,.G;.G:._._._._._._._._._._._._._._.G:.G;K.G,K.GK.GK.GK.G.G</a>
    <a>_._._._А.C.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G,.G;.G:._._._._._.G:.G;.G,.G.G.GK.GK.GK.GK.GK.G.G</a>
    <a>C.C.C.C.C.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <back id="light4" x="10" y="12"/>
    <obj id="hatch1" code="Edol97aOffVU5UH5" x="2" y="16"/>
    <obj id="table" code="OSxzjYmUOeijo2Vg" x="11" y="15" cont="*">
      <item id="lasp"/>
    </obj>
    <obj id="bloat" code="elxIzmSbbsvnHQnO" x="25" y="14"/>
    <obj id="term" code="M8Hw61f2fOvmWdVk" x="12" y="14">
      <scr act="dialog" val="begDialBloat"/>
    </obj>
    <obj id="bloat" code="ofXF1UAApzY8PX8g" x="35" y="7"/>
    <obj id="wallsafe" code="ZFInezz6Wt2OzukV" x="9" y="2" lock="2" mine="1" lockhp="10000">
      <item id="sphera" imp="1"/>
    </obj>
    <obj id="wallcab" code="DvF7wBjJbeQW3WCw" x="11" y="2">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="ammobox" code="QM5dOdriq45UVaom" x="8" y="4"/>
    <obj id="ebloat" code="nMWu3VciyqCF1a7U" x="28" y="3" multhp="0.6">
      <scr act="unlock" targ="trDoorNest"/>
    </obj>
    <obj id="area" code="QIyTH6VHohuQodKc" x="8" y="15" w="6" h="4">
      <scr>
        <s act="dialog" val="begDialBloat2"/>
        <s act="off" targ="this"/>
      </scr>
    </obj>
    <obj id="door2" uid="trDoorNest" code="FGHyXLXwDcr0L2qg" x="14" y="2" lock="3"/>
    <obj id="player" code="FmGzQegE3NPeyfFj" x="6" y="15"/>
    <back id="konstr" x="40" y="3"/>
    <obj id="medbox" code="ENor7nwbQ05cPmgd" x="9" y="14"/>
    <back id="light4" x="6" y="12"/>
    <back id="stillage" x="11" y="13"/>
    <back id="konstr" x="40" y="15"/>
    <back id="konstr" x="40" y="7"/>
    <back id="konstr" x="40" y="11"/>
    <back id="konstr" x="40" y="19"/>
    <back id="konstr" x="46" y="6"/>
    <back id="konstr" x="46" y="10"/>
    <back id="konstr" x="46" y="14"/>
    <back id="konstr" x="46" y="18"/>
    <back id="hkonstr" x="16" y="3"/>
    <back id="hkonstr" x="22" y="3"/>
    <back id="hkonstr" x="28" y="3"/>
    <back id="hkonstr" x="34" y="3"/>
    <options wrad="0" backwall="tCave"/>
  </room>
  <room name="room_0_2" x="0" y="2">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C._._.C.C.C.C._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C.C._D._D._D._D._D._D._D._D._D._D._D</a>
    <a>C.C.C.C.C._._.C.C.C.C._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C.C._D._D._D._D._D._D._D._D._D._D._D</a>
    <a>C.C.C.C.C._._.C.C.C.C._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C.C._D._D._D._D._D._D._D._D._D._D._D</a>
    <a>C.C.C.C.C._._.C.C.C.C._._._._._._._._._._._._.C;.C;.C;.C;.C;.C;.C;._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.F.F.C.C.C.C.C.C.C.C.C.C.C._._._._._.C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C._D._D._D._D._D._D._D._D._D._D._D._D.C.C.C.C.C._._._._._.C.C.C.C.C.C.C._._А.C._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._D._D._D._D._D._D._D._D._D._D._D._D.C.C.C.C.C._._._._._.C.C.C.C.C.C.C._._А.C._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._D._D._D._D._D._D._D._D._D._D._D._D.C.C.C.C.C._._._._._.C.C.C.C.C.C.C._._А.C._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._D._D._D._D._D._D._D._D._D._D._D._D.C.C.C.C.C._._._._._.C.C.C.C.C.C.C._._А.C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E</a>
    <a>C._D._D._D._D._D._D._D._D._D._D._D._D.C.C.C.C.C._._._._._.C.C.C.C.C.C.C._._А.C._E-._E-._E-._E-._E-._E-.C.C.C._E._E._E._E._E._E</a>
    <a>C._D._D._D._D._D._D._D._D._D._D._D._D.C._D._D._D.C._._._._._.C.C.C.C.C.C.C._._А.C._E._E._E._E._E._E.C.C.C._E._E._E._E._E._E</a>
    <a>C._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.C._._._._._._D._D._D._D._D._D._D._._А.C._E-._E-._E-._E-._E-._E-.C.C.C.C.C.C.C.C.C</a>
    <a>C._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.C._._._._._._D._D._D._D._D._D._D._._А.C._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._А.C._E-._E-._E-._E-._E-._E-.C.C.C.C.C.C.C.C.C</a>
    <a>C._._._._._._._._А._._._._._._._._._._.C._._._._._._._._._._._._А.C._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C</a>
    <a>C._._._._._._._._А._._._._._._._._._._.C._._._._._._._._._._._._А.C._E-._E-._E-._E-._E-._E-.C.C.C.C.C.C.C.C.C</a>
    <a>C._._._._._._._._А._._._._._._._._._._.C._._._._._._._._._._._._А.C._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C</a>
    <a>C._-._-._-._-._-._._._А._._._-._-._-._-._-._-._-._-.C._._._._._._._._._._._._А.C._E-._E-._E-._E-._E-._E-.C.C.C.C.C.C.C.C.C</a>
    <a>C._._._._._._._._А._._._._._._._._._._.C._._._._._._._._._._._._А.C._E._E._E._E._E._E.C.C.C.C.C.C.C.C.C</a>
    <a>C._._._._._._._._А._._._._._._._._._._.C._._._._._._._._._._._._А.C._E-._E-._E-._E-._E-._E-.C.C.C.C.C.C.C.C.C</a>
    <a>C._._._._._._._._._._._._._._._._._._.C._._._._._._._._._._._._А.C._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <obj id="term3" code="cnOzktR17jF6Puz6" x="15" y="12"/>
    <obj id="fspikes" code="LkDJ6MQHY0fRmeEO" x="24" y="1"/>
    <obj id="fspikes" code="D6cp23C7LoAmdcgd" x="23" y="1"/>
    <obj id="fspikes" code="wH4j1bbHYqFGuwvJ" x="22" y="1"/>
    <obj id="fspikes" code="yGhzRZ2iSsphjQMp" x="21" y="1"/>
    <obj id="fspikes" code="ASbtznPHjbVnrC9R" x="19" y="1"/>
    <obj id="fspikes" code="NWW0XieraG2zCATh" x="18" y="1"/>
    <obj id="fspikes" code="xmtnYWzsgJMgqssS" x="20" y="1"/>
    <obj id="fspikes" code="XrLL9XrL3SUbz9z5" x="16" y="1"/>
    <obj id="fspikes" code="Cs4qHO2v7jtwbYmc" x="15" y="1"/>
    <obj id="medbox" code="hBInxY3ALuz54TAU" x="12" y="3">
      <scr act="off" targ="trDash"/>
    </obj>
    <obj id="chest" code="gAJM9qVqJ07CxMij" x="14" y="4" lock="0">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="molerat" code="wb4CbK2tJJOsSTF2" x="25" y="23"/>
    <obj id="fspikes" code="rHNTCIMoNtZJ9DDZ" x="17" y="1"/>
    <obj id="player" code="HM8dnGPOpl14m3E4" x="44" y="11"/>
    <obj id="ammobox" code="ThzcnuNghbK6kVx0" x="38" y="3"/>
    <obj id="door2" code="XgsGXUi2QAvzL0Pm" lock="0" x="32" y="23"/>
    <obj id="door2" code="hfBYx3aP6VOG3SNB" x="19" y="23" lock="0"/>
    <obj id="molerat" code="ejN3xMeJLfvYZ7bK" x="2" y="17"/>
    <obj id="molerat" code="IshvePTNktI6uQeg" x="15" y="17"/>
    <obj id="wallcab" code="YLAis2dLq4LwfKoO" x="42" y="2"/>
    <obj id="rat" code="jPNQL24mtlhpqZjW" x="13" y="23"/>
    <obj id="ammobox" code="i9PpIQ6j1jOSIJ2G" x="26" y="3"/>
    <obj id="bloat" code="j4mGqzui4sHxE6W1" x="5" y="2"/>
    <obj id="case" code="Ppyuica1i4JswVcz" x="6" y="4">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="door1a" code="w2WmQFK6GL2FCABd" x="13" y="13"/>
    <obj id="rat" code="P46Vr1oe6QxbM8OM" x="5" y="23"/>
    <obj id="ammobox" code="TG4JnhC2zl7qopC4" x="17" y="17"/>
    <obj id="area" code="Z8yxggyx1bqOBdNz" x="39" y="9" mess="trShelf"/>
    <obj id="area" uid="trDash" code="nQJfOqB3NxoPV2l3" x="23" y="3" mess="trDash" down="1"/>
    <obj id="instr2" code="TWI74leXN07nOaCB" x="39" y="2" cont="">
      <item id="bat"/>
      <item id="aero" kol="100"/>
    </obj>
    <obj id="area" code="dAYd4CEi1pc23K15" x="20" y="23" w="28" mess="trDash2"/>
    <back id="battery" x="22" y="23"/>
    <back id="battery" x="28" y="23"/>
    <back id="pipe1" x="0" y="16"/>
    <back id="pipe1" x="10" y="16"/>
    <back id="rak" x="2" y="22"/>
    <back id="unitaz" x="11" y="22"/>
    <back id="unitaz" x="15" y="22"/>
    <back id="poster" x="3" y="11"/>
    <back id="poster" x="10" y="10"/>
    <back id="potek" x="11" y="1"/>
    <back id="potek" x="21" y="1"/>
    <back id="pipe1" x="15" y="6"/>
    <back id="pipe1" x="15" y="9"/>
    <back id="vent" x="21" y="16"/>
    <back id="vent" x="23" y="16"/>
    <back id="vent" x="25" y="16"/>
    <back id="vent" x="27" y="16"/>
    <back id="vent" x="29" y="16"/>
    <back id="light2" x="22" y="15"/>
    <back id="light2" x="27" y="15"/>
    <back id="light2" x="35" y="7"/>
    <back id="light2" x="39" y="1"/>
    <back id="web1tl" x="37" y="1"/>
    <back id="web1bl" x="11" y="2"/>
    <options wrad="0"/>
  </room>
  <room name="room_2_0" x="2" y="0">
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.A._F._F._F._F._F._F._F._F._F._F._F._F._F._O._O._F._F._F._F._F._F._F._F._F._F._F._F._F.A.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.A._F._F._F._F._F._F._F._F._F._F._F._F._F._O._O._F._F._F._F._F._F._F._F._F._F._F._F._F.A.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.A._F._F._F._F._F._F._F._F._F._F._F._F._F._O._O._F._F._F._F._F._F._F._F._F._F._F._F._F.A.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.A._F._F._F._F._F._F._F._F._F._F._F._F._F._O._O._F._F._F._F._F._F._F._F._F._F._F._F._F.A.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.A._F._F._F._F._F._F._F._F._F._F._F._F._O._O._O._O._F._F._F._F._F._F._F._F._F._F._F._F.A.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.A._F._F._F._F._F._F._F._F._F._F._O._O._O._O._O._O._O._O._F._F._F._F._F._F._F._F._F._F.A.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.A._F._F._F._F._F._F._F._F._F._F._O._O._O._O._O._O._O._O._F._F._F._F._F._F._F._F._F._F.A.H.H.H.H.H.H.H.H.H</a>
    <a>A.A.A.A.A.A.A.A.A.A._F._F._F._F._F._F._F._F._F._F._O._O._F._F._F._F._O._O._F._F._F._F._F._F._F._F._F._F.A.A.A.A.A.A.A.A.A.A</a>
    <a>_._._._._._._._._._G._F._F._F._F._F._F._F._F._F._F._O._O._F._F._F._F._O._O._F._F._F._F._F._F._F._F._F._F._._._._._._._._._._</a>
    <a>_._._._._._._._._._G._F._F._F._F._F._F._F._F._F._F._O._O._F._F._F._F._O._O._F._F._F._F._F._F._F._F._F._F._._._._._._._._._._</a>
    <a>_._._._._._._._._._G._F._F._F._F._F._F._F._F._F._F._O._O._F._F._F._F._O._O._F._F._F._F._F._F._F._F._F._F._._._._._._._._._._</a>
    <a>A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <obj id="player" code="aO4un9KLHgCVYbIo" x="4" y="15"/>
    <obj id="area" code="RRQ78BEyQpXO8yA2" x="17" y="15" h="10" w="7" scr="beginMtn"/>
    <obj id="area" code="N4lXezpHYysPCupl" x="31" y="15" h="6" w="7" mess="trPipbuck"/>
    <obj id="door3" uid="begDoor" x="38" y="15" locktip="0" code="ouEctKHpD8NjKL3a"/>
    <obj id="checkpoint" uid="begCP" x="23" y="15" code="RAjyxYOw8qcyS0t0"/>
    <back id="light4" x="19" y="5"/>
    <back id="light4" x="27" y="5"/>
    <back id="light4" x="12" y="5"/>
    <back id="light4" x="34" y="5"/>
    <back id="vents" x="19" y="7"/>
    <back id="vents" x="12" y="7"/>
    <back id="vents" x="27" y="7"/>
    <back id="vents" x="34" y="7"/>
    <back id="light5" x="31" y="6"/>
    <back id="light5" x="16" y="6"/>
    <back id="wires1" x="23" y="5"/>
    <back id="wires1" x="23" y="7"/>
    <back id="wires1" x="23" y="9"/>
    <back id="wires1" x="23" y="11"/>
    <back id="wires1" x="23" y="13"/>
    <options color="red"/>
  </room>
  <room name="room_1_0" x="1" y="0">
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._C-._C-._C-._C-._C-._C-._C-._C-._C-._C-._C-._C-.C.H.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>_D._D._D._D._D._D._D._D._D.DD.DD.DD.DD._D._D._D._D._D._D.C.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>_D._D._D._D._D._D._D._D._D.DD.DD.DD.DD._D._D._D._D._D._D.C.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>_D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.C.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._D-._D-._D-.C.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._D.C.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._D.C.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._D.C.H.H.H.H.H.H.H.C._C._C._C._C._C._C._C._C._C._C._C._C.C.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._D.C.C.C.C.C.C.C.C.C.C.C.C.C.C._C-._C-._CА-.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._D._C._C._C._C._C._C._C._C._C._._._._._._._._А._._.C._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._D._C._C._C._C._C._C._C._C._C._._._._._._._._А._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._D._C._C._C._C._C._C._C._C._C._._._._._._._._А._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>H.H.H.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._А.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._D._D._D._D._D._D._D._D.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._А.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._D._D._D._D._D._D._D._D.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._._А.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._D._D._D._D._D._D._D._D.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._А.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._D._D._D._D._D._D._D._D._._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._D._D._D._D._D._D._D._D._._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C._D._D._D._D._D._D._D._D._._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._EА.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="pipe4" x="38" y="4"/>
    <obj id="area" code="OYJU8YlgKzkzUZTv" x="5" y="7" mess="trSit"/>
    <obj id="area" code="I3ndeRBGnIouAx0Z" x="16" y="7" mess="trDownJump"/>
    <obj id="case" x="31" y="2" code="fInksMkFM1Rj4kRT" uid="trSign3">
      <item id="col1" imp="1"/>
      <scr targ="trTele" act="off"/>
    </obj>
    <obj id="area" uid="trCont" code="RMLiZLoa3LwKjjjK" x="16" y="15" w="5" mess="trCont">
      <scr targ="trSign1" act="sign" val="1"/>
    </obj>
    <obj id="area" uid="trTele" code="drajCNRpM05nIlWN" x="34" y="11" mess="trTele" down="1">
      <scr targ="trSign3" act="sign" val="1"/>
    </obj>
    <obj id="area" uid="trPunch" code="D55F3NFVYNkPeyIt" x="15" y="23" w="6" mess="trPunch">
      <scr targ="trSign2" act="sign" val="1"/>
    </obj>
    <obj id="wallcab" x="23" cont="" y="14" code="jqoF54gK5Sa6YvOd" lock="0" uid="trSign1">
      <item id="col1" imp="1"/>
      <scr targ="trCont" act="off"/>
    </obj>
    <obj id="case" x="8" y="23" code="sR7whrdZZxsQOsSM">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="septum" x="12" y="23" code="nJrkP0fKTo7ty31p" inter="0" uid="trSign2">
      <scr eve="die" targ="trPunch" act="off"/>
    </obj>
    <back id="pipe4" x="38" y="8"/>
    <back id="pipe4" x="38" y="10"/>
    <back id="pipe4" x="29" y="10"/>
    <back id="pipe1" x="25" y="4"/>
    <back id="pipe4" x="38" y="6"/>
    <back id="pipe4" x="38" y="0"/>
    <back id="pipe4" x="29" y="0"/>
    <back id="pipe4" x="29" y="6"/>
    <back id="pipe4" x="29" y="4"/>
    <back id="pipe4" x="29" y="2"/>
    <back id="pipe4" x="29" y="8"/>
    <back id="pipe4" x="38" y="2"/>
    <obj id="door1" x="38" y="15" lock="0" code="ACmqoTi6dil3iQgs"/>
    <back id="pipe1" x="35" y="4"/>
    <back id="light1" x="7" y="6"/>
    <back id="light1" x="14" y="6"/>
    <back id="potek" x="3" y="18"/>
    <back id="light2" x="31" y="1"/>
    <back id="light2" x="35" y="1"/>
    <back id="hkonstr" x="4" y="18"/>
    <back id="hkonstr" x="10" y="18"/>
    <back id="web1tr" x="16" y="5"/>
    <back id="web1tr" x="37" y="1"/>
    <back id="web1bl" x="4" y="21"/>
    <back id="pipe1" x="3" y="19"/>
    <back id="pipe4" x="6" y="22"/>
    <back id="pipe4" x="6" y="20"/>
    <back id="pipe4" x="6" y="18"/>
    <back id="plesen" x="3" y="22"/>
    <back id="plesen" x="12" y="22"/>
    <back id="plesen" x="22" y="22"/>
    <back id="stok2" x="33" y="6"/>
    <back id="stok2" x="36" y="6"/>
    <back id="stok2" x="30" y="6"/>
    <options/>
  </room>
  <room name="room_2_1" x="2" y="1">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_._.F._._._._._._._._._._._._._._._._.F._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>_._.F._._._._._._._._._._._._._._._._.F._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C._-._-._Г._._._._._._._._._._._._._.F._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C._._._._Г._._._._._._._._._._._._.F._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C._._._._._Г._._._._._._._._._._._.F._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._._В._-._-._-.C.C.C.C.E.E.E.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._._._._._._._В._._._._.C.C.C.C._A._A._A._A._A._A._A._A.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._._._._._._В._._._._._.C.C.C.C.CA.CA.CA.CA.CA.CA._A._A.C</a>
    <a>C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._В._._._._._._.C.C.C.C.CA.CA.CA.CA.CA.CA._A._A.C</a>
    <a>C.C._._._._._._._._._._._._._._._._._._._._._._._._._._В._._._._._._._.C.C.C.C.CA._A._A._A._A._A._A._A.C</a>
    <a>C.C._._._._._._._._._._._._._._._._._._._._._._._._._В._._._._._._._._.C.C.C.C.CA._A-._A-._A-._A._A._A._A.C</a>
    <a>C.C._._А.D.D.D.D._._.D.D._._.D.D._._.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.C.C.C.C.CA._A._A._A._A._A._A._A.C</a>
    <a>C.C._._А.D.D.D.D._._.D.D._._.D.D._._.D.C.C.C.C.C.C.C.C.C._A._A._A._A._A._A._A._A._A._A._A._A._A._A._A._A._A._A._A.C</a>
    <a>C.C._._А.D.D.D.D._._.D.D._._.D.D._._.D.C.C.C.C.C.C.C.C.C._._.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C._._А.D.D.D.D._._.D.D._._.D.D._._.D.C.C.C.C.C.C.C.C.C._C._C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._C._C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C._._А.C.C.C._._._._._._._._._._I._I._I._I._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._I._I._I._I._I._I._I._I._I.C</a>
    <a>C.C._._А.C.C.C._._._._._._._._._.C.C.C.C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C._._А.C.C.C._._._._._.C.C.C.C.C.C.C.C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C._._А.C.C.C._._._._._.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C._._А._._._._._._._._._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._CА._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C.CC</a>
    <a>C.C._._А._._._._._._._._._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._CА._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C.CC</a>
    <a>C.C._._А._._._._._._._._._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._CА._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C._C.CC</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._C._C._C._C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <obj id="spikes" code="OV6wpYeFDWLXtFR8" x="13" y="15"/>
    <obj id="tarakan" code="BFTqPXHecpqWQuAO" x="44" y="17"/>
    <obj id="tarakan" code="YhjjS27ElSkkgz8h" x="45" y="17"/>
    <obj id="hatch1" code="cVmL8kL220k8JTBh" x="28" y="14" lock="0"/>
    <obj id="door3" uid="trMDoor" code="VVjUWaNcxmKhhpA1" x="12" y="23" lock="3"/>
    <obj id="ammobox" code="pZu3bApfKisxwceA" x="43" y="13"/>
    <obj id="case" code="MeIAluQQj7SC3lsZ" x="41" y="10"/>
    <obj id="case" code="MnEazoGecV0oUt7j" x="42" y="10"/>
    <obj id="weapbox" code="oaFfGxsfdHSYGllZ" x="44" y="5" cont="*">
      <item id="shok"/>
    </obj>
    <obj id="instr1" code="DjyenstHgwvcA3Lh" x="44" y="23">
      <item id="mont" kol="1"/>
      <item id="aero" kol="100"/>
    </obj>
    <obj id="bloat" code="na3wwzYpsO76ptc7" x="14" y="2"/>
    <obj id="bloat" code="gCMUWWviZapeNqVZ" x="8" y="4"/>
    <obj id="spikes" code="WMelHJ7xE3oVyENi" x="8" y="15"/>
    <obj id="ammobox" code="aSmn1z9iokqtCq5q" x="41" y="13"/>
    <obj id="spikes" code="XOJZm63A3kC06r0l" x="12" y="15"/>
    <obj id="spikes" code="gd1d5046bTN5G3HK" x="9" y="15"/>
    <obj id="spikes" code="zYKeK3iko8dgN1G9" x="16" y="15"/>
    <obj id="spikes" code="r5f0DwZPxUIDsyTf" x="17" y="15"/>
    <obj id="case" code="e1M0JcK845yrUbXR" x="42" y="5">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="player" code="GJbeeWqA2k1TDlT4" x="23" y="11"/>
    <obj id="area" code="e16zXoOlr6MPIujA" x="6" y="11" w="14" mess="trFast"/>
    <obj id="area" uid="trWeaponUp" code="Rv5v9oglJp33p6Ns" x="23" y="19" mess="trWeaponUp"/>
    <obj id="fspikes" code="NDZ1ci58CdhDGIih" x="7" y="9"/>
    <obj id="fspikes" code="rJKdi067V3AdciqE" x="9" y="9"/>
    <obj id="fspikes" code="HhwoGvmrbW6YPUXe" x="13" y="9"/>
    <obj id="fspikes" code="FfL05Txl9lgn7qZ6" x="16" y="9"/>
    <obj id="fspikes" code="XXRZyWfqoXEWEAa9" x="18" y="9"/>
    <obj id="area" code="wJPQ2FnFgLxhL47l" x="24" y="11" mess="trDiagon"/>
    <obj id="knop2" code="CMzLmlZdXvkead6a" x="8" y="17">
      <scr>
        <s act="unlock" targ="trMDoor"/>
        <s act="off" targ="trWeaponUp"/>
      </scr>
    </obj>
    <obj id="checkpoint" code="Ij1mxj7OxGSpiD7F" x="32" y="11"/>
    <obj id="case" code="koVyabDWnfViDhlG" x="43" y="17">
      <item id="col1" imp="1"/>
    </obj>
    <options bezdna="1" backwall="tDirt"/>
  </room>
  <room name="room_1_3" x="1" y="3">
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.DD._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.DD._D._D._D._D._D._D._D._D.DD.DD._D._D.D</a>
    <a>D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.D</a>
    <a>D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.DD.DD.DD.DD.DD._D._D.D</a>
    <a>D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._D._D.D</a>
    <a>D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._D._D.D</a>
    <a>D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._D._D.D</a>
    <a>D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._D._D.D</a>
    <a>D._D-._D-._D-._D-._D-._D-.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._._._._._D.DD._D._D._D._D._D._D._D.D</a>
    <a>D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._._._._._D._D._D._D._D._D._D._D._D.D</a>
    <a>D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._._._._._D._D._D._D._D._D._D._D._D.D</a>
    <a>D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._-._-._-._-.D</a>
    <a>D._D-._D-._D-._D-.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._._._._._._._</a>
    <a>_._D._D._D._D.D._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._D._D._D._D._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._D._D._D._D._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>D.D.D.D.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*.D.D.D._._._._._</a>
    <a>D.D.D.D.D.D.D.D.D._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*.D.D.D._._._._._</a>
    <a>D.D.D.D.D.D.D.D.D._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*._*.D.D.D._._._._._</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._А.D.D.D</a>
    <obj id="explbox" code="fHM7BlfrbS0gxDnM" x="23" y="3"/>
    <obj id="fspikes" code="cLp9o3NepcHYrZIq" x="38" y="13"/>
    <obj id="fspikes" code="omh48SwQJW1MwhYm" x="37" y="13"/>
    <obj id="fspikes" code="cEiPTIAF3j1KEo9V" x="36" y="13"/>
    <obj id="woodbox" code="p5utJNliFWBUhIAf" x="41" y="15"/>
    <obj id="door1" code="KjHX4Gxrfa7aFcR5" x="39" y="10"/>
    <obj id="woodbox" code="gT6PRadPCeP4pI7q" x="35" y="10"/>
    <obj id="ammobox" code="qcDPEQq6auovwoFV" x="33" y="10"/>
    <obj id="ammobox" code="T8QocVa4pEzrfcZM" x="36" y="23"/>
    <obj id="ammobox" code="qlBnDEvl9n7nwTW4" x="23" y="23"/>
    <obj id="fspikes" code="LxXRZUidC1Qh6hHi" x="39" y="13"/>
    <obj id="door1" code="YO5L25FMPamQ8I96" x="5" y="15"/>
    <obj id="wallcab" code="fmIBCOfR18GsPpXo" x="5" y="10">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="molerat" code="rqfYFdsZ4ubr1eY8" x="27" y="3"/>
    <obj id="rat" code="UaPeFFzFm0C1w4Nj" x="2" y="7"/>
    <obj id="rat" code="TCHDLCcYNswsVan8" x="5" y="7"/>
    <obj id="instr2" code="rBJzp2oN1nROaT4c" x="10" y="2"/>
    <obj id="medbox" code="O3n4tPrnBNleKdTu" x="13" y="2"/>
    <obj id="weapbox" code="TZbr777BcP0DE8D6" x="19" y="3" cont="*">
      <item id="p10mm"/>
    </obj>
    <obj id="door1" code="ldDaq4s3DltdfavX" x="17" y="3"/>
    <obj id="ammobox" code="SQZz5gRRmRCLlcBd" x="32" y="3"/>
    <obj id="door1" code="CE5MvAJzjaWiRQLo" x="34" y="3"/>
    <obj id="explbox" code="CPgNbWayFNRx6Hse" x="37" y="10"/>
    <obj id="woodbox" code="PEFHtcfRvvTQfQGx" x="44" y="10"/>
    <obj id="woodbox" code="ECwEnZlouBaSRfgi" x="37" y="19"/>
    <obj id="woodbox" code="d6LjFZlqWbqsbCrh" x="11" y="19"/>
    <obj id="area" code="q7u4JaHfwlsGZXAq" x="40" y="15">
      <scr>
        <s act="dialog" val="begDialWater"/>
        <s act="off" targ="this"/>
      </scr>
    </obj>
    <back id="depot" x="32" y="8"/>
    <back id="depot" x="34" y="8"/>
    <back id="depot" x="36" y="8"/>
    <back id="pipes" x="22" y="1"/>
    <back id="pipes" x="27" y="1"/>
    <back id="pipes" x="36" y="1"/>
    <back id="pipes" x="13" y="1"/>
    <back id="pipe1" x="0" y="10"/>
    <back id="pipe1" x="0" y="6"/>
    <back id="light1" x="32" y="1"/>
    <back id="light1" x="19" y="1"/>
    <back id="light1" x="2" y="1"/>
    <back id="light1" x="5" y="1"/>
    <back id="pipe2" x="28" y="21"/>
    <back id="pipe2" x="16" y="21"/>
    <back id="pipe2" x="4" y="21"/>
    <back id="rad" x="43" y="13"/>
    <options wrad="6" wtip="1" color="green" backwall="tMossy"/>
  </room>
  <room name="room_2_4" x="2" y="4">
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J.D</a>
    <a>D.D.D.D._A._A._A.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J.D</a>
    <a>D.D.D.D.EA.EA.EA.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J._J.D</a>
    <a>D.D.D.D._A._A._A.E._B._B._B._B._BА._B._B._B._B._B.D.D.D.D._J._J._J._J._J._J._J._J._J._J._J.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D._A._A._A.E._B._B._B._B._BА._B._B._B._B._B.D.D.D.D._DБ-._D-._D-._D-._D-._D-._D-._D-._D-._D-._D-.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D._A._A._A.E._B._B._B._B._BА._B._B._B._B._B.D.D.D.D._DБ._D._D._D._D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D._A._A._A.E._B._B._B._B._BА._B._B._B._B._B.D.D.D.D._DБ._D._D._D._D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D._._А.D.D.D.D.D.D.D.D.D._DБ._D._D._D._D._D._D._D._D._D._D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D._._._._._._А._._._А._._._А._._._._.D.D._DБ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.D</a>
    <a>D.D.D.D._._._._._._А._._._А._._._А._._._._.D.D._DБ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.D</a>
    <a>D.D.D.D._._._._._._А._._._А._._._А._._._._.D.D._DБ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.D</a>
    <a>D.D.D.D._._._._._._А._._._А._._._А._._._._.D.D.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD._D-._DГ._D._D._D._D._D.D</a>
    <a>D.D.D.D._._._._._._А._._._А._._._А._._._._.D.D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.DD._D._D._DГ._D._D._D._D.D</a>
    <a>_._._._._._._._._._._._._А._._._._._._._._._._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.DD._D._D._D._DГ._D._D._D.D</a>
    <a>_._._._._._._._._._._._._А._._._._._._._._._._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.DD._D._D._D._D._DГ._D._D.D</a>
    <a>D.D.D.D.D.D._._._._._._._._._._._._.D.D.D.D.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD.DD._D._D.DD.DD.DD.DD.DD._D._D._D._D._DВ._D-._D-.D</a>
    <a>D.D.D.D.D.D._._._._._._._._._._._._.D.D.D.D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DВ._D._D._D.D</a>
    <a>D.D.D.D.D.D._._._._._._._._._._._._.D.D.D.D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DВ._D._D._D._D.D</a>
    <a>D.D.D.D.D.D._._._._._._._._._._._._.D.D.D.D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DВ._D._D._D._D._D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <back id="light3" x="15" y="5"/>
    <obj id="scorp" code="PXzJVgBHlAMptBTj" x="29" y="4"/>
    <obj id="wallcab" code="Zn1erj1Zrhm1s3ul" x="45" y="2">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="ammobox" code="vBSNVnxbHXrPa5iz" x="42" y="3"/>
    <obj id="ammobox" code="Rcx6vp5TBQOQUovr" x="38" y="3"/>
    <obj id="table" code="K5JHYB144oVeiv1x" x="35" y="3"/>
    <obj id="instr1" code="O8PYts35Vtbg3UcZ" x="36" y="15">
      <item id="lighter"/>
    </obj>
    <obj id="medbox" code="nU9OlTakvHEAABrz" x="40" y="2">
      <item id="antidote"/>
    </obj>
    <obj id="scorp" code="D6SysGKbpBw88BD2" x="13" y="19"/>
    <obj id="medbox" code="vHzFHDXyJjGt7IcE" x="15" y="6" cont="">
      <item id="antidote"/>
    </obj>
    <obj id="hatch1" code="LlFIpbg46a74L08s" x="33" y="16" lock="0"/>
    <obj id="door1" code="SHJ4BHnq1myu1u5Y" x="21" y="15"/>
    <obj id="chest" code="ouDrRyNcGUlUgIkE" x="5" y="2"/>
    <obj id="scorp" code="moRetnE4CT8jpfB0" x="27" y="15"/>
    <obj id="scorp" code="yFbFnlnxncM0LJc0" x="26" y="19"/>
    <back id="unitaz" x="5" y="6"/>
    <back id="plesen" x="4" y="18"/>
    <back id="konstr" x="10" y="4"/>
    <back id="konstr" x="13" y="4"/>
    <back id="poster" x="8" y="5"/>
    <obj id="scorp" code="Fi7DzdcjDKppgekW" x="24" y="4"/>
    <back id="plesen" x="12" y="18"/>
    <back id="vkonstr" x="45" y="17"/>
    <back id="vkonstr" x="45" y="14"/>
    <back id="vkonstr" x="45" y="11"/>
    <back id="vkonstr" x="45" y="8"/>
    <back id="vkonstr" x="39" y="17"/>
    <back id="vkonstr" x="39" y="14"/>
    <back id="vkonstr" x="39" y="11"/>
    <back id="vkonstr" x="39" y="8"/>
    <back id="fuse" x="22" y="9"/>
    <back id="fuse" x="26" y="9"/>
    <back id="fuse" x="30" y="9"/>
    <back id="fuse" x="34" y="9"/>
    <back id="pipes2" x="41" y="17"/>
    <back id="web1tl" x="22" y="1"/>
    <back id="web1bl" x="4" y="5"/>
    <back id="web1bl" x="22" y="17"/>
    <back id="web1tr" x="44" y="9"/>
    <back id="web1bl" x="22" y="9"/>
    <options backwall="tDirt"/>
  </room>
  <room name="room_3_1" x="3" y="1">
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>C._C._C._C._C._C._C.GC.GC.GC.GC.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>C._C._C._C._C._C._C.GC.GC.GC.GC.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>C._C._C._C._C._C._C.GC.GC.GC.GC.G.G._._._._._._._._._._._._._._._._._._._._._._._._.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>C._C._C._C._C._C._C.GC.GC.GC.GC.G._._._._._._._._._._._._._._._._._._._._._._._._._.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>C.CC.CC.CC._C._C._C._C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>C.CC.CC.CC._C._C._C._C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G.G._._._._._._._.C</a>
    <a>C.CC.CC.CC._C._C._C._C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G._._._._._._._._.C</a>
    <a>C.CC.CC.CC._C._C._C._C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.CC.CC.CC._C._C._C._C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._Б-._-._-._-._._._._._._._._._._._._._._._._-._-._А-.C.C.C.C._._._.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._Б._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C._*._*._*.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._Б._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C._*._*._*.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._Б._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C._*._*._*.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._Б._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C._*._*._*.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C._*._*._*._*._*._*._*</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C._*._*._*._*._*._*._*</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C._*._*._*._*._*._*._*</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C._._._._._._._._._._._._._._._._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._C._CА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._C-._CА-.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <obj id="player" code="FT1l2aiJUS0nHKLP" x="15" y="11"/>
    <obj id="tarakan" x="19" y="21" code="z73uNEsCLjMiwWWw"/>
    <obj id="wallcab" x="2" y="4" code="MlzWbi5nE41YKzjU" lock="0">
      <item id="col1" imp="1"/>
      <scr targ="trLevitUp" act="off"/>
    </obj>
    <obj id="tarakan" x="24" y="21" code="xOOnv1kujxkHMXAo"/>
    <obj id="area" code="liv1wxJ8cn2Id928" x="39" y="11" mess="trZoom"/>
    <obj id="area" code="srrGwklIxXAAv9eC" x="34" y="11" h="6" scr="beginLevit"/>
    <obj id="area" uid="trLevitUp" mess="trLevitUp" code="xT6sHZiSAoHfc2X7" x="4" y="11"/>
    <obj id="area" uid="trLevit" mess="trLevit" code="Q0DOgcHoPVJu32Hp" x="35" y="11" off="1"/>
    <back id="vents" x="4" y="4"/>
    <back id="rgraff" x="18" y="17"/>
    <back id="rgraff" x="24" y="14"/>
    <back id="rgraff" x="31" y="17"/>
    <back id="web1tr" x="44" y="8"/>
    <back id="web1tr" x="4" y="3"/>
    <options wrad="0" backwall="tConcreteDirt"/>
  </room>
  <room name="room_1_2" x="1" y="2">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_E._E._E._E._E._E._E._E.EE._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E.CE.CE.CE.CE._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E</a>
    <a>_E._E._E._E._E._E._E._E.EE._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E</a>
    <a>_E._E._E._E._E._E._E._E.EE._E._E._E._E._E._E._E._E.CE.CE.CE.CE.CE._E._E._E._E.CE.CE.CE.CE._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E</a>
    <a>C.C.C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C._._._.E._._._._._._А.C._._._._А._._._._А._._._._А._._._._А._._._._._._._._._._._._.C._._._._._._.C</a>
    <a>C._._._.E._._._._._._А.C._._._._А._._._._А._._._._А._._._._А._._._._._._._._._._._._.C._._._._._._.C</a>
    <a>C._._._.E._._._._._._А.C._._._._А._._._._А._._._._А._._._._А._._._._._._._._._._._._.C._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._А.C._._._._А._._._._А._._._._А._._._._А._._._._._._._._._._._._.C.C.C._-._-._-._-.C</a>
    <a>_._._._._._._._._._._А.C._._._._А._._._._._._._._А._._._._А._._._._._._._._._._._._._._._._._._._.C</a>
    <a>_._._._._._._._._._._А.C._._._._А._._._._._._._._А._._._._А._._._._._._._._._._._._._._._._._._._.C</a>
    <a>_._._._._._._._._._._А.C._._._._А._._._._._._._._А._._._._А._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C._._._._._._._._._А.C._._._._А._._._._._._._._А._._._._А._._._._._._._._._._._._._._._._А.C.C.C.C</a>
    <a>C.C._._._._._._._._._А.C._._._._._._._._._._._._._._._._А._._._._._._._._._._._._._._._._А._._._._</a>
    <a>C.C._._._._._._._._._А.C._._._._._._._._._._._._._._._._А._._._._._._._._._._._._._._._._А._._._._</a>
    <a>C.C._._._._._._._._._А.C._._._._._._._._._._._._._._._._А._._._._._._._._._._._._._._._._А._._._._</a>
    <a>C.C._._А.C.C.C.C.C.C.C.C.C.C._._.C.C._._._._._._._._._._А._._._._._А.C.C.C;._._._._._._._._А._._._._</a>
    <a>C._._._А._._._.C.C.C.C.C._._._._.C.C._._._._._._._._._._А._._._._._А.C.C.C.C.C;._._._._._._А._._._._</a>
    <a>C._._._А._._._.C.C.C.C.C._._._._.C.C._._._._._._._._._._._._._._._А.C.C.C.C.C.C.C;._._._._А._._._._</a>
    <a>C._._._А._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._А.C.C.C.C.C.C.C.C.C;._._А._._._._</a>
    <a>C._H._H._HА._H._H._H._H._H._H._H._H._H._H._H._H.C.C._H._H._H._H._H._H._H._H._H._H._H._H._H._H._HА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.CH.CH.CH.CH._H._H._H._H._H._H._H._H._H.CH.CH.C.C._H._H._H._H._H._H._H._H._H._H._H._H._H._H._HА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.CH.CH.CH.CH._H._H._H._H._H._H._H._H._H.CH.CH.C.C._H._H._H._H._H._H._H._H._H._H._H._H._H._H._HА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.CH.CH.CH.CH._H._H._H._H._H._H._H._H._H.CH.CH.C.C._H._H._H._H._H._H._H._H._H._H._H._H._H._H._HА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <obj id="spikes" code="yFrr0uENDCaQ0mGs" x="7" y="23"/>
    <obj id="spikes" code="Vooe9CFh5iD9z0ON" x="13" y="15"/>
    <obj id="spikes" code="CCOxqKGDivGJZ5Ey" x="16" y="15"/>
    <obj id="spikes" code="d0krjwFrKrc5J3RO" x="17" y="15"/>
    <obj id="spikes" code="RPSQNAzfaG6RcWqN" x="18" y="23"/>
    <obj id="spikes" code="ICJDgSlFZhxWSAH0" x="19" y="23"/>
    <obj id="spikes" code="jPu7W3MgkMiBegHU" x="20" y="23"/>
    <obj id="spikes" code="w0NGCzFnuuDZZPb7" x="21" y="23"/>
    <obj id="spikes" code="aTMt8FlyFI3ac2v0" x="22" y="23"/>
    <obj id="spikes" code="kBCpj9IQI4NLr9NV" x="24" y="23"/>
    <obj id="spikes" code="rOzpCLWusry5Mt7K" x="23" y="23"/>
    <obj id="spikes" code="ziEI70rBstdOGdu2" x="25" y="23"/>
    <obj id="spikes" code="yqMurIrr75VEnalg" x="27" y="23"/>
    <obj id="spikes" code="XvYTYLqArWyjCyb5" x="26" y="23"/>
    <obj id="spikes" code="aonMhMjYz9On33W8" x="5" y="23"/>
    <obj id="spikes" code="pToruIbJ9wWAwoa1" x="6" y="23"/>
    <obj id="spikes" code="zkQ586SAKiKsxyGc" x="12" y="15"/>
    <obj id="spikes" code="XZazbobAVy9GB0HG" x="8" y="23"/>
    <obj id="spikes" code="zHEMLPptkDHjn4Rg" x="9" y="23"/>
    <obj id="spikes" code="W3FjqX4gLjkMNUFY" x="10" y="23"/>
    <obj id="spikes" code="iL4bCKRNx0Dvp11q" x="11" y="23"/>
    <obj id="spikes" code="lqk79ZSlItYhavBm" x="12" y="23"/>
    <obj id="spikes" code="nogrP7MLNsnUB1RM" x="13" y="23"/>
    <obj id="woodbox" code="LjfTlAbjMC2wGuUu" x="2" y="20"/>
    <obj id="woodbox" code="HXKE6xj8ttbMJCCI" x="11" y="23"/>
    <obj id="weapbox" code="jh6buSipuImHGYZC" x="41" y="7" cont="*">
      <item id="p9mm"/>
    </obj>
    <obj id="ammobox" code="YL7N5Du8K8ctc1RO" x="44" y="7"/>
    <obj id="chest" code="E14hRTfb8ushsWOv" x="1" y="7">
      <item id="mach"/>
    </obj>
    <obj id="rat" code="MWTLr09w1LN2S7u7" x="2" y="6"/>
    <obj id="rat" code="hlTGoVZub7bHEGvO" x="18" y="2"/>
    <obj id="rat" code="SZe28CPTJ60Lf8uT" x="33" y="3"/>
    <obj id="tarakan" code="DubqSgJm4EqQ4cfM" x="21" y="2"/>
    <obj id="tarakan" code="BsZpPrN2VkEf8kkY" x="39" y="3"/>
    <obj id="case" code="NW3wnKmCiBhGTZk2" x="5" y="3"/>
    <obj id="area" code="p8Ka9vAf8C3xSdb7" x="33" y="15" mess="trStairs"/>
    <obj id="area" code="sciKXvEhDF4hJGj1" x="14" y="11" h="6" mess="trStDown"/>
    <obj id="area" code="SDHwaqqnOyCCa4Re" x="27" y="14" h="10" mess="trStJump"/>
    <obj id="area" code="RfgQtfSdNYGMCkng" x="14" y="3" mess="trVlaz" w="18"/>
    <back id="chole1" x="19" y="10"/>
    <back id="chole5" x="27" y="8"/>
    <back id="chole6" x="21" y="15"/>
    <back id="vkonstr" x="11" y="1"/>
    <back id="vkonstr" x="44" y="1"/>
    <back id="web1bl" x="1" y="5"/>
    <back id="web1bl" x="1" y="18"/>
    <back id="web1tl" x="41" y="5"/>
    <options wrad="0" backwall="tLeaking"/>
  </room>
  <room name="room_4_0" x="4" y="0">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._._._._._.C._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F.CF.CF.CF.CF.CF</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._._._._._.C._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F.CF.CF.CF.CF.CF</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._._._._._.C._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F.CF.CF.CF.CF.CF</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._._._._._.C._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F.CF.CF.CF.CF.C</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._._._._._.C._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F.C</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._._._._._.C._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F.C</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._._._._._.C._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F._F.C</a>
    <a>C.C.C.C.C.C.C._-._А-.C.C.C.C.C.C.C.C.C._-._-._-._-._-._-.C.C.C.C.C.C._FБ._F.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._._А.C.C.C._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DБ._D._D._D.C.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>C.C.C.C.C.C.C._._А.C.C.C._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DБ._D._D._D.C.H.H.H.H.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._._А.C.C.C._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DБ._D._D._D.C.H.H.H.H.C._D._D._D._D._D._D._D.C</a>
    <a>C.C.C.C.C.C.C._._А.C.C.C._D._D._D._D._D._D._D-._D-._D-._D-._DГ._D._D._D._D._D._D._D._DБ._D._D._D.C.C.C.C.C.C._D._D._D._D._D._D._D.C</a>
    <a>_._._._._._._._._А.C.C.C._D._D._D._D._D._D._D._D._D._D._D._DГ._D._D._D._D._D._D._DБ._D._D._D.CD._D._D._D._D._D._D._D._D._D._D._D._D.C</a>
    <a>_._._._._._._._._А.C.C.C._D._D._D._D._D._D._D._D._D._D._D._D._DГ._D._D._D._D._D._DБ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.C</a>
    <a>_._._._._._._._._А.C.C.C._D._D._D._D._D._D._D._D._D._D._D._D._D._DГ._D._D._D._D._DБ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._D-._D-._DА-.C.C.C.C.C.C.C</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._DА.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._DА.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._DА.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._DА.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._DА.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._DА.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._DА.C.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._D._D._DА.C.H.H.H.H.H.H</a>
    <obj id="weapbox" x="2" y="7" lock="0" code="Bt7jOeAQwWjnbvRq" cont="" sign="1">
      <item id="rech" kol="2" imp="1"/>
      <scr>
        <s act="on" targ="trChWeap"/>
        <s act="on" targ="trSats"/>
      </scr>
    </obj>
    <obj id="door3" x="43" y="7" code="BEBvKRAI2E1e4m1M"/>
    <obj id="term2" x="37" y="6" code="q0fM6nQEGkx6Kxvi" lock="1" noblock="1" lockatt="1000" uid="trSign7">
      <scr act="off" targ="trTerm"/>
    </obj>
    <obj id="chest" x="45" y="7" code="qkyu3ZZQqPDFCw8Z" cont="" lock="0">
      <item id="col1" imp="1"/>
      <item id="tape"/>
    </obj>
    <obj id="rat" x="15" y="15" code="laPpbf5Uz2UfOtOE"/>
    <obj id="rat" x="21" y="15" code="YindVm4myDHga3F1"/>
    <obj id="rat" x="28" y="15" code="PfIEW5eweiBFcmwc"/>
    <obj id="area" uid="trSats" off="1" code="lnHLtpc1p0F4n8ko" x="19" y="7" w="4" mess="trSats" down="1"/>
    <obj id="area" uid="trTerm" code="LOkHXBKAvJLRitjU" x="30" y="7" mess="trTerm" down="1">
      <scr>
        <s targ="trSign6" act="sign" val="1"/>
        <s targ="trSign7" act="sign" val="1"/>
      </scr>
    </obj>
    <obj id="term" code="YZnqr2BmSRLiTRjI" x="34" y="6" uid="trSign6">
      <scr act="dialog" val="begDialInvent"/>
    </obj>
    <obj id="area" uid="trChWeap" off="1" code="dE2MskWi7VDvTKGb" x="10" y="7" mess="trChWeap"/>
    <obj id="table" x="44" y="15" code="nHC1roETUw3PAaGP" lock="0" cont="">
      <item id="r32" imp="1"/>
      <item id="p32" kol="5"/>
    </obj>
    <obj id="ammobox" x="42" y="15" code="rNw79sVXO6ytd4Bl" lock="0" cont="">
      <item id="p32" kol="5"/>
    </obj>
    <obj id="door1" x="34" y="15" code="zEoJjGddBiJbW6k3" lock="0"/>
    <back id="pult" x="40" y="6"/>
    <back id="vents" x="29" y="1"/>
    <back id="light1" x="35" y="2"/>
    <back id="light4" x="41" y="11"/>
    <back id="swindow" x="5" y="2"/>
    <back id="swindow" x="21" y="2"/>
    <back id="swindow" x="10" y="2"/>
    <back id="swindow" x="16" y="2"/>
    <back id="vents" x="40" y="1"/>
    <back id="vents" x="32" y="1"/>
    <back id="vents" x="37" y="1"/>
    <back id="pult" x="38" y="6"/>
    <back id="monitor" x="33" y="4"/>
    <back id="monitor" x="36" y="4"/>
    <back id="pult" x="29" y="6"/>
    <back id="pult" x="31" y="6"/>
    <back id="pult" x="33" y="6"/>
    <back id="monitor" x="30" y="4"/>
    <back id="monitor" x="39" y="4"/>
    <back id="pult" x="35" y="6"/>
    <back id="light4" x="44" y="11"/>
    <back id="stillage" x="1" y="5"/>
    <back id="stillage" x="4" y="5"/>
    <back id="pipe4" x="25" y="6"/>
    <back id="pipe4" x="25" y="4"/>
    <back id="pipe4" x="25" y="2"/>
    <back id="pipe4" x="25" y="0"/>
    <back id="wires2" x="28" y="6"/>
    <back id="wires2" x="28" y="4"/>
    <back id="wires2" x="28" y="2"/>
    <back id="wires2" x="28" y="0"/>
    <back id="wires2" x="42" y="0"/>
    <back id="wires2" x="42" y="2"/>
    <back id="wires2" x="42" y="4"/>
    <back id="wires2" x="42" y="6"/>
    <back id="pipe4" x="25" y="9"/>
    <back id="pipe4" x="25" y="11"/>
    <back id="pipe4" x="25" y="13"/>
    <back id="pipe4" x="25" y="15"/>
    <back id="light1" x="13" y="10"/>
    <back id="light1" x="32" y="10"/>
    <back id="door" x="14" y="5"/>
    <back id="konstr" x="17" y="9"/>
    <back id="konstr" x="17" y="13"/>
    <back id="vkonstr" x="36" y="13"/>
    <back id="vkonstr" x="41" y="13"/>
    <back id="vkonstr" x="41" y="10"/>
    <back id="vkonstr" x="44" y="13"/>
    <back id="vkonstr" x="44" y="10"/>
    <back id="potek" x="1" y="1"/>
    <back id="potek" x="11" y="1"/>
    <back id="potek" x="18" y="1"/>
    <back id="web1br" x="44" y="5"/>
    <options bezdna="1"/>
  </room>
  <room name="room_0_1" x="0" y="1">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E.C.C._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._._._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._._._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B.C</a>
    <a>C._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._E._._._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B._B.C</a>
    <a>C.C.C._._._.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._Б._.C.C.C</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._Б._._._.C</a>
    <a>C._._._._._._._._._._._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._Б._._._.C</a>
    <a>C.C.C.C.C.C.C._-._-._._._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._Б._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._Б._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._Б._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._Б._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._-._-._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._._._.C.C._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._-._-._._._._._.C.C._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>C.C.C.C.C.C.C._._._._._._._._._._._._._._.C.C.C.C.C._Б._._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._*._*._*._*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C._Б._._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._*._*._*._*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C._Б._._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C._*._*._*._*._*._*._*._*._*._*._*._*._*._*.C.C.C.C.C._Б._._._._._._._._А.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <back id="hkonstr" x="6" y="12"/>
    <obj id="tarakan" code="Pg8mANnAVlKkdcoX" x="38" y="4"/>
    <obj id="tarakan" code="WVNSHx35yPqFVp3f" x="34" y="4"/>
    <obj id="tarakan" code="rHB1y9ZWPNc48xzG" x="16" y="4"/>
    <obj id="tarakan" code="uC1Bn0uvF38sijrK" x="12" y="4"/>
    <obj id="chest" code="HpJM9w7ahDttQmKl" x="26" y="4" lock="0">
      <item id="col1" imp="1"/>
      <item id="telebul" imp="1" kol="2"/>
    </obj>
    <obj id="woodbox" code="rYOW2BxZ2CYqxZao" x="13" y="21"/>
    <obj id="medbox" code="YAlw1iGJsRKqPYow" x="27" y="2"/>
    <obj id="instr1" code="GWjhfS0T1neXbosP" x="7" y="4" lock="0">
      <item id="s_arson" imp="1"/>
    </obj>
    <obj id="work" code="qSfkg9B3Q5F3AXZ1" x="14" y="4"/>
    <obj id="grate" code="TP94hX7v3vgb7y0C" x="23" y="4"/>
    <obj id="grate" code="KQ0dJIJB1XjSMkBc" x="24" y="4"/>
    <back id="vkonstr" x="16" y="18"/>
    <back id="hkonstr" x="3" y="8"/>
    <back id="vkonstr" x="16" y="21"/>
    <back id="hkonstr" x="12" y="16"/>
    <back id="hkonstr" x="6" y="16"/>
    <obj id="woodbox" code="XRtI0gIcXg7YYnsJ" x="18" y="21"/>
    <back id="pipe2" x="23" y="21"/>
    <back id="pipe2" x="0" y="21"/>
    <back id="pipe2" x="12" y="21"/>
    <back id="pipes2" x="32" y="1"/>
    <back id="electro" x="29" y="1"/>
    <back id="electro" x="36" y="1"/>
    <back id="fuse" x="18" y="2"/>
    <back id="vent" x="16" y="2"/>
    <back id="vent" x="14" y="2"/>
    <back id="vkonstr" x="39" y="6"/>
    <back id="vkonstr" x="39" y="9"/>
    <back id="vkonstr" x="39" y="12"/>
    <back id="vkonstr" x="39" y="15"/>
    <back id="vkonstr" x="39" y="18"/>
    <back id="vkonstr" x="23" y="17"/>
    <back id="light1" x="8" y="2"/>
    <options backwall="tDirt"/>
  </room>
  <room name="room_0_3" x="0" y="3">
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>H.H.H.H.H.H.H.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._F._F._F._F._F._F.C</a>
    <a>H.H.H.H.H.H.H.C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._F._F._F._F._F._F.C</a>
    <a>H.H.H.H.H.H.H.C._._._._._.C._._._._._._._._._._._._._._._._._._._._._._._._._._.C._F._F._F._F._F._F.C</a>
    <a>H.H.H.H.H.H.H.C._Б._.C._-._-.C._._._._._._._._._._._._._._._._._._._._._._._._._._.C._F-._F-._F-.C._._.C</a>
    <a>H.H.H.H.H.H.H.C._Б._.C._._.C._._._S._S._._._._._._._._._._._._._._._._._._._._._._.C._F._F._F.C._._.C</a>
    <a>H.H.H.H.H.H.H.C._Б._.C._._._._._._S._S._._._._._._._._._._._._._._._._._._._._._._._._F._F._F.C._._.C</a>
    <a>H.H.H.H.H.H.H.C._Б._.C._._._._._._S._S._._._._._._._._._._._._._._._._._._._._._._._._F._F._F.C._._.C</a>
    <a>H.H.H.H.H.H.H.C._Б._.C.C.C.C.C.C.C.C.C.C.C.C.C._I-._I-.CI.CI.CI._I-._I-.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._.C</a>
    <a>H.H.H.H.H.H.H.C._Б._._._._._._._._._._._._._.C._I._I._I._I._I._I._I.C._._._._._._._._._._._._._._._._.C</a>
    <a>H.H.H.H.H.H.H.C._Б._._._._._._._._._._._._._.C.C.C.C.C.C.C.C.C._._._._._._._._._._._._._._._._.C</a>
    <a>H.H.H.H.H.H.H.C._Б._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>H.H.H.H.H.H.H.C._Б._._._S._S._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.C</a>
    <a>H.H.H.H.H.H.H.C._Б._._._S._S._._._._._._._._._.C._-._-.C.C.C.C._._._._._._._._._S._S._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.C._Б._._._S._S._._._._._._._._._._._._.C.C.C.C._._._._._._._._._S._S._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.C._Б._._._S._S._._._._._._._._._._._._.C.C.C.C._._._._._._._._._S._S._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <obj id="case" code="ngsqLfml11uGFuXp" x="44" y="3">
      <item id="col1" imp="1"/>
    </obj>
    <obj id="hatch2" code="fVuAXu2hlKEl3OXE" x="45" y="4" lock="0" autoclose="45"/>
    <obj id="door2" code="I9SCWGN9SNBv9OOp" x="40" y="7" lock="0" autoclose="45"/>
    <obj id="door1" code="N8hm8ogIV6GvJHhk" x="22" y="15"/>
    <obj id="window1" code="YfJzXNdUKrPLVHtH" x="22" y="12"/>
    <obj id="molerat" code="DtsetD6dLfsbOD2d" x="11" y="15" observ="-6"/>
    <obj id="window2" code="eiezEe62nr92CfpH" x="40" y="2"/>
    <obj id="term1" code="KpgAgEFnjQI73933" x="42" y="2" lock="1"/>
    <obj id="term" code="Tj5BGb2BGZhu1YSE" x="45" y="2">
      <scr act="dialog" val="begDialTurret"/>
    </obj>
    <obj id="mcrate1" code="m7EgQZsbipAWGnJ7" x="33" y="15"/>
    <obj id="door2" code="OEd5bMe0bA8VIgj7" x="13" y="7" lock="0" autoclose="45"/>
    <obj id="couch" code="i2fHAUSL5b9wX3Om" x="30" y="15"/>
    <obj id="area" code="Hg7q9nRfcnQ7Tk3B" x="39" y="15" mess="trLurk" h="6"/>
    <obj id="area" code="Z4OC5khzKlcUkBWs" x="23" y="12" mess="trSneak"/>
    <obj id="area" code="knreEnYBSpUgjDMt" x="11" y="7">
      <scr>
        <s act="dialog" val="begDialPodkradun"/>
        <s act="off" targ="this"/>
      </scr>
    </obj>
    <obj id="turret" code="AIxZrbA2V7HfbTsd" x="26" y="1" tr="1" multhp="6" observ="-1"/>
    <obj id="bigbox" code="LcgTYQekk7WZweyU" x="34" y="7"/>
    <obj id="window2" code="gHrJa0xAxogOieJp" x="13" y="2"/>
    <obj id="explbox" code="MGcvHUMSPMNom9uY" x="43" y="7"/>
    <obj id="ammobox" code="DXleak9nP20DQpwG" x="41" y="3"/>
    <back id="wires2" x="42" y="5"/>
    <back id="wires2" x="42" y="3"/>
    <back id="light5" x="23" y="2"/>
    <back id="light5" x="29" y="2"/>
    <back id="wires2" x="42" y="1"/>
    <back id="wires2" x="42" y="7"/>
    <back id="monitor" x="43" y="2"/>
    <back id="storage" x="32" y="13"/>
    <back id="pipe4" x="29" y="11"/>
    <back id="pipe4" x="29" y="13"/>
    <back id="pipe4" x="29" y="15"/>
    <back id="hkonstr" x="31" y="9"/>
    <back id="hkonstr" x="37" y="9"/>
    <back id="hkonstr" x="43" y="9"/>
    <back id="konstr" x="45" y="5"/>
    <back id="konstr" x="46" y="5"/>
    <back id="lorange" x="25" y="0" h="3" w="3"/>
    <options wrad="6" wtip="1" color="red"/>
  </room>
</all>



var rooms_surf:XML=<all>
  <land serial="1"/>
  <room name="room_9_2" x="9" y="2">
    <a>G.G.G.G.G.G.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._А.D.D.D.G.G</a>
    <a>G.G.G.G.G.G.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D._._А.D.D.D.G.G</a>
    <a>G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._.G.G.G.G</a>
    <a>G.G.G.G._._._._._._._._._._._._._._-._-._-._-._-._-._._._._._._._._._._._._._._._._._._._._А._._.G.G.G</a>
    <a>G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._._.G.G.G</a>
    <a>G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._._._.G.G</a>
    <a>G.G.G._._._._._._._._-._-._-._-._-._._._._._._._._._._._._._._-._-._-._-._-._._._._._._._._._._А._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._F._F._F._F._F._F._F._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._F._F._F._F._F._F._F._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G._F._F._F._F._F._F._F._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.G.GF.GF.GF.GF._F._F._F.G.G.G;._._._._._._._._._._._._._._._._._.G;.G.G.G;._._._._._._._._._._._._.G.G</a>
    <a>G.G.G.GF.GF.GF.GF._F._F._F.G.G.G.G.G;._.G;.G.G.G.G.G;._._._._._._.G;.G.G.G.G.G.G.G;._._._._._._._._._._.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G._._.G.G.G.G.G</a>
    <obj id="bloodwing" code="TiLwIlJI4ytfkSuq" x="8" y="2"/>
    <obj id="bloodwing" code="O2JmY7guofF3KqNv" x="12" y="2"/>
    <obj id="bloodwing" code="EJu6eqjqAFxupl71" x="26" y="2"/>
    <obj id="bloodwing" code="muS7XmgTlZ0EN85E" x="38" y="2"/>
    <obj id="ammobox" code="QZKQX6LjCkylKUQj" x="11" y="5"/>
    <obj id="ammobox" code="q9qE22YaVpXuNmIc" x="29" y="5"/>
    <obj id="explbox" code="z2anKbmbAlaUd9H4" x="13" y="5"/>
    <obj id="explbox" code="bE16XjwQCk91qkHI" x="31" y="5"/>
    <obj id="chest" code="aOnXj5PFCvV4eRmv" x="18" y="2"/>
    <obj id="platform2" code="RiFMteSUqOLUjYMP" x="7" y="22" allid="1">
      <move dy="-16" tstay="30" tmove="180"/>
    </obj>
    <obj id="spikes" code="RJ3YxQadr6NCZH1G" x="15" y="23"/>
    <obj id="spikes" code="rO7GAzNGQncNJdLw" x="22" y="23"/>
    <obj id="spikes" code="hWodK0BFF82PD1Od" x="18" y="22"/>
    <obj id="spikes" code="oc61B17tfoJM1elw" x="20" y="22"/>
    <obj id="spikes" code="HNPwoehotfqT7Ekz" x="27" y="23"/>
    <obj id="spikes" code="b8W8YE1swdLVxSCV" x="31" y="21"/>
    <obj id="spikes" code="ehkyZOmiR4OpSTnI" x="36" y="23"/>
    <obj id="spikes" code="Q2J1MDKilLsTkPm8" x="38" y="23"/>
    <obj id="trap" code="Z4o86QvVochpx7ID" x="23" y="23"/>
    <obj id="trap" code="Ke72hd4xxR4mT8zn" x="34" y="22"/>
    <obj id="trap" code="Z8G0k1AZacswczX5" x="13" y="22"/>
    <obj id="knop1" code="Hw0rD8ED9OBfCcvV" x="4" y="20" allid="1" allact="move3" lock="1" locktip="5"/>
    <back id="konstr" x="28" y="2"/>
    <back id="konstr" x="14" y="2"/>
    <back id="konstr" x="10" y="2"/>
    <back id="konstr" x="32" y="2"/>
    <back id="hkonstr" x="17" y="1"/>
    <back id="vrail" x="7" y="6"/>
    <back id="vrail" x="9" y="6"/>
    <back id="vrail" x="7" y="10"/>
    <back id="vrail" x="9" y="10"/>
    <back id="vrail" x="7" y="14"/>
    <back id="vrail" x="9" y="14"/>
    <back id="vrail" x="7" y="18"/>
    <back id="vrail" x="9" y="18"/>
    <back id="vrail" x="7" y="22"/>
    <back id="vrail" x="9" y="22"/>
    <back id="electro" x="3" y="18"/>
    <back id="light1" x="4" y="16"/>
    <options backwall="tCave"/>
  </room>
  <room name="room_1_1" x="1" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._.E._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._.E._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._.E._._._._.E._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._.E._._._.E.E.E._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._.E.E.E.E.E.E._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._.E._._._._.E._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.E._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._;._;._._._._.E._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._;.E;._._._.E.E.E;._._;.E.E:._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.E.E.E.E.E.E.H.H.H.H.H.H.H.H.H.H.H.H.H.E.E.E.E.E.E.E.E.E.E.E.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="trava" x="36" y="21"/>
    <obj id="spikes" code="W8SJCRvOTzePiAfR" x="10" y="12"/>
    <obj id="spikes" code="bGZ3AcfztEr9UwGm" x="37" y="21"/>
    <obj id="spikes" code="KZOCQk5OHWBrjNdc" x="11" y="16"/>
    <obj id="spikes" code="yTwZzIlCrgU5goGs" x="13" y="16"/>
    <obj id="spikes" code="oqFfsO0mrA9y3UWe" x="14" y="15"/>
    <obj id="case" code="UQm0seQZeyEYsDKg" x="12" y="16"/>
    <obj id="trap" code="YPodxYuwiHypL1t9" x="31" y="21"/>
    <back id="pipe4" x="11" y="20"/>
    <back id="stenka2" x="10" y="17"/>
    <back id="stenka3" x="19" y="21"/>
    <back id="stenka1" x="28" y="16"/>
    <back id="trava" x="0" y="21"/>
    <obj id="checkpoint" code="bEO0ZWbbvX4dGG2P" x="12" y="21" tele="1"/>
    <back id="pipe4" x="11" y="18"/>
    <back id="wires1" x="14" y="18"/>
    <back id="wires1" x="14" y="20"/>
    <back id="tree" x="2" y="13"/>
    <back id="tree" x="21" y="13"/>
    <back id="stree" x="18" y="16"/>
    <back id="stree" x="41" y="16"/>
    <back id="remains1" x="23" y="13"/>
    <back id="remains1" x="14" y="13"/>
    <back id="remains2" x="3" y="16"/>
    <back id="heap1" x="31" y="20"/>
    <back id="musor1" x="9" y="21"/>
    <back id="musor1" x="30" y="21"/>
    <options/>
  </room>
  <room name="room_1_2" x="1" y="2">
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.E.H.H.E.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.E.H.H.E.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.E.H.H.E.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._C._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._C._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._C._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.BC.BC.BC.BC.BC.BC.BC.EC.EC.EC.EC.EC.EC.EC.EC.EC._C._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.BC._C._C._C._C._C.BC._C._C._C._C._C._C._C._C._C._C._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.BC._C._C._C._C._C.BC._C._C._C._C._C._C._C._C._C._C._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.BC._C._C._C._C._C.BC._C._C._C._C._C._C._C._C._C._C._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.BC._C._C._C._C._C.BC._C._C._C._C._C._C._C._C._C._C._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.BC._C._C._C._C._C.BC._C._C._C._C._C._C._C._C._C._C._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.BC.BC.BC.BC.BC.BC.BC.EC.EC.EC.EC.EC.EC.EC.EC.EC._CБ-._C-.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._CБ._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._CБ._C.EC.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._CБ._C.EC.H.H.H._._._.H.H.H.H.H.H.H._._.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._CБ._C.EC.H.H.H._Д.H.H.H.H.H.H._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._CБ._C.EC.H.H.H._.H.H.H.H.H.H.H.H.H._Д._Д.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._CБ._C.EC.H.H.H._.H.H.H.H.H.H.H.H.H._._.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.EC._CБ._C._C._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <obj id="ammobox" code="tlfpRZCXffPbbAWA" x="10" y="11"/>
    <obj id="rat" code="vAMsKRTMuD217XGZ" x="33" y="21"/>
    <obj id="area" code="wTKLeXZ6UCsF5oVI" x="12" y="11" w="1" h="5" tilehp="1"/>
    <obj id="rat" code="qAXzya7MY4VKSTJ6" x="29" y="15"/>
    <obj id="weapbox" code="aDT3YZk4GPzs8lvG" x="8" y="11" cont="*">
      <item id="hunt" kol="2"/>
    </obj>
    <obj id="molerat" code="yqgzySWLvYwxDEiL" x="15" y="11"/>
    <obj id="rat" code="vM8nqD5D9UyLMUu6" x="35" y="16"/>
    <obj id="area" code="SZD95fkbPeQu6vwa" x="13" y="11" w="7" h="5" mess="surfSecret"/>
    <back id="minkrut" x="14" y="9"/>
    <back id="musor1" x="13" y="11"/>
    <options backwall="tDirt" color="black"/>
  </room>
  <room name="room_6_1" x="6" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._F._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._-._-._-._-._-._-._-._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._Г._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._Г._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._Г._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._-._А-._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._._._._._</a>
    <a>_._._._._._._._._._._-._-._-._-._-._._._._._._._._._._._._._._._._._._._._._._._._._._._._А._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._В._-._-._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._В._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._В._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.D.D.D.D.D._._._._._.F.F.F.F._._._._._._.F.F._._._._._А.D.D.D.D.D.D.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.HL.DL._._._._._._._._._._._._._._._._._._._._._._А.DL.HL.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.HL.DL._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DА.DL.HL.H.H.H.H.H.H.H.H.H</a>
    <back id="light5" x="40" y="5"/>
    <back id="vkonstr" x="41" y="19"/>
    <back id="vkonstr" x="38" y="16"/>
    <back id="vkonstr" x="41" y="16"/>
    <back id="vkonstr" x="38" y="13"/>
    <back id="vkonstr" x="41" y="13"/>
    <back id="vkonstr" x="38" y="10"/>
    <back id="vkonstr" x="41" y="10"/>
    <back id="railing" x="37" y="9"/>
    <back id="vkonstr" x="38" y="19"/>
    <back id="konstr" x="40" y="6"/>
    <back id="railing" x="40" y="9"/>
    <back id="konstr" x="11" y="18"/>
    <back id="konstr" x="13" y="18"/>
    <back id="remains1" x="0" y="13"/>
    <back id="remains1" x="38" y="13"/>
    <back id="trava" x="0" y="21"/>
    <back id="stree" x="1" y="16"/>
    <back id="stree" x="5" y="18"/>
    <back id="stenka3" x="14" y="22"/>
    <back id="stenka3" x="22" y="22"/>
    <back id="stenka3" x="28" y="22"/>
    <options bezdna="1"/>
  </room>
  <room name="room_2_1" x="2" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._.I._._._._._._._._._._._._._._._._._._._._._._.I._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._.I._._._._._._._._._._._._._._._._._._._._._._.I.R.R.R.R.R._._._._._._._._._._._._</a>
    <a>_._._._._._._.I._._._._._._._._._._._._._._._._._._._._._._.I.R.R.R.R.R.R._._._._._._._._._._._</a>
    <a>_._._._._._._.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID._D._DА.ID.ID.ID.ID.ID.E.E.E.E.E.E._._._._._._._._._._._</a>
    <a>_._._._._._._.ID._D._D._D._D._D._D._D._D._D._D._D.ID._D._D._D._D._D._DА._D._D._D._D.ID._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._.ID._D._D._D._D._D._D._D._D._D._D._D.ID._D._D._D._D._D._DА._D._D._D._D.ID._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._D._D._D._D._D._D._D._D._D._D._D._D.ID._D._D._D._D._D._DА._D._D._D._D.ID._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DА._D._D._D._D.ID._._._._._._._._.F._._._._._._._._</a>
    <a>_._._._._._._.ID._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DА._D._D._D._D.ID._._._._._._._._.F._._._._._._._._</a>
    <a>_._._._._._._.ID.ID.ID._DД._DЗ._DД._DД._DД._DД._DД.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID._._._._._._._._</a>
    <a>_._._._._._._.ID._D._D._D._D._DЗ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.ID._D._D._D._D._D._D._D._D.ID._._._._._._._._</a>
    <a>_._._._._._._.ID._D._D._D._D._D._DЗ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.ID._D._D._D._D._D._D._D._D.ID._._._._._._._._</a>
    <a>_._._._._._._.ID._D._D._D._D._D._D._DЗ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D.ID._D._D._D._D._D._D._D._D.ID._._._._._._._._</a>
    <a>_._._._._._._._D._D._D._D._D._D._D._D._DЗ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._._._._._._._._</a>
    <a>_._._._._._._._D._D._D._D._D._D._D._D._D._DЗ._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._D._DА.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._D._DА.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._D._DА.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <obj id="case" code="Mpx6a3XHZISgXaCv" x="28" y="9"/>
    <obj id="hatch1" code="NT4xiGiCQcxOGXbL" x="24" y="10"/>
    <obj id="door1" code="cLbU9heFZQa7X9vL" x="30" y="21"/>
    <obj id="door1" code="CWkqLUh6xskgZqzl" x="7" y="21"/>
    <obj id="hatch1" code="LbNvs7u7xjQIU7Y7" x="23" y="22"/>
    <obj id="door1" code="XwGjfECgCIokbzOK" x="39" y="21"/>
    <obj id="stove" code="e0XwCW1MjTvHEzjT" x="32" y="21"/>
    <obj id="wcup" code="aQX4uEXMih8JbjEb" x="33" y="21"/>
    <obj id="tap" code="HZyWfuDOAYmuAKOl" x="34" y="21"/>
    <obj id="fridge" code="TrNT3DrGdKAHZgGZ" x="35" y="21"/>
    <obj id="chest" code="L8Gm9KGcp5D4TJKX" x="9" y="9"/>
    <obj id="door1" code="ohNHKlJirPODPqYs" x="19" y="15"/>
    <obj id="trap" code="Ut372oVQEPLg2Ipa" x="12" y="9"/>
    <obj id="tarakan" code="uHEnHOnlBSegSMtc" x="21" y="9"/>
    <obj id="tarakan" code="ppJq5fFNWQBc7E2x" x="36" y="21"/>
    <obj id="bed" code="IZaG2ElaZ3yeKLuR" x="26" y="15"/>
    <obj id="tumba1" code="eV1GyTSdAxA09p10" x="24" y="15"/>
    <obj id="cup" code="pp7XEsflEjEJ4d8L" x="16" y="15"/>
    <obj id="table1" code="e3IBMVyW6J2HFzQu" x="36" y="21"/>
    <obj id="table1" code="TCwHGQkpx8YsqWjz" x="18" y="21"/>
    <obj id="couch" code="MSXHfquN25iVxpU1" x="26" y="21"/>
    <obj id="table" code="Ju1OKvM7jEDx0PXH" x="8" y="15"/>
    <obj id="tarakan" code="VsUYBnCiYKIw3xKY" x="16" y="9"/>
    <obj id="ammobox" code="XvLQAVWAHFhUmY6a" x="35" y="15"/>
    <obj id="spikes" code="WnS0W4yFJXrFyvWV" x="38" y="15"/>
    <obj id="trap" code="oQX7Ygn7xWeqdIsj" x="37" y="15"/>
    <obj id="spikes" code="jQNFqAyZYUyNBuHc" x="32" y="15"/>
    <obj id="spikes" code="O06hJmlqA1BUO2jT" x="7" y="6"/>
    <obj id="trash" code="YPxaz44PtSekcUd7" x="21" y="21"/>
    <obj id="wallcab" code="pTjvMNrJhoqvfXz3" x="33" y="13"/>
    <obj id="spikes" code="JtdsSIyhMKzpEhoe" x="30" y="6"/>
    <obj id="tarakan" code="TjtATJlrRhHQCvvH" x="33" y="15"/>
    <obj id="window1" code="VRlX00LYpgKzXXKa" x="7" y="14"/>
    <obj id="ammobox" code="Kuzb06HHXke4cMmd" x="8" y="9"/>
    <back id="bwindow" x="18" y="18"/>
    <back id="bwindow" x="24" y="18"/>
    <back id="swindow" x="32" y="18"/>
    <back id="swindow" x="36" y="18"/>
    <back id="blood1" x="34" y="19"/>
    <back id="blood2" x="28" y="19"/>
    <back id="rgraff" x="10" y="18"/>
    <back id="bwindow" x="9" y="13"/>
    <back id="bwindow" x="14" y="13"/>
    <back id="bwindow" x="21" y="13"/>
    <back id="vent" x="36" y="17"/>
    <back id="vent" x="33" y="17"/>
    <back id="stenka2" x="30" y="10"/>
    <back id="rgraff" x="14" y="19"/>
    <back id="stenka1" x="7" y="4"/>
    <back id="stenka3" x="18" y="8"/>
    <back id="stree" x="2" y="16"/>
    <back id="stree" x="40" y="16"/>
    <back id="tree" x="41" y="13"/>
    <back id="musor1" x="9" y="21"/>
    <back id="musor1" x="20" y="21"/>
    <back id="musor1" x="31" y="21"/>
    <back id="musor1" x="31" y="15"/>
    <back id="musor2" x="20" y="15"/>
    <back id="musor1" x="10" y="9"/>
    <back id="musor1" x="21" y="9"/>
    <back id="skel" x="22" y="15"/>
    <back id="skel" x="13" y="21"/>
    <back id="web1tl" x="8" y="11"/>
    <back id="web1tl" x="20" y="11"/>
    <back id="web1tr" x="27" y="11"/>
    <back id="web1tr" x="16" y="11"/>
    <back id="web1bl" x="31" y="13"/>
    <options/>
  </room>
  <room name="room_10_3" x="10" y="3">
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H._._._._.H.H.H.H.H.H.H</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H._._._._.H.H.H.H.H.H.H</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H._._._._.H.H.H.H.H.H.H</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H._._._.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="zavod2" x="18" y="21"/>
    <obj id="radbarrel" code="cQDtuUqS7EDpUpdF" x="33" y="19"/>
    <obj id="radbigbarrel" code="g3YYCwp1pXNZvHl3" x="38" y="21"/>
    <obj id="radbarrel" code="AHm22rrGEuMagi1y" x="25" y="22"/>
    <obj id="radbarrel" code="YuHDawzAhBWkgmtx" x="18" y="22"/>
    <back id="zavod2" x="24" y="21"/>
    <obj id="radbarrel" code="TCTBtq1Y8AyqbZCA" x="30" y="21"/>
    <back id="zavod2" x="39" y="20"/>
    <back id="plesen" x="9" y="21"/>
    <back id="plesen" x="18" y="21"/>
    <back id="plesen" x="29" y="20"/>
    <back id="unitaz" x="14" y="21"/>
    <back id="plesen" x="0" y="20"/>
    <options backwall="tCave" wlevel="0" color="black" wopac="0.2"/>
  </room>
  <room name="room_9_3" x="9" y="3">
    <a>G.G.G.G.G.G.G.G.GA.GA.DA.DA.DA.DA.DA.DA.DA.DA.DA.DA.DA.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G._A._A.G.G.G.G.G</a>
    <a>G.G.DE.DE.DE.DE.DE.DE.DA.DA.DA.DA.DA.DA.DA.DA.DA.DA.DA.DA.DA.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G._A._A.G.G.G.G.G</a>
    <a>G.G.DE._E._E._E._E._E._A._A._A._A._A.DA.DA.DA.DA.DA.DA._A._A._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.DE._E._E._E._E._E._A._A._A._A._A._A.DA.DA.DA.DA._A._A._A._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.DE._E._E._E._E._E._._._A._A._A._A.DA.DA.DA.DA._A._A._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.DE._E._E._E._E._E._._._._._._A.DA.DA.DA.DA._A._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>G.G.DE.DE.DE.DE.DE.DE.D._._._._._A.DA.DA.DA.DA._A._._._._.G.G.G.G.G.G.G.G.G._._.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G._._._._._A._A.DA.DA._A._A._._._._.G.G.G.G.G.G.G.G.G._._.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G._._._._A._A._A._A._A._A._._._.G.G.G.G.G.G.G.G.G.G._._._._._._._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G._._._._A._A._A._A._A._A._._._.G.G.G.G.G.G.G.G.G.G._._._._._._._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G._E._E._E._E._E._E._._._._.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G._E._E._E._E._E._E._._._._._._._._.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G._E._E._E.G.G.G.G.G._._._._._._._.G.G.G.G.G.G.G.G.G._._._.G.G.G._._._._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G._E._E._E.G.G.G.G.G.G._._._._._._.G.G.G.G.G.G._._._._._._._._._._._._._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G._E._E._E.G.G.G.G.G.G.G._._._._._.G.G.G.G.G._._._._._._._._._._._._._._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G._E._E._E.G.G.G.G.G.G.G.G.G._._._.G.G.G.G.G._._._.G.G.G.G.G.G.G.G.G.G._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.DE.DE.DE.EE.EE.EE.DE.DE.DE.G.G.G.G.G.G.G._._.G.G.G.G.G._._.G.G.G.G.G.G.G.G.G.G.G._._.G.G.G.G.G.G.G.G</a>
    <a>G.G.DE._E._E._E._E._E._E._E.DE.G.G.G.G.G.G.G._._._.G.G.G._._._.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._</a>
    <a>G.G.DE._E._E._E._E._E._E._E.DE.G.G.G.G.G.G.G._._._._._._._._._.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._</a>
    <a>G.G.DE._E._E._E._E._E._E._E.DE.G.G.G.G.G.G.G.G._._._._._._._.G.G.G.G.G.G.G.G.G.G.G.G._._._._._._._._._._</a>
    <a>G.G.DE._E._E._E._E._E._E._E.DE.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>G.G.DE.DE.DE.DE.DE.DE.DE.DE.DE.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <obj id="weapbox" code="UlPPUUUPHDucWX5V" x="8" y="22"/>
    <obj id="fspikes" code="RhUJ8gekH551Knmh" x="14" y="7"/>
    <obj id="fspikes" code="AsUhbbo72erB4xlC" x="17" y="7"/>
    <obj id="fspikes" code="iE8exNAeorYQitoa" x="18" y="3"/>
    <obj id="fspikes" code="sLQt4k0V0GRSzVCz" x="13" y="3"/>
    <obj id="fspikes" code="pMUAyOoeOAHd699u" x="19" y="2"/>
    <obj id="fspikes" code="yLzm91YWOd6tpbKN" x="20" y="2"/>
    <obj id="fspikes" code="RfATNkAFT2Szgv1K" x="10" y="2"/>
    <obj id="fspikes" code="JJEAS7DkIPOqs6lg" x="11" y="2"/>
    <obj id="fspikes" code="tfbcGFRf1SeHigea" x="12" y="2"/>
    <obj id="scorp" code="i7hPYQOvkpPHR0fw" x="26" y="5"/>
    <obj id="scorp" code="Z2pGg0L5xASKmtE8" x="6" y="5"/>
    <obj id="medbox" code="nAJNnDGYyr3xhvZu" x="4" y="3" cont="med2">
      <item id="antiradin"/>
      <item id="antiradin"/>
    </obj>
    <obj id="chest" code="Tgczg8oCEHg6VDL7" x="3" y="5"/>
    <obj id="radbarrel" code="xWxM93YmBp3FAC0W" x="12" y="9"/>
    <obj id="radbarrel" code="mMVAZoG6sNKEZtxp" x="19" y="9"/>
    <obj id="radbarrel" code="g2UQ1HkPjQ6WFAlc" x="19" y="21"/>
    <obj id="radbarrel" code="v7YMPKAfqj0vygtM" x="22" y="21"/>
    <obj id="radbarrel" code="c6qcFc1SXTzAMMpO" x="26" y="20"/>
    <obj id="safe" code="mXGfP5EXIvHBtuzD" x="5" y="22"/>
    <obj id="woodbox" code="GG1qG1KMHnkH1vQR" x="24" y="5"/>
    <back id="pipe4" x="4" y="19"/>
    <back id="pipe4" x="8" y="19"/>
    <back id="pipe4" x="8" y="21"/>
    <back id="pipe4" x="4" y="21"/>
    <back id="minkrut" x="8" y="12"/>
    <back id="wires1" x="6" y="2"/>
    <back id="pipes2" x="4" y="14"/>
    <back id="pipes2" x="3" y="4"/>
    <back id="wires1" x="6" y="4"/>
    <back id="plesen" x="38" y="20"/>
    <back id="plesen" x="28" y="8"/>
    <back id="plesen" x="28" y="15"/>
    <back id="plesen" x="18" y="20"/>
    <back id="potek" x="5" y="12"/>
    <back id="potek" x="19" y="2"/>
    <back id="potek" x="29" y="2"/>
    <back id="potek" x="38" y="2"/>
    <back id="skel" x="5" y="5"/>
    <back id="skel" x="43" y="5"/>
    <options backwall="tCave" wlevel="7" color="black" wopac="0.3"/>
  </room>
  <room name="room_12_1" x="12" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.E.E.E.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._.D.D.D.D.E.E.E.E.E.D.D.D._._._._._.E.E.E.E.E.E.E.E.E.D.D</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.D.D.D.D.D.D.D.D.D.D.D.D.H.H.H.H.H.H.H.H.H.H.H.H.H.H.D.D</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.D.D.D.D.D.D.D.D.D.D.D.D.H.H.H.H.H.H.H.H.H.H.H.H.H.H.D.D</a>
    <obj id="raider" code="k6dIZiF41fyeQ5uf" x="22" y="21" ai="stay" turn="-1" tr="5" weap="p9mm"/>
    <obj id="raider" code="A8br3VOMiVcyqpVz" x="26" y="21" ai="stay" turn="-1" tr="3"/>
    <obj id="raider" code="ebizFa1IdLxAYZH1" x="30" y="21" ai="stay" turn="-1" tr="4"/>
    <obj id="raider" code="kJVw3q5iwjYkoIgT" x="37" y="21" ai="stay" turn="-1" tr="2"/>
    <obj id="raider" code="RQhOqSWhLLhgokOT" x="13" y="22" ai="quiet" turn="-1" tr="7" uid="surfRaider1" weap="oldr"/>
    <obj id="area" code="vNvr2nBZDcpt2hH1" x="1" y="22" h="22" scr="surfStory"/>
    <obj id="npc" code="MraR4xuhkXhpQYkj" x="40" y="2" npc="calam" uid="surfCalam" fly="1" turn="-1" invis="1"/>
    <obj id="raider" code="E0WORd8SEQHzAomy" x="17" y="22" ai="stay" turn="-1" tr="6" weap="oldshot"/>
    <back id="stenka1" x="20" y="16"/>
    <back id="stenka3" x="34" y="21"/>
    <back id="stenka2" x="41" y="16"/>
    <back id="musor1" x="10" y="22"/>
    <back id="heap3" x="14" y="22"/>
    <back id="musor1" x="21" y="21"/>
    <back id="heap1" x="16" y="20"/>
    <back id="heap2" x="39" y="20"/>
    <back id="heap2" x="30" y="21"/>
    <back id="heap3" x="21" y="21"/>
    <back id="trava" x="0" y="22"/>
    <back id="tree" x="6" y="14"/>
    <back id="stree" x="13" y="17"/>
    <back id="stree" x="4" y="17"/>
    <back id="remains1" x="32" y="13"/>
    <back id="remains1" x="8" y="14"/>
    <back id="remains2" x="25" y="16"/>
    <back id="remains2" x="14" y="16"/>
    <options bezdna="1"/>
  </room>
  <room name="room_7_1" x="7" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.R;.R.R.R.R.R.R.R.R.R</a>
    <a>_._._._._._._._._._._._._._._._._._.C._._._._._._._._._._._._._._._._._.R;.R.R.R._._._.R.R.R.R.R</a>
    <a>_._._._._._._._._._._._._._._._._._.CN.CN.CN.FN.FN.FN.FN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.EN.EN.EN.CN.CN.CN.CN.CN</a>
    <a>_._._._._._._._._._._._._._._._._._.CN._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._N._N._N._N._N._N._N._N._N._N._N._N._N.CN</a>
    <a>_._._._._._._._._._._._._._._._._._.CN._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._N._N._N._N._N._N._N._N._N._N._N._N._N.CN</a>
    <a>_._._._._._._._._._._._._._._._._._._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._N._N._N._N._N._N._N._N._N._N._N._N._N.CN</a>
    <a>_._._._._._._._._._._._._._._._._._._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N</a>
    <a>_._._._._._._._._._._._._._._._._._.CN._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N</a>
    <a>_._._._._._._._._._._._._._._._._._.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN</a>
    <a>_._._._._._._._._._._._._._._._._._.CN._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._N._N._N._N._N._N._N._N.CN</a>
    <a>_._._._._._._._._._._._._._._._._._.CN._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._N._N._N._N._N._N._N._N.CN</a>
    <a>_._._._._._._._._._._._._._._._._._.CN._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._N._N._N._N._N._N._N._N.CN</a>
    <a>_D._._._._D._._._._D._._._._D._D._D._D._D._D._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N</a>
    <a>_D._K._K._K._D._K._K._K._D._K._K._K._D._D._D._D._D._D._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N</a>
    <a>_D._K._K._K._D._K._K._K._D._K._K._K._D._DЛ._DК._DК.CD.CD.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>_D._K._K._K._D._K._K._K._D._K._K._K._DЛ._D._D._D.CD.CD.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="stenka3" x="28" y="6"/>
    <obj id="mine" code="OtwSIJNXEpjE1x7Q" x="45" y="5"/>
    <obj id="raider" code="pYEbvrSEnB9Y6Rvh" x="24" y="19" tr="1"/>
    <obj id="bed" code="IOzusOi4UYChaPKc" x="19" y="13"/>
    <obj id="couch" code="YjuHGvKli3dttKby" x="27" y="13"/>
    <obj id="wallcab" code="xb0rFHKTAE1KGFfP" x="35" y="12" cont="">
      <item id="potion_swim"/>
    </obj>
    <obj id="cup" code="afuRuXoArEl5Wjqz" x="30" y="13"/>
    <obj id="tumba1" code="THvY1OpbTtlNHGSb" x="26" y="13"/>
    <obj id="fridge" code="TvqdMoNU2sOKVBrL" x="25" y="13"/>
    <obj id="ammobox" code="V8ssxb46leH7yMoB" x="21" y="19"/>
    <obj id="ammobox" code="lNxIDBGd4q10KRzC" x="40" y="19"/>
    <obj id="ammobox" code="qW6jRbCXUbQpTiJh" x="44" y="19"/>
    <obj id="mine" code="R4DU1shlTSuFp2aH" x="43" y="5"/>
    <obj id="raider" code="UxlaXN65UoqEHELc" x="21" y="13" turn="1" tr="5" ai="quet" unres="1"/>
    <obj id="chest" code="x8OoqQzAN0nabkii" x="41" y="7"/>
    <obj id="door1" code="NXYVSTa9dS1Ga4ER" x="18" y="19"/>
    <obj id="door1" code="sfOEhR3L31SHsP3k" x="38" y="19"/>
    <obj id="door1" code="pJdFKdcjHZTEu8ty" x="33" y="13"/>
    <obj id="window1" code="SWyNXmbc3D0JDMDa" x="18" y="12"/>
    <back id="chains" x="33" y="15"/>
    <back id="chains" x="24" y="15"/>
    <back id="bwindow" x="22" y="11"/>
    <back id="bwindow" x="37" y="11"/>
    <back id="bwindow" x="41" y="11"/>
    <back id="bwindow" x="26" y="11"/>
    <back id="chains" x="19" y="9"/>
    <back id="chains" x="22" y="15"/>
    <back id="chains" x="19" y="15"/>
    <back id="stenka3" x="35" y="6"/>
    <obj id="raider" code="HB8bri24dgoRDlo7" x="41" y="19" tr="4"/>
    <back id="stenka3" x="18" y="6"/>
    <back id="chains" x="30" y="15"/>
    <back id="chains" x="40" y="15"/>
    <back id="chains" x="39" y="15"/>
    <back id="chains" x="28" y="9"/>
    <back id="chains" x="26" y="9"/>
    <back id="chains" x="34" y="9"/>
    <back id="chains" x="42" y="9"/>
    <back id="chains" x="37" y="9"/>
    <back id="rgraff" x="20" y="16"/>
    <back id="rgraff" x="28" y="17"/>
    <back id="rgraff" x="26" y="15"/>
    <back id="rgraff" x="41" y="16"/>
    <back id="blood1" x="43" y="17"/>
    <back id="blood1" x="41" y="16"/>
    <back id="potek" x="19" y="9"/>
    <back id="potek" x="29" y="9"/>
    <back id="potek" x="38" y="9"/>
    <back id="battery" x="38" y="13"/>
    <back id="battery" x="42" y="13"/>
    <back id="battery" x="23" y="13"/>
    <back id="battery" x="27" y="13"/>
    <back id="heap1" x="12" y="19"/>
    <back id="heap3" x="15" y="19"/>
    <back id="heap3" x="19" y="7"/>
    <back id="musor1" x="29" y="19"/>
    <back id="musor2" x="21" y="19"/>
    <back id="musor2" x="35" y="13"/>
    <back id="musor2" x="39" y="19"/>
    <options/>
  </room>
  <room name="room_2_2" x="2" y="2">
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._А.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._А.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._А.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._А.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._А._._._._._.FC._C._C._C._C._C.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._А._._._._._.FC._C._C._C._C._C.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._А._._._._._.FC._C._C._C._C._C.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._А._._._._._.FC._C._C._C._C._C.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.C.C._._А.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._._._._А._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._._._._А._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._._._._А._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD.CD._DБ._D.CD.CD.CD.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DБ._D._D._D._D.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DБ._D._D._D._D.H.H.H.H.H._._._._._.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DБ._D._D._D._D.H.H.H.H.H._._._._._.H.H</a>
    <a>_._._._._._._.F._._._._._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._DБ._D._D._D._D._._.F._._._._._._._.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="wires1" x="28" y="13"/>
    <obj id="rat" code="olh1V2QempRBbAO1" x="24" y="11"/>
    <obj id="case" code="GOSrs6r7FGS5GOo6" x="43" y="16"/>
    <obj id="wallcab" code="xHlWBjLneRTboshL" x="33" y="6"/>
    <obj id="molerat" code="Ikf9o9Btk9En7Osx" x="25" y="16"/>
    <obj id="rat" code="DEjn6baOeC9kkr5u" x="34" y="7"/>
    <obj id="ammobox" code="TYl6shyZcVTFnIpf" x="35" y="7"/>
    <obj id="rat" code="oj76D5M9cdv64reb" x="20" y="11"/>
    <obj id="area" code="GPMNkVFvIq8cg1QP" x="2" y="16">
      <scr>
        <s act="dialog" val="surfDialNora"/>
        <s act="off" targ="this"/>
      </scr>
    </obj>
    <obj id="rat" code="FwyCbUq12NDBR2Zg" x="32" y="7"/>
    <back id="depot" x="12" y="9"/>
    <back id="wires1" x="28" y="15"/>
    <back id="depot" x="18" y="9"/>
    <back id="depot" x="16" y="9"/>
    <back id="plesen" x="8" y="15"/>
    <back id="plesen" x="18" y="15"/>
    <back id="plesen" x="28" y="15"/>
    <back id="electro" x="27" y="4"/>
    <back id="wires1" x="28" y="9"/>
    <back id="wires1" x="28" y="11"/>
    <obj id="molerat" code="cMdUiIdelatBnOtC" x="20" y="16"/>
    <back id="depot" x="20" y="9"/>
    <back id="depot" x="24" y="9"/>
    <back id="depot" x="26" y="9"/>
    <back id="depot" x="29" y="9"/>
    <back id="pipes" x="33" y="9"/>
    <back id="pipes2" x="42" y="14"/>
    <back id="wires1" x="41" y="14"/>
    <back id="wires1" x="41" y="16"/>
    <back id="depot" x="20" y="5"/>
    <back id="depot" x="18" y="5"/>
    <back id="depot" x="12" y="5"/>
    <back id="pipe1" x="12" y="4"/>
    <back id="pipe1" x="22" y="4"/>
    <back id="pipe1" x="32" y="4"/>
    <back id="rgraff" x="14" y="13"/>
    <back id="rgraff" x="22" y="13"/>
    <back id="musor1" x="16" y="16"/>
    <back id="musor2" x="14" y="11"/>
    <back id="musor2" x="22" y="7"/>
    <back id="skel" x="43" y="16"/>
    <options backwall="tDirt" color="black"/>
  </room>
  <room name="room_9_1" x="9" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L.HL.H.H.H.H.H.H.H.H.H.H</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L.HL.H.HE.HE.HE.HE.HE.HE.HE.HE.HE</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L._L.H.HE.HE.CE.CE.CE.CE.CE.HE.HE</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L._L._L.CE.CE.CE.CE._E._E._E.CE.CE.CE</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L._L._L._E._E._E._E._E._E._E._E._E._E</a>
    <a>_._._._._._._._._._._._._._._._.H.H.H.H.H.H._._._._._._._._._._L._L._L._L._L._L._L._E._E._E._E._E._E._E._E._E._E</a>
    <a>_._._._.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C.C.CE.CE.CE.CE.CE.CE.CE.CE.CE.CE</a>
    <a>_._._.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._A._A.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._A._A.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._A._AА.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._A._AА.H.H.H.H.H</a>
    <back id="trava" x="22" y="19"/>
    <obj id="bigbox" code="UMAJDMceSof9Ezp9" x="32" y="19"/>
    <obj id="woodbox" code="EsU3b0OMgr5rfkIh" x="9" y="19"/>
    <obj id="door2" uid="surfKanal" code="UwanPMZjjl30sbjp" x="38" y="19" lock="4"/>
    <obj id="area" code="SkbdOzEfYh6J3PTB" x="41" y="20" tilehp="1" h="1"/>
    <obj id="molerat" code="AFUBggJGHiVYFhBy" x="30" y="19"/>
    <obj id="knop1" code="x0FTHKpCDuB8U8hR" x="43" y="18">
      <scr act="unlock" targ="surfKanal"/>
    </obj>
    <back id="tree" x="8" y="11"/>
    <back id="stree" x="4" y="14"/>
    <obj id="molerat" code="D0nmFmefK5QJlr1n" x="24" y="19"/>
    <back id="trava" x="5" y="19"/>
    <back id="stree" x="12" y="14"/>
    <back id="zavod2" x="27" y="18"/>
    <back id="plesen" x="38" y="18"/>
    <back id="stree" x="17" y="16"/>
    <back id="stree" x="20" y="17"/>
    <back id="stree" x="14" y="17"/>
    <back id="musor1" x="38" y="12"/>
    <options/>
  </room>
  <room name="room_10_2" x="10" y="2">
    <a>H.H.H.H.H.HL._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._L._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._L._L._L._L._._._._._._._._._._._._._._._._._._._._._._._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.HL._LБ._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._LБ._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._LБ._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L._L.H.H.H.H.H.H</a>
    <options wlevel="13" wopac="0.2"/>
  </room>
  <room name="room_4_1" x="4" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._.I._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._Д.I._._._._._._._._._._._.I._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._.I._._._._._._._._._._._.I._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._.ID._D._D._D._D._D._D._D._D._D._D._D.ID._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._.ID._D._D._D._D._D._D._D._D._D._D._D._D._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._.ID._D._D._D._D._D._D._D._D._D._D._D._D._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._.ID._D._D._D._D._D._D._D._D._D._D._D.ID._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._.I._._._._._.I.I.I.I.I.I.ID.ID.ID.ID.ID.ID.ID.ID.ID._D._D.ID.ID._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._.ID._D._D._D._D._D._D._D._D.ID._D._D._D._D._D._D._D._D._D._D._D._D._D._D.ID._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._.ID._D._D._D._D._D._D._D._D.ID._D._D._D._D._D._D._D._D._D._D._D._D._D._D.ID._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._D._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="stenka1" x="24" y="6"/>
    <obj id="bed" code="ZR9vWkXlAHuTbu9F" x="25" y="16"/>
    <obj id="tumba1" code="q6pAxrAAMJrdG79c" x="19" y="21"/>
    <obj id="table" code="U8ow1MenQkzkUS3T" x="24" y="21"/>
    <obj id="woodbox" code="QF4A8DgW4jNTJEE9" x="29" y="16"/>
    <obj id="door1" code="WrLu1wrBNBPGXYqj" x="36" y="21" lock="1"/>
    <obj id="chest" code="tWxyzqZB9fApJKy3" x="26" y="11"/>
    <obj id="ammobox" code="Yq2kcQ3Df5L82rUT" x="28" y="11"/>
    <obj id="case" code="snEdAAeHqEzu8Yy2" x="29" y="11"/>
    <obj id="table1" code="rQqilcrO1gPDWsXm" x="26" y="21"/>
    <obj id="raider" code="NwzXQn5Df0j9eJmN" x="28" y="21" tr="2"/>
    <obj id="rat" code="sRhSRQafOWZ7xfak" x="31" y="16"/>
    <obj id="rat" code="NKpbMfhKuyJyxnir" x="27" y="16"/>
    <obj id="ammobox" code="nD8tEi1I88CzdpcB" x="35" y="16"/>
    <obj id="woodbox" code="GcQCsmQq50QmGV3I" x="22" y="21"/>
    <obj id="door1" code="cJ1mX1LuI6IGwLK9" x="12" y="21"/>
    <obj id="door1" code="c78J2xL2XqTVTz9P" x="21" y="21" lock="1"/>
    <obj id="medbox" code="n6Eius4Nxq80OZYh" x="28" y="15"/>
    <obj id="hatch1" code="TZMeAuUZivT4MJ6s" x="33" y="17"/>
    <obj id="checkpoint" code="cXsldanzeDqvr87S" x="15" y="21"/>
    <obj id="window1" code="pvKEHkIRRVoZhpk5" x="36" y="15"/>
    <obj id="couch" code="X8sXIDwnKPV8JSBa" x="17" y="21"/>
    <back id="potek" x="21" y="18"/>
    <back id="chole1" x="29" y="15"/>
    <back id="stenka3" x="12" y="16"/>
    <obj id="box" code="IxH0N50okqU8qrOc" x="7" y="21"/>
    <back id="blood1" x="18" y="18"/>
    <back id="heap1" x="30" y="19"/>
    <back id="heap3" x="9" y="21"/>
    <back id="paint" x="26" y="14"/>
    <back id="rgraff" x="13" y="17"/>
    <back id="rgraff" x="25" y="18"/>
    <back id="rgraff" x="15" y="19"/>
    <back id="rgraff" x="22" y="19"/>
    <back id="potek" x="25" y="13"/>
    <back id="blood2" x="28" y="14"/>
    <back id="heap1" x="19" y="14"/>
    <back id="remains1" x="36" y="13"/>
    <back id="remains1" x="1" y="13"/>
    <back id="tree" x="2" y="13"/>
    <back id="tree" x="39" y="13"/>
    <back id="stree" x="39" y="16"/>
    <back id="trava" x="37" y="21"/>
    <back id="trava" x="0" y="21"/>
    <back id="musor1" x="24" y="21"/>
    <back id="musor1" x="13" y="21"/>
    <back id="musor1" x="25" y="16"/>
    <back id="musor1" x="25" y="11"/>
    <back id="skel" x="31" y="11"/>
    <back id="skel" x="28" y="16"/>
    <back id="signboard" x="10" y="18"/>
    <options/>
  </room>
  <room name="room_6_2" x="6" y="2">
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.D._._._._._._._._._._._._._._._._._._._._._._А.D.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.D._._._._._._._._._._._._._._._._._._._._._._А.D.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.D._._._._._._._._._._._._._._._._._._._._._._А.D.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.D._._._._._._._._._._._._._._._._._._._._._._А.D.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.D._._._._._._._._._._._._._._._._._._._._._._А.D.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.D._._._._._._._._._._._._._._._._._._._._._._А.D.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.D._._._._._._._._._._._._._._._._._._._._._._А.D.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.D._._._._._._._._._._._._._._._._._._._._._._.D.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.D._._._._._._._._._._._._._._._._._._._._._._.D.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H._._._._._._._._._._._._._._._.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <obj id="radbarrel" code="jCMrtemPgU9Cioup" x="32" y="15"/>
    <obj id="radbarrel" code="uoLcBIWkXBCUoU2t" x="26" y="15"/>
    <obj id="radbarrel" code="wsihdGrmYIX5YEwe" x="28" y="15"/>
    <obj id="radbarrel" code="A6Kh9cqfNMlEKsKG" x="22" y="15"/>
    <back id="moss" x="17" y="14"/>
    <back id="moss" x="27" y="14"/>
    <options backwall="tDirt2" wlevel="13" wtip="1"/>
  </room>
  <room name="room_11_1" x="11" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>D.D.D.D.D.D.D.D.D._._._._.D.D.D.D._._._.D.D.D.D.D._._.D.D.D.D._._._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H._L._L._L._L.HL.HL.HL._L._L._L._L.H.H.H.H.H.H.H.H.G.G._L._._._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.HL._L._L.HL.HL.HL.HL.HL.HL.HL.HL.H.H.H.H.H.H.H.H.G.G._L-._-._._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G._L._._._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G._L._._._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G._L._._._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C.C.C.C.C.C.C._L-._L-._L-._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._E._E._E._E._E.CE._L._L._L._L._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._E._E._E._E._E._E._L._L._L._L._L._L._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C._E._E._E._E._E._E._L._L._L._L._L._L._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="musor1" x="1" y="12"/>
    <obj id="checkpoint" code="EWojhE8UK208iddU" x="24" y="22" tele="1"/>
    <back id="musor1" x="30" y="22"/>
    <back id="heap3" x="19" y="14"/>
    <back id="tree" x="37" y="14"/>
    <obj id="door1" code="i40Ck396UNu1Lzef" x="29" y="22"/>
    <back id="heap3" x="15" y="14"/>
    <back id="heap2" x="8" y="14"/>
    <back id="stree" x="40" y="19"/>
    <back id="stree" x="36" y="20"/>
    <back id="trava" x="36" y="22"/>
    <options bezdna="1"/>
  </room>
  <room name="room_5_1" x="5" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._K._K._K._K._K._K._K._K._K._K._K._K._K._K._._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._._._._._._._._._._</a>
    <a>_._._._._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._._._._._._._._._._</a>
    <a>_._._._._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._K._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="trava" x="5" y="21"/>
    <obj id="scorp" code="JmpfVQPsGunHOQpa" x="22" y="21"/>
    <obj id="scorp" code="SAEeYiJrlqrpsM2G" x="33" y="21"/>
    <obj id="scorp" code="GsX5HSHm4QlHBV7z" x="29" y="21"/>
    <obj id="grate" code="zJXGOvUMTtMS3TFk" x="19" y="21"/>
    <back id="remains1" x="6" y="13"/>
    <back id="trava" x="0" y="21"/>
    <back id="tree" x="11" y="14"/>
    <back id="stree" x="8" y="16"/>
    <back id="tree" x="4" y="13"/>
    <obj id="grate" code="kW3qn9lW8KItX7Yu" x="38" y="21"/>
    <back id="tree" x="20" y="13"/>
    <back id="tree" x="31" y="13"/>
    <back id="stree" x="30" y="16"/>
    <back id="stree" x="25" y="16"/>
    <back id="stree" x="15" y="16"/>
    <back id="stree" x="41" y="16"/>
    <back id="trava" x="38" y="21"/>
    <back id="zavod2" x="39" y="20"/>
    <back id="zavod2" x="11" y="20"/>
    <options/>
  </room>
  <room name="room_8_1" x="8" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._.R._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>CN._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._N._N._N._N._N._N._N._N.CN._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>CN._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._N._N._N._N._N._N._N._N.CN._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>CN._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._N._N._N._N._N._N._N._N.CN._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN.CN._NК._NК._NК._NК._NК.CN.CN.CN._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>CN._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>CN._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N.CN._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>CN._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._NЛ._NК._NК._NК._NК._NК.CN._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._NЛ._N._N._N._N._N._N._N._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_N._N._N._N._N._N._N._N._N._N._N._N._N._N._N._NЛ._N._N._N._N._N._N._N._N._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._К._К._М._._._._._._._._._._._._._._._._._._._._._</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C._._._._М._._._._._._._._._._._._._._._._._._._._</a>
    <a>C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.C.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="stenka3" x="2" y="4"/>
    <obj id="ammobox" code="TBfmGQh8kQBmjbXF" x="4" y="13"/>
    <obj id="locker" code="CSuzGusxJADWaV5s" x="2" y="13"/>
    <obj id="woodbox" code="hf9BSNuW5dDTCiP4" x="21" y="16"/>
    <obj id="box" code="B9aufa9Qz9UBm9Fx" x="21" y="13"/>
    <obj id="bigbox" code="TxswiipXqdn7zhEg" x="6" y="19"/>
    <obj id="chest" code="jPaHr6u5oQzaFdQq" x="18" y="5"/>
    <obj id="raider" code="oggxRfUgzOOp9zBB" x="7" y="13" tr="3"/>
    <obj id="trap" code="pO5NgubEPHiOHwIC" x="14" y="5"/>
    <obj id="tarakan" code="bnaZKQO1RW2oVyZw" x="32" y="21"/>
    <obj id="tarakan" code="S4BK6zcBx8E55DtK" x="42" y="21"/>
    <obj id="safe" code="wfKVVzRFrJLPZOQc" x="20" y="5"/>
    <obj id="checkpoint" code="aXCMfRADlUtR7gHY" x="9" y="19"/>
    <obj id="raider" code="RODYOsP6OnLcn5zW" x="11" y="13" tr="2"/>
    <obj id="door1" code="c6Q1kzZIOdoDYouT" x="14" y="13"/>
    <obj id="medbox" code="uWp8RRd1uDyIYCSx" x="13" y="18"/>
    <obj id="trap" code="mbPdQVRHG6Cgn1nk" x="16" y="5"/>
    <back id="chole2" x="16" y="9"/>
    <back id="rgraff" x="8" y="16"/>
    <back id="rgraff" x="3" y="16"/>
    <back id="stenka3" x="12" y="4"/>
    <back id="rgraff" x="15" y="16"/>
    <obj id="door1" code="D4nNqYxJeDpdwLQU" x="23" y="19"/>
    <back id="rgraff" x="9" y="11"/>
    <back id="chole3" x="5" y="8"/>
    <back id="potek" x="14" y="9"/>
    <back id="light3" x="2" y="10"/>
    <back id="potek" x="1" y="15"/>
    <back id="pipe4" x="14" y="15"/>
    <back id="pipe4" x="14" y="17"/>
    <back id="pipe4" x="14" y="19"/>
    <back id="heap1" x="22" y="19"/>
    <back id="trava" x="24" y="21"/>
    <back id="trava" x="36" y="21"/>
    <back id="stree" x="29" y="16"/>
    <back id="stree" x="40" y="18"/>
    <back id="tree" x="32" y="13"/>
    <back id="tree" x="35" y="16"/>
    <back id="tree" x="24" y="13"/>
    <back id="remains2" x="25" y="16"/>
    <back id="remains2" x="38" y="16"/>
    <back id="remains1" x="31" y="13"/>
    <back id="musor2" x="1" y="19"/>
    <back id="musor2" x="5" y="13"/>
    <back id="musor2" x="15" y="19"/>
    <options/>
  </room>
  <room name="room_10_1" x="10" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>DG.DG.DG.DG.DG.D.D.D.D.D.D.D.D.D.D.D.D._._._._._._._._._._._._._._.D.D.D.D.D.D.D.D.D.D.D.D.DG.DG.DG.DG.DG</a>
    <a>K.K.K.K.K.K.K.K.K.K.K.K.K.K.K.K._._._._._._._._._._._._._._._._.K.K.K.K.K.K.K.K.K.K.K.K.K.K.K.K</a>
    <a>K.K.K.K.K.K.K.D.K._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.K.D.K.K.K.K.K.K.K</a>
    <a>H.H.H.H.H.K.K.D.K._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.K.D.K.K.H.H.H.H.H</a>
    <a>H.H.H.D.D.D.D.D._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D.D.H.H.H</a>
    <a>_E._E._E._E._E._E._E._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.D.D.D.D.D.H.H.H</a>
    <a>_E._E._E._E._E._E._E._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L.H.H.H.H.H.H</a>
    <a>D.D.D.D.D.D._LБ._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L._L.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H._LБ._L._L._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._L._L._L.H.H.H.H.H.H</a>
    <back id="bigbeam" x="29" y="15"/>
    <obj id="bloodwing" code="M2JmTNp0dUGyYXFI" x="10" y="15"/>
    <obj id="bloodwing" code="KxQ8aNtcDqiopUS1" x="13" y="15"/>
    <back id="bigbeam" x="9" y="15"/>
    <back id="hkonstr" x="21" y="13"/>
    <back id="hkonstr" x="27" y="13"/>
    <back id="hkonstr" x="33" y="13"/>
    <back id="hkonstr" x="15" y="13"/>
    <back id="hkonstr" x="9" y="13"/>
    <back id="vkonstr" x="7" y="10"/>
    <back id="vkonstr" x="39" y="10"/>
    <back id="vkonstr" x="39" y="7"/>
    <back id="vkonstr" x="7" y="7"/>
    <obj id="bloodwing" code="QYPOkGYJTMKvVa33" x="36" y="15"/>
    <back id="bigbeam" x="19" y="15"/>
    <back id="hrail" x="35" y="12"/>
    <back id="hrail" x="31" y="12"/>
    <back id="hrail" x="13" y="12"/>
    <back id="hrail" x="9" y="12"/>
    <back id="hrail" x="39" y="12"/>
    <back id="hrail" x="5" y="12"/>
    <back id="hkonstr" x="9" y="12"/>
    <back id="hkonstr" x="33" y="12"/>
    <back id="hrail" x="43" y="12"/>
    <back id="hrail" x="1" y="12"/>
    <back id="hkonstr" x="41" y="12"/>
    <back id="hkonstr" x="1" y="12"/>
    <options bezdna="1"/>
  </room>
  <room name="room_3_1" x="3" y="1">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._.I._._._._._._._._._._._._._._.I._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID.ID._D._DА.ID.ID._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._.ID._D._D._D._D._D._D._D._D._D._D._D._D._DА._D.ID._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._.ID._D._D._D._D._D._D._D._D._D._D._D._D._DА._D.ID.E._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._D._D._D._D._D._D._D._D._D._D._D._D._D._DА._D.ID.E._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._D._D._D._D._D._D._D._D._D._D._D._D._D._DА._D.ID.E._._._._._._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.I.I.I.I.I.I.I.I.I.I.I.I.I.I.I.I.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <obj id="area" code="YaU7LjBHGjTeOoHh" x="4" y="21" h="8">
      <scr>
        <s act="dialog" val="surfDialSome"/>
        <s act="off" targ="this"/>
      </scr>
    </obj>
    <obj id="spikes" code="QY58y4VIZNhyg2Kh" x="12" y="16"/>
    <obj id="spikes" code="VoSmAwLP5y123qhS" x="11" y="15"/>
    <obj id="spikes" code="BpiczqZxXaSghIcL" x="17" y="16"/>
    <obj id="spikes" code="Q98khA2PJI5FhSmO" x="15" y="16"/>
    <obj id="spikes" code="lzzC8DlVv6oyhbTz" x="21" y="16"/>
    <obj id="hatch1" code="RtMdvAT6SqDQq5Ui" x="23" y="17"/>
    <obj id="spikes" code="LFU61cah32GiHOSs" x="19" y="16"/>
    <obj id="spikes" code="qnRlS5UgrOI9ntLG" x="20" y="16"/>
    <obj id="door1" code="OdwegZPBoEiHlZ4H" x="11" y="21" lock="0"/>
    <obj id="raider" code="vnXcxQlJKwKgPbTm" x="21" y="21" tr="1" ai="stay" turn="-1">
      <scr>
        <s act="dialog" val="surfDialKill"/>
      </scr>
      <scr eve="alarm">
        <s act="off" targ="this"/>
        <s act="control off"/>
        <s act="dial" val="surfDialHello" n="0" t="2"/>
        <s act="dialog" val="surfDialHello"/>
        <s act="on" targ="this"/>
      </scr>
    </obj>
    <obj id="instr1" code="DoDT8ssz1JQxVR6Z" x="14" y="21"/>
    <obj id="instr2" code="cx9QOjA69rB1cAfd" x="14" y="19"/>
    <obj id="locker" code="o5K5ZjDd6E2VSg5k" x="17" y="21"/>
    <obj id="spikes" code="prqaJGDBnZQUBQqu" x="13" y="16"/>
    <back id="stenka3" x="12" y="15"/>
    <back id="rgraff" x="12" y="19"/>
    <back id="rgraff" x="16" y="18"/>
    <back id="rgraff" x="20" y="19"/>
    <back id="stree" x="31" y="16"/>
    <back id="stree" x="41" y="16"/>
    <back id="tree" x="35" y="13"/>
    <back id="trava" x="27" y="21"/>
    <back id="trava" x="36" y="21"/>
    <back id="trava" x="0" y="21"/>
    <back id="stenka1" x="24" y="18"/>
    <back id="remains1" x="0" y="13"/>
    <back id="remains1" x="37" y="13"/>
    <back id="remains2" x="32" y="16"/>
    <options/>
  </room>
  <room name="room_0_1" x="0" y="1">
    <a>G.G.G.G.G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>B.B.B.B.B._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_C._C._C._C._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>B.B.B.B.B._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._K._K._K._K._K._K._K._K._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._K._K._K._K._K._K._K._K._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._K._K._K._K._K._K._K._K._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._K._K._K._K._K._K._K._K._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>G.G.G.G.G._K._K._K._K._K._K._K._K._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="trava" x="15" y="21"/>
    <obj id="player" code="lXxKW8q3awFfm9Gm" x="2" y="9"/>
    <back id="trava" x="36" y="21"/>
    <back id="stree" x="29" y="16"/>
    <back id="trava" x="4" y="21"/>
    <back id="trava" x="26" y="21"/>
    <obj id="area" code="UZErLgC2CGAdpzE0" x="17" y="21" h="20" w="2">
      <scr>
        <s act="dialog" val="surfDialFirst"/>
        <s act="off" targ="this"/>
      </scr>
    </obj>
    <back id="stree" x="40" y="16"/>
    <back id="stree" x="25" y="18"/>
    <back id="tree" x="35" y="13"/>
    <back id="vkonstr" x="13" y="19"/>
    <back id="vkonstr" x="13" y="16"/>
    <back id="heap1" x="3" y="19"/>
    <options/>
  </room>
</all>



var rooms_garages:XML=<all>
  <land serial="1"/>
  <room name="room_2_0" x="1" y="0">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_._._._._._._._._._._._._._.ED.ED.ED.ED.ED.ED.ED._A._A._A._A._A._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_._._._._._._._._._._._._._.ED._D._D._D._D._D._D._D._D._D._D._A._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_E._E._E._E._E._._._._._._._._._._A._D._D._D._D._D._D._D._D._D._D._A._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_E._E._E._E._E._._._._._._._._._._A._D._D._D._D._D._D._D._D._D._D._A._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_E._E._E._E._E._._._._._._._._._._A._D._D._D._D._D._D._D._D._D._D._A._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_E._E._E._E._E._._._._._._._._._К.BD.BD.BD.BD.BD.BD._AБК._AК._AК.BD.BD.BD._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_E._E._E._E._E._._._._._._._._._.BD._D._D._D._D._D._DБ._D._D._D._D.BD._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_E._E._E._E._E._._._._._._._._._._A._D._D._D._D._D._DБ._D._D._D._D.BD._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_E._E._EК._EК._E._._._._._._._._._._A._D._D._D._D._D._D._D._D._D._D.BD._._._._._._._._._._._._._._._._._._._._.G.G</a>
    <a>_E._E._E._E._E._._._._._._._._._._A._D._D._D._D._D._D._D._D._D._D._A._._._._._._.H;.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G</a>
    <a>_E._E._E._E._E._._._._._._._._._._A._D._D._D._D._D._D._D._D._D._D._A._._._._.H;.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G</a>
    <a>_E._E._E._E._E._._._._._._._._._._A._D._D._D._D._D._D._D._D._D._D._A._._.H;.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G</a>
    <a>B.B.B.B.B._A._A._A._A._A._A.B.B.B.B.B.B.B.B.B.B.B.B.B.B.B.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G.G</a>
    <a>G.G.G.G.G._L._L._L._L.GL.GL.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G.G</a>
    <a>G.G.G.G.G.GL.GL.GL.GL.GL.GL.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G.G</a>
    <a>G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.G.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.G.G.G</a>
    <obj id="spikes" code="Qx1h0p3XZnO3y23V" x="25" y="12"/>
    <obj id="ranger" code="HGfOtcqVR63C4iHO" x="25" y="19" tr="1" turn="-1" ai="quiet" weap="minigun" observ="50"/>
    <obj id="area" code="slf3WcY3wVcVFLez" x="0" y="19" h="20">
      <scr>
        <s act="music" val="pre_1"/>
        <s act="dialog" val="meetDial1"/>
        <s act="showstage" val="storyMeet" n="3"/>
        <s act="off" targ="this"/>
      </scr>
    </obj>
    <obj id="ranger" code="kshh7qQBCR642eqq" x="20" y="19" tr="1" turn="-1" ai="quiet" weap="incin" observ="50"/>
    <obj id="protect" code="zK2cTdi1kL0Vv2OM" x="36" y="16" tr="1" turn="-1" ai="quiet"/>
    <obj id="brspr" code="zpSiQPNi4cpbf2Ec" x="18" y="19" sign="1" inter="12" time="60" scr="brspr"/>
    <obj id="ammobox" code="iWNts9o1fSCr3F6n" x="16" y="7"/>
    <obj id="spikes" code="qEbKY9kgcPVLJH5w" x="14" y="12"/>
    <back id="stree" x="39" y="14"/>
    <back id="stree" x="25" y="16"/>
    <back id="hole1" x="20" y="2"/>
    <back id="hole3" x="3" y="6"/>
    <back id="bwindow" x="15" y="16"/>
    <back id="bwindow" x="21" y="16"/>
    <back id="swindow" x="16" y="10"/>
    <back id="stree" x="11" y="17"/>
    <back id="tree" x="35" y="8"/>
    <back id="tree" x="39" y="9"/>
    <back id="stree" x="34" y="13"/>
    <back id="hole4" x="0" y="9"/>
    <back id="stree" x="28" y="16"/>
    <back id="stree" x="30" y="14"/>
    <back id="heap1" x="12" y="18"/>
    <back id="heap3" x="15" y="12"/>
    <back id="heap3" x="23" y="19"/>
    <back id="heap3" x="23" y="12"/>
    <back id="trava" x="33" y="16"/>
    <back id="trava" x="37" y="16"/>
    <back id="musor1" x="16" y="19"/>
    <back id="musor1" x="17" y="12"/>
    <back id="musor2" x="0" y="19"/>
    <back id="potek" x="15" y="14"/>
    <back id="potek" x="15" y="13"/>
    <back id="musor1" x="5" y="21"/>
    <options lon="-1"/>
  </room>
  <room name="room_0_0" x="0" y="0">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._E._E._E._E._E</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._E._E._E._E._E</a>
    <a>_._._._._._._._._._._._._._T._T._T._T._T._T._T._T._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._T-._._._._E._E._E._E._E</a>
    <a>_._._._._._._._._._._._._._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._._._._E._E._E._E._E</a>
    <a>_._._._.K.K.KC.KC.KC.KC.K.K._._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._._._._E._E._E._E._E</a>
    <a>_._._._._._._C._C._C._C._._._._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._._._._E._E._E._E._E</a>
    <a>_._._._K._K._K._C._C._C._C._K._K._K._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._K._K._K._E._E._E._E._E</a>
    <a>_._._._K._K._K._C._C._C._C._K._K._K._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._K._K._K._E._E._E._E._E</a>
    <a>_._._._K._K._K._C._C._C._C._K._K._K._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._K._K._K._E._E._E._E._E</a>
    <a>_._._._K._K._K._C._C._C._C._K._K._K._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._T._K._K._K._E._E._E._E._E</a>
    <a>H.H.H.H.H.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D.D</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="wires2" x="8" y="15"/>
    <obj id="scorp" code="rPE6IaOXpaubIKHK" x="43" y="19"/>
    <obj id="case" code="axjN0ZEWn89G1kJW" x="6" y="13"/>
    <obj id="player" code="N6u7DzIwOPKuGqQO" x="6" y="19"/>
    <obj id="area" code="c47OPgR5db2nU0RU" x="5" y="23" h="20" w="6" scr="garages"/>
    <obj id="checkpoint" code="Ih2uIhkdHr0lFoHz" x="7" y="19" tele="1"/>
    <obj id="ammobox" code="sU4Z9UAzllnNqBih" x="35" y="11"/>
    <back id="rgraff" x="43" y="16"/>
    <back id="rgraff" x="44" y="15"/>
    <back id="plantgate" x="15" y="14"/>
    <back id="potek" x="21" y="12"/>
    <back id="plantgate" x="23" y="14"/>
    <back id="plantgate" x="31" y="14"/>
    <back id="vkonstr" x="4" y="15"/>
    <back id="vkonstr" x="10" y="15"/>
    <back id="vkonstr" x="10" y="18"/>
    <back id="vkonstr" x="4" y="18"/>
    <back id="railing" x="4" y="13"/>
    <back id="railing" x="8" y="13"/>
    <obj id="ant" code="kqX1MWWgNbGVOgTI" x="39" y="19"/>
    <back id="hole1" x="36" y="4"/>
    <back id="potek" x="13" y="12"/>
    <back id="potek" x="28" y="12"/>
    <back id="light1" x="22" y="14"/>
    <back id="light1" x="30" y="14"/>
    <back id="musor1" x="9" y="19"/>
    <back id="musor1" x="19" y="19"/>
    <back id="musor1" x="27" y="19"/>
    <back id="musor1" x="35" y="19"/>
    <back id="musor2" x="41" y="19"/>
    <back id="musor1" x="22" y="11"/>
    <back id="musor2" x="30" y="11"/>
    <back id="musor2" x="13" y="11"/>
    <back id="heap2" x="40" y="18"/>
    <back id="zavod2" x="29" y="18"/>
    <back id="zavod2" x="36" y="18"/>
    <back id="zavod2" x="23" y="19"/>
    <back id="zavod2" x="38" y="19"/>
    <options lon="-1"/>
  </room>
</all>



var rooms_way:XML=<all>
  <land serial="1"/>
  <room name="room_0_0" x="0" y="0">
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>_._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <a>H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H.H</a>
    <back id="stree" x="36" y="19"/>
    <obj id="zebpon" code="ay4TwznxQEcupubw" x="32" y="22" turn="-1" tr="2"/>
    <obj id="zebpon" code="VMkgieSillFZcWVO" x="34" y="22" turn="-1" tr="3"/>
    <obj id="area" code="dJCIuOyFRZU1LsQP" x="20" y="23" h="22">
      <scr>
        <s act="control off"/>
        <s act="dialog" val="dialZebra1"/>
        <s act="trigger" val="encounter_way" n="1"/>
        <s act="gotoland" val="covert"/>
        <s act="control on"/>
      </scr>
    </obj>
    <obj id="player" code="YgCBWzx9yyKeOLSi" x="4" y="22"/>
    <obj id="zebpon" code="cuRga03e8VTToCEs" x="24" y="22" turn="-1" tr="4" name="askari"/>
    <obj id="zebpon" code="Ako9BcWtwfiKNqWa" x="27" y="22" turn="-1" tr="1"/>
    <back id="tree" x="27" y="14"/>
    <obj id="zebpon" code="byCEadIch3hTvqUW" x="31" y="22" turn="-1" tr="5"/>
    <back id="stree" x="39" y="20"/>
    <back id="stree" x="27" y="19"/>
    <back id="trava" x="36" y="22"/>
    <back id="trava" x="25" y="22"/>
    <back id="trava" x="14" y="22"/>
    <back id="musor1" x="1" y="22"/>
    <back id="musor2" x="7" y="22"/>
    <options/>
  </room>
</all>

//=============================================================================================================================================		

		

	}
	
}
