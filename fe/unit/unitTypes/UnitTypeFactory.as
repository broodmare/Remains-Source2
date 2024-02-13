package fe.unit.unitTypes
{
    import fe.XMLDataGrabber;

    import fe.unit.Unit;
    import fe.unit.Mine;

    public class UnitTypeFactory
    {
        public static function create(id:String, dif:int, xml:XML=null, loadObj:Object=null, ncid:String=null):Unit
		{
			switch (id)
			{
				case "mwall":
					return new UnitMWall(null,0,null,null);
				break;
				case "scythe":
					return new UnitScythe(null,0,null,null);
				break;
				case "ttur":
					return new UnitThunderTurret(ncid,0,null,null);
				break;
			}

			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id);
			if (!node)
			{
				trace("ERROR (00:57): unit: '" + id + "' not found!");
				return null;
			}
			var uc:Class;
			var cn:String = node.@cl;
			switch (cn)
			{
				case "Mine":			uc = Mine;break;
				case "UnitTrap":		uc = UnitTrap;break;
				case "UnitTrigger":		uc = UnitTrigger;break;
				case "UnitDamager":		uc = UnitDamager;break;
				case "UnitRaider":		uc = UnitRaider;break;
				case "UnitSlaver":		uc = UnitSlaver;break;
				case "UnitZebra":		uc = UnitZebra;break;
				case "UnitRanger":		uc = UnitRanger;break;
				case "UnitEncl":		uc = UnitEncl;break;
				case "UnitMerc":		uc = UnitMerc;break;
				case "UnitZombie":		uc = UnitZombie;break;
				case "UnitAlicorn":		uc = UnitAlicorn;break;
				case "UnitHellhound":	uc = UnitHellhound;break;
				case "UnitRobobrain":	uc = UnitRobobrain;break;
				case "UnitProtect":		uc = UnitProtect;break;
				case "UnitGutsy":		uc = UnitGutsy;break;
				case "UnitEqd":			uc = UnitEqd;break;
				case "UnitSentinel":	uc = UnitSentinel;break;
				case "UnitTurret":		uc = UnitTurret;break;
				case "UnitBat":			uc = UnitBat;break;
				case "UnitFish":		uc = UnitFish;break;
				case "UnitBloat":		uc = UnitBloat;break;
				case "UnitSpriteBot":	uc = UnitSpriteBot;break;
				case "UnitDron":		uc = UnitDron;break;
				case "UnitVortex":		uc = UnitVortex;break;
				case "UnitMonstrik":	uc = UnitMonstrik;break;
				case "UnitAnt":			uc = UnitAnt;break;
				case "UnitSlime":		uc = UnitSlime;break;
				case "UnitRoller":		uc = UnitRoller;break;
				case "UnitNPC":			uc = UnitNPC;break;
				case "UnitCaptive":		uc = UnitCaptive;break;
				case "UnitPonPon":		uc = UnitPonPon;break;
				case "UnitTrain":		uc = UnitTrain;break;
				case "UnitMsp":			uc = UnitMsp;break;
				case "UnitTransmitter":	uc = UnitTransmitter;break;
				case "UnitNecros":		uc = UnitNecros;break;
				case "UnitSpectre":		uc = UnitSpectre;break;
				case "UnitBossRaider":	uc = UnitBossRaider;break;
				case "UnitBossAlicorn":	uc = UnitBossAlicorn;break;
				case "UnitBossUltra":	uc = UnitBossUltra;break;
				case "UnitBossNecr":	uc = UnitBossNecr;break;
				case "UnitBossDron":	uc = UnitBossDron;break;
				case "UnitBossEncl":	uc = UnitBossEncl;break;
				case "UnitThunderHead":	uc = UnitThunderHead;break;
				case "UnitDestr":		uc = UnitDestr;break;
				case "UnitBloatEmitter": uc = UnitBloatEmitter;break;
			}
			if (!uc) return null;

			var cid:String = null;	// [Creation ID]
			if (node.@cid.length()) cid = node.@cid;
			if (ncid) cid = ncid;
			var un:Unit = new uc(cid, dif, xml, loadObj);
			if (xml && xml.@code.length()) un.code = xml.@code;
			return un;
		}
    }
}