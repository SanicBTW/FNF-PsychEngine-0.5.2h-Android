import flixel.FlxG;

class Ratings
{
    public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
    {
        var ranking:String = "N/A";
		if(PlayState.instance.cpuControlled)
			ranking = "BotPlay";

        if (PlayState.instance.songMisses == 0 && PlayState.instance.bads == 0 && PlayState.instance.shits == 0 && PlayState.instance.goods == 0) // Marvelous (SICK) Full Combo
            ranking = "(MFC)";
        else if (PlayState.instance.songMisses == 0 && PlayState.instance.bads == 0 && PlayState.instance.shits == 0 && PlayState.instance.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
            ranking = "(GFC)";
        else if (PlayState.instance.songMisses == 0) // Regular FC
            ranking = "(FC)";
        else if (PlayState.instance.songMisses < 10) // Single Digit Combo Breaks
            ranking = "(SDCB)";
        else
            ranking = "(Clear)";

        // WIFE TIME :)))) (based on Wife3)

        var wifeConditions:Array<Bool> = [
            accuracy >= 99.9935, // AAAAA
            accuracy >= 99.980, // AAAA:
            accuracy >= 99.970, // AAAA.
            accuracy >= 99.955, // AAAA
            accuracy >= 99.90, // AAA:
            accuracy >= 99.80, // AAA.
            accuracy >= 99.70, // AAA
            accuracy >= 99, // AA:
            accuracy >= 96.50, // AA.
            accuracy >= 93, // AA
            accuracy >= 90, // A:
            accuracy >= 85, // A.
            accuracy >= 80, // A
            accuracy >= 70, // B
            accuracy >= 60, // C
            accuracy < 60 // D
        ];

        for(i in 0...wifeConditions.length)
        {
            var b = wifeConditions[i];
            if (b)
            {
                switch(i)
                {
                    case 0:
                        ranking += " AAAAA";
                    case 1:
                        ranking += " AAAA:";
                    case 2:
                        ranking += " AAAA.";
                    case 3:
                        ranking += " AAAA";
                    case 4:
                        ranking += " AAA:";
                    case 5:
                        ranking += " AAA.";
                    case 6:
                        ranking += " AAA";
                    case 7:
                        ranking += " AA:";
                    case 8:
                        ranking += " AA.";
                    case 9:
                        ranking += " AA";
                    case 10:
                        ranking += " A:";
                    case 11:
                        ranking += " A.";
                    case 12:
                        ranking += " A";
                    case 13:
                        ranking += " B";
                    case 14:
                        ranking += " C";
                    case 15:
                        ranking += " D";
                }
                break;
            }
        }

        if (accuracy == 0)
            ranking = "N/A";
		else if(PlayState.instance.cpuControlled)
			ranking = "BotPlay";

        return ranking;
    }
    
    public static function CalculateRating(noteDiff:Float, ?customSafeZone:Float):String // Generate a judgement through some timing shit
    {

        var customTimeScale = Conductor.timeScale;

        if (customSafeZone != null)
            customTimeScale = customSafeZone / 166;

        // trace(customTimeScale + ' vs ' + Conductor.timeScale);

        // I HATE THIS IF CONDITION
        // IF LEMON SEES THIS I'M SORRY :(

        // trace('Hit Info\nDifference: ' + noteDiff + '\nZone: ' + Conductor.safeZoneOffset * 1.5 + "\nTS: " + customTimeScale + "\nLate: " + 155 * customTimeScale);

        if (PlayState.instance.cpuControlled)
            return "sick"; // FUNNY
	

        var rating = checkRating(noteDiff,customTimeScale);


        return rating;
    }

    public static function checkRating(ms:Float, ts:Float)
    {
        var rating = "miss";
        if (ms < 166 * ts && ms > 135 * ts)
            rating = "shit";
        if (ms > -166 * ts && ms < -135 * ts)
            rating = "shit";
        if (ms < 135 * ts && ms > 90 * ts) 
            rating = "bad";
        if (ms > -135 * ts && ms < -90 * ts)
            rating = "bad";
        if (ms < 90 * ts && ms > 45 * ts)
            rating = "good";
        if (ms > -90 * ts && ms < -45 * ts)
            rating = "good";
        if (ms < 45 * ts && ms > -45 * ts)
            rating = "sick";
        return rating;
    }

    public static function CalculateRanking(score:Int,scoreDef:Int,accuracy:Float):String
    {
        return
         (!PlayState.instance.cpuControlled ? "Score:" + (ClientPrefs.safeFrames != 10 ? score + " (" + scoreDef + ")" : "" + score) + 		// Score
         " | Combo Breaks:" + PlayState.instance.songMisses + 																				// 	Misses/Combo Breaks
         " | Accuracy:" + (PlayState.instance.cpuControlled ? "N/A" : HelperFunctions.truncateFloat(accuracy, 2) + " %") +  				// 	Accuracy
         " | " + GenerateLetterRank(accuracy) : ""); 																		// 	Letter Rank
    }
}