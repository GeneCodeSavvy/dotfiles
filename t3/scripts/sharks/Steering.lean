import Lean

/-!
Discrete steering and affine playback contract, using exact rationals. The
candidate generator (wander, boundary and peer forecasts) is outside the
safety argument. A bake publishes only certified transitions, including the
loop seam. Speed increments and unwrapped heading increments are per tick.
-/
namespace SharkSteering

structure Point where
  x : Rat
  y : Rat

def clamp (lo hi value : Rat) : Rat := max lo (min hi value)

theorem clamp_bounds {lo hi value : Rat} (h : lo ≤ hi) :
    lo ≤ clamp lo hi value ∧ clamp lo hi value ≤ hi := by
  unfold clamp
  grind

def speedStep (speed wanted top accel brake : Rat) : Rat :=
  clamp 0 top (speed + clamp (-brake) accel (wanted - speed))

def turnStep (heading signedError turn : Rat) : Rat :=
  heading + clamp (-turn) turn signedError

theorem speedStep_caps {speed wanted top accel brake : Rat}
    (h0 : 0 ≤ speed) (hS : speed ≤ top) (hA : 0 ≤ accel) (hB : 0 ≤ brake) :
    let next := speedStep speed wanted top accel brake
    0 ≤ next ∧ next ≤ top ∧ -brake ≤ next - speed ∧ next - speed ≤ accel := by
  have h := clamp_bounds (lo := -brake) (hi := accel) (value := wanted - speed) (by grind)
  dsimp [speedStep, clamp] at *
  grind

theorem turnStep_cap {heading signedError turn : Rat} (h : 0 ≤ turn) :
    -turn ≤ turnStep heading signedError turn - heading ∧
    turnStep heading signedError turn - heading ≤ turn := by
  have hb := clamp_bounds (lo := -turn) (hi := turn) (value := signedError) (by grind)
  unfold turnStep
  grind

structure Window where
  width : Rat
  height : Rat

def fits (w : Window) (extent : Rat) : Prop :=
  0 ≤ extent ∧ 2 * extent ≤ w.width ∧ 2 * extent ≤ w.height

def inside (w : Window) (extent : Rat) (p : Point) : Prop :=
  extent ≤ p.x ∧ p.x ≤ w.width - extent ∧
  extent ≤ p.y ∧ p.y ≤ w.height - extent

-- The art diameter and the viewport fraction impose independent size limits.
def extentFor (w : Window) (preferred fraction : Rat) : Rat :=
  min preferred (fraction * min w.width w.height)

-- Multiplicative premises state exactly what resize must supply for this fit.
theorem extentFor_fits {w : Window} {preferred fraction : Rat}
    (hPreferred : 0 ≤ preferred) (hScale : 0 ≤ fraction * min w.width w.height)
    (hWidth : 2 * (fraction * min w.width w.height) ≤ w.width)
    (hHeight : 2 * (fraction * min w.width w.height) ≤ w.height) :
    fits w (extentFor w preferred fraction) := by
  unfold fits extentFor
  grind

def fitCenter (w : Window) (extent : Rat) (p : Point) : Point :=
  ⟨clamp extent (w.width - extent) p.x, clamp extent (w.height - extent) p.y⟩

theorem fitCenter_inside {w : Window} {extent : Rat} (h : fits w extent) (p : Point) :
    inside w extent (fitCenter w extent p) := by
  obtain ⟨_, hW, hH⟩ := h
  have hx := clamp_bounds (value := p.x) (lo := extent) (hi := w.width - extent) (by grind)
  have hy := clamp_bounds (value := p.y) (lo := extent) (hi := w.height - extent) (by grind)
  exact ⟨hx.1, hx.2, hy.1, hy.2⟩

-- A look-ahead trigger leaves the nominated outward travel budget available.
-- The budget must be validated for the chosen turn/brake and sampling policy.
def shouldTurn (clearance budget sampleGuard : Rat) : Prop :=
  clearance ≤ budget + sampleGuard

