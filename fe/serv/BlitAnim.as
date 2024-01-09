﻿package fe.serv {
	
	//Анимация с помощью спрайт-листов, шаблон
	
	public class BlitAnim {
		/*public static var spriteLists:Array=new Array();

		spriteLists['expl'] = new sprExpl();
		spriteLists['iskr'] = new sprIskr();
		spriteLists['kap'] = new sprKap();
		spriteLists['blood'] = new sprBlood();
		spriteLists['gblood'] = new sprGBlood();
		spriteLists['bspark'] = new sprBSpark();*/
		
		//public static var wPos:Array=new Array();
		public static var wPosRaider1:Array = [
[{x:100,y:63,r:0},{x:115,y:100,r:0}],
[{x:100,y:65,r:2},{x:101,y:65,r:4},{x:101,y:63,r:4},{x:101,y:62,r:3},{x:102,y:63,r:3},{x:102,y:65,r:2},{x:102,y:67,r:3},{x:101,y:68,r:3},{x:101,y:67,r:4},{x:101,y:65,r:5},{x:101,y:63,r:4},{x:101,y:62,r:3},{x:101,y:63,r:3},{x:102,y:65,r:1},{x:101,y:67,r:3},{x:101,y:68,r:3},{x:101,y:67,r:3}],
[{x:107,y:68,r:4},{x:109,y:69,r:4},{x:113,y:71,r:4},{x:114,y:71,r:1},{x:112,y:72,r:1},{x:107,y:73,r:6},{x:105,y:72,r:6},{x:103,y:69,r:9}],
[{x:93,y:50,r:-14},{x:94,y:51,r:-12},{x:95,y:52,r:-11},{x:96,y:53,r:-9},{x:97,y:54,r:-7},{x:98,y:55,r:-6},{x:99,y:55,r:-4},{x:99,y:56,r:-3},{x:100,y:58,r:-2},{x:100,y:58,r:0},{x:100,y:60,r:2},{x:100,y:62,r:4},{x:101,y:64,r:6},{x:101,y:65,r:8},{x:101,y:67,r:11},{x:102,y:69,r:13}],
[{x:100,y:63,r:0},{x:99,y:58,r:-12},{x:98,y:52,r:-24},{x:95,y:45,r:-36},{x:92,y:39,r:-49},{x:95,y:46,r:-45},{x:97,y:54,r:-41},{x:99,y:61,r:-38},{x:101,y:68,r:-34},{x:103,y:76,r:-31},{x:105,y:83,r:-27},{x:107,y:91,r:-24},{x:107,y:89,r:-27},{x:107,y:87,r:-31},{x:109,y:93,r:-23},{x:111,y:99,r:-16},{x:113,y:105,r:-8},{x:114,y:110,r:0},{x:115,y:115,r:8},{x:116,y:120,r:16}],
[{x:88,y:81,r:35},{x:94,y:85,r:20},{x:99,y:88,r:6},{x:104,y:90,r:-9},{x:107,y:91,r:-24},{x:107,y:89,r:-27},{x:107,y:87,r:-31},{x:109,y:93,r:-23},{x:111,y:99,r:-16},{x:113,y:105,r:-8},{x:114,y:110,r:0},{x:115,y:115,r:8},{x:116,y:120,r:16}],
[{x:103,y:49,r:-26},{x:103,y:49,r:-28},{x:102,y:48,r:-30},{x:102,y:47,r:-32},{x:102,y:47,r:-34},{x:102,y:47,r:-32},{x:102,y:48,r:-30},{x:103,y:49,r:-28}],
[{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4},{x:99,y:55,r:-4}],
[{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51},{x:87,y:35,r:-51}],
[{x:100,y:65,r:2},{x:101,y:65,r:2},{x:101,y:64,r:2},{x:101,y:64,r:2},{x:101,y:64,r:2},{x:102,y:63,r:1},{x:103,y:63,r:-1},{x:102,y:63,r:0},{x:101,y:64,r:0},{x:101,y:64,r:1},{x:100,y:65,r:2},{x:100,y:65,r:2},{x:100,y:65,r:2},{x:101,y:64,r:2},{x:101,y:64,r:1},{x:101,y:64,r:1},{x:102,y:63,r:0},{x:102,y:63,r:0},{x:102,y:63,r:0},{x:102,y:64,r:1},{x:101,y:64,r:1},{x:101,y:64,r:1},{x:101,y:65,r:2},{x:101,y:65,r:2}]
		];
		public static var wPosRaider2:Array = [
/*[{x:92,y:57,r:0},{x:107,y:91,r:0}],
[{x:93,y:59,r:2},{x:93,y:59,r:4},{x:94,y:57,r:4},{x:94,y:57,r:3},{x:94,y:57,r:3},{x:94,y:59,r:2},{x:94,y:61,r:3},{x:94,y:62,r:3},{x:94,y:61,r:4},{x:93,y:59,r:5},{x:93,y:57,r:4},{x:94,y:57,r:3},{x:94,y:57,r:3},{x:94,y:59,r:1},{x:94,y:61,r:3},{x:94,y:62,r:3},{x:94,y:61,r:3}],
[{x:98,y:62,r:4},{x:100,y:63,r:4},{x:104,y:64,r:4},{x:105,y:65,r:1},{x:103,y:66,r:1},{x:99,y:67,r:6},{x:97,y:65,r:6},{x:95,y:63,r:9}],
[{x:86,y:46,r:-14},{x:87,y:47,r:-12},{x:88,y:47,r:-11},{x:89,y:48,r:-9},{x:90,y:49,r:-7},{x:90,y:50,r:-6},{x:91,y:50,r:-4},{x:92,y:51,r:-3},{x:92,y:52,r:-2},{x:92,y:53,r:0},{x:92,y:55,r:2},{x:93,y:56,r:4},{x:93,y:58,r:6},{x:93,y:60,r:8},{x:94,y:61,r:11},{x:94,y:63,r:13}],
[{x:92,y:57,r:0},{x:92,y:52,r:-12},{x:90,y:47,r:-24},{x:88,y:41,r:-36},{x:85,y:35,r:-49},{x:88,y:42,r:-45},{x:90,y:50,r:-41},{x:93,y:57,r:-38},{x:95,y:65,r:-34},{x:98,y:72,r:-31},{x:100,y:80,r:-27},{x:102,y:87,r:-24},{x:103,y:86,r:-27},{x:103,y:85,r:-31},{x:105,y:89,r:-26},{x:106,y:94,r:-21},{x:108,y:98,r:-15},{x:109,y:102,r:-10},{x:110,y:107,r:-4},{x:111,y:111,r:1}],
[{x:82,y:79,r:35},{x:88,y:82,r:20},{x:93,y:85,r:6},{x:98,y:87,r:-9},{x:102,y:87,r:-24},{x:103,y:86,r:-27},{x:103,y:85,r:-31},{x:105,y:89,r:-26},{x:106,y:94,r:-21},{x:108,y:98,r:-15},{x:109,y:102,r:-10},{x:110,y:107,r:-4},{x:111,y:111,r:1}],
[{x:95,y:45,r:-26},{x:95,y:44,r:-28},{x:94,y:44,r:-30},{x:94,y:43,r:-32},{x:94,y:42,r:-34},{x:94,y:43,r:-32},{x:94,y:44,r:-30},{x:95,y:44,r:-28}],
[{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4}],
[{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51}]*/
[{x:92,y:57,r:0},{x:107,y:91,r:0}],
[{x:93,y:59,r:2},{x:93,y:59,r:4},{x:94,y:57,r:4},{x:94,y:57,r:3},{x:94,y:57,r:3},{x:94,y:59,r:2},{x:94,y:61,r:3},{x:94,y:62,r:3},{x:94,y:61,r:4},{x:93,y:59,r:5},{x:93,y:57,r:4},{x:94,y:57,r:3},{x:94,y:57,r:3},{x:94,y:59,r:1},{x:94,y:61,r:3},{x:94,y:62,r:3},{x:94,y:61,r:3}],
[{x:98,y:62,r:4},{x:100,y:63,r:4},{x:104,y:64,r:4},{x:105,y:65,r:1},{x:103,y:66,r:1},{x:99,y:67,r:6},{x:97,y:65,r:6},{x:95,y:63,r:9}],
[{x:86,y:46,r:-14},{x:87,y:47,r:-12},{x:88,y:47,r:-11},{x:89,y:48,r:-9},{x:90,y:49,r:-7},{x:90,y:50,r:-6},{x:91,y:50,r:-4},{x:92,y:51,r:-3},{x:92,y:52,r:-2},{x:92,y:53,r:0},{x:92,y:55,r:2},{x:93,y:56,r:4},{x:93,y:58,r:6},{x:93,y:60,r:8},{x:94,y:61,r:11},{x:94,y:63,r:13}],
[{x:92,y:57,r:0},{x:92,y:52,r:-12},{x:90,y:47,r:-24},{x:88,y:41,r:-36},{x:85,y:35,r:-49},{x:88,y:42,r:-45},{x:90,y:50,r:-41},{x:93,y:57,r:-38},{x:95,y:65,r:-34},{x:98,y:72,r:-31},{x:100,y:80,r:-27},{x:102,y:87,r:-24},{x:103,y:86,r:-27},{x:103,y:85,r:-31},{x:105,y:89,r:-26},{x:106,y:94,r:-21},{x:108,y:98,r:-15},{x:109,y:102,r:-10},{x:110,y:107,r:-4},{x:111,y:111,r:1}],
[{x:82,y:79,r:35},{x:88,y:82,r:20},{x:93,y:85,r:6},{x:98,y:87,r:-9},{x:102,y:87,r:-24},{x:103,y:86,r:-27},{x:103,y:85,r:-31},{x:105,y:89,r:-26},{x:106,y:94,r:-21},{x:108,y:98,r:-15},{x:109,y:102,r:-10},{x:110,y:107,r:-4},{x:111,y:111,r:1}],
[{x:95,y:45,r:-26},{x:95,y:44,r:-28},{x:94,y:44,r:-30},{x:94,y:43,r:-32},{x:94,y:42,r:-34},{x:94,y:43,r:-32},{x:94,y:44,r:-30},{x:95,y:44,r:-28}],
[{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4},{x:91,y:50,r:-4}],
[{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51},{x:80,y:32,r:-51}],
[{x:93,y:59,r:2},{x:93,y:59,r:2},{x:93,y:59,r:2},{x:93,y:59,r:2},{x:93,y:58,r:2},{x:94,y:58,r:1},{x:95,y:57,r:-1},{x:94,y:58,r:0},{x:94,y:58,r:0},{x:93,y:58,r:1},{x:92,y:59,r:2},{x:93,y:59,r:2},{x:93,y:59,r:2},{x:93,y:59,r:2},{x:93,y:58,r:1},{x:94,y:58,r:1},{x:94,y:58,r:0},{x:94,y:57,r:0},{x:94,y:58,r:0},{x:94,y:58,r:1},{x:94,y:58,r:1},{x:93,y:59,r:1},{x:93,y:59,r:2},{x:93,y:59,r:2}]
		];
		public static var wPosGutsy:Array = [
[{x:101,y:94,r:160},{x:101,y:93,r:160},{x:100,y:92,r:160},{x:100,y:92,r:160},{x:100,y:91,r:160},{x:100,y:91,r:160},{x:99,y:90,r:160},{x:99,y:90,r:160},{x:99,y:89,r:160},{x:99,y:89,r:160},{x:98,y:88,r:160},{x:98,y:88,r:160},{x:98,y:87,r:160},{x:98,y:86,r:160},{x:97,y:86,r:160},{x:97,y:85,r:160},{x:97,y:85,r:160},{x:96,y:84,r:160},{x:96,y:84,r:160},{x:96,y:83,r:160},{x:96,y:84,r:160},{x:96,y:84,r:160},{x:97,y:85,r:160},{x:97,y:85,r:160},{x:97,y:86,r:160},{x:97,y:86,r:160},{x:98,y:87,r:160},{x:98,y:87,r:160},{x:98,y:88,r:160},{x:98,y:88,r:160},{x:99,y:89,r:160},{x:99,y:89,r:160},{x:99,y:90,r:160},{x:99,y:90,r:160},{x:100,y:91,r:160},{x:100,y:91,r:160},{x:100,y:92,r:160},{x:100,y:92,r:160},{x:100,y:93,r:160},{x:101,y:93,r:160}],
[{x:101,y:94,r:160},{x:100,y:95,r:158},{x:99,y:96,r:157},{x:98,y:97,r:155},{x:97,y:98,r:154},{x:96,y:98,r:152},{x:95,y:99,r:151},{x:95,y:100,r:151},{x:94,y:100,r:150},{x:92,y:101,r:143},{x:90,y:101,r:136},{x:88,y:102,r:129},{x:87,y:102,r:123},{x:85,y:103,r:116},{x:83,y:104,r:109},{x:81,y:104,r:102},{x:79,y:105,r:95},{x:77,y:105,r:88},{x:76,y:106,r:82},{x:74,y:106,r:75}]
		];

		public static var wPosAlicorn:Array = [
[{x:132,y:14,r:180},{x:132,y:14,r:180},{x:132,y:14,r:179},{x:132,y:13,r:179},{x:132,y:13,r:178},{x:132,y:13,r:178},{x:131,y:12,r:177},{x:131,y:12,r:177},{x:132,y:11,r:176},{x:131,y:11,r:176},{x:132,y:11,r:176},{x:132,y:12,r:177},{x:132,y:12,r:178},{x:132,y:13,r:178},{x:132,y:14,r:179},{x:132,y:14,r:180},{x:132,y:14,r:179},{x:132,y:13,r:178},{x:132,y:12,r:178},{x:131,y:12,r:177},{x:131,y:11,r:176},{x:131,y:11,r:176},{x:131,y:11,r:176},{x:131,y:12,r:177},{x:131,y:12,r:177},{x:132,y:13,r:178},{x:131,y:13,r:178},{x:131,y:13,r:179},{x:131,y:14,r:179}],
[{x:137,y:21,r:-165},{x:137,y:21,r:-166},{x:137,y:21,r:-166},{x:137,y:20,r:-167},{x:137,y:20,r:-168},{x:137,y:20,r:-169},{x:137,y:20,r:-169},{x:137,y:20,r:-170},{x:137,y:20,r:-169},{x:137,y:20,r:-169},{x:137,y:20,r:-168},{x:137,y:20,r:-167},{x:137,y:21,r:-166},{x:137,y:21,r:-166}],
[{x:132,y:14,r:180},{x:117,y:8,r:163},{x:101,y:5,r:146},{x:85,y:6,r:128},{x:82,y:7,r:125},{x:79,y:9,r:121},{x:87,y:15,r:124},{x:96,y:22,r:127},{x:105,y:29,r:130},{x:114,y:37,r:134},{x:123,y:44,r:137},{x:125,y:49,r:139},{x:126,y:55,r:141},{x:128,y:60,r:144},{x:134,y:67,r:153},{x:139,y:76,r:163},{x:144,y:86,r:172},{x:145,y:89,r:175},{x:146,y:92,r:178},{x:146,y:95,r:-179}],
[{x:144,y:70,r:-131},{x:146,y:59,r:-150},{x:144,y:49,r:-168},{x:138,y:43,r:174},{x:131,y:41,r:155},{x:123,y:44,r:137},{x:125,y:49,r:139},{x:126,y:55,r:141},{x:128,y:60,r:144},{x:134,y:67,r:153},{x:139,y:76,r:163},{x:144,y:86,r:172},{x:145,y:89,r:175},{x:146,y:92,r:178},{x:146,y:95,r:-179}],
[{x:145,y:36,r:180},{x:145,y:36,r:180},{x:145,y:36,r:180},{x:145,y:36,r:180},{x:146,y:36,r:-179},{x:146,y:37,r:-179},{x:146,y:37,r:-179},{x:146,y:37,r:-179},{x:146,y:37,r:-178},{x:146,y:37,r:-178},{x:146,y:37,r:-179},{x:146,y:37,r:-179},{x:146,y:37,r:-179},{x:146,y:36,r:-179},{x:145,y:36,r:180},{x:145,y:36,r:180},{x:145,y:36,r:180},{x:146,y:36,r:-179},{x:146,y:37,r:-179},{x:146,y:37,r:-179},{x:146,y:37,r:-178},{x:146,y:37,r:-178},{x:146,y:37,r:-178},{x:146,y:37,r:-178},{x:146,y:37,r:-179},{x:146,y:37,r:-179},{x:146,y:36,r:-179},{x:145,y:36,r:180},{x:145,y:36,r:180}]
		];
		
		public static var wPosAlicornBoss:Array = [
[{x:146,y:21,r:180},{x:146,y:21,r:-179},{x:147,y:21,r:-178},{x:148,y:22,r:-178},{x:148,y:22,r:-177},{x:149,y:23,r:-176},{x:149,y:23,r:-176},{x:149,y:23,r:-176},{x:149,y:23,r:-176},{x:149,y:23,r:-176},{x:150,y:23,r:-177},{x:149,y:22,r:-177},{x:148,y:22,r:-178},{x:147,y:21,r:-179},{x:147,y:21,r:180},{x:146,y:20,r:179},{x:146,y:20,r:179},{x:146,y:21,r:179},{x:146,y:21,r:180},{x:146,y:21,r:180}],
[{x:152,y:29,r:-165},{x:152,y:28,r:-166},{x:152,y:28,r:-166},{x:152,y:28,r:-167},{x:152,y:27,r:-168},{x:152,y:27,r:-169},{x:152,y:27,r:-169},{x:152,y:27,r:-170},{x:152,y:27,r:-169},{x:152,y:27,r:-169},{x:152,y:27,r:-168},{x:152,y:28,r:-167},{x:152,y:28,r:-166},{x:152,y:28,r:-166}],
[{x:152,y:29,r:-165},{x:143,y:21,r:-176},{x:133,y:16,r:173},{x:124,y:12,r:164},{x:115,y:10,r:155},{x:107,y:9,r:148},{x:101,y:9,r:141},{x:95,y:9,r:135},{x:90,y:10,r:131},{x:86,y:10,r:127},{x:83,y:11,r:124},{x:82,y:11,r:123},{x:81,y:11,r:123},{x:80,y:11,r:122},{x:80,y:11,r:121},{x:79,y:11,r:120},{x:94,y:8,r:135},{x:109,y:8,r:150},{x:125,y:12,r:165},{x:139,y:19,r:180}]
		];
		/*wPos['raider3'] = wPos['raider2'];
		wPos['raider4'] = wPos['raider1'];
		wPos['raider5'] = wPos['raider2'];
		wPos['raider6'] = wPos['raider1'];
		wPos['raider7'] = wPos['raider2'];
		wPos['raider8'] = wPos['raider1'];
		wPos['raider9'] = wPos['raider2'];
		
		wPos['pip']=[
[{x:73,y:43,r:0},{x:75,y:47,r:0},{x:76,y:50,r:0},{x:78,y:54,r:0},{x:80,y:58,r:0},{x:81,y:61,r:0},{x:83,y:65,r:0},{x:84,y:69,r:0},{x:86,y:72,r:0},{x:84,y:69,r:0},{x:83,y:66,r:0},{x:82,y:63,r:0},{x:80,y:59,r:0},{x:79,y:55,r:0},{x:77,y:51,r:0},{x:75,y:47,r:0}],
[{x:71,y:43,r:1},{x:69,y:43,r:2},{x:67,y:42,r:2},{x:65,y:42,r:3},{x:62,y:42,r:4},{x:60,y:42,r:5},{x:58,y:41,r:6},{x:55,y:41,r:7},{x:75,y:43,r:0},{x:77,y:43,r:0},{x:79,y:42,r:0},{x:81,y:42,r:0},{x:83,y:42,r:0},{x:85,y:42,r:1},{x:87,y:41,r:1},{x:89,y:41,r:1},{x:84,y:72,r:0},{x:82,y:72,r:-1},{x:81,y:73,r:-1},{x:79,y:73,r:-1},{x:78,y:73,r:-1},{x:76,y:73,r:-2},{x:74,y:73,r:-2},{x:73,y:73,r:-2},{x:87,y:72,r:-1},{x:88,y:72,r:-3},{x:88,y:72,r:-4},{x:90,y:72,r:-5},{x:91,y:71,r:-6},{x:91,y:71,r:-8},{x:92,y:71,r:-9},{x:93,y:71,r:-10}],
[{x:74,y:44,r:2},{x:75,y:44,r:4},{x:76,y:42,r:4},{x:75,y:42,r:3},{x:76,y:43,r:3},{x:76,y:44,r:2},{x:76,y:46,r:3},{x:75,y:46,r:3},{x:76,y:46,r:4},{x:75,y:44,r:5},{x:75,y:42,r:4},{x:75,y:42,r:3},{x:75,y:43,r:3},{x:76,y:44,r:1},{x:75,y:46,r:3},{x:75,y:46,r:3},{x:75,y:46,r:3}],
[{x:74,y:38,r:2},{x:75,y:38,r:4},{x:76,y:36,r:4},{x:75,y:36,r:3},{x:76,y:36,r:3},{x:76,y:38,r:2},{x:76,y:40,r:3},{x:75,y:40,r:3},{x:76,y:40,r:4},{x:75,y:38,r:5},{x:75,y:36,r:4},{x:75,y:36,r:3},{x:75,y:36,r:3},{x:76,y:38,r:1},{x:75,y:40,r:3},{x:75,y:40,r:3},{x:75,y:40,r:3}],
[{x:78,y:44,r:0},{x:80,y:45,r:4},{x:80,y:44,r:4},{x:80,y:43,r:3},{x:80,y:44,r:3},{x:80,y:45,r:2},{x:80,y:47,r:3},{x:80,y:48,r:3},{x:80,y:47,r:4},{x:80,y:45,r:5},{x:80,y:44,r:4},{x:80,y:43,r:3},{x:80,y:44,r:3},{x:80,y:46,r:1},{x:80,y:47,r:3},{x:80,y:48,r:3},{x:80,y:47,r:3}],
[{x:80,y:46,r:4},{x:82,y:47,r:4},{x:85,y:48,r:4},{x:86,y:50,r:1},{x:84,y:50,r:1},{x:81,y:50,r:6},{x:79,y:49,r:6},{x:78,y:46,r:9}],
[{x:86,y:72,r:0},{x:85,y:73,r:0},{x:85,y:73,r:0},{x:84,y:73,r:0},{x:84,y:74,r:0},{x:85,y:74,r:0},{x:86,y:74,r:0},{x:87,y:73,r:0},{x:88,y:72,r:0},{x:88,y:72,r:0},{x:89,y:72,r:0},{x:88,y:72,r:0},{x:87,y:72,r:0},{x:86,y:72,r:0}],
[{x:65,y:36,r:-14},{x:66,y:36,r:-13},{x:66,y:36,r:-13},{x:67,y:36,r:-12},{x:67,y:36,r:-11},{x:67,y:36,r:-11},{x:68,y:36,r:-10},{x:68,y:37,r:-9},{x:69,y:37,r:-9},{x:69,y:37,r:-8},{x:70,y:37,r:-7},{x:70,y:37,r:-7},{x:70,y:37,r:-6},{x:71,y:37,r:-6},{x:71,y:37,r:-5},{x:72,y:37,r:-4},{x:72,y:38,r:-3},{x:72,y:38,r:-3},{x:72,y:39,r:-2},{x:73,y:39,r:-1},{x:73,y:39,r:0},{x:73,y:40,r:1},{x:74,y:40,r:2},{x:74,y:41,r:3},{x:75,y:42,r:4},{x:75,y:42,r:6},{x:75,y:43,r:7},{x:76,y:43,r:8},{x:76,y:44,r:9},{x:76,y:45,r:10},{x:77,y:45,r:12},{x:77,y:46,r:13}],
[{x:72,y:42,r:0},{x:71,y:41,r:1},{x:70,y:40,r:2},{x:70,y:39,r:2},{x:70,y:39,r:2},{x:71,y:39,r:2},{x:70,y:39,r:2},{x:70,y:39,r:2},{x:70,y:40,r:2},{x:71,y:41,r:1},{x:72,y:42,r:0}],
[{x:78,y:46,r:5},{x:82,y:48,r:11},{x:86,y:51,r:16},{x:90,y:53,r:22},{x:88,y:54,r:15},{x:86,y:55,r:11},{x:85,y:56,r:7},{x:82,y:53,r:6},{x:80,y:51,r:4},{x:78,y:48,r:3},{x:76,y:46,r:1}],
[{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4},{x:72,y:37,r:-4}],
[{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51},{x:57,y:44,r:-51}],
[{x:73,y:43,r:0},{x:71,y:41,r:-12},{x:68,y:39,r:-24},{x:65,y:37,r:-36},{x:62,y:35,r:-49},{x:66,y:40,r:-45},{x:70,y:46,r:-41},{x:75,y:51,r:-38},{x:79,y:57,r:-34},{x:83,y:63,r:-31},{x:87,y:68,r:-27},{x:91,y:74,r:-24},{x:91,y:74,r:-27},{x:91,y:74,r:-31},{x:93,y:76,r:-26},{x:95,y:79,r:-21},{x:97,y:82,r:-15},{x:99,y:84,r:-10},{x:101,y:87,r:-4},{x:103,y:89,r:1}]
		];*/
		
		
/*
[{x:78,y:53,r:0},{x:80,y:57,r:0},{x:81,y:60,r:0},{x:83,y:64,r:0},{x:85,y:68,r:0},{x:86,y:71,r:0},{x:88,y:75,r:0},{x:89,y:79,r:0},{x:91,y:82,r:0},{x:89,y:79,r:0},{x:88,y:76,r:0},{x:87,y:73,r:0},{x:85,y:69,r:0},{x:84,y:65,r:0},{x:82,y:61,r:0},{x:80,y:57,r:0}],
[{x:76,y:53,r:1},{x:74,y:53,r:2},{x:72,y:52,r:2},{x:70,y:52,r:3},{x:67,y:52,r:4},{x:65,y:52,r:5},{x:63,y:51,r:6},{x:60,y:51,r:7},{x:80,y:53,r:0},{x:82,y:53,r:0},{x:84,y:52,r:0},{x:86,y:52,r:0},{x:88,y:52,r:0},{x:90,y:52,r:1},{x:92,y:51,r:1},{x:94,y:51,r:1},{x:89,y:82,r:0},{x:87,y:82,r:-1},{x:86,y:83,r:-1},{x:84,y:83,r:-1},{x:83,y:83,r:-1},{x:81,y:83,r:-2},{x:79,y:83,r:-2},{x:78,y:83,r:-2},{x:92,y:82,r:-1},{x:93,y:82,r:-3},{x:93,y:82,r:-4},{x:95,y:82,r:-5},{x:96,y:81,r:-6},{x:96,y:81,r:-8},{x:97,y:81,r:-9},{x:98,y:81,r:-10}],
[{x:79,y:54,r:2},{x:80,y:54,r:4},{x:81,y:52,r:4},{x:80,y:52,r:3},{x:81,y:53,r:3},{x:81,y:54,r:2},{x:81,y:56,r:3},{x:80,y:56,r:3},{x:81,y:56,r:4},{x:80,y:54,r:5},{x:80,y:52,r:4},{x:80,y:52,r:3},{x:80,y:53,r:3},{x:81,y:54,r:1},{x:80,y:56,r:3},{x:80,y:56,r:3},{x:80,y:56,r:3}],
[{x:79,y:48,r:2},{x:80,y:48,r:4},{x:81,y:46,r:4},{x:80,y:46,r:3},{x:81,y:46,r:3},{x:81,y:48,r:2},{x:81,y:50,r:3},{x:80,y:50,r:3},{x:81,y:50,r:4},{x:80,y:48,r:5},{x:80,y:46,r:4},{x:80,y:46,r:3},{x:80,y:46,r:3},{x:81,y:48,r:1},{x:80,y:50,r:3},{x:80,y:50,r:3},{x:80,y:50,r:3}],
[{x:83,y:54,r:0},{x:85,y:55,r:4},{x:85,y:54,r:4},{x:85,y:53,r:3},{x:85,y:54,r:3},{x:85,y:55,r:2},{x:85,y:57,r:3},{x:85,y:58,r:3},{x:85,y:57,r:4},{x:85,y:55,r:5},{x:85,y:54,r:4},{x:85,y:53,r:3},{x:85,y:54,r:3},{x:85,y:56,r:1},{x:85,y:57,r:3},{x:85,y:58,r:3},{x:85,y:57,r:3}],
[{x:85,y:56,r:4},{x:87,y:57,r:4},{x:90,y:58,r:4},{x:91,y:60,r:1},{x:89,y:60,r:1},{x:86,y:60,r:6},{x:84,y:59,r:6},{x:83,y:56,r:9}],
[{x:91,y:82,r:0},{x:90,y:83,r:0},{x:90,y:83,r:0},{x:89,y:83,r:0},{x:89,y:84,r:0},{x:90,y:84,r:0},{x:91,y:84,r:0},{x:92,y:83,r:0},{x:93,y:82,r:0},{x:93,y:82,r:0},{x:94,y:82,r:0},{x:93,y:82,r:0},{x:92,y:82,r:0},{x:91,y:82,r:0}],
[{x:70,y:46,r:-14},{x:71,y:46,r:-13},{x:71,y:46,r:-13},{x:72,y:46,r:-12},{x:72,y:46,r:-11},{x:72,y:46,r:-11},{x:73,y:46,r:-10},{x:73,y:47,r:-9},{x:74,y:47,r:-9},{x:74,y:47,r:-8},{x:75,y:47,r:-7},{x:75,y:47,r:-7},{x:75,y:47,r:-6},{x:76,y:47,r:-6},{x:76,y:47,r:-5},{x:77,y:47,r:-4},{x:77,y:48,r:-3},{x:77,y:48,r:-3},{x:77,y:49,r:-2},{x:78,y:49,r:-1},{x:78,y:49,r:0},{x:78,y:50,r:1},{x:79,y:50,r:2},{x:79,y:51,r:3},{x:80,y:52,r:4},{x:80,y:52,r:6},{x:80,y:53,r:7},{x:81,y:53,r:8},{x:81,y:54,r:9},{x:81,y:55,r:10},{x:82,y:55,r:12},{x:82,y:56,r:13}],
[{x:77,y:52,r:0},{x:76,y:51,r:1},{x:75,y:50,r:2},{x:75,y:49,r:2},{x:75,y:49,r:2},{x:76,y:49,r:2},{x:75,y:49,r:2},{x:75,y:49,r:2},{x:75,y:50,r:2},{x:76,y:51,r:1},{x:77,y:52,r:0}],
[{x:83,y:56,r:5},{x:87,y:58,r:11},{x:91,y:61,r:16},{x:95,y:63,r:22},{x:93,y:64,r:15},{x:91,y:65,r:11},{x:90,y:66,r:7},{x:87,y:63,r:6},{x:85,y:61,r:4},{x:83,y:58,r:3},{x:81,y:56,r:1}],
[{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4},{x:77,y:47,r:-4}],
[{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51},{x:62,y:54,r:-51}],
[{x:78,y:53,r:0},{x:76,y:51,r:-12},{x:73,y:49,r:-24},{x:70,y:47,r:-36},{x:67,y:45,r:-49},{x:71,y:50,r:-45},{x:75,y:56,r:-41},{x:80,y:61,r:-38},{x:84,y:67,r:-34},{x:88,y:73,r:-31},{x:92,y:78,r:-27},{x:96,y:84,r:-24},{x:96,y:84,r:-27},{x:96,y:84,r:-31},{x:98,y:86,r:-26},{x:100,y:89,r:-21},{x:102,y:92,r:-15},{x:104,y:94,r:-10},{x:106,y:97,r:-4},{x:108,y:99,r:1}]
*/
		public static var wPosGriffon1:Array = [
[{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105},{x:104,y:105}],
[{x:105,y:105},{x:104,y:104},{x:104,y:103},{x:104,y:102},{x:104,y:101},{x:104,y:100},{x:104,y:99},{x:104,y:98},{x:104,y:99},{x:104,y:100},{x:104,y:101},{x:104,y:102},{x:104,y:103},{x:104,y:104}],
[{x:104,y:105},{x:105,y:103},{x:105,y:102},{x:106,y:101},{x:106,y:100},{x:106,y:100},{x:106,y:99},{x:107,y:99},{x:107,y:99},{x:107,y:102},{x:107,y:105},{x:107,y:109},{x:108,y:112},{x:108,y:115},{x:108,y:119},{x:107,y:119},{x:106,y:119},{x:105,y:119},{x:104,y:119},{x:103,y:119},{x:102,y:119},{x:102,y:119},{x:102,y:119},{x:101,y:119},{x:101,y:119}],
[{x:107,y:92},{x:107,y:96},{x:107,y:101},{x:107,y:105},{x:108,y:110},{x:108,y:114},{x:108,y:119},{x:107,y:119},{x:106,y:119},{x:105,y:119},{x:104,y:119},{x:103,y:119},{x:102,y:119},{x:102,y:119},{x:102,y:119},{x:101,y:119},{x:101,y:119}]
		];

		public static var wPosZebra1:Array = [
[{x:99,y:65,r:0},{x:113,y:100,r:0}],
[{x:99,y:67,r:2},{x:99,y:67,r:4},{x:100,y:65,r:4},{x:100,y:65,r:3},{x:100,y:65,r:3},{x:100,y:67,r:2},{x:100,y:69,r:3},{x:100,y:70,r:3},{x:100,y:70,r:4},{x:100,y:67,r:5},{x:100,y:65,r:4},{x:100,y:65,r:3},{x:100,y:65,r:3},{x:100,y:67,r:1},{x:100,y:69,r:3},{x:100,y:70,r:3},{x:100,y:69,r:3}],
[{x:105,y:70,r:4},{x:107,y:71,r:4},{x:111,y:73,r:4},{x:112,y:73,r:1},{x:110,y:74,r:1},{x:105,y:75,r:6},{x:103,y:74,r:6},{x:102,y:71,r:9}],
[{x:92,y:53,r:-14},{x:93,y:54,r:-12},{x:94,y:55,r:-11},{x:95,y:56,r:-9},{x:96,y:56,r:-7},{x:97,y:57,r:-6},{x:98,y:58,r:-4},{x:98,y:59,r:-3},{x:98,y:60,r:-2},{x:98,y:61,r:0},{x:99,y:63,r:2},{x:99,y:64,r:4},{x:99,y:66,r:6},{x:100,y:68,r:8},{x:100,y:69,r:11},{x:100,y:71,r:13}],
[{x:99,y:65,r:0},{x:98,y:60,r:-12},{x:96,y:54,r:-24},{x:94,y:48,r:-36},{x:91,y:42,r:-49},{x:94,y:50,r:-45},{x:97,y:57,r:-41},{x:99,y:65,r:-38},{x:102,y:73,r:-34},{x:104,y:81,r:-31},{x:107,y:89,r:-27},{x:109,y:97,r:-24},{x:109,y:95,r:-27},{x:110,y:94,r:-31},{x:112,y:99,r:-26},{x:113,y:103,r:-21},{x:115,y:108,r:-15},{x:116,y:112,r:-10},{x:117,y:117,r:-4},{x:118,y:121,r:1}],
[{x:88,y:88,r:35},{x:94,y:91,r:20},{x:100,y:94,r:6},{x:104,y:96,r:-9},{x:109,y:97,r:-24},{x:109,y:95,r:-27},{x:110,y:94,r:-31},{x:112,y:99,r:-26},{x:113,y:103,r:-21},{x:115,y:108,r:-15},{x:116,y:112,r:-10},{x:117,y:117,r:-4},{x:118,y:121,r:1}],
[{x:101,y:52,r:-26},{x:101,y:52,r:-28},{x:101,y:51,r:-30},{x:101,y:50,r:-32},{x:100,y:50,r:-34},{x:101,y:50,r:-32},{x:101,y:51,r:-30},{x:101,y:52,r:-28}],
[{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4},{x:98,y:58,r:-4}],
[{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51},{x:86,y:39,r:-51}],
[{x:99,y:67,r:2},{x:99,y:67,r:2},{x:99,y:67,r:2},{x:100,y:66,r:2},{x:100,y:66,r:2},{x:101,y:66,r:1},{x:101,y:65,r:-1},{x:100,y:66,r:0},{x:100,y:66,r:0},{x:99,y:66,r:1},{x:99,y:67,r:2},{x:99,y:67,r:2},{x:99,y:67,r:2},{x:99,y:67,r:2},{x:100,y:66,r:1},{x:100,y:66,r:1},{x:100,y:66,r:0},{x:100,y:65,r:0},{x:100,y:66,r:0},{x:100,y:66,r:1},{x:100,y:66,r:1},{x:100,y:67,r:1},{x:100,y:67,r:2},{x:99,y:67,r:2}]
		];
		public static var wPosRanger1:Array = [
[{x:107,y:70,r:0},{x:123,y:108,r:0}],
[{x:107,y:72,r:2},{x:108,y:71,r:2},{x:108,y:71,r:2},{x:108,y:71,r:2},{x:108,y:71,r:2},{x:109,y:70,r:1},{x:110,y:70,r:-1},{x:109,y:70,r:0},{x:109,y:70,r:0},{x:108,y:71,r:1},{x:107,y:71,r:2},{x:107,y:72,r:2},{x:107,y:72,r:2},{x:108,y:71,r:2},{x:108,y:71,r:1},{x:108,y:70,r:1},{x:109,y:70,r:0},{x:109,y:70,r:0},{x:109,y:70,r:0},{x:109,y:71,r:1},{x:108,y:71,r:1},{x:108,y:71,r:1},{x:108,y:72,r:2},{x:108,y:72,r:2}],
[{x:107,y:72,r:2},{x:108,y:72,r:4},{x:108,y:70,r:4},{x:108,y:69,r:3},{x:109,y:70,r:3},{x:109,y:72,r:2},{x:109,y:74,r:3},{x:108,y:75,r:3},{x:108,y:75,r:4},{x:108,y:72,r:5},{x:108,y:70,r:4},{x:108,y:69,r:3},{x:108,y:70,r:3},{x:109,y:72,r:1},{x:108,y:74,r:3},{x:108,y:75,r:3},{x:108,y:74,r:3}],
[{x:114,y:75,r:4},{x:116,y:76,r:4},{x:120,y:78,r:4},{x:122,y:79,r:1},{x:120,y:80,r:1},{x:114,y:80,r:6},{x:112,y:79,r:6},{x:110,y:76,r:9}],
[{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51},{x:93,y:41,r:-51}],
[{x:100,y:57,r:-14},{x:101,y:58,r:-12},{x:102,y:58,r:-11},{x:103,y:59,r:-9},{x:104,y:60,r:-7},{x:105,y:61,r:-6},{x:106,y:62,r:-4},{x:106,y:63,r:-3},{x:107,y:64,r:-2},{x:107,y:65,r:0},{x:107,y:67,r:2},{x:107,y:69,r:4},{x:108,y:71,r:6},{x:108,y:72,r:8},{x:108,y:74,r:11},{x:109,y:76,r:13}],
[{x:107,y:70,r:0},{x:106,y:64,r:-12},{x:104,y:58,r:-24},{x:102,y:51,r:-36},{x:99,y:44,r:-49},{x:101,y:52,r:-45},{x:104,y:60,r:-41},{x:106,y:68,r:-38},{x:108,y:76,r:-34},{x:110,y:84,r:-31},{x:112,y:91,r:-27},{x:114,y:99,r:-24},{x:114,y:97,r:-27},{x:114,y:95,r:-31},{x:117,y:102,r:-23},{x:119,y:108,r:-16},{x:120,y:114,r:-8},{x:122,y:120,r:0},{x:123,y:125,r:8},{x:124,y:130,r:16}],
[{x:94,y:89,r:35},{x:101,y:93,r:20},{x:106,y:96,r:6},{x:111,y:98,r:-9},{x:115,y:99,r:-24},{x:115,y:97,r:-27},{x:114,y:96,r:-31},{x:117,y:102,r:-23},{x:119,y:108,r:-16},{x:121,y:114,r:-8},{x:122,y:120,r:0},{x:123,y:125,r:8},{x:124,y:130,r:16}]
		];
		public static var wPosEncl1:Array = [
[{x:102,y:60,r:0},{x:118,y:98,r:0}],
[{x:102,y:62,r:2},{x:103,y:62,r:4},{x:103,y:60,r:4},{x:103,y:59,r:3},{x:104,y:60,r:3},{x:104,y:62,r:2},{x:104,y:64,r:3},{x:103,y:65,r:3},{x:103,y:65,r:4},{x:103,y:62,r:5},{x:103,y:60,r:4},{x:103,y:59,r:3},{x:103,y:60,r:3},{x:104,y:62,r:1},{x:103,y:64,r:3},{x:103,y:65,r:3},{x:103,y:64,r:3}],
[{x:102,y:62,r:2},{x:103,y:61,r:2},{x:103,y:61,r:2},{x:103,y:61,r:2},{x:103,y:61,r:2},{x:104,y:60,r:1},{x:105,y:60,r:-1},{x:104,y:60,r:0},{x:104,y:60,r:0},{x:103,y:61,r:1},{x:102,y:61,r:2},{x:102,y:62,r:2},{x:102,y:62,r:2},{x:103,y:61,r:2},{x:103,y:61,r:1},{x:103,y:60,r:1},{x:104,y:60,r:0},{x:104,y:60,r:0},{x:104,y:60,r:0},{x:104,y:61,r:1},{x:103,y:61,r:1},{x:103,y:61,r:1},{x:103,y:62,r:2},{x:103,y:62,r:2}],
[{x:103,y:61,r:-3},{x:103,y:60,r:-3},{x:102,y:60,r:-2},{x:102,y:59,r:-1},{x:102,y:59,r:0},{x:102,y:59,r:-1},{x:102,y:60,r:-2},{x:102,y:60,r:-3}],
[{x:102,y:60,r:0},{x:101,y:54,r:-12},{x:99,y:48,r:-24},{x:97,y:41,r:-36},{x:94,y:34,r:-49},{x:96,y:42,r:-45},{x:99,y:50,r:-41},{x:101,y:58,r:-38},{x:103,y:66,r:-34},{x:105,y:74,r:-31},{x:107,y:81,r:-27},{x:109,y:89,r:-24},{x:109,y:87,r:-27},{x:109,y:85,r:-31},{x:112,y:92,r:-23},{x:114,y:98,r:-16},{x:115,y:104,r:-8},{x:117,y:110,r:0},{x:118,y:115,r:8},{x:119,y:120,r:16}],
[{x:89,y:79,r:35},{x:96,y:83,r:20},{x:101,y:86,r:6},{x:106,y:88,r:-9},{x:110,y:89,r:-24},{x:110,y:87,r:-27},{x:109,y:86,r:-31},{x:112,y:92,r:-23},{x:114,y:98,r:-16},{x:116,y:104,r:-8},{x:117,y:110,r:0},{x:118,y:115,r:8},{x:119,y:120,r:16}]
		];


		public var id:int=0;		//номер строки в спрайт-листе
		public var firstf:int=0;	//стартовый кадр
		public var maxf:int=1;		//длительность анимации
		public var retf:int=0;		//кадр, на который возвращается анимация
		public var replay:Boolean=false;	//автоматически повторять
		public var st:Boolean=false;
		public var stab:Boolean=false;
		public var f:Number=0;		//текущий кадр
		public var df:Number=1;		//кадров за такт

		
		//строка спрайт-листа, кол-во кадров, начальный кадр, цикличность, задавать кадр, кадров за такт
		/*public function BlitAnim(nid:int, nmaxf:int, nretf:int=0, rep:Boolean=false, nstab:Boolean=false,ndf:Number=1) {
			id=nid, maxf=nmaxf, retf=nretf, replay=rep, stab=nstab, df=ndf;
		}*/
		
		public function BlitAnim(xml:XML) {
			if (xml.@y.length()) id=xml.@y;
			if (xml.@len.length()) maxf=xml.@len;
			if (xml.@ff.length()) firstf=xml.@ff;
			if (xml.@rf.length()) retf=xml.@rf;
			if (xml.@df.length()) df=xml.@df;
			if (xml.@rep.length()) replay=true ;
			if (xml.@stab.length()) stab=true ;
			f=firstf;
		}
		
		public function step() {
			if (stab) return;
			if (f<firstf+maxf-1) f+=df;
			else if (replay) f=retf;
			else st=true;
		}
		
		public function restart() {
			st=false;
			f=firstf;
		}
		
		public function setStab(n:Number) {
			if (n<0) n=0;
			if (n>0.999) n=0.999;
			f=maxf*n;
		}

	}
	
}
