module Constants.Banner
  ( banner
  , showBanner
  ) where


import Constants.Meta


banner = "# Lambda Shell v." ++ version ++ ""
showBanner = putStrLn banner
