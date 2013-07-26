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

proc `==`*[T, I](a, b: TVector[T, I]): bool =
  for i in low(a)..high(a):
    if a[i] != b[i]:
      return false

  return true

# Ditto.
proc `~=`*[T:range, U](a, b: array[T, U]): bool =
  for i in low(a)..high(a):
    if a[i] + b[i] > 0.000001:
      return false

  return true

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
  for i in low(b)..high(b):
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

const
  SwizzleArr =
    [{'x', 'X', 'r', 'R', 's', 'S'},
     {'y', 'Y', 'g', 'G', 't', 'T'},
     {'z', 'Z', 'b', 'B', 'p', 'P'},
     {'w', 'W', 'a', 'A', 'q', 'Q'}]

  X_swizzleChars = SwizzleArr[0]
  XY_swizzleChars = X_swizzleChars + SwizzleArr[1]
  XYZ_swizzleChars = XY_swizzleChars + SwizzleArr[2]
  swizzleChars = SwizzleArr[0] +
    SwizzleArr[1] +
    SwizzleArr[2] +
    SwizzleArr[3]

proc swizzleImpl[T, U](str: string): array[T, U] {.compileTime.} =
  for i, ch in str:
    if ch in SwizzleArr[0]:
      result[i] = 0
    elif ch in SwizzleArr[1]:
      result[i] = 1
    elif ch in SwizzleArr[2]:
      result[i] = 2
    elif ch in SwizzleArr[3]:
      result[i] = 3
    else:
      # I don't know how to fail here. Pragmas are evaluated independently of the code flow.

from strutils import contains

template `{}`*[T, I](vec: TVector[T, I], str: string{lit}): expr =
  when str.contains({char(0)..char(255)} - swizzleChars):
    {.fatal: "Invalid characters for swizzling".}

  when str.len == 0:
    {.fatal: "Cannot swizzle zero components".}

  var result: TVector[vec[0].type, range[0.. <str.len]]
  for i, component in swizzleImpl[range[0.. <str.len], vec[0].type](str):
    assert component < vec.len
    result[i] = vec[component]
  result

template swizzle*[T, I](a: TVector[T, I], str: string{lit}): expr =
  a{str}

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

when isMainModule:
  var vec3: TVec3i = [1, 3, 37]
  assert vec3{"rgbbg"} == [1, 3, 37, 37, 3]
  assert vec3{"rgbbg"} == vec3.swizzle("rgbbg")
  assert vec3{"rrbbggr"} == [1, 1, 37, 37, 3, 3, 1]

  var vec4: TVec4i = [1, 3, 37, 4]
  assert vec4{"rgbbg"} == [1, 3, 37, 37, 3]
  assert vec4{"rrbaggr"} == [1, 1, 37, 4, 3, 3, 1]

  assert($vec3 == "[1, 3, 37]")
  assert($vec4 == "[1, 3, 37, 4]")
