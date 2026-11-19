import Lean

/-!
A planar reduction of swimmer.js (phase accumulator, wave slope, bend,
fixed-length chain, child frames). Algebra is generic over exact commutative
rings. The renderer supplies real trigonometry and a clipped inverse sine.
Angles are radians; wave phase and wavenumber are in cycles.
-/
namespace SharkSpine

open Lean.Grind

variable {R : Type} [CommRing R]

structure Point (R : Type) where
  x : R
  y : R

def plus (p q : Point R) : Point R :=
  ⟨p.x + q.x, p.y + q.y⟩

def minus (p q : Point R) : Point R :=
  ⟨p.x - q.x, p.y - q.y⟩

def scale (s : R) (p : Point R) : Point R :=
  ⟨s * p.x, s * p.y⟩

def squared (p : Point R) : R :=
  p.x * p.x + p.y * p.y

structure Trig (R : Type) [CommRing R] where
  sin : R → R
  cos : R → R
  unit : ∀ a, cos a * cos a + sin a * sin a = 1

def tangent (trig : Trig R) (a : R) : Point R :=
  ⟨trig.cos a, trig.sin a⟩

/-- Transform a segment-local vertex with tangent and its 90° normal. -/
def attach (trig : Trig R) (origin : Point R) (a : R) (v : Point R) : Point R :=
  ⟨origin.x + v.x * trig.cos a - v.y * trig.sin a,
   origin.y + v.x * trig.sin a + v.y * trig.cos a⟩

theorem attachment_preserves_distance (trig : Trig R) (origin v w : Point R) (a : R) :
    squared (minus (attach trig origin a v) (attach trig origin a w)) =
      squared (minus v w) := by
  have unit := trig.unit a
  simp only [squared, minus, attach]
  grind

theorem attachment_origin (trig : Trig R) (origin : Point R) (a : R) :
    attach trig origin a ⟨0, 0⟩ = origin := by
  cases origin
  simp only [attach, Point.mk.injEq]
  constructor <;> grind

theorem shared_body_fin_root (trig : Trig R) (origin : Point R) (a : R)
    (mount : Point R) :
    attach trig (attach trig origin a mount) a ⟨0, 0⟩ =
      attach trig origin a mount :=
  attachment_origin trig (attach trig origin a mount) a

structure WaveOps (R : Type) [CommRing R] where
  trig : Trig R
  tau : R
  /-- asin(clamp(slope, -0.95, 0.95)), with the length division included. -/
  yawFromRise : R → R → R
  zeroRise : ∀ length, yawFromRise length 0 = 0

structure Rig (R : Type) where
  length : Nat → R
  arc : Nat → R
  envelope : Nat → R
  weight : Nat → R
  waveNumber : R
  half : R

structure Swim (R : Type) where
  phase : R
  amplitude : R
  bend : R

def carrier (phase waveNumber u : R) : R :=
  phase - waveNumber * u

/-- Constant carrier phase propagates toward larger arc coordinates. -/
theorem carrier_travels (phase waveNumber u du : R) :
    carrier (phase + waveNumber * du) waveNumber (u + du) =
      carrier phase waveNumber u := by
  unfold carrier
  grind

def wave (ops : WaveOps R) (rig : Rig R) (swim : Swim R) (j : Nat) : R :=
  swim.amplitude * rig.envelope j *
    ops.trig.sin (ops.tau * carrier swim.phase rig.waveNumber (rig.arc j))

def waveYaw (ops : WaveOps R) (rig : Rig R) (swim : Swim R) (i : Nat) : R :=
  ops.yawFromRise (rig.length i) (wave ops rig swim (i + 1) - wave ops rig swim i)

def bendPrefix (rig : Rig R) : Nat → R
  | 0 => 0
  | i + 1 => bendPrefix rig i + rig.weight i

def midpointWeight (rig : Rig R) (i : Nat) : R :=
  bendPrefix rig i + rig.half * rig.weight i

def signedYaw (ops : WaveOps R) (rig : Rig R) (swim : Swim R) (i : Nat) : R :=
  waveYaw ops rig swim i + swim.bend * midpointWeight rig i

