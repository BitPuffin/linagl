## Author: Isak Andersson

type
  TVector*[T, D: int] = object ## T = Type, D = Dimension
    elements: array[1..D, T]
  TVec2* = TVector[float, 2]
  TVec3* = TVector[float, 3]
  TVec4* = TVector[float, 4]
  TVec2d* = TVector[float64, 2]
  TVec3d* = TVector[float64, 3]
  TVec4d* = TVector[float64, 4]
  TVec2i* = TVector[int, 2]
  TVec3i* = TVector[int, 3]
  TVec4i* = TVector[int, 4]

proc initVector*[T, D](elements: varargs[T]): TVector[T, D] =
  # TODO: Implement this shit
