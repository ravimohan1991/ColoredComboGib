class cbg extends abcShockRifle;

var float LastBallTime;
var config bool bReduceBall;
var config float MinSecBetweenBalls;

function AltFire( float Value )
{
	if ( Owner == None )
		return;

	if ( !bReduceBall || ((Level.TimeSeconds - LastBallTime) > MinSecBetweenBalls) )
	{
	    Super.AltFire(Value);
	    LastBallTime=Level.TimeSeconds;
	}
}

simulated function bool ClientAltFire(float Value)
{
	if( !bReduceBall || (Level.TimeSeconds - LastBallTime) > MinSecBetweenBalls )
	{
	    LastBallTime=Level.TimeSeconds;
	    return Super.ClientAltFire(Value);				//not great that we set last ball time before knowing if the firing actually happens but ok for now.
	}
	else
	{
		return False;
	}
}

state ComboMove
{
	function Fire(float F)
	{
    }

	function AltFire(float F);

	function Tick(float DeltaTime)
	{
		if ( (Owner == None) || (Pawn(Owner).Enemy == None) )
		{
			Tracked = None;
			bBotSpecialMove = false;
			Finish();
			return;
		}
		if ( (Tracked == None) || Tracked.bDeleteMe
			|| (((Tracked.Location - Owner.Location)
				dot (Tracked.Location - Pawn(Owner).Enemy.Location)) >= 0)
			|| (VSize(Tracked.Location - Pawn(Owner).Enemy.Location) < 100) )
			Global.Fire(0);
	}

Begin:
	Sleep(7.0);
	Tracked = None;
	bBotSpecialMove = false;
	Global.Fire(0);
}

defaultproperties
{
     ItemName="ComboGib"
     MyDamageType=jolted
     hitdamage=1000
     PickupAmmoCount=50
     DeathMessage="%k electrified %o with the %w."
     PickupMessage="You got the Combogib."
     AmmoName=Class'cbgcore'
     AltProjectileClass=Class'cbgproj'
     bReduceBall=True
     MinSecBetweenBalls=0.7
}
