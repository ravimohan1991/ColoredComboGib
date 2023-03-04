class abcShockRifle extends ShockRifle;

var class<SuperShockBeam> RedBeamClass;
var class<SuperShockBeam> BlueBeamClass;

simulated function PostBeginPlay()
{
	RedBeamClass = class<SuperShockBeam>(DynamicLoadObject("ColoredComboGib.SuperShockBeam_Red", class'Class'));
	BlueBeamClass = class<SuperShockBeam>(DynamicLoadObject("ColoredComboGib.SuperShockBeam_Blue", class'Class'));

    super.PostBeginPlay();
}

function SpawnEffect(vector HitLocation, vector SmokeLocation)
{
	local SuperShockBeam Smoke;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;

	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector)/135.0;
	if ( NumPoints < 1 )
		return;
	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);

    if(Pawn(Owner).PlayerReplicationInfo.Team == 0)
    {
		Smoke = Spawn(RedBeamClass,,,SmokeLocation,SmokeRotation);
	}
	else
	{
    	Smoke = Spawn(BlueBeamClass,,,SmokeLocation,SmokeRotation);
    }

    Smoke.MoveAmount = DVector/NumPoints;
	Smoke.NumPuffs = NumPoints - 1;
}