theorem earlyTurn_remaining_budget {before after budget sampleGuard : Rat}
    (hBefore : ¬ shouldTurn before budget sampleGuard)
    (hAdvance : before - after ≤ sampleGuard) : budget < after := by
  unfold shouldTurn at hBefore
  grind

-- When braking, integrate with the new speed. In one tick the reduction in
-- squared speed pays for at least that tick's outward movement.
theorem brake_step_budget {speed brake : Rat} (hSpeed : 0 ≤ speed) (hBrake : 0 ≤ brake) :
    let next := max 0 (speed - brake)
    2 * brake * next ≤ speed * speed - next * next := by
  dsimp
  by_cases h : speed ≤ brake
  · have hNext : max 0 (speed - brake) = 0 := by grind
    have hSq := Rat.mul_nonneg hSpeed hSpeed
    rw [hNext]
    grind
  · have hNext : max 0 (speed - brake) = speed - brake := by grind
    have hSq := Rat.mul_nonneg hBrake hBrake
    rw [hNext]
    grind

-- If dt > 0 and brake > 0, this is the scaled form of clearance ≥
-- speed² * dt / (2 * brake). Actual outward advance may be negative.
theorem brake_preserves_clearance {speed brake dt clearance advance : Rat}
    (hSpeed : 0 ≤ speed) (hBrake : 0 ≤ brake) (hDt : 0 ≤ dt)
    (hRoom : speed * speed * dt ≤ 2 * brake * clearance)
    (hAdvance : advance ≤ max 0 (speed - brake) * dt) :
    let next := max 0 (speed - brake)
    next * next * dt ≤ 2 * brake * (clearance - advance) := by
  have hBudget := Rat.mul_le_mul_of_nonneg_right (brake_step_budget hSpeed hBrake) hDt
  have hScale : 0 ≤ 2 * brake := by grind
  have hUsed := Rat.mul_le_mul_of_nonneg_left hAdvance hScale
  dsimp at hBudget ⊢
  grind

theorem extentFor_fits_fraction {w : Window} {preferred fraction : Rat}
    (hW : 0 ≤ w.width) (hH : 0 ≤ w.height) (hPreferred : 0 ≤ preferred)
    (hFraction : 0 ≤ fraction) (hHalf : fraction ≤ 1 / 2) :
    fits w (extentFor w preferred fraction) := by
  have hm : 0 ≤ min w.width w.height := by grind
  have hs := Rat.mul_nonneg hFraction hm
  have hUpper := Rat.mul_le_mul_of_nonneg_right hHalf hm
  apply extentFor_fits hPreferred hs <;> grind

def mix (t a b : Rat) : Rat := (1 - t) * a + t * b

def positionAt (t : Rat) (start finish : Point) : Point :=
  ⟨mix t start.x finish.x, mix t start.y finish.y⟩

theorem mix_mono {t a b c d : Rat} (ht0 : 0 ≤ t) (ht1 : t ≤ 1)
    (ha : a ≤ c) (hb : b ≤ d) : mix t a b ≤ mix t c d := by
  have h0 := Rat.mul_le_mul_of_nonneg_left ha (c := 1 - t) (by grind)
  have h1 := Rat.mul_le_mul_of_nonneg_left hb ht0
  unfold mix
  grind

theorem inside_segment {w : Window} {extent t : Rat} {start finish : Point}
    (hStart : inside w extent start) (hFinish : inside w extent finish)
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) : inside w extent (positionAt t start finish) := by
  obtain ⟨hx0, hx1, hy0, hy1⟩ := hStart
  obtain ⟨hx0', hx1', hy0', hy1'⟩ := hFinish
  have hxl := mix_mono ht0 ht1 hx0 hx0'
  have hxh := mix_mono ht0 ht1 hx1 hx1'
  have hyl := mix_mono ht0 ht1 hy0 hy0'
  have hyh := mix_mono ht0 ht1 hy1 hy1'
  simp only [inside, positionAt]
  unfold mix at *
  grind