/-- Positive local yaw moves the tail toward the forward vector's positive normal. -/
def angle (ops : WaveOps R) (rig : Rig R) (swim : Swim R) (tailHeading : R) (i : Nat) : R :=
  tailHeading - signedYaw ops rig swim i

def joint (ops : WaveOps R) (rig : Rig R) (swim : Swim R) (origin : Point R)
    (tailHeading : R) : Nat → Point R
  | 0 => origin
  | i + 1 =>
    plus (joint ops rig swim origin tailHeading i)
      (scale (rig.length i) (tangent ops.trig (angle ops rig swim tailHeading i)))

theorem link_length (ops : WaveOps R) (rig : Rig R) (swim : Swim R)
    (origin : Point R) (heading : R) (i : Nat) :
    squared (minus (joint ops rig swim origin heading (i + 1))
      (joint ops rig swim origin heading i)) = rig.length i * rig.length i := by
  have unit := ops.trig.unit (angle ops rig swim heading i)
  simp only [joint, squared, minus, plus, scale, tangent]
  grind

theorem segment_endpoint (ops : WaveOps R) (rig : Rig R) (swim : Swim R)
    (origin : Point R) (heading : R) (i : Nat) :
    attach ops.trig (joint ops rig swim origin heading i)
      (angle ops rig swim heading i) ⟨rig.length i, 0⟩ =
      joint ops rig swim origin heading (i + 1) := by
  simp only [joint, plus, scale, tangent, attach, Point.mk.injEq]
  constructor <;> grind

/-- A rigid caudal fin is mounted at the last segment's far endpoint. -/
def caudalVertex (ops : WaveOps R) (rig : Rig R) (swim : Swim R)
    (origin : Point R) (heading : R) (last : Nat) (v : Point R) : Point R :=
  attach ops.trig (joint ops rig swim origin heading (last + 1))
    (angle ops rig swim heading last) v

theorem caudal_root (ops : WaveOps R) (rig : Rig R) (swim : Swim R)
    (origin : Point R) (heading : R) (last : Nat) :
    caudalVertex ops rig swim origin heading last ⟨0, 0⟩ =
      attach ops.trig (joint ops rig swim origin heading last)
        (angle ops rig swim heading last) ⟨rig.length last, 0⟩ := by
  rw [segment_endpoint, caudalVertex, attachment_origin]

/-- With zero envelope and bend weights through the front, each front joint
    depends only on the origin, tailward heading and bind lengths. -/
theorem steady_front (ops : WaveOps R) (rig : Rig R) (swim other : Swim R)
    (origin : Point R) (heading : R) (count : Nat)
    (envZero : ∀ j, j ≤ count → rig.envelope j = 0)
    (flexZero : ∀ i, i < count → rig.weight i = 0) :
    joint ops rig swim origin heading count = joint ops rig other origin heading count := by
  induction count with
  | zero => rfl
  | succ n ih =>
    have prev := ih
      (fun j h => envZero j (by omega))
      (fun i h => flexZero i (by omega))
    have bendPrefixZero (i : Nat) (hi : i ≤ n) : bendPrefix rig i = 0 := by
      induction i with
      | zero => rfl
      | succ j step =>
        rw [bendPrefix, step (by omega), flexZero j (by omega)]
        grind
    have noBend : midpointWeight rig n = 0 := by
      unfold midpointWeight
      rw [bendPrefixZero n (by omega), flexZero n (by omega)]
      grind
    have yawZero (state : Swim R) : waveYaw ops rig state n = 0 := by
      unfold waveYaw wave
      rw [envZero n (by omega), envZero (n + 1) (by omega)]
      simp only [Semiring.mul_zero, Semiring.zero_mul, AddCommGroup.sub_self, ops.zeroRise]
    have straight (state : Swim R) : angle ops rig state heading n = heading := by
      unfold angle signedYaw
      rw [yawZero state, noBend]
      grind
    simp only [joint, prev, straight]

/-- Turn-induced change in adjacent local yaw is signed bend times the
    mean of the two adjacent nonnegative weights. -/
