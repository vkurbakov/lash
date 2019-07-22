{-# LANGUAGE TupleSections #-}
module Repl
  ( repl
  ) where


import System.IO
import System.Exit
import System.Process
import Control.Monad
import Constants.Banner
import Utils.Iterable
import Utils.IOStream
import Language.Haskell.HsColour.ANSI
import Text.Printf
import Extensions


extensions :: [Extension]
extensions = [syntax]


repl :: IO ()
repl = showBanner >> forever
  (prepStdIn
   >>  getCmd
   >>= runCmd . words
   >>  return ())


runCmd :: [String] -> IO (Bool, ExitCode)
runCmd ("exit":_) = return (False, ExitSuccess)
runCmd (cmd:args) = spawnProcess cmd args >>= waitForProcess >>= return . (True,)


prepStdIn :: IO ()
prepStdIn = hSetBuffering stdin NoBuffering


getCmd :: IO String
getCmd = accumString "$ " ""


accumString :: Prompt -> String -> IO String
accumString _   ('\n':rest) = return $ reverse rest
accumString ps1 stack = fmtState
  >>= hPutStr stdout
  >> flush
  >> liftM (:stack) getChar
  >>= accumString ps1
    where fmtState = cursorPos . printf "\r%s%s" ps1 <$> (fmtStack stack)
          fmtStack = applyExtensions extensions . reverse
          cursorPos = (++ (printf "\x1b[%dG" $ (1+) . length $ ps1 ++ stack))


-- Types
type Prompt = String
type Command = String
type Argument = String