def projectionGap (axis a b : Point) : Rat :=
  axis.x * (b.x - a.x) + axis.y * (b.y - a.y)

private theorem square_nonneg (x : Rat) : 0 ≤ x * x := by
  by_cases h : 0 ≤ x
  · exact Rat.mul_nonneg h h
  · have hn : 0 ≤ -x := by grind
    have hs := Rat.mul_nonneg hn hn
    grind

def axisBounded (axis : Point) : Prop := axis.x * axis.x + axis.y * axis.y ≤ 1

def distanceSq (a b : Point) : Rat :=
  (b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y)

-- Both bodies use the same interpolation fraction and the same separating
-- axis throughout this segment. The axis may change at the next tick.
theorem projectionGap_segment {axis a0 a1 b0 b1 : Point} {t required : Rat}
    (hStart : required ≤ projectionGap axis a0 b0)
    (hFinish : required ≤ projectionGap axis a1 b1)
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    required ≤ projectionGap axis (positionAt t a0 a1) (positionAt t b0 b1) := by
  have h := mix_mono ht0 ht1 hStart hFinish
  simp only [projectionGap, positionAt, mix] at *
  grind

theorem disk_separation_of_projection {axis a b : Point} {required : Rat}
    (hAxis : axisBounded axis) (hR : 0 ≤ required) (hGap : required ≤ projectionGap axis a b) :
    required * required ≤ distanceSq a b := by
  have hGapNonneg : 0 ≤ projectionGap axis a b := by grind
  have hL := Rat.mul_le_mul_of_nonneg_left hGap hR
  have hR' := Rat.mul_le_mul_of_nonneg_right hGap hGapNonneg
  let cross := axis.x * (b.y - a.y) - axis.y * (b.x - a.x)
  have hCross := square_nonneg cross
  have hx := square_nonneg (b.x - a.x)
  have hy := square_nonneg (b.y - a.y)
  have hDistanceNonneg : 0 ≤ distanceSq a b := by unfold distanceSq; grind
  have hIdentity : projectionGap axis a b * projectionGap axis a b + cross * cross =
      (axis.x * axis.x + axis.y * axis.y) * distanceSq a b := by
    dsimp [projectionGap, cross, distanceSq]
    grind
  have hScale := Rat.mul_le_mul_of_nonneg_right hAxis hDistanceNonneg
  grind

theorem disk_separation_segment {axis a0 a1 b0 b1 : Point} {t required : Rat}
    (hAxis : axisBounded axis) (hR : 0 ≤ required)
    (hStart : required ≤ projectionGap axis a0 b0)
    (hFinish : required ≤ projectionGap axis a1 b1)
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    required * required ≤ distanceSq (positionAt t a0 a1) (positionAt t b0 b1) :=
  disk_separation_of_projection hAxis hR (projectionGap_segment hStart hFinish ht0 ht1)

def scalePoint (sx sy : Rat) (p : Point) : Point := ⟨sx * p.x, sy * p.y⟩

theorem scaled_inside {w : Window} {extent sx sy : Rat} {p : Point}
    (h : inside w extent p) (he : 0 ≤ extent) (hx : 1 ≤ sx) (hy : 1 ≤ sy) :
    inside ⟨sx * w.width, sy * w.height⟩ extent (scalePoint sx sy p) := by
  obtain ⟨hxl, hxh, hyl, hyh⟩ := h
  have hx0 : 0 ≤ sx := by grind
  have hy0 : 0 ≤ sy := by grind
  have ex := Rat.mul_le_mul_of_nonneg_right hx he
  have ey := Rat.mul_le_mul_of_nonneg_right hy he
  have xl := Rat.mul_le_mul_of_nonneg_left hxl hx0
  have xh := Rat.mul_le_mul_of_nonneg_left hxh hx0
  have yl := Rat.mul_le_mul_of_nonneg_left hyl hy0
  have yh := Rat.mul_le_mul_of_nonneg_left hyh hy0
  simp only [inside, scalePoint]
  grind

