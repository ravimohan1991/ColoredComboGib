//================================================================================
// Red_RingExplosion2.
//================================================================================

class Red_RingExplosion2 extends Red_RingExplosion;

simulated function PreBeginPlay ()
{
  bExtraEffectsSpawned = False;
}

simulated function SpawnExtraEffects ()
{
  local Actor A;

  bExtraEffectsSpawned = True;
  A = Spawn(Class'RedExplo');
  A.RemoteRole = ROLE_None;
  Spawn(Class'EnergyImpact');
  if ( Level.bHighDetailMode &&  !Level.bDropDetail )
  {
    A = Spawn(Class'Red_RingExplosion');
    A.RemoteRole = ROLE_None;
  }
}

defaultproperties
{
    Skin=Texture'redring'
}
