## Author: Isak Andersson

from math import pow, sqrt

type
  TVector*[T; I:range] = array[I, T] ## T = Type, I = Indices - will possibly later be changed to Dimension (number)
  TVec2* = TVector[float32, range[0..1]]
  TVec3* = TVector[float32, range[0..2]]
  TVec4* = TVector[float32, range[0..3]]
  TVec2d* = TVector[float64, range[0..1]]
  TVec3d* = TVector[float64, range[0..2]]
  TVec4d* = TVector[float64, range[0..3]]
  TVec2i* = TVector[int, range[0..1]]
  TVec3i* = TVector[int, range[0..2]]
  TVec4i* = TVector[int, range[0..3]]

template `+`*[T, I](a: TVector[T, I]): TVector[T, I] = 
  a

proc `+`*[T, I](a, b: TVector[T, I]): TVector[T, I] =
  for i in low(a)..high(a):
    result[i] = a[i] + b[i]

template add*[T, I](a, b: TVector[T, I]): TVector[T, I] =
  a + b

proc `-`*[T, I](a: TVector[T, I]): TVector[T, I] =
  for i in low(a)..high(a):
    result[i] = -a[i]

proc `-`*[T, I](a, b: TVector[T, I]): TVector[T, I] =
  for i in low(a)..high(a):
    result[i] = a[i] - b[i]

template sub*[T, I](a, b: TVector[T, I]): TVector[T, I] =
  a - b

proc mag*[T, I](a: TVector[T, I]): float =
  for i in low(a)..high(a):
    when T is int:
      result += pow(toFloat(a[i]), 2.0)
    elif T is float:
      result += pow(a[i], 2.0)
    else:
      {.fatal: "Cannot pow that datatype".}
  result = sqrt(result)

proc dot*[T, I](a, b: TVector[T, I]): T =
  for i in low(a)..high(a):
    result += a[i] * b[i]

template `*.`*[T, I](a, b: TVector[T, I]): T =
  a.dot(b)

proc cross*[T, I](a, b: TVector[T, I]): TVector[T, I] =
  when len(a) != 3:
    {.fatal: "Cross product only works with 3 dimensional vectors".}
  result =
    [a[1] * b[2] - b[1] * a[2],
     a[2] * b[0] - b[2] * a[0],
     a[0] * b[1] - b[0] * a[1]]

template `*+`*[T, I](a, b: TVector[T, I]): TVector[T, I] =
  a.cross(b)

proc dist*[T, I](a, b: TVector[T, I]): float =
  result = (a - b).mag

proc `*`*[T, I](a: T; b: TVector[T, I]): TVector[T, I] =
  for i in low(b)..high(b):
    result[i] = a * b[i]

template `*`*[T, I](a: TVector[T, I]; b: T): TVector[T, I] =
  b * a

# Kind of sucks for ints currently, perhaps convert an int vector to float in this case?
proc normalize*[T, I](a: TVector[T, I]): TVector[T, I] =
  let m = mag(a)
  for i in low(a)..high(a):
    result[i] = a[i] / m

#template swizzle*[T, I](a: TVector[T, I]; s: string) =
#  var result: TVector[T, 0..len(s)]
#  for i, c in pairs(s):
#    case c
#    of 'x', 'r', 's':
#      result[i] = a[0]
#    of 'y', 'g', 't':
#      result[i] = a[1]
#    of 'z', 'b', 'r':
#      result[i] = a[2]
#    of 'w', 'a', 'q':
#      result[i] = a[3]

proc `$`*[T, I](a: TVector[T, I]): string =
  result = ""
  result &= "["
  var h = high(a)
  for i in low(a)..h:
    result &= $a[i]
    if i != h:
      result &= ", "
  result &= "]"

template toString*[T, I](a: TVector[T, I]) =
  $a

