module Utils.Iterable
  ( tip
  ) where


tip :: (a -> a) -> [a] -> [a]
tip f (h:t) = (f h):t
tip _ [] = []
