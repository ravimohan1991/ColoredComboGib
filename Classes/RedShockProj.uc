//================================================================================
// RedShockProj.
//================================================================================

class RedShockProj extends ShockProj;

function SuperExplosion ()
{
  HurtRadius(Damage * 3,250.0,MyDamageType,MomentumTransfer * 2,Location);
  Spawn(Class'RedUT_ComboRing',,'None',Location,Instigator.ViewRotation);
  PlaySound(ExploSound,,20.0,,2000.0,0.62);
  Destroy();
}

function Explode (Vector HitLocation, Vector HitNormal)
{
  PlaySound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());
  HurtRadius(Damage,70.0,MyDamageType,MomentumTransfer,Location);
  if ( Damage > 60 )
  {
    Spawn(Class'Red_ringexplosion3',,,HitLocation + HitNormal * 8,rotator(HitNormal));
  } else {
    Spawn(Class'Red_RingExplosion',,,HitLocation + HitNormal * 8,rotator(Velocity));
  }
  Destroy();
}

defaultproperties
{
    Texture=Texture'RedASMDAlt_a00'
    LightHue=0
    Damage=1000
    MyDamageType=ShockBall
}

