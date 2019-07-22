module Utils.IOStream
  ( flush
  ) where


import System.IO


flush :: IO ()
flush = hFlush stdout
