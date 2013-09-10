{-| ConstantUtils contains the helper functions for constants

This module cannot be merged with 'Ganeti.Utils' because it would
create a circular dependency if imported, for example, from
'Ganeti.Constants'.

-}

{-

Copyright (C) 2013 Google Inc.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.

-}
module Ganeti.ConstantUtils where

import Data.Set (Set)
import qualified Data.Set as Set (fromList, toList)

import Ganeti.THH (PyValue(..))
import Ganeti.PyValueInstances ()

-- | FrozenSet wraps a Haskell 'Set'
--
-- See 'PyValue' instance for 'FrozenSet'.
newtype FrozenSet a = FrozenSet { unFrozenSet :: Set a }
  deriving (Eq, Show)

-- | Converts a Haskell 'Set' into a Python 'frozenset'
--
-- This instance was supposed to be for 'Set' instead of 'FrozenSet'.
-- However, 'ghc-6.12.1' seems to be crashing with 'segmentation
-- fault' due to the presence of more than one instance of 'Set',
-- namely, this one and the one in 'Ganeti.OpCodes'.  For this reason,
-- we wrap 'Set' into 'FrozenSet'.
instance PyValue a => PyValue (FrozenSet a) where
  showValue s = "frozenset(" ++ showValue (Set.toList (unFrozenSet s)) ++ ")"

mkSet :: Ord a => [a] -> FrozenSet a
mkSet = FrozenSet . Set.fromList