private theorem square_noncontracting {scale : Rat} (hs : 1 ≤ scale) (x : Rat) :
    x * x ≤ (scale * x) * (scale * x) := by
  have hs0 : 0 ≤ scale := by grind
  have hh := Rat.mul_le_mul_of_nonneg_left hs hs0
  have hs2 : 1 ≤ scale * scale := by grind
  have h := Rat.mul_le_mul_of_nonneg_right hs2 (square_nonneg x)
  grind

theorem scaled_distance {sx sy : Rat} (hx : 1 ≤ sx) (hy : 1 ≤ sy) (a b : Point) :
    distanceSq a b ≤ distanceSq (scalePoint sx sy a) (scalePoint sx sy b) := by
  have xx := square_noncontracting hx (b.x - a.x)
  have yy := square_noncontracting hy (b.y - a.y)
  simp only [distanceSq, scalePoint]
  grind

def cycleNext {frames : Nat} (i : Fin frames) : Fin frames :=
  if h : i.val + 1 < frames then ⟨i.val + 1, h⟩ else ⟨0, by have := i.isLt; omega⟩

theorem cycleNext_seam {frames : Nat} (i : Fin frames) (h : i.val + 1 = frames) :
    (cycleNext i).val = 0 := by
  simp [cycleNext, h]

-- A looping bake supplies next by modular indexing. The last frame therefore
-- has exactly the same obligations as every other frame.
structure CertifiedBake {frames sharks : Nat} (w : Window)
    (radius : Fin sharks → Rat) (buffer : Rat) (next : Fin frames → Fin frames)
    (center : Fin frames → Fin sharks → Point) : Prop where
  radiiNonneg : ∀ i, 0 ≤ radius i
  bufferNonneg : 0 ≤ buffer
  contained : ∀ frame i, inside w (radius i) (center frame i)
  separates : ∀ frame i j, i < j → ∃ axis, axisBounded axis ∧
    radius i + radius j + buffer ≤ projectionGap axis (center frame i) (center frame j) ∧
    radius i + radius j + buffer ≤ projectionGap axis (center (next frame) i) (center (next frame) j)

theorem baked_containment {frames sharks : Nat} {w radius buffer}
    {next : Fin frames → Fin frames} {center : Fin frames → Fin sharks → Point}
    (bake : CertifiedBake w radius buffer next center) (frame : Fin frames) (i : Fin sharks) {t : Rat}
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    inside w (radius i) (positionAt t (center frame i) (center (next frame) i)) :=
  inside_segment (bake.contained frame i) (bake.contained (next frame) i) ht0 ht1

theorem baked_separation {frames sharks : Nat} {w radius buffer}
    {next : Fin frames → Fin frames} {center : Fin frames → Fin sharks → Point}
    (bake : CertifiedBake w radius buffer next center) (frame : Fin frames) (i j : Fin sharks) (hij : i < j) {t : Rat}
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    let gap := radius i + radius j + buffer
    gap * gap ≤ distanceSq (positionAt t (center frame i) (center (next frame) i))
      (positionAt t (center frame j) (center (next frame) j)) := by
  obtain ⟨axis, hAxis, hStart, hFinish⟩ := bake.separates frame i j hij
  have hi := bake.radiiNonneg i
  have hj := bake.radiiNonneg j
  have hb := bake.bufferNonneg
  exact disk_separation_segment hAxis (by grind) hStart hFinish ht0 ht1

