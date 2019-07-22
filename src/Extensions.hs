module Extensions
  ( Extension
  , applyExtensions
  , syntax
  ) where


import Control.Monad
import Language.Haskell.HsColour.ANSI
import Utils.Iterable


applyExtensions :: [Extension] -> String -> IO String
applyExtensions (e:es) = foldr (>=>) e es
applyExtensions _ = return


-- Extensions
syntax :: Extension
syntax = return
  . unwords
  . map (highlight [Bold])
  . tip (highlight [Foreground Green])
  . words
--  where option =


-- Types
type Extension = String -> IO String
