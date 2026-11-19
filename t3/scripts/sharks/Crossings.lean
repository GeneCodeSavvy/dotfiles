import Std

namespace SharkCrossings

def mix (t start finish : Rat) := (1-t)*start + t*finish

-- For any projected vertex on each silhouette, bounds at both ends
-- certify that vertex pair over the whole synchronized interval.
theorem movingSilhouettesSeparate {a0 a1 b0 b1 gap t : Rat}
    (atStart : gap ≤ b0-a0) (atEnd : gap ≤ b1-a1)
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    gap ≤ mix t b0 b1 - mix t a0 a1 := by
  have left := Rat.mul_le_mul_of_nonneg_left atStart (show 0 ≤ 1-t by grind)
  have right := Rat.mul_le_mul_of_nonneg_left atEnd ht0
  unfold mix
  grind

-- Two centerlines can intersect geometrically. Their buffered occupancy
-- windows at that crossing can be disjoint in time.
theorem staggeredCrossing {exitA entryB time : Rat}
    (scheduled : exitA < entryB) :
    ¬ (time ≤ exitA ∧ entryB ≤ time) := by
  grind

def dashFactor (requested predictedGap reserve : Rat) : Rat :=
  if reserve ≤ predictedGap then requested else 0

theorem yieldOverridesDash {requested predictedGap reserve : Rat}
    (blocked : predictedGap < reserve) :
    dashFactor requested predictedGap reserve = 0 := by
  unfold dashFactor
  split <;> grind

theorem dashFactorBound {requested predictedGap reserve cap : Rat}
    (lo : 0 ≤ requested) (hi : requested ≤ cap) :
    0 ≤ dashFactor requested predictedGap reserve ∧
      dashFactor requested predictedGap reserve ≤ cap := by
  unfold dashFactor
  split <;> grind

theorem viewportBetweenFrames {lo hi x0 x1 t : Rat}
    (l0 : lo ≤ x0) (l1 : lo ≤ x1) (h0 : x0 ≤ hi) (h1 : x1 ≤ hi)
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    lo ≤ mix t x0 x1 ∧ mix t x0 x1 ≤ hi := by
  have a := Rat.mul_le_mul_of_nonneg_left l0 (show 0 ≤ 1-t by grind)
  have b := Rat.mul_le_mul_of_nonneg_left l1 ht0
  have c := Rat.mul_le_mul_of_nonneg_left h0 (show 0 ≤ 1-t by grind)
  have d := Rat.mul_le_mul_of_nonneg_left h1 ht0
  unfold mix
  grind
end SharkCrossings