-- These are the numeric checks for any actual sequence, including the seam.
-- The generator supplies wrapped heading errors and stores a locally unwrapped
-- heading increment. The verifier checks the increments that playback uses.
structure CertifiedControls {frames sharks : Nat} (next : Fin frames → Fin frames)
    (speed headingDelta : Fin frames → Fin sharks → Rat)
    (top accel brake turn : Fin sharks → Rat) : Prop where
  speedBounds : ∀ frame i, 0 ≤ speed frame i ∧ speed frame i ≤ top i
  accelerationBounds : ∀ frame i, -brake i ≤ speed (next frame) i - speed frame i ∧
    speed (next frame) i - speed frame i ≤ accel i
  turnBounds : ∀ frame i, -turn i ≤ headingDelta frame i ∧ headingDelta frame i ≤ turn i

theorem playback_turn_cap {frames sharks : Nat} {next : Fin frames → Fin frames}
    {speed headingDelta : Fin frames → Fin sharks → Rat} {top accel brake turn}
    (controls : CertifiedControls next speed headingDelta top accel brake turn)
    (frame : Fin frames) (i : Fin sharks) {u v : Rat} (huv : u ≤ v) :
    -(v - u) * turn i ≤ (v - u) * headingDelta frame i ∧
    (v - u) * headingDelta frame i ≤ (v - u) * turn i := by
  have h := controls.turnBounds frame i
  have hNonneg : 0 ≤ v - u := by grind
  have hl := Rat.mul_le_mul_of_nonneg_left h.1 hNonneg
  have hr := Rat.mul_le_mul_of_nonneg_left h.2 hNonneg
  grind

-- A linear speed channel respects the same longitudinal caps at all
-- subintervals. Bounds are expressed per whole tick, as in speedStep_caps.
theorem playback_acceleration_caps {frames sharks : Nat} {next : Fin frames → Fin frames}
    {speed headingDelta : Fin frames → Fin sharks → Rat} {top accel brake turn}
    (controls : CertifiedControls next speed headingDelta top accel brake turn)
    (frame : Fin frames) (i : Fin sharks) {u v : Rat} (huv : u ≤ v) :
    let a := speed frame i
    let b := speed (next frame) i
    (-(v - u) * brake i ≤ mix v a b - mix u a b) ∧
      (mix v a b - mix u a b ≤ (v - u) * accel i) := by
  have h := controls.accelerationBounds frame i
  have hNonneg : 0 ≤ v - u := by grind
  have hl := Rat.mul_le_mul_of_nonneg_left h.1 hNonneg
  have hr := Rat.mul_le_mul_of_nonneg_left h.2 hNonneg
  dsimp [mix]
  grind

-- This optional check uses second differences of emitted positions to cap
-- discrete vector acceleration as well as the longitudinal speed change.
def chordVelocity (dt : Rat) (start finish : Point) : Point :=
  ⟨(finish.x - start.x) / dt, (finish.y - start.y) / dt⟩

def vectorAccel (dt : Rat) (prev current next : Point) : Point :=
  chordVelocity dt (chordVelocity dt prev current) (chordVelocity dt current next)

def normSq (p : Point) : Rat := p.x * p.x + p.y * p.y

theorem vectorAccel_cap {dt cap : Rat} {prev current next : Point}
    (hDt : 0 < dt)
    (hSecondDiff : ∃ delta : Point,
      delta.x = next.x - 2 * current.x + prev.x ∧
      delta.y = next.y - 2 * current.y + prev.y ∧
      normSq delta ≤ (cap * dt * dt) * (cap * dt * dt)) :
    normSq (vectorAccel dt prev current next) ≤ cap * cap := by
  obtain ⟨delta, hx, hy, hBound⟩ := hSecondDiff
  have hCancel := Rat.mul_inv_cancel dt (by grind)
  have hDiv := Rat.mul_le_mul_of_nonneg_left hBound (square_nonneg (dt⁻¹ * dt⁻¹))
  unfold normSq at *
  simp only [vectorAccel, chordVelocity]
  grind

end SharkSteering
