## Author: Isak Andersson

type
  TVector*[T, I:range] = object ## T = Type, I = Indices - will possibly later be changed to Dimension (number)
    elements: array[I, T]
  TVec2* = TVector[float, range[1..2]]
  TVec3* = TVector[float, range[1..3]]
  TVec4* = TVector[float, range[1..4]]
  TVec2d* = TVector[float64, range[1..2]]
  TVec3d* = TVector[float64, range[1..3]]
  TVec4d* = TVector[float64, range[1..4]]
  TVec2i* = TVector[int, range[1..2]]
  TVec3i* = TVector[int, range[1..3]]
  TVec4i* = TVector[int, range[1..4]]

proc initVector*[T, D](elements: varargs[T]): TVector[T, D] =
  # TODO: Implement this shit
