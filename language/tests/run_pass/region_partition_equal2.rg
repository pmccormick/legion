-- Copyright 2015 Stanford University
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- FIXME: This needs a shim for Realm before it will run.

import "regent"

local int1d = index_type(int, "int1d")

struct t {
  value : int,
}

task f()
  var r = region(ispace(ptr, 5), t)
  var x0 = new(ptr(t, r))
  var x1 = new(ptr(t, r))
  var x2 = new(ptr(t, r))
  var x3 = new(ptr(t, r))

  var p = partition(equal, r, ispace(int1d, 3))

  for i = 0, 3 do
    var ri = p[i]
    for x in ri do
      x.value = (1 + i) * (1 + i)
    end
  end

  var s = 0
  for i = 0, 3 do
    var ri = p[i]
    for x in ri do
      s += x.value
    end
  end

  return s
end

task main()
  regentlib.assert(f() == 15, "test failed")
end
regentlib.start(main)
