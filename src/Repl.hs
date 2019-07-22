module Repl
  ( repl
  ) where


import System.IO
import System.Exit
import System.Process
import Control.Monad
import Utils.Iterable
import Utils.IOStream
import Language.Haskell.HsColour.ANSI
import Text.Printf


repl :: IO ()
repl = prepStdIn
  >>   getCmd
  >>=  putStrLn


prepStdIn :: IO ()
prepStdIn = hSetBuffering stdin NoBuffering


getCmd :: IO String
getCmd = accumString "$ " ""


accumString :: Prompt -> String -> IO String
accumString _   ('\n':rest) = return $ reverse rest
accumString ps1 stack = putStr fmtState
  >> flush
  >> liftM (:stack) getChar
  >>= accumString ps1
    where fmtState = printf "\r%s%s" ps1 (reverse stack)


-- Types
type Prompt = String
type Command = String
type Argument = String
type Extension = String -> String