theorem adjacent_signed_bend (ops : WaveOps R) (rig : Rig R) (swim : Swim R)
    (half : rig.half + rig.half = 1) (i : Nat) :
    (signedYaw ops rig swim (i + 1) - signedYaw ops rig swim i) -
      (waveYaw ops rig swim (i + 1) - waveYaw ops rig swim i) =
        swim.bend * rig.half * (rig.weight i + rig.weight (i + 1)) := by
  simp only [signedYaw, midpointWeight, bendPrefix]
  grind

theorem positive_bend_turns_positive
    [LE R] [LT R] [Std.IsPreorder R] [OrderedRing R]
    (ops : WaveOps R) (rig : Rig R) (swim : Swim R)
    (half : rig.half + rig.half = 1) (i : Nat)
    (hb : 0 < swim.bend)
    (hw : 0 < rig.half * (rig.weight i + rig.weight (i + 1))) :
    0 < (signedYaw ops rig swim (i + 1) - signedYaw ops rig swim i) -
      (waveYaw ops rig swim (i + 1) - waveYaw ops rig swim i) := by
  rw [adjacent_signed_bend ops rig swim half i]
  have assoc : swim.bend * rig.half * (rig.weight i + rig.weight (i + 1)) =
      swim.bend * (rig.half * (rig.weight i + rig.weight (i + 1))) := by grind
  rw [assoc]
  exact OrderedRing.mul_pos hb hw

theorem turning_component_reverses (ops : WaveOps R) (rig : Rig R)
    (swim : Swim R) (i : Nat) :
    signedYaw ops rig { swim with bend := -swim.bend } i - waveYaw ops rig swim i =
      -(signedYaw ops rig swim i - waveYaw ops rig swim i) := by
  simp only [signedYaw, waveYaw, wave]
  grind

/-- A control interval starts from the previous pose and sets rates only. -/
def advance (start rates : Swim R) (elapsed : R) : Swim R :=
  ⟨start.phase + rates.phase * elapsed,
   start.amplitude + rates.amplitude * elapsed,
   start.bend + rates.bend * elapsed⟩

theorem phase_increment (start rates : Swim R) (elapsed : R) :
    (advance start rates elapsed).phase - start.phase = rates.phase * elapsed := by
  unfold advance
  grind

theorem dash_seam_state (start beforeRates afterRates : Swim R) (elapsed : R) :
    advance (advance start beforeRates elapsed) afterRates 0 =
      advance start beforeRates elapsed := by
  cases start
  cases beforeRates
  cases afterRates
  simp only [advance, Swim.mk.injEq]
  grind

theorem dash_seam_joint (ops : WaveOps R) (rig : Rig R)
    (origin : Point R) (heading : R) (start beforeRates afterRates : Swim R)
    (elapsed : R) (i : Nat) :
    joint ops rig (advance (advance start beforeRates elapsed) afterRates 0) origin heading i =
      joint ops rig (advance start beforeRates elapsed) origin heading i := by
  rw [dash_seam_state]

theorem dash_seam_attachment (ops : WaveOps R) (rig : Rig R)
    (origin vertex : Point R) (heading : R) (start beforeRates afterRates : Swim R)
    (elapsed : R) (i : Nat) :
    let before := advance start beforeRates elapsed
    let after := advance before afterRates 0
    attach ops.trig (joint ops rig after origin heading i) (angle ops rig after heading i) vertex =
      attach ops.trig (joint ops rig before origin heading i) (angle ops rig before heading i) vertex := by
  dsimp only
  rw [dash_seam_state]

theorem dash_seam_caudal (ops : WaveOps R) (rig : Rig R)
    (origin vertex : Point R) (heading : R) (start beforeRates afterRates : Swim R)
    (elapsed : R) (last : Nat) :
    let before := advance start beforeRates elapsed
    let after := advance before afterRates 0
    caudalVertex ops rig after origin heading last vertex =
      caudalVertex ops rig before origin heading last vertex := by
  dsimp only
  rw [dash_seam_state]

end SharkSpine
