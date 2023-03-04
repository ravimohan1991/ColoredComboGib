class abcShockRifle extends ShockRifle;

var class<SuperShockBeam> RedBeamClass;
var class<SuperShockBeam> BlueBeamClass;
var class<Projectile> RedProjectileClass;

simulated function PostBeginPlay()
{
	RedBeamClass = class<SuperShockBeam>(DynamicLoadObject("ColoredComboGib.SuperShockBeam_Red", class'Class'));
	BlueBeamClass = class<SuperShockBeam>(DynamicLoadObject("ColoredComboGib.SuperShockBeam_Blue", class'Class'));

	RedProjectileClass = class<Projectile>(DynamicLoadObject("ColoredComboGib.RedShockProj", class'Class'));

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

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local PlayerPawn PlayerOwner;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);

	PlayerOwner = PlayerPawn(Owner);
	if ( PlayerOwner != None )
		PlayerOwner.ClientInstantFlash( -0.4, vect(450, 190, 650));

    // If team == 0 spawn red projectile
    Tracked = Spawn(RedProjectileClass, , , Start, AdjustedAim);

	if ( Level.Game.IsA('DeathMatchPlus') && DeathmatchPlus(Level.Game).bNoviceMode )
		Tracked = None; //no combo move
	return Tracked;
}

